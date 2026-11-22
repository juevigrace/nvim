-- Compatibility shim for nvim-treesitter's frozen `master` branch on
-- Neovim 0.12+.
--
-- Neovim 0.12 changed directive handlers to receive captures as lists
-- (`table<integer, TSNode[]>`), but nvim-treesitter master still treats
-- `match[capture_id]` as a single node. This makes parsing markdown fenced
-- code blocks throw:
--
--   attempt to call method 'range' (a nil value)
--
-- from `nvim-treesitter/query_predicates.lua` while resolving the injection
-- language. The directives below are drop-in replacements that support both
-- the old and new capture shapes.

local M = {}

local html_script_type_languages = {
  importmap = "json",
  module = "javascript",
  ["application/ecmascript"] = "javascript",
  ["text/ecmascript"] = "javascript",
}

local language_aliases = {
  ex = "elixir",
  pl = "perl",
  sh = "bash",
  ts = "typescript",
  uxn = "uxntal",
}

-- Older Neovim versions store a single node, 0.12 stores a list of nodes.
local function first_node(value)
  if type(value) == "table" then
    return value[1]
  end
  return value
end

function M.setup()
  local query = require("vim.treesitter.query")
  local opts = { force = true }

  query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local node = first_node(match[pred[2]])
    if not node then
      return
    end

    local alias = vim.treesitter.get_node_text(node, bufnr):lower()
    metadata["injection.language"] = vim.filetype.match({ filename = "a." .. alias })
      or language_aliases[alias]
      or alias
  end, opts)

  query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
    local node = first_node(match[pred[2]])
    if not node then
      return
    end

    local mimetype = vim.treesitter.get_node_text(node, bufnr)
    local parts = vim.split(mimetype, "/", { plain = true })
    metadata["injection.language"] = html_script_type_languages[mimetype] or parts[#parts]
  end, opts)

  query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
    local capture_id = pred[2]
    local node = first_node(match[capture_id])
    if not node then
      return
    end

    local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[capture_id] }) or ""
    metadata[capture_id] = metadata[capture_id] or {}
    metadata[capture_id].text = text:lower()
  end, opts)
end

return M
