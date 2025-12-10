local M = {}

local config = {
  bin = "global",
  cword_fallback = true,
  use_loclist = false,
  qf = {
    open = false,
    height = 5,
  },
}

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})
  M.config = config
  M.create_commands()
end

-- global 출력 한 줄을 quickfix item으로 변환
-- 기대 포맷: file:lnum:text (global -n 기준)
local function parse_line(line)
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

local function set_list(list, title)
  if config.use_loclist then
    vim.fn.setloclist(0, {}, " ", { title = title, items = list })
    if config.qf.open then
      vim.cmd(("lopen %d"):format(config.qf.height or 10))
    end
    vim.cmd("ll")  -- 첫 결과로 점프
  else
    vim.fn.setqflist({}, " ", { title = title, items = list })
    if config.qf.open then
      vim.cmd(("copen %d"):format(config.qf.height or 10))
    end
    vim.cmd("cc")  -- 첫 결과로 점프
  end
end

-- kind: "symbol" | "def" | "ref"
local function run_global(kind, pattern)
  if (not pattern or pattern == "") and config.cword_fallback then
    pattern = vim.fn.expand("<cword>")
  end

  if not pattern or pattern == "" then
    vim.notify("[gtags.nvim] empty pattern", vim.log.levels.WARN)
    return
  end

  local cmd = { config.bin, "-n", "--result=grep" }

  if kind == "def" then
    table.insert(cmd, "-d")
  elseif kind == "ref" then
    table.insert(cmd, "-r")
  end

  table.insert(cmd, pattern)

  -- global 실행
  local output = vim.fn.systemlist(cmd)
  local ok = (vim.v.shell_error == 0)

  if not ok then
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
    local item = parse_line(line)
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

-- 공개 API들
function M.search_symbol(pattern)
  run_global("symbol", pattern)
end

function M.search_def(pattern)
  run_global("def", pattern)
end

function M.search_ref(pattern)
  run_global("ref", pattern)
end

function M.search_cursor()
  run_global("symbol", vim.fn.expand("<cword>"))
end

-- :Gtags, :GtagsDef, :GtagsRef, :GtagsCursor 명령 생성
function M.create_commands()
  -- 기본 심볼 검색 (정의+참조 통합)
  vim.api.nvim_create_user_command("Gtags", function(opts)
    M.search_symbol(opts.args)
  end, {
    nargs = "?",
    complete = "file",
  })

  -- 정의만
  vim.api.nvim_create_user_command("GtagsDef", function(opts)
    M.search_def(opts.args)
  end, {
    nargs = "?",
  })

  -- 참조만
  vim.api.nvim_create_user_command("GtagsRef", function(opts)
    M.search_ref(opts.args)
  end, {
    nargs = "?",
  })

  -- 커서 위치 심볼 검색
  vim.api.nvim_create_user_command("GtagsCursor", function(_)
    M.search_cursor()
  end, {
    nargs = 0,
  })
end

return M

