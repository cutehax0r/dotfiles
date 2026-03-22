-- TODO: consider writing a "list LSPs" and "start/stop/restart lsps" plugin. nvim-lsp config
-- provides something but I think we can go lighter than that.
-- `:checkhealth vim.lsp` exists to list things but maybe you can do better with Snacks?
-- List lsps with `vim.lsp.get_clients({ bufnr = 0 })`
-- Stop them with `vim.lsp.stop_client(client.id)` where `client` is from `get_clients`
-- force shutdown by passing `true` as a second argument to `stop_client()`
-- Start them with `local client_id = vim.lsp.start_client(config)` and then attach it to the
-- current buffer with vim.lsp.buf_attach_client(0, client_id)
-- note that config should come from `vim.lsp['_enabled_configs']`

-- Automatically enable any LSP defined in ~/.config/nvim/lsp
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lsp")) do
  local lsp_name = file:gsub("%.lua", "")
  vim.lsp.enable(lsp_name)
end

---from https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md
---display lsp loading status
---@type table<number, {token:lsp.ProgressToken, msg:string, pct:number, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        local pct = value.kind == "end" and 100 or value.percentage or 100
        p[i] = {
          token = ev.data.params.token,
          msg = ("%3d%%"):format(pct),
          pct = pct,
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local display = {} ---@type string[]
    for active_client_id, client_progress in pairs(progress) do
      if #client_progress > 0 then
        local active_client = vim.lsp.get_client_by_id(active_client_id)
        if active_client then
          local best_msg = client_progress[1].msg
          local best_pct = -1
          for _, item in ipairs(client_progress) do
            if item.pct >= best_pct then
              best_pct = item.pct
              best_msg = item.msg
            end
          end
          table.insert(display, ("%s: %s"):format(active_client.name, best_msg))
        end
      end
    end
    table.sort(display)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    local is_loading = #display > 0
    vim.notify(is_loading and table.concat(display, "\n") or "All language servers are ready", "info", {
      id = "lsp_progress",
      title = "LSP Loading",
      opts = function(notif)
        notif.icon = not is_loading and " "
          ---@diagnostic disable-next-line: undefined-field
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})
