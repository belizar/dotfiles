#!/bin/bash

# Setup completo para entorno de desarrollo en macOS
# Uso: ./setup.sh

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Funciones de output
print_header() {
	echo ""
	echo -e "${BLUE}🔹 $1${NC}"
	echo "─────────────────────────────────────────"
}

print_status() {
	echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
	echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
	echo -e "${RED}✗${NC} $1"
}

# Función para verificar si un comando existe
command_exists() {
	command -v "$1" >/dev/null 2>&1
}

# Función para copiar configuraciones de forma segura
copy_config() {
	local source="$1"
	local destination="$2"
	local description="$3"

	# Crear directorio de destino
	mkdir -p "$(dirname "$destination")"

	if [ -d "$source" ]; then
		cp -r "$source" "$(dirname "$destination")/" 2>/dev/null || {
			mkdir -p "$destination"
			cp -r "$source"/* "$destination/" 2>/dev/null || {
				print_warning "No se pudo copiar $description"
				return 1
			}
		}
		print_status "$description copiada"
		return 0
	elif [ -f "$source" ]; then
		cp "$source" "$destination"
		print_status "$description copiada"
		return 0
	else
		print_warning "$description no encontrada en $source"
		return 1
	fi
}

# Banner inicial
echo ""
echo "🚀 SETUP COMPLETO DE ENTORNO DE DESARROLLO"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# PASO 1: Validar estructura de dotfiles
print_header "Validando estructura de dotfiles"

configs_found=0
missing_configs=()

# Verificar configuraciones
if [ -d "./nvim" ] || [ -f "./nvim" ]; then
	print_status "Configuración de Neovim encontrada"
	((configs_found++))
else
	missing_configs+=("nvim")
fi

if [ -d "./zellij" ] || [ -f "./zellij/config.kdl" ]; then
	print_status "Configuración de Zellij encontrada"
	((configs_found++))
else
	missing_configs+=("zellij")
fi

if [ -d "./wezterm" ] || [ -f "./wezterm.lua" ]; then
	print_status "Configuración de WezTerm encontrada"
	((configs_found++))
else
	missing_configs+=("wezterm")
fi

if [ -f "./fish-config.fish" ]; then
	print_status "Configuración de Fish encontrada"
	((configs_found++))
else
	missing_configs+=("fish")
fi

if [ $configs_found -eq 0 ]; then
	print_error "No se encontraron configuraciones en el directorio actual"
	echo ""
	echo "Para crear dotfiles desde tu configuración actual:"
	echo "  cp -r ~/.config/nvim ./nvim"
	echo "  cp -r ~/.config/zellij ./zellij"
	echo "  cp -r ~/.config/wezterm ./wezterm"
	echo "  cp ~/.config/fish/config.fish ./fish-config.fish"
	exit 1
elif [ ${#missing_configs[@]} -gt 0 ]; then
	print_warning "Algunas configuraciones no se encontraron: ${missing_configs[*]}"
	echo "Continuando con las configuraciones disponibles..."
fi

print_status "Estructura validada - $configs_found configuraciones encontradas"

# PASO 2: Instalar Homebrew
print_header "Instalando Homebrew"

if ! command_exists brew; then
	echo "📦 Instalando Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Configurar PATH para Homebrew
	if [[ $(uname -m) == "arm64" ]]; then
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
		eval "$(/opt/homebrew/bin/brew shellenv)"
	else
		echo 'eval "$(/usr/local/bin/brew shellenv)"' >>~/.zprofile
		eval "$(/usr/local/bin/brew shellenv)"
	fi
	print_status "Homebrew instalado"
else
	print_status "Homebrew ya está instalado"
fi

# Actualizar Homebrew
brew update >/dev/null 2>&1

# PASO 3: Instalar herramientas básicas
print_header "Instalando herramientas básicas"

tools_to_install=(
	"git"
	"curl"
	"wget"
	"fish"
	"neovim"
	"zellij"
	"node"
	"python3"
	"ripgrep"
	"fd"
	"fzf"
)

for tool in "${tools_to_install[@]}"; do
	if brew list "$tool" >/dev/null 2>&1; then
		print_status "$tool ya está instalado"
	else
		echo "Instalando $tool..."
		brew install "$tool" >/dev/null 2>&1 && print_status "$tool instalado"
	fi
done

# PASO 4: Instalar WezTerm
print_header "Instalando WezTerm"

if brew list --cask wezterm >/dev/null 2>&1; then
	print_status "WezTerm ya está instalado"
else
	echo "Instalando WezTerm..."
	brew install --cask wezterm >/dev/null 2>&1 && print_status "WezTerm instalado"
fi

# PASO 5: Configurar Fish
print_header "Configurando Fish como shell por defecto"

# Agregar fish a shells válidos si no está
if ! grep -q "$(which fish)" /etc/shells 2>/dev/null; then
	echo "$(which fish)" | sudo tee -a /etc/shells >/dev/null
fi

# Cambiar shell por defecto
if [ "$SHELL" != "$(which fish)" ]; then
	chsh -s "$(which fish)"
	print_status "Fish configurado como shell por defecto"
else
	print_status "Fish ya es el shell por defecto"
fi

# PASO 6: Crear directorios de configuración
print_header "Creando directorios de configuración"

config_dirs=(
	~/.config/nvim
	~/.config/zellij
	~/.config/wezterm
	~/.config/fish
)

for dir in "${config_dirs[@]}"; do
	mkdir -p "$dir"
done

print_status "Directorios de configuración creados"

# PASO 7: Copiar configuraciones
print_header "Copiando configuraciones"

configs_copied=0

# Neovim
if copy_config "./nvim" ~/.config/nvim "Configuración de Neovim"; then
	((configs_copied++))
fi

# Zellij
if copy_config "./zellij" ~/.config/zellij "Configuración de Zellij"; then
	((configs_copied++))
fi

# WezTerm (intentar diferentes ubicaciones)
if copy_config "./wezterm" ~/.config/wezterm "Configuración de WezTerm"; then
	((configs_copied++))
elif copy_config "./wezterm.lua" ~/.config/wezterm/wezterm.lua "Configuración de WezTerm"; then
	((configs_copied++))
fi

# Fish
if copy_config "./fish-config.fish" ~/.config/fish/config.fish "Configuración de Fish"; then
	((configs_copied++))
fi

print_status "$configs_copied configuraciones copiadas exitosamente"

# PASO 8: Instalar herramientas de Node.js
print_header "Instalando herramientas de Node.js"

node_tools=(
	"typescript"
	"typescript-language-server"
	"prettier"
	"@fsouza/prettierd"
	"eslint"
	"eslint_d"
)

echo "Instalando herramientas de npm..."
for tool in "${node_tools[@]}"; do
	npm install -g "$tool" >/dev/null 2>&1 && echo "  ✓ $tool" || echo "  ⚠ $tool (falló)"
done

print_status "Herramientas de Node.js procesadas"

# PASO 9: Instalar herramientas de Python
print_header "Instalando herramientas de Python"

python_tools=(
	"pyright"
	"black"
	"ruff"
	"mypy"
)

echo "Instalando herramientas de pip..."
for tool in "${python_tools[@]}"; do
	pip3 install "$tool" >/dev/null 2>&1 && echo "  ✓ $tool" || echo "  ⚠ $tool (falló)"
done

print_status "Herramientas de Python procesadas"

# PASO 10: Configurar Git
print_header "Configurando Git"

if [ -z "$(git config --global user.name 2>/dev/null)" ]; then
	echo "📝 Configurando Git..."
	read -p "Tu nombre para Git: " git_name
	read -p "Tu email para Git: " git_email

	git config --global user.name "$git_name"
	git config --global user.email "$git_email"
	print_status "Git configurado"
else
	print_status "Git ya está configurado"
fi

# PASO 11: Verificación final
print_header "Verificación final"

verification_passed=true

# Verificar herramientas principales
tools_to_verify=("nvim" "zellij" "fish" "node" "python3")

for tool in "${tools_to_verify[@]}"; do
	if command_exists "$tool"; then
		print_status "$tool instalado correctamente"
	else
		print_error "$tool no encontrado"
		verification_passed=false
	fi
done

# Verificar archivos de configuración
if [ -f ~/.config/nvim/init.lua ]; then
	print_status "Configuración de Neovim lista"
else
	print_warning "init.lua de Neovim no encontrado"
fi

if [ -f ~/.config/zellij/config.kdl ]; then
	print_status "Configuración de Zellij lista"
else
	print_warning "config.kdl de Zellij no encontrado"
fi

# PASO 12: Mensaje final
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$verification_passed" = true ]; then
	echo -e "${GREEN}🎉 ¡INSTALACIÓN COMPLETADA EXITOSAMENTE!${NC}"
else
	echo -e "${YELLOW}⚠️  INSTALACIÓN COMPLETADA CON ADVERTENCIAS${NC}"
fi

echo ""
echo "🎯 PRÓXIMOS PASOS:"
echo "1. Reinicia la terminal o ejecuta: exec fish"
echo "2. Abre WezTerm"
echo "3. Ejecuta: zellij --session desarrollo"
echo "4. Abre Neovim: nvim"
echo ""
echo "⌨️  COMANDOS PRINCIPALES:"
echo "• Neovim: <leader>ff (find files), <leader>fb (buffers)"
echo "• Zellij: Alt+p,r (nuevo panel), Alt+h/l (cambiar panel)"
echo "• Git: :Git (en Neovim), <leader>gc (commits)"
echo ""
echo -e "${GREEN}🚀 Tu entorno de desarrollo está listo!${NC}"

# Opcional: abrir WezTerm
echo ""
read -p "¿Quieres abrir WezTerm ahora? (y/n): " open_wezterm
if [[ $open_wezterm =~ ^[Yy]$ ]]; then
	open -a WezTerm
fi
