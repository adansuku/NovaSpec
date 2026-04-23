#!/usr/bin/env bash
#
# nova-spec installer — Interactivo
# Instala nova-spec en Claude Code o OpenCode.
#
# Uso: bash install.sh [opciones]
#   -t, --target    claude|opencode|both  Destino (prompt si no se especifica)
#   -p, --path      <ruta>          Directorio destino (default: $PWD)
#       --pick                      Elegir directorio destino (interactivo)
#   -h, --help               Mostrar ayuda
#
# Sin opciones: modo interactivo
#

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TARGET=""
DEST_DIR=""
PICK_DEST=false

# Parsear argumentos
while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--target)
      TARGET="$2"
      shift 2
      ;;
    -p|--path)
      DEST_DIR="$2"
      shift 2
      ;;
    --pick)
      PICK_DEST=true
      shift
      ;;
    -h|--help)
      echo "Uso: $0 [opciones]"
      echo ""
      echo "Opciones:"
      echo "  -t, --target DESTINO  Destino: claude|opencode|both"
      echo "  -p, --path RUTA       Directorio destino (default: directorio actual)"
      echo "      --pick            Elegir directorio destino (interactivo)"
      echo "  -h, --help        Mostrar esta ayuda"
      echo ""
      echo "Sin opciones: modo interactivo"
      exit 0
      ;;
    *)
      echo "Opción desconocida: $1"
      exit 1
      ;;
  esac
done

# Navegador simple de directorios (sin dependencias).
pick_dir_menu() {
  local current="${1:-$HOME}"

  while true; do
    echo ""
    echo -e "${BLUE}📁 Elige directorio destino${NC}"
    echo "Directorio actual: $current"
    echo ""
    echo "Acciones:"
    echo "  0) Usar este directorio"
    echo "  u) Subir (..)"
    echo "  q) Cancelar"
    echo ""
    echo "Subdirectorios:"

    local -a subdirs=()
    local d
    while IFS= read -r d; do
      subdirs+=("$d")
    done < <(find "$current" -maxdepth 1 -mindepth 1 -type d -print 2>/dev/null | sort | head -n 30)

    local i=1
    for d in "${subdirs[@]}"; do
      echo "  $i) $(basename "$d")"
      i=$((i + 1))
    done

    echo ""
    echo "Tip: también puedes pegar una ruta y pulsar Enter."
    read -r -p "→ " choice

    case "$choice" in
      0)
        echo "$current"
        return 0
        ;;
      u)
        current=$(cd "$current/.." && pwd)
        ;;
      q)
        return 1
        ;;
      /*|~*)
        local expanded="$choice"
        if [[ "$expanded" == "~"* ]]; then
          expanded="${expanded/#\~/$HOME}"
        fi
        if [[ -d "$expanded" ]]; then
          current=$(cd "$expanded" && pwd)
        else
          echo -e "${RED}✗ No existe: $expanded${NC}"
        fi
        ;;
      '' )
        ;;
      *)
        if [[ "$choice" =~ ^[0-9]+$ ]]; then
          local idx=$((choice - 1))
          if (( idx >= 0 )) && (( idx < ${#subdirs[@]} )); then
            current=$(cd "${subdirs[$idx]}" && pwd)
          else
            echo -e "${RED}✗ Opción inválida${NC}"
          fi
        else
          echo -e "${RED}✗ Opción inválida${NC}"
        fi
        ;;
    esac
  done
}

# Selector por búsqueda (si fzf está instalado).
pick_dir_fzf() {
  local start="${1:-$HOME}"
  if ! command -v fzf >/dev/null 2>&1; then
    return 1
  fi

  echo -e "${YELLOW}Buscando carpetas bajo: $start (puede tardar unos segundos)${NC}" >&2
  find "$start" -maxdepth 5 -type d 2>/dev/null \
    | sed '/\/\.git\//d' \
    | fzf --prompt="Destino> " --height=20 --border
}

resolve_dest_dir() {
  if [[ -n "$DEST_DIR" ]]; then
    if [[ ! -d "$DEST_DIR" ]]; then
      mkdir -p "$DEST_DIR"
    fi
    cd "$DEST_DIR"
    return 0
  fi

  if [[ "$PICK_DEST" == true ]]; then
    local picked=""
    if picked=$(pick_dir_fzf "$HOME"); then
      cd "$picked"
      return 0
    fi
    if picked=$(pick_dir_menu "$HOME"); then
      cd "$picked"
      return 0
    fi
    echo "Cancelado."
    exit 0
  fi
}

# Verificar que estamos en el repo correcto
if [[ ! -d "$SCRIPT_DIR/novaspec" ]] || [[ ! -f "$SCRIPT_DIR/AGENTS.md" ]]; then
  echo -e "${RED}✗ No encuentro novaspec/ o AGENTS.md en $SCRIPT_DIR${NC}" >&2
  echo "  Ejecuta este script desde el repo nova-spec." >&2
  exit 1
fi

# Resolver el destino (si --path/--pick).
resolve_dest_dir

# Verificar que NO estamos en el propio repo nova-spec
if [[ "$SCRIPT_DIR" == "$PWD" ]]; then
  echo -e "${BLUE}📁 ¿Dónde quieres instalar nova-spec?${NC}"
  echo ""
  echo "Directorio actual: $PWD"
  echo ""
  echo "Opciones:"
  echo "  (1) Escribir ruta manual (usa TAB para autocompletar)"
  echo "  (2) Navegar por carpetas (menú)"
  echo "  (3) Buscar carpeta (fzf, si lo tienes instalado)"
  echo "  (4) Cancelar"
  echo ""
  read -p "→ " -n 1 choice
  echo ""

  case $choice in
    1)
      echo ""
      echo "Escribe la ruta absoluta o relativa:"
      read -e DEST_DIR
      if [[ -z "$DEST_DIR" ]]; then
        echo -e "${RED}✗ Ruta vacía${NC}"
        exit 1
      fi
      if [[ ! -d "$DEST_DIR" ]]; then
        mkdir -p "$DEST_DIR"
      fi
      cd "$DEST_DIR"
      echo -e "${GREEN}→ Instalando en: $(pwd)${NC}"
      ;;
    2)
      if picked=$(pick_dir_menu "$HOME"); then
        cd "$picked"
        echo -e "${GREEN}→ Instalando en: $(pwd)${NC}"
      else
        echo "Cancelado."
        exit 0
      fi
      ;;
    3)
      if picked=$(pick_dir_fzf "$HOME"); then
        cd "$picked"
        echo -e "${GREEN}→ Instalando en: $(pwd)${NC}"
      else
        echo -e "${RED}✗ fzf no está instalado o no se seleccionó carpeta${NC}"
        exit 1
      fi
      ;;
    4)
      echo "Cancelado."
      exit 0
      ;;
    *)
      echo -e "${RED}✗ Opción inválida${NC}"
      exit 1
      ;;
  esac
fi

case "$PWD" in
  "$SCRIPT_DIR"/*)
    echo -e "${RED}✗ No instales dentro del repo nova-spec.${NC}" >&2
    echo "  Elige un repo destino fuera de: $SCRIPT_DIR" >&2
    exit 1
    ;;
esac

#
# Modalidad interactiva si TARGET no está definido
#
if [[ -z "$TARGET" ]]; then
  echo -e "${BLUE}🎯 nova-spec installer${NC}"
  echo "─────────────────"
  echo ""
  echo "¿Destino?"
  echo "  (1) Claude Code"
  echo "  (2) OpenCode"
  echo "  (3) Ambos (Claude + OpenCode)"
  echo ""
  read -p "→ " -n 1 choice
  echo ""

  case $choice in
    1) TARGET="claude" ;;
    2) TARGET="opencode" ;;
    3) TARGET="both" ;;
    *)
      echo -e "${RED}Opción inválida: $choice${NC}"
      exit 1
      ;;
  esac

fi

# Añade reglas de ignore de forma idempotente (sin pisar un .gitignore existente).
ensure_gitignore() {
  local file=".gitignore"
  local begin="# nova-spec (local)"
  local end="# /nova-spec"

  if [[ -f "$file" ]] && grep -Fq "$begin" "$file"; then
    return 0
  fi

  cat >> "$file" << 'EOF'

# nova-spec (local)
novaspec/config.yml
.env
notes.md
.opencode/settings.local.json
.opencode/node_modules/
.DS_Store
*.swp
*.swo
# /nova-spec
EOF
}

# Crea symlinks per-ítem en .<runtime>/{commands,skills,agents}/<name>.
# Convive con commands/skills/agents ajenos del usuario. Aborta ante
# colisiones de nombre (marca COLLISION=1 en el caller).
#
# Migra instalaciones previas que usaban symlinks a la carpeta entera
# (p. ej. .claude/skills -> ../novaspec/skills) y limpia el symlink
# anidado .claude/skills/skills que producía la versión anterior cuando
# .claude/skills/ ya existía como directorio real.
install_nova_symlinks() {
  local runtime=$1    # "claude" | "opencode"
  local base=".$runtime"
  mkdir -p "$base"

  local kind
  for kind in commands skills agents; do
    # Migración: quitar symlink legacy a la carpeta entera de novaspec/.
    local legacy="$base/$kind"
    if [[ -L "$legacy" ]]; then
      local current_legacy
      current_legacy=$(readlink "$legacy")
      case "$current_legacy" in
        ../novaspec/$kind|../novaspec/$kind/)
          rm -f "$legacy"
          ;;
      esac
    fi
    # Limpieza del bug anidado del instalador anterior.
    if [[ -L "$base/$kind/$kind" ]]; then
      rm -f "$base/$kind/$kind"
    fi
  done

  for kind in commands skills agents; do
    local src="$SCRIPT_DIR/novaspec/$kind"
    [[ -d "$src" ]] || continue
    local dst="$base/$kind"
    mkdir -p "$dst"

    shopt -s nullglob
    local -a items=()
    case "$kind" in
      skills)  items=("$src"/*/) ;;  # skills son directorios con SKILL.md
      *)       items=("$src"/*.md) ;; # commands y agents son archivos .md
    esac
    shopt -u nullglob

    local item name target link current
    for item in "${items[@]}"; do
      name=$(basename "$item")
      target="../../novaspec/$kind/$name"
      link="$dst/$name"

      if [[ -L "$link" ]]; then
        current=$(readlink "$link")
        if [[ "$current" != "$target" ]]; then
          echo -e "${YELLOW}  ⚠ $link ya es symlink a $current — saltando${NC}"
        fi
        continue
      fi

      if [[ -e "$link" ]]; then
        echo -e "${RED}  ✗ $link ya existe y no es de nova-spec${NC}" >&2
        echo -e "${RED}    Renómbralo o muévelo antes de reinstalar.${NC}" >&2
        COLLISION=1
        continue
      fi

      ln -s "$target" "$link"
    done
  done
}

# Validar TARGET
if [[ "$TARGET" != "claude" ]] && [[ "$TARGET" != "opencode" ]] && [[ "$TARGET" != "both" ]]; then
  echo -e "${RED}✗ Destino inválido: $TARGET${NC}" >&2
  echo "  Usa: claude, opencode o both"
  exit 1
fi

echo ""
echo -e "${BLUE}→ Instalando para $TARGET...${NC}"
echo ""

#
# Instalación common
#
echo -e "${YELLOW}[1/6] Copiando novaspec/${NC}"
DEST_CONFIG_BACKUP=""
if [[ -f novaspec/config.yml ]]; then
  DEST_CONFIG_BACKUP=$(mktemp)
  cp novaspec/config.yml "$DEST_CONFIG_BACKUP"
fi
rm -rf novaspec
cp -R "$SCRIPT_DIR/novaspec" .
rm -f novaspec/config.yml  # nunca distribuir el config del maintainer
if [[ -n "$DEST_CONFIG_BACKUP" ]]; then
  mv "$DEST_CONFIG_BACKUP" novaspec/config.yml
elif [[ -f novaspec/config.example.yml ]]; then
  cp novaspec/config.example.yml novaspec/config.yml
fi

echo -e "${YELLOW}[2/6] Copiando AGENTS.md / CLAUDE.md${NC}"
for f in AGENTS.md CLAUDE.md; do
  src="$SCRIPT_DIR/$f"
  dst="./$f"
  if [[ -f "$dst" ]]; then
    if diff -q "$src" "$dst" >/dev/null 2>&1; then
      : # idéntico, no-op
    else
      ts=$(date +%Y%m%d-%H%M%S)
      backup="$dst.bak.$ts"
      cp "$dst" "$backup"
      echo -e "${YELLOW}  ℹ $f existente y distinto → backup en $backup (no se sobrescribe)${NC}"
    fi
  else
    cp "$src" "$dst"
  fi
done

echo -e "${YELLOW}[3/6] Creando estructura context/${NC}"
mkdir -p context/{decisions/archived,gotchas,services,changes/{active,archive}}
touch context/changes/active/.gitkeep

COLLISION=0

if [[ "$TARGET" == "claude" ]] || [[ "$TARGET" == "both" ]]; then
  echo -e "${YELLOW}[4/6] Symlinks .claude/ (por ítem)${NC}"
  install_nova_symlinks claude
fi

if [[ "$TARGET" == "opencode" ]] || [[ "$TARGET" == "both" ]]; then
  echo -e "${YELLOW}[4/6] Symlinks .opencode/ (por ítem)${NC}"
  install_nova_symlinks opencode

  echo -e "${YELLOW}[5/6] Configurando OpenCode${NC}"
  if [[ ! -f .opencode/settings.local.json ]]; then
    cat > .opencode/settings.local.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "skill": {
      "*": "allow"
    }
  }
}
EOF
  fi
fi

if [[ "$COLLISION" == "1" ]]; then
  echo "" >&2
  echo -e "${RED}✗ Instalación incompleta por colisiones de nombre.${NC}" >&2
  echo "  Resuelve los conflictos (rename/move) y vuelve a ejecutar." >&2
  exit 1
fi

echo -e "${YELLOW}[5/6] Asegurando .gitignore${NC}"
ensure_gitignore

echo -e "${YELLOW}[6/6] Creando notes.md${NC}"
touch notes.md

echo ""
echo -e "${GREEN}✓ nova-spec instalado para $TARGET${NC}"
echo ""
echo "Estructura creada:"
ls -la . | grep -E '^(d|l)' | head -10
echo ""
echo "Siguiente paso:"
echo "  Abre $TARGET en este directorio y prueba:"
echo "    /nova-start PROJ-123"
