# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modular Neovim configuration using lazy.nvim for plugin management, with a focus on LSP integration, AI-assisted coding (Copilot + Sidekick), and multi-language development support.

## Architecture

**Entry Point**: `init.lua` orchestrates the loading sequence:
1. Sources `vimrc` (legacy VimScript settings)
2. Bootstraps lazy.nvim plugin manager
3. Loads `lua/plugins.lua` (lazy.nvim plugin specs)
4. Loads `lua/plugin-config.lua` (main plugin configurations)
5. Loads `lua/mappings.lua`, `lua/options.lua`, `lua/autocommands.lua`
6. Applies color scheme via `lua/colors/init.lua`

**Configuration Organization**:
- `lua/plugins.lua` - Plugin declarations using lazy.nvim
- `lua/plugin-config.lua` - Main configuration file (~805 lines) containing setup for nvim-cmp, LSP, Telescope, Treesitter, Sidekick, Copilot, and other plugins
- `lua/nv/` - Dedicated modules for complex plugins (currently contains legacy LSP configs)
- `lua/code_action_utils.lua` - Custom LSP utility functions
- `lua/run-notify/` - Custom module for Claude Code system notifications

**Important Pattern**: The codebase has both legacy and modern LSP configurations. The modern setup using `vim.lsp.config()` in `plugin-config.lua` is the active one (lines 279-312). The legacy setup in `lua/nv/lspconfig.lua` is commented out but kept for reference.

## Common Commands

**Plugin Management**:
- Open plugin manager UI: `:Lazy`
- Install plugins: `:Lazy install`
- Update plugins: `:Lazy update`
- Clean unused plugins: `:Lazy clean`
- Sync plugins (install/update/clean): `:Lazy sync`

**LSP Management**:
- Check LSP status: `:LspInfo`
- Manage language servers: `:Mason`

**No build, lint, or test commands** - this is a Neovim configuration, not a software project.

## Key Technical Details

**LSP Configuration** (`plugin-config.lua:279-312`):
- Uses modern `vim.lsp.config()` API (Neovim 0.10+)
- Active servers: ts_ls, gopls, angularls, pyright, solargraph
- Shared capabilities configured via cmp-nvim-lsp
- Common `on_attach` function for consistent keybindings across all servers
- Diagnostics: virtual_text disabled, signs enabled, float on hover

**Completion System** (nvim-cmp):
- Source priority: Copilot (highest) → nvim-lsp → vsnip → buffer
- Custom formatting with lspkind icons
- Copilot entries highlighted in green and truncated at 60 chars
- Key mappings with intelligent fallbacks (Tab/S-Tab navigate, CR confirms)

**Sidekick AI Integration** (`plugin-config.lua:620-805`):
- NES (Next Edit Suggestions) workflow with Tab/C-y/C-n navigation
- Context-aware sending: `{this}`, `{file}`, `{selection}` templates
- CLI session management via `<leader>a*` keymaps
- Telescope integration: `<C-s>` in any Telescope picker to send files/grep results to Claude
- Lualine integration showing AI status
- Custom highlight groups: SidekickAccept (green), SidekickDecline (red), SidekickNavigate (yellow)

**Claude Code Integration Enhancements**:
- **Wrapper Script** (`scripts/claude-wrapper.sh`): Handles terminal resize signals (SIGWINCH) to fix text wrapping issues when Sidekick buffer changes size
- **System Notifications** (`plugin/run-notify.nvim`): Monitors Claude CLI output and sends OS-level notifications via notify-send when:
  - Claude asks a question (🤔 normal urgency)
  - Claude finishes responding (✅ low urgency)
  - Claude needs tool approval (⚠️ critical urgency)
  - Claude encounters an error (❌ critical urgency)
- Notifications only sent when Neovim is not focused (configurable)
- User commands: `:ClaudeNotifyEnable`, `:ClaudeNotifyDisable`, `:ClaudeNotifyToggle <type>`, `:ClaudeNotifyTest`
- **Voice Features** (`lua/voice-input.lua`): Two modes for voice interaction with Claude Code
  - **Voice Conversation Mode**: Two-way voice chat with Claude
    - Keybind: `<leader>aw` (normal/insert mode)
    - Triggers `/voicemode:converse` command for full voice conversation
    - Requires voicemode MCP server to be configured in Claude Code
  - **Voice-to-Text Prompts**: Speak prompts that get transcribed and sent as text
    - Keybind: `<leader>av` (normal/insert mode)
    - Records audio (10 seconds max), transcribes via Whisper, sends text to Claude
    - Requires Whisper endpoint at `$WHISPER_ENDPOINT` (default: `http://localhost:2022/v1/audio/transcriptions`)
    - Requires `arecord` (ALSA utils) for audio capture
  - Both modes work with Sidekick terminal sessions and standalone Claude Code terminals
  - Automatically opens Claude Code session if none exists

**Treesitter Configuration**:
- Installed languages: python, typescript, lua
- Highlight enabled (html disabled due to conflicts)
- Indent enabled

## Modifying This Configuration

**To add a new plugin**:
1. Add `'author/repo'` to the plugin list in `lua/plugins.lua`
   - For plugins with build steps: `{ 'author/repo', build = ':CommandHere' }`
   - For plugins with custom names: `{ 'author/repo', name = 'custom-name' }`
   - For lazy-loaded plugins: `{ 'author/repo', lazy = true, event = 'BufEnter' }`
2. For simple setups: add configuration to `lua/plugin-config.lua`
3. For complex plugins: create `lua/nv/plugin-name.lua` and require it
4. Restart Neovim (lazy.nvim auto-installs on startup) or run `:Lazy install`

**To modify LSP servers**:
- Edit the server list in `plugin-config.lua` around line 300
- Update the `on_attach` function (line 281) to modify LSP keybindings
- Modify `capabilities` (line 291) if adding new LSP features

**To add keybindings**:
- General mappings: `lua/mappings.lua`
- LSP-specific: modify `on_attach` in `plugin-config.lua`
- Plugin-specific: add to that plugin's configuration section

**To adjust completion behavior**:
- Source configuration: `plugin-config.lua:103-135`
- Keybindings: `plugin-config.lua:137-234`
- Formatting: `plugin-config.lua:236-254`

## Important Conventions

**Plugin Configuration Pattern**:
- Simple plugins configured inline in `plugin-config.lua`
- Complex plugins get dedicated modules in `lua/nv/` directory
- This allows the configuration to scale as complexity grows

**Dual Setup Notice**:
- Modern LSP setup (`vim.lsp.config()`) in `plugin-config.lua` is active
- Legacy setup in `lua/nv/lspconfig.lua` is commented out
- When making LSP changes, update the modern setup only

**Color Scheme Overrides**:
- Base theme: OneDark
- Custom highlight adjustments in `lua/autocommands.lua`
- Line numbers colored #ffbfee (pink)
- Sidekick-specific highlight groups defined

**Indentation Settings**:
- Default: 4 spaces (set in `lua/options.lua`)
- JavaScript/TypeScript/JSON/etc: 2 spaces (autocmd in `lua/autocommands.lua`)
- Python: 4 spaces (autocmd)

## File Locations Reference

- Main config orchestration: `init.lua:1-18` (includes lazy.nvim bootstrap)
- Plugin declarations: `lua/plugins.lua`
- LSP server configuration: `plugin-config.lua:279-312`
- Completion setup: `plugin-config.lua:103-254`
- Sidekick AI setup: `plugin-config.lua:640-805`
- Claude notifications setup: `plugin-config.lua:603-638`
- Telescope setup: `plugin-config.lua:465-498` (includes Sidekick integration)
- Key mappings: `lua/mappings.lua` and LSP on_attach in `plugin-config.lua:281-290`
- Editor options: `lua/options.lua`
- Custom utilities: `lua/code_action_utils.lua`
- Claude wrapper script: `scripts/claude-wrapper.sh`
- Notification monitoring: `lua/run-notify/init.lua`
