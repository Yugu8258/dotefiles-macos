-- ~/.config/nvim/lua/neovide.lua
if not vim.g.neovide then
    return
end

-- 1. Font family and size (JetBrains Mono Nerd Font, 14pt)
vim.o.guifont = "JetBrainsMono Nerd Font:h14"

-- 2. Enable font ligatures on startup
vim.g.neovide_enable_ligatures = true

-- 3. Set window opacity and background color (#212836)
vim.g.neovide_opacity = 1.0
vim.g.neovide_normal_opacity = 1.0

local function apply_bg()
    vim.api.nvim_set_hl(0, "Normal", { bg = "#212836" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "#212836" })
end

apply_bg()

-- Re-apply custom background color after any colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("NeovideCustomBg", { clear = true }),
    callback = apply_bg,
})

-- 4. Window state
vim.g.neovide_remember_window_size = true

-- 5. Cursor trail and particle VFX settings
-- Available modes: "railgun", "torpedo", "pixiedust", "sonicboom", "ripple", "wireframe"
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_cursor_animation_length = 0.12
vim.g.neovide_cursor_trail_size = 0.8

-- Optional particle fine-tuning
vim.g.neovide_cursor_vfx_opacity = 200.0
vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
vim.g.neovide_cursor_vfx_particle_density = 7.0
vim.g.neovide_cursor_vfx_particle_speed = 10.0
