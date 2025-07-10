# Mi Setup de Desarrollo

Este repositorio contiene mi configuración completa de desarrollo para macOS.

## 🛠 Stack de herramientas

- **Terminal**: WezTerm
- **Multiplexor**: Zellij
- **Shell**: Fish
- **Editor**: Neovim + LazyVim
- **Lenguajes**: TypeScript/JavaScript, Python

## 🚀 Instalación rápida en nueva Mac

```bash
# Clonar repositorio
git clone https://github.com/tu-usuario/dotfiles.git
cd dotfiles

# Ejecutar script de instalación
chmod +x setup.sh
./setup.sh
```

## 📦 Lo que instala

### Herramientas principales

- Homebrew
- Fish shell
- Neovim
- Zellij
- WezTerm
- Node.js y Python

### LSP servers y herramientas

- TypeScript Language Server
- Prettier / Prettierd
- ESLint / ESLint_d
- Pyright (Python)
- Black (Python formatter)
- Ruff (Python linter)

## 🎨 Características

### Neovim (LazyVim)

- ✅ LSP para TypeScript/JavaScript y Python
- ✅ Auto-formateo con Prettier
- ✅ Linting con ESLint
- ✅ Git integration (Fugitive, Gitsigns)
- ✅ File explorer (Neo-tree, Oil)
- ✅ Fuzzy finder (Telescope)
- ✅ GitHub Copilot
- ✅ Harpoon para navegación rápida

### Zellij

- ✅ Sesiones persistentes
- ✅ Paneles múltiples
- ✅ Keybindings customizados
- ✅ Tema kanagawa_dragon

### WezTerm

- ✅ Tema moderno
- ✅ Font rendering excelente
- ✅ Configuración optimizada

## ⌨️ Keybindings principales

### Neovim

- `<leader>ff` - Find files
- `<leader>fb` - Switch buffers
- `<leader>fg` - Find text
- `-` - Oil file manager
- `<C-w>w` - Switch between Neo-tree and code

### Zellij

- `Alt + p, r` - Nuevo panel derecha
- `Alt + p, d` - Nuevo panel abajo
- `Alt + h/l` - Moverse entre paneles
- `Alt + t` - Modo tab

## 🔧 Instalación manual (alternativa)

Si preferís instalar paso a paso:

```bash
# 1. Instalar Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Instalar herramientas
brew install fish neovim zellij node python3 ripgrep fd fzf
brew install --cask wezterm

# 3. Configurar Fish como shell
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)

# 4. Copiar configs
cp -r nvim ~/.config/
cp -r zellij ~/.config/
cp -r wezterm ~/.config/
cp fish-config.fish ~/.config/fish/config.fish

# 5. Instalar LSP servers
npm install -g typescript typescript-language-server prettier eslint
pip3 install pyright black ruff
```

## 📝 Personalización

### Cambiar tema de WezTerm

Editar `~/.config/wezterm/wezterm.lua` y cambiar `color_scheme`.

### Agregar plugins de Neovim

Agregar archivos en `~/.config/nvim/lua/plugins/`

### Modificar keybindings de Zellij

Editar `~/.config/zellij/config.kdl`

## 🔄 Sincronización

Para mantener tus configs sincronizadas:

```bash
# Actualizar dotfiles desde configs actuales
./update-dotfiles.sh

# Pushear cambios
git add .
git commit -m "Update configs"
git push
```

## 🆘 Troubleshooting

### Si Neovim no encuentra LSP servers

```bash
# Reinstalar con Mason
nvim
:Mason
# Instalar typescript-language-server, prettier, etc.
```

### Si Fish no es el shell por defecto

```bash
chsh -s $(which fish)
```

### Si faltan dependencias

```bash
brew doctor
npm doctor
```

## 📞 Contacto

Si tenés problemas con la instalación, revisar los logs del script o crear un issue en el repositorio.
