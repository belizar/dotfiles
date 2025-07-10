#!/bin/bash

# Script para actualizar dotfiles desde configuraciones actuales
# Uso: ./update-dotfiles.sh

set -e

echo "🔄 Actualizando dotfiles desde configuraciones actuales..."

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
  echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
  echo -e "${RED}✗${NC} $1"
}

# Función para copiar configuraciones de forma segura
copy_config() {
  local source="$1"
  local destination="$2"
  local description="$3"

  if [ ! -e "$source" ]; then
    print_warning "$description no encontrado en $source"
    return 1
  fi

  echo "📁 Copiando $description..."

  # Crear directorio de destino
  mkdir -p "$(dirname "$destination")"

  if [ -d "$source" ]; then
    # Si es directorio, usar rsync para excluir archivos problemáticos
    if command -v rsync >/dev/null 2>&1; then
      rsync -av \
        --exclude='.git' \
        --exclude='node_modules' \
        --exclude='.DS_Store' \
        --exclude='*.log' \
        --exclude='.lazy' \
        --exclude='lazy-lock.json' \
        --exclude='.luarc.json' \
        "$source/" "$destination/" 2>/dev/null
    else
      # Fallback: copiar y luego limpiar
      cp -r "$source" "$(dirname "$destination")/" 2>/dev/null || {
        print_error "No se pudo copiar $description"
        return 1
      }
      # Limpiar archivos problemáticos
      find "$destination" -name '.git' -type d -exec rm -rf {} + 2>/dev/null || true
      find "$destination" -name 'node_modules' -type d -exec rm -rf {} + 2>/dev/null || true
      find "$destination" -name '.DS_Store' -delete 2>/dev/null || true
    fi
  elif [ -f "$source" ]; then
    # Si es archivo, copiar directamente
    cp "$source" "$destination" 2>/dev/null || {
      print_error "No se pudo copiar $description"
      return 1
    }
  fi

  print_status "$description copiado exitosamente"
  return 0
}

# Crear backup de configuraciones actuales
BACKUP_DIR="backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "💾 Creando backup en $BACKUP_DIR..."

# Backup solo si existen los directorios
[ -d "nvim" ] && cp -r nvim "$BACKUP_DIR/" 2>/dev/null || true
[ -d "zellij" ] && cp -r zellij "$BACKUP_DIR/" 2>/dev/null || true
[ -d "wezterm" ] && cp -r wezterm "$BACKUP_DIR/" 2>/dev/null || true
[ -f "fish-config.fish" ] && cp fish-config.fish "$BACKUP_DIR/" 2>/dev/null || true

print_status "Backup creado en $BACKUP_DIR"

# Contador de configs actualizadas
configs_updated=0

echo ""
echo "📝 Actualizando configuraciones..."

# Neovim
if copy_config ~/.config/nvim ./nvim "Configuración de Neovim"; then
  ((configs_updated++))
fi

# Zellij
if copy_config ~/.config/zellij ./zellij "Configuración de Zellij"; then
  ((configs_updated++))
fi

# WezTerm
if copy_config ~/.config/wezterm ./wezterm "Configuración de WezTerm"; then
  ((configs_updated++))
fi

# Fish
if copy_config ~/.config/fish/config.fish ./fish-config.fish "Configuración de Fish"; then
  ((configs_updated++))
fi

# Git configs útiles (opcional)
if [ -f ~/.gitconfig ]; then
  echo "📝 Copiando .gitconfig..."
  cp ~/.gitconfig ./gitconfig 2>/dev/null && {
    print_status "Configuración de Git copiada"
    ((configs_updated++))
  } || print_warning "No se pudo copiar .gitconfig"
fi

# Verificar si se actualizó algo
if [ $configs_updated -eq 0 ]; then
  print_error "No se pudieron actualizar configuraciones"
  print_error "Verifica que existan los archivos de configuración"
  exit 1
fi

# Limpiar archivos problemáticos que puedan haber quedado
echo ""
echo "🧹 Limpiando archivos innecesarios..."

# IMPORTANTE: Solo limpiar dentro de las carpetas de config, NO tocar .git del repo principal
# Eliminar archivos de Git solo de las carpetas de configuración
find ./nvim ./zellij ./wezterm -name '.git' -type d -exec rm -rf {} + 2>/dev/null || true
find ./nvim ./zellij ./wezterm -name 'node_modules' -type d -exec rm -rf {} + 2>/dev/null || true
find . -name '.DS_Store' -delete 2>/dev/null || true
find . -name '*.log' -delete 2>/dev/null || true

# Crear/actualizar .gitignore
echo "📄 Actualizando .gitignore..."
cat >.gitignore <<EOF
# Archivos del sistema
.DS_Store
*.log

# Directorios de desarrollo
node_modules/
.git/

# Archivos temporales de Neovim
.lazy/
lazy-lock.json
.luarc.json

# Backups
backup-*/
EOF

print_status ".gitignore actualizado"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_status "¡Dotfiles actualizados exitosamente!"
echo ""
echo "📊 Resumen:"
echo "• $configs_updated configuraciones actualizadas"
echo "• Backup guardado en: $BACKUP_DIR"
echo "• Archivos problemáticos eliminados"
echo ""
echo "🚀 Próximos pasos:"
echo "1. Revisar cambios: git status"
echo "2. Ver diferencias: git diff"
echo "3. Commitear: git add . && git commit -m 'Update configs'"
echo "4. Push: git push"
echo ""
echo "💡 Tip: Ejecuta 'git status' para ver qué cambió"
