-- SPDX-License-Identifier : MIT
-- Copyright (C) 2026 LWM
--
-- **Windows only**
-- Automatically turn off IME when leaving Insert mode,
-- and restore previous IME state when entering Insert mode again.
--
--   @compat : if something goes wrong, try setting this value to 1 and see if it helps.
local function i_leave_ime(compat)
	if vim.g.cookie_i_leave_ime then
		-- pcall(vim.api.nvim_del_autocmd, vim.g.cookie_i_leave_ime)
		return
	end
	if vim.fn.has("win32") ~= 1 then
		return
	end
	local ffi = require("ffi")
	ffi.cdef[[
		typedef void* HWND;
		typedef unsigned long DWORD;
		HWND GetForegroundWindow();
		HWND GetWindow(HWND, DWORD);
		HWND ImmGetDefaultIMEWnd(HWND);
		int64_t SendMessageW(HWND, DWORD, int64_t, int64_t);
		/*
		 * WM_IME_CONTROL                   0x0283
		 *   wparam :
		 *     - IMC_GETCONVERSIONMODE           1
		 *     - IMC_SETCONVERSIONMODE           2 (default)
		 *     - IMC_SETOPENSTATUS               6 (for compat)
		 */
	]]
	local hwnd = ffi.C.GetForegroundWindow()
	local wime = ffi.C.GetWindow(hwnd, 3)      -- (GW_HWNDPREV : 3)
	if ffi.C.GetWindow(wime, 4) ~= hwnd then   -- (GW_OWNER    : 4)
		wime = ffi.load("imm32").ImmGetDefaultIMEWnd(hwnd)
	end
	if not wime then
		vim.notify("IME Window not found", vim.log.levels.ERROR)
		return
	end
	local ACTION = compat and type(compat) ~= "table" and 6LL or 2LL
	local C = ffi.C        -- don't cache C functions, but do cache namespaces!
	local conversion = 0LL -- (cdata) 64-bit integer literal
	local function onchanged(e)
		local flags = 0LL
		local mode = e.match
		if mode:byte(1) == 105 then        -- Insert Mode Leave, 'i' = 105
			-- e.g : "ic:i" or "i:ix"... (':' is 58)
			if mode:byte(2) ~= 58 or mode:byte(3) == 105 then return end
			conversion = C.SendMessageW(wime, 0x283, 1LL, 0LL)
		elseif mode:byte(-1) == 105 then   -- Insert Mode Enter
			flags = conversion
		else
			return
		end
		if bit.band(conversion, 1LL) == 1LL then
			C.SendMessageW(wime, 0x283, ACTION, flags)
		end
	end
	vim.g.cookie_i_leave_ime = vim.api.nvim_create_autocmd("ModeChanged", {
		callback = onchanged,
	})
end

return { enable = i_leave_ime, setup = i_leave_ime }
