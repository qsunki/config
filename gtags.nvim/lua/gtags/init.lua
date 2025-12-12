local M = {}

local config = {
  quickfix = {
    open = false,
    height = 5,
  },
}

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function set_list(list, title)
  vim.fn.setqflist({}, " ", { title = title, items = list })
  if config.quickfix.open then
    vim.cmd(("copen %d"):format(config.quickfix.height or 10))
  end
  vim.cmd("cc")
end

local function parse_grep(line)
  local file, lnum, text = line:match("^([^:]+):(%d+):(.*)$")
  if not file then
    return nil
  end
  return {
    filename = file,
    lnum = tonumber(lnum),
    col = 1,
    text = trim(text),
  }
end

local function global(fargs)
  local cmd = { "global", "-N", "--result=grep" }
  vim.list_extend(cmd, fargs)

  local output = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify(
      ("[gtags.nvim] global failed (%d): %s"):format(
        vim.v.shell_error,
        table.concat(output or {}, "\n")
      ),
      vim.log.levels.ERROR
    )
    return
  end

  local items = {}
  for _, line in ipairs(output) do
    local item = parse_grep(line)
    if item then
      table.insert(items, item)
    end
  end

  if #items == 0 then
    vim.notify(("[gtags.nvim] no matches for: %s"):format(pattern), vim.log.levels.INFO)
    return
  end

  local title = ("[gtags] %s: %s"):format(kind, pattern)
  set_list(items, title)
end

local function create_commands()
  vim.api.nvim_create_user_command(
    "Gtags",

    function(cmd)
      global(cmd.fargs)
    end,

    { nargs = "*" }
  )

  vim.api.nvim_create_user_command(
    "GtagsCword",

    function(opts)
      local fargs = opts.fargs
      table.insert(fargs, vim.fn.expand("<cword>"))
      global(fargs)
    end,

    { nargs = "?" }
  )

  vim.api.nvim_create_user_command(
    "GtagsGrepCword",

    function(opts)
      local fargs = vim.deepcopy(opts.fargs)
	  table.insert(fargs, "-g")
      table.insert(fargs, "\\<" .. vim.fn.expand("<cword>") .. "\\>")
      global(fargs)
    end,

    { nargs = "?" }
  )
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})
  M.config = config
  create_commands()
end

return M

