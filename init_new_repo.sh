#!/bin/bash
# Initialize a new GitHub repository for system-design-daily-demos

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "Initialize New GitHub Repository"
echo "=========================================="
echo ""

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install Git first."
    exit 1
fi

# Initialize Git repository if it doesn't exist
if [ ! -d ".git" ]; then
    echo "📦 Initializing Git repository..."
    git init
    echo "✅ Git repository initialized"
else
    echo "✅ Git repository already exists"
fi

# Ensure we're on main branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")
if [ -z "$CURRENT_BRANCH" ]; then
    echo "🌿 Creating 'main' branch..."
    git checkout -b main 2>/dev/null || git branch -M main 2>/dev/null || true
else
    if [ "$CURRENT_BRANCH" != "main" ]; then
        echo "🌿 Renaming branch to 'main'..."
        git branch -M main
    fi
fi
echo "✅ Branch: main"

# Configure Git user if not set
if ! git config user.name >/dev/null 2>&1; then
    echo ""
    echo "📝 Configuring Git user..."
    git config user.name "karamvirsingh1998"
    git config user.email "karamvirsingh1998@users.noreply.github.com"
    echo "✅ Git user configured"
else
    echo "✅ Git user: $(git config user.name) <$(git config user.email)>"
fi

# Check if remote exists
if git remote get-url origin >/dev/null 2>&1; then
    CURRENT_REMOTE=$(git remote get-url origin)
    echo ""
    echo "⚠️  Remote 'origin' already exists: $CURRENT_REMOTE"
    echo "   It has been removed. Setting up new repository..."
    git remote remove origin
fi

echo ""
echo "=========================================="
echo "Next Steps:"
echo "=========================================="
echo ""
echo "1. Create a new repository on GitHub:"
echo "   Go to: https://github.com/new"
echo "   Repository name: system-design-daily-demos"
echo "   Description: Daily system design interactive demos"
echo "   Visibility: Public or Private (your choice)"
echo "   ⚠️  DO NOT initialize with README, .gitignore, or license"
echo ""
echo "2. After creating the repository, run:"
echo "   git remote add origin https://github.com/karamvirsingh1998/system-design-daily-demos.git"
echo ""
echo "   Or if you used a different name:"
echo "   git remote add origin https://github.com/karamvirsingh1998/YOUR_REPO_NAME.git"
echo ""
echo "3. Make initial commit and push:"
echo "   git add -A"
echo "   git commit -m 'Initial commit: System design daily demo generator'"
echo "   git push -u origin main"
echo ""
echo "=========================================="
echo "Quick Setup (if repo already exists):"
echo "=========================================="
echo ""
read -p "Enter your GitHub repository URL (or press Enter to skip): " REPO_URL

if [ -n "$REPO_URL" ]; then
    echo ""
    echo "🔗 Adding remote..."
    git remote add origin "$REPO_URL"
    echo "✅ Remote added: $REPO_URL"
    
    echo ""
    echo "📦 Staging all files..."
    git add -A
    
    echo ""
    echo "💾 Making initial commit..."
    if git diff --staged --quiet; then
        echo "ℹ️  No changes to commit"
    else
        git commit -m "Initial commit: System design daily demo generator"
        echo "✅ Initial commit created"
    fi
    
    echo ""
    echo "🚀 Pushing to GitHub..."
    read -p "Push to GitHub now? (y/N): " PUSH_NOW
    if [[ "$PUSH_NOW" =~ ^[Yy]$ ]]; then
        if git push -u origin main; then
            echo "✅ Successfully pushed to GitHub!"
            echo ""
            echo "🎉 Repository initialized and pushed!"
        else
            echo ""
            echo "❌ Push failed. Common issues:"
            echo "   1. Authentication: You may need to set up SSH keys or use a personal access token"
            echo "   2. Repository doesn't exist: Make sure you created it on GitHub first"
            echo "   3. Permissions: Ensure you have write access"
            echo ""
            echo "   You can push manually later with:"
            echo "   git push -u origin main"
        fi
    else
        echo "ℹ️  Skipping push. You can push later with: git push -u origin main"
    fi
else
    echo "ℹ️  Skipping remote setup. Run the commands above when ready."
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "The daily_run.sh script will now push to your new repository."
echo ""
