#!/bin/bash
# Script to remove API key from git history using git filter-branch
# WARNING: This rewrites git history. Only use if you haven't pushed successfully yet.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "Remove API Key from Git History"
echo "=========================================="
echo ""
echo "⚠️  WARNING: This will rewrite git history!"
echo "   Only use this if you haven't successfully pushed to GitHub yet."
echo ""
read -p "Continue? (y/N): " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "🔍 Checking for API key in history..."
if git log --all --source --full-history -S "sk-proj-" -- "generate_demo.py" | grep -q "sk-proj-"; then
    echo "⚠️  Found API key in git history!"
    echo ""
    echo "Removing from history using git filter-branch..."
    
    # Remove the API key from all commits
    git filter-branch --force --index-filter \
        "git update-index --remove generate_demo.py 2>/dev/null || true" \
        --prune-empty --tag-name-filter cat -- --all || true
    
    # Alternative: Use sed to replace the key (if needed)
    # Note: This script is deprecated - use git filter-repo or BFG Repo-Cleaner instead
    # OLD_KEY="your-api-key-here"  # Don't hardcode keys!
    
    # git filter-branch --force --tree-filter \
    #     "if [ -f generate_demo.py ]; then sed -i '' 's|$OLD_KEY|os.getenv(\"OPENAI_API_KEY\")|g' generate_demo.py 2>/dev/null || true; fi" \
    #     --prune-empty --tag-name-filter cat -- --all || true
    
    echo ""
    echo "✅ History rewritten!"
    echo ""
    echo "Next steps:"
    echo "1. Verify the fix: git log -p --all | grep -i 'sk-proj-'"
    echo "2. Force push (if needed): git push --force origin main"
    echo "   (Only if you're sure no one else has pulled your changes)"
else
    echo "✅ No API key found in history (or already removed)"
fi

echo ""
