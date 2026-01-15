#!/bin/bash
# Script to create GitHub repository and push code

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "GitHub Repository Setup & Push"
echo "=========================================="
echo ""

# Check current remote
CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
if [ -n "$CURRENT_REMOTE" ]; then
    echo "Current remote: $CURRENT_REMOTE"
    REPO_NAME=$(echo "$CURRENT_REMOTE" | sed 's|.*github.com/[^/]*/||' | sed 's|\.git$||')
    echo "Repository name: $REPO_NAME"
    echo ""
    read -p "Do you want to use this repository name? (Y/n): " USE_CURRENT
    if [[ "$USE_CURRENT" =~ ^[Nn]$ ]]; then
        read -p "Enter new repository name: " REPO_NAME
        git remote set-url origin "https://github.com/karamvirsingh1998/$REPO_NAME.git"
        echo "✅ Remote updated"
    fi
else
    read -p "Enter repository name (e.g., system-design-daily-demo): " REPO_NAME
    git remote add origin "https://github.com/karamvirsingh1998/$REPO_NAME.git"
    echo "✅ Remote added"
fi

REPO_NAME=$(git remote get-url origin | sed 's|.*github.com/[^/]*/||' | sed 's|\.git$||')
REPO_URL="https://github.com/karamvirsingh1998/$REPO_NAME"

echo ""
echo "=========================================="
echo "Step 1: Create Repository on GitHub"
echo "=========================================="
echo ""
echo "1. Open this URL in your browser:"
echo "   https://github.com/new"
echo ""
echo "2. Fill in the form:"
echo "   Repository name: $REPO_NAME"
echo "   Description: Daily system design interactive demos"
echo "   Visibility: Public or Private (your choice)"
echo "   ⚠️  IMPORTANT: DO NOT check any boxes (no README, .gitignore, or license)"
echo ""
echo "3. Click 'Create repository'"
echo ""
read -p "Press Enter after you've created the repository on GitHub..."

echo ""
echo "=========================================="
echo "Step 2: Push to GitHub"
echo "=========================================="
echo ""

# Stage all files
echo "📦 Staging all files..."
git add -A

# Check if there are changes
if git diff --staged --quiet && [ -z "$(git log --oneline 2>/dev/null)" ]; then
    echo "💾 Making initial commit..."
    git commit -m "Initial commit: System design daily demo generator" || true
elif ! git diff --staged --quiet; then
    echo "💾 Committing changes..."
    git commit -m "Update: System design daily demo generator" || true
fi

# Push to GitHub
echo "🚀 Pushing to GitHub..."
echo "   Repository: $REPO_URL"
echo ""

if git push -u origin main 2>&1; then
    echo ""
    echo "✅ Successfully pushed to GitHub!"
    echo "   View at: $REPO_URL"
    echo ""
    echo "🎉 Setup complete! The daily_run.sh script will now push daily commits here."
else
    echo ""
    echo "❌ Push failed. Possible issues:"
    echo "   1. Repository doesn't exist - make sure you created it on GitHub"
    echo "   2. Authentication - you may need to:"
    echo "      - Set up SSH keys, OR"
    echo "      - Use a personal access token"
    echo ""
    echo "   To set up authentication:"
    echo "   - SSH: https://docs.github.com/en/authentication/connecting-to-github-with-ssh"
    echo "   - Token: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token"
    echo ""
    echo "   After setting up, try again:"
    echo "   git push -u origin main"
fi

echo ""
