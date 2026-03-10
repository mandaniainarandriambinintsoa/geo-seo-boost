#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# GEO-SEO Boost — Claude Code Skill Installer
# GEO + SEO + GSC unified skill
# Forked from zubair-trabzada/geo-seo-claude with GSC integration
# ============================================================

REPO_URL="https://github.com/mandaniainarandriambinintsoa/geo-seo-boost.git"
CLAUDE_DIR="${HOME}/.claude"
SKILLS_DIR="${CLAUDE_DIR}/skills"
AGENTS_DIR="${CLAUDE_DIR}/agents"
INSTALL_DIR="${SKILLS_DIR}/geo"
TEMP_DIR=$(mktemp -d)

# Detect if running via curl pipe (no interactive input available)
INTERACTIVE=true
if [ ! -t 0 ]; then
    INTERACTIVE=false
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   GEO-SEO Boost — Skill Installer        ║${NC}"
    echo -e "${BLUE}║   GEO + SEO + GSC Unified                ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_info() { echo -e "${BLUE}→ $1${NC}"; }

cleanup() { rm -rf "$TEMP_DIR"; }
trap cleanup EXIT

main() {
    print_header

    # ---- Check Prerequisites ----
    print_info "Checking prerequisites..."

    if ! command -v git &> /dev/null; then
        print_error "Git is required but not installed."
        exit 1
    fi
    print_success "Git found: $(git --version)"

    PYTHON_CMD=""
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
    elif command -v python &> /dev/null; then
        PYTHON_VERSION=$(python --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
        if [ -n "$PYTHON_VERSION" ]; then
            MAJOR=$(echo "$PYTHON_VERSION" | cut -d. -f1)
            MINOR=$(echo "$PYTHON_VERSION" | cut -d. -f2)
            if [ "$MAJOR" -ge 3 ] && [ "$MINOR" -ge 8 ]; then
                PYTHON_CMD="python"
            fi
        fi
    fi

    if [ -z "$PYTHON_CMD" ]; then
        print_error "Python 3.8+ is required but not found."
        exit 1
    fi
    print_success "Python found: $($PYTHON_CMD --version)"

    if ! command -v claude &> /dev/null; then
        print_warning "Claude Code CLI not found in PATH."
        if [ "$INTERACTIVE" = true ]; then
            read -p "Continue installation anyway? (y/n): " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then exit 1; fi
        else
            print_info "Non-interactive mode — continuing anyway..."
        fi
    else
        print_success "Claude Code CLI found"
    fi

    # ---- Remove old /gsc skill if exists ----
    if [ -d "$SKILLS_DIR/gsc" ]; then
        print_info "Removing old /gsc skill (now integrated into /geo)..."
        rm -rf "$SKILLS_DIR/gsc"
        print_success "Old /gsc skill removed"
    fi

    # ---- Create Directories ----
    print_info "Creating directories..."
    mkdir -p "$SKILLS_DIR" "$AGENTS_DIR" "$INSTALL_DIR" "$INSTALL_DIR/scripts" "$INSTALL_DIR/schema"
    print_success "Directory structure created"

    # ---- Clone or Copy Repository ----
    print_info "Fetching GEO-SEO Boost skill files..."

    SCRIPT_DIR=""
    if [ -n "${BASH_SOURCE[0]:-}" ] && [ "${BASH_SOURCE[0]}" != "bash" ]; then
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)" || true
    fi

    if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/geo/SKILL.md" ]; then
        print_info "Installing from local directory..."
        SOURCE_DIR="$SCRIPT_DIR"
    else
        print_info "Cloning from repository..."
        git clone --depth 1 "$REPO_URL" "$TEMP_DIR/repo" || {
            print_error "Failed to clone repository."
            exit 1
        }
        SOURCE_DIR="${TEMP_DIR}/repo"
    fi

    # ---- Install Main Skill ----
    print_info "Installing main GEO skill (with GSC integration)..."
    cp -r "$SOURCE_DIR/geo/"* "$INSTALL_DIR/"
    print_success "Main skill installed"

    # ---- Install Sub-Skills ----
    print_info "Installing sub-skills..."
    SKILL_COUNT=0
    for skill_dir in "$SOURCE_DIR/skills"/*/; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            target_dir="${SKILLS_DIR}/${skill_name}"
            mkdir -p "$target_dir"
            cp -r "$skill_dir"* "$target_dir/"
            SKILL_COUNT=$((SKILL_COUNT + 1))
            print_success "  ${skill_name}"
        fi
    done
    echo "  → ${SKILL_COUNT} sub-skills installed"

    # ---- Install Agents ----
    print_info "Installing subagents..."
    AGENT_COUNT=0
    for agent_file in "$SOURCE_DIR/agents/"*.md; do
        if [ -f "$agent_file" ]; then
            cp "$agent_file" "$AGENTS_DIR/"
            AGENT_COUNT=$((AGENT_COUNT + 1))
            print_success "  $(basename "$agent_file")"
        fi
    done
    echo "  → ${AGENT_COUNT} subagents installed"

    # ---- Install Scripts ----
    print_info "Installing utility scripts..."
    if [ -d "$SOURCE_DIR/scripts" ]; then
        cp -r "$SOURCE_DIR/scripts/"* "$INSTALL_DIR/scripts/"
        chmod +x "$INSTALL_DIR/scripts/"*.py 2>/dev/null || true
        print_success "Scripts installed"
    fi

    # ---- Install Schema Templates ----
    print_info "Installing schema templates..."
    if [ -d "$SOURCE_DIR/schema" ]; then
        cp -r "$SOURCE_DIR/schema/"* "$INSTALL_DIR/schema/"
        print_success "Schema templates installed"
    fi

    # ---- Install Python Dependencies ----
    print_info "Installing Python dependencies..."
    if [ -f "$SOURCE_DIR/requirements.txt" ]; then
        $PYTHON_CMD -m pip install -r "$SOURCE_DIR/requirements.txt" --quiet 2>/dev/null && {
            print_success "Python dependencies installed"
        } || {
            print_warning "Some Python dependencies failed. Run manually: pip install -r requirements.txt"
            cp "$SOURCE_DIR/requirements.txt" "$INSTALL_DIR/"
        }
    fi

    # ---- Verify Installation ----
    echo ""
    print_info "Verifying installation..."
    [ -f "$INSTALL_DIR/SKILL.md" ] && print_success "Main skill file" || print_error "Main skill file missing"
    [ -d "$SKILLS_DIR/geo-audit" ] && print_success "Sub-skills" || print_error "Sub-skills missing"
    [ "$(ls "$AGENTS_DIR"/geo-*.md 2>/dev/null | wc -l)" -gt 0 ] && print_success "Agent files" || print_error "Agent files missing"
    [ -d "$INSTALL_DIR/scripts" ] && print_success "Scripts" || print_error "Scripts missing"

    # ---- Summary ----
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     GEO-SEO Boost — Installation OK!     ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo "  Installed to: ${INSTALL_DIR}"
    echo "  Skills:       ${SKILL_COUNT} sub-skills"
    echo "  Agents:       ${AGENT_COUNT} subagents"
    echo ""
    echo -e "${BLUE}Quick Start:${NC}"
    echo ""
    echo "    /geo audit https://example.com     Full GEO+SEO+GSC audit"
    echo "    /geo gsc                           GSC report only"
    echo "    /geo quick https://example.com     60-second snapshot"
    echo "    /geo citability https://example.com/blog/article"
    echo "    /geo crawlers https://example.com"
    echo "    /geo brands https://example.com"
    echo "    /geo report https://example.com"
    echo ""
    echo -e "${BLUE}Note:${NC} For GSC features, configure the GSC MCP server in Claude Code."
    echo ""
}

main "$@"
