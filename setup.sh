#!/usr/bin/env bash
# ============================================================
#  MyWeb Digital Agency — Cursor Skills Setup Script
#  Muallif: Hayotbek Ismoilov
#  Foydalanish: bash setup.sh [loyiha-papkasi]
# ============================================================

set -e

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-$(pwd)}"
CURSOR_DIR="$TARGET/.cursor"
SKILL_DEST="$CURSOR_DIR/skills"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
  echo ""
  echo -e "${CYAN}${BOLD}╔════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}${BOLD}║     MyWeb — Cursor Skills Setup v2.0           ║${NC}"
  echo -e "${CYAN}${BOLD}║     30 ta Production-Grade Skill               ║${NC}"
  echo -e "${CYAN}${BOLD}╚════════════════════════════════════════════════╝${NC}"
  echo ""
}

print_step() {
  echo -e "${BLUE}▶${NC} $1"
}

print_ok() {
  echo -e "  ${GREEN}✓${NC} $1"
}

print_warn() {
  echo -e "  ${YELLOW}⚠${NC} $1"
}

print_error() {
  echo -e "  ${RED}✗${NC} $1"
}

print_header

echo -e "${BOLD}Target loyiha:${NC} $TARGET"
echo ""

# Step 1: Create .cursor/skills directory
print_step "Papkalar yaratilmoqda..."
mkdir -p "$SKILL_DEST"
print_ok ".cursor/skills/ papkasi tayyor"

# Step 2: Copy all skill directories
print_step "30 ta skill ko'chirilmoqda..."
COPIED=0
FAILED=0

for skill_dir in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill_dir")
  if [ -f "$skill_dir/SKILL.md" ]; then
    cp -r "$skill_dir" "$SKILL_DEST/"
    COPIED=$((COPIED + 1))
    print_ok "$skill_name"
  else
    print_warn "$skill_name — SKILL.md topilmadi, o'tkazildi"
    FAILED=$((FAILED + 1))
  fi
done

echo ""
echo -e "  Ko'chirildi: ${GREEN}${BOLD}$COPIED${NC} ta skill"
if [ $FAILED -gt 0 ]; then
  echo -e "  O'tkazildi:  ${YELLOW}${BOLD}$FAILED${NC} ta skill"
fi

# Step 3: Copy .cursorrules to project root
print_step ".cursorrules fayli joylanmoqda..."
if [ -f "$SKILLS_DIR/.cursorrules" ]; then
  if [ -f "$TARGET/.cursorrules" ]; then
    cp "$TARGET/.cursorrules" "$TARGET/.cursorrules.backup"
    print_warn "Mavjud .cursorrules → .cursorrules.backup ga saqlandi"
  fi
  cp "$SKILLS_DIR/.cursorrules" "$TARGET/.cursorrules"
  print_ok ".cursorrules → $TARGET/.cursorrules"
else
  print_error ".cursorrules fayli topilmadi"
fi

# Step 4: Add .cursor to .gitignore if git repo
print_step ".gitignore tekshirilmoqda..."
if [ -f "$TARGET/.gitignore" ]; then
  if grep -q "\.cursor/skills" "$TARGET/.gitignore" 2>/dev/null; then
    print_warn ".cursor/skills allaqachon .gitignore da bor"
  else
    echo "" >> "$TARGET/.gitignore"
    echo "# Cursor AI Skills (local development)" >> "$TARGET/.gitignore"
    echo ".cursor/skills/" >> "$TARGET/.gitignore"
    print_ok ".cursor/skills/ → .gitignore ga qo'shildi"
  fi
  
  # Don't gitignore .cursorrules — commit it
  if grep -q "^\.cursorrules$" "$TARGET/.gitignore" 2>/dev/null; then
    print_warn ".cursorrules .gitignore da edi — olib tashlash tavsiya etiladi (commit qiling)"
  fi
elif git -C "$TARGET" rev-parse 2>/dev/null; then
  cat >> "$TARGET/.gitignore" << 'EOF'

# Cursor AI Skills (local development)
.cursor/skills/
EOF
  print_ok ".gitignore yaratildi va .cursor/skills/ qo'shildi"
else
  print_warn "Git repo emas — .gitignore yaratilmadi"
fi

# Step 5: Verify structure
print_step "Struktura tekshirilmoqda..."
VERIFIED=0
for skill_dir in "$SKILL_DEST"/*/; do
  if [ -f "$skill_dir/SKILL.md" ]; then
    VERIFIED=$((VERIFIED + 1))
  fi
done

echo ""
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}  ✅  O'rnatish muvaffaqiyatli yakunlandi!${NC}"
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════${NC}"
echo ""
echo -e "  ${BOLD}Jami skilllar:${NC}    $VERIFIED / 30"
echo -e "  ${BOLD}Skills papkasi:${NC}   $SKILL_DEST"
echo -e "  ${BOLD}.cursorrules:${NC}     $TARGET/.cursorrules"
echo ""
echo -e "${CYAN}${BOLD}Keyingi qadamlar:${NC}"
echo -e "  1. Cursor IDE ni qayta ishga tushiring"
echo -e "  2. Cursor Settings → Rules for AI → .cursorrules mazmunini tasdiqlang"
echo -e "  3. Har bir loyiha uchun: bash setup.sh /path/to/project"
echo ""
echo -e "${YELLOW}Skill ro'yxati (.cursor/skills/):${NC}"
ls "$SKILL_DEST" | while read -r s; do echo "  • $s"; done
echo ""
