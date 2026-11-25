-- Hot-patch: which-key drops [count] and ["x] in Visual mode, e.g. `{Visual}5g<C-a>`
-- behaves like `g<C-a>`. Its replay (`which-key.state.execute`) skips the count
-- prefix for every mode where `Mode:xo()` is true; we let Visual mode through and
-- keep upstream behaviour for Operator-pending.
-- Remove once https://github.com/folke/which-key.nvim/issues/824 is fixed.
return {
  "folke/which-key.nvim",
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    local ok, State = pcall(require, "which-key.state")
    if not (ok and type(State.execute) == "function") then
      vim.notify("extend-which-key: which-key.state.execute not found; count patch inactive", vim.log.levels.WARN)
      return
    end

    local execute = State.execute
    State.execute = function(state, ...)
      local mode = state and state.mode
      if not (mode and mode.mode == "x") then
        return execute(state, ...)
      end
      mode.xo = function()
        return false
      end
      local ret = { pcall(execute, state, ...) }
      mode.xo = nil
      if not ret[1] then
        error(ret[2], 0)
      end
      return unpack(ret, 2)
    end
  end,
}
