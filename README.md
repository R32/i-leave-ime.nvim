i leave ime
------------------

A Neovim plugin that automatically turn off IME when leaving Insert mode,
and restore previous IME state when entering Insert mode again.

**Windows only**, other platforms are not supported.

## Features

- **Lightweight** -- all the code, comments included, is only about 60 lines.

- **No dependencies** -- pure Lua with LuaJIT FFI, no extra tools or libraries required.

- **Zero configuration** -- just install and enable, works out of the box.


## How it works

This plugin uses **LuaJIT FFI** with a few legacy flags to call Windows APIs directly.

⚠️ Note: It has only been tested on Windows 10 with the built-in IME,
Compatibility with Windows 11 or third-party IMEs has not been verified, so it may no longer work as expected.


## Installation

### Manual

To install manually, simply download the single [i-leave-ime.lua](lua/i-leave-ime.lua) file,
and place it in either `%LOCALAPPDATA%/nvim-data/site/lua` or `%LOCALAPPDATA%/nvim/lua`

If the `lua` directory doesn't exist, you have to create it manually.

### vim.pack.add

Use Neovim's built-in package manager:

```bash
vim.pack.add({"https://github.com/R32/i-leave-ime.nvim.git"})
```

## Usage

After installation, add the following line to your `init.lua`:


```lua
require("i-leave-ime").enable()
```

If something goes wrong (especially with third-party IMEs),
try passing 1 to enable compatibility mode and see if that helps.

```lua
require("i-leave-ime").enable(1)  -- 1 = compatibility mode
```






------------------






我离开输入法
------------------

此 neovim 插件用于在离开 "编辑模式" 时自动关闭输入法, 当再次回到 "编辑模式" 时将会恢复输入法之前的状态.

**仅限 Windows 平台**, 不支持其它平台.

此插件的原理是使用 `LuaJIT` 的 `FFI` 和几个过时的 "标记" 直接调用了 Windows API,

⚠️ 目前只在 WIN10 平台测试过自带的拼音输入法, 对于 WIN11 或其它输入法 **不清楚** 这些标记是否仍然有效.


## 特性


- 轻量 : 代码只有 60 行左右

- 无任何第三方依赖, 纯 Lua 加 LuaJIT FFI 实现.


## 安装

### 手动安装

单独下载 [i-leave-ime.lua](lua/i-leave-ime.lua) 文件, 放到 `%LOCALAPPDATA%/nvim-data/site/lua` 或者 `%LOCALAPPDATA%/nvim/lua` 目录下

如果目录 `lua` 不存在, 则需要自己建立它

### vim.pack

使用 neovim 自带的插件工具安装 :

```lua
vim.pack.add({"https://github.com/R32/i-leave-ime.nvim.git"})
```

## 使用

安装后, 在 nvim 配置文件 `init.lua` 里添加下边一行:

```lua
require("i-leave-ime").enable()
```

目前我仅在 win10 平台测试过系统自带的拼音输入法, 对第三方输入法的兼容性未知,
如果出现问题, 尝试在启用时添加参数 `1` 看是否能解决问题. 例如 :


```lua
require("i-leave-ime").enable(1) -- 1 : 表示使用兼容模式
```
