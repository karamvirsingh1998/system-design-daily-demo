#!/bin/bash
# Setup script to initialize GitHub repository for daily demos

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "GitHub Repository Setup"
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

# Configure Git user (skip if already configured)
if ! git config user.name >/dev/null 2>&1; then
    echo ""
    read -p "Enter your Git username (or press Enter for 'Daily Demo Bot'): " GIT_USER
    GIT_USER=${GIT_USER:-"Daily Demo Bot"}
    git config user.name "$GIT_USER"
    
    read -p "Enter your Git email (or press Enter for 'demo-bot@localhost'): " GIT_EMAIL
    GIT_EMAIL=${GIT_EMAIL:-"demo-bot@localhost"}
    git config user.email "$GIT_EMAIL"
    
    echo "✅ Git user configured: $GIT_USER <$GIT_EMAIL>"
else
    echo "✅ Git user already configured: $(git config user.name) <$(git config user.email)>"
fi

# Check for existing remote
if git remote get-url origin >/dev/null 2>&1; then
    CURRENT_REMOTE=$(git remote get-url origin)
    echo ""
    echo "⚠️  Remote 'origin' already exists: $CURRENT_REMOTE"
    read -p "Do you want to change it? (y/N): " CHANGE_REMOTE
    if [[ "$CHANGE_REMOTE" =~ ^[Yy]$ ]]; then
        git remote remove origin
    else
        echo "✅ Using existing remote"
        REMOTE_URL="$CURRENT_REMOTE"
    fi
fi

# Set up remote if needed
if ! git remote get-url origin >/dev/null 2>&1; then
    echo ""
    echo "📝 GitHub Repository Setup"
    echo "   You can create a new repository at: https://github.com/new"
    echo ""
    read -p "Enter your GitHub repository URL (e.g., https://github.com/username/repo.git): " REMOTE_URL
    
    if [ -z "$REMOTE_URL" ]; then
        echo "⚠️  No remote URL provided. You can set it later with:"
        echo "   git remote add origin <your-repo-url>"
    else
        git remote add origin "$REMOTE_URL"
        echo "✅ Remote 'origin' set to: $REMOTE_URL"
    fi
fi

# Set default branch to main
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")
if [ -z "$CURRENT_BRANCH" ]; then
    echo ""
    echo "🌿 Creating 'main' branch..."
    git checkout -b main
    echo "✅ Created and switched to 'main' branch"
else
    echo ""
    echo "✅ Current branch: $CURRENT_BRANCH"
    read -p "Do you want to rename it to 'main'? (y/N): " RENAME_BRANCH
    if [[ "$RENAME_BRANCH" =~ ^[Yy]$ ]]; then
        git branch -M main
        echo "✅ Branch renamed to 'main'"
    fi
fi

# Make initial commit if repository is empty
if [ -z "$(git status --porcelain)" ]; then
    echo ""
    echo "ℹ️  No changes to commit"
elif git log --oneline -1 >/dev/null 2>&1; then
    echo ""
    echo "✅ Repository already has commits"
else
    echo ""
    echo "📝 Making initial commit..."
    git add -A
    git commit -m "Initial commit: Daily system design demo generator"
    echo "✅ Initial commit created"
fi

# Test push (optional)
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [ -n "$REMOTE_URL" ]; then
    echo ""
    read -p "Do you want to push to GitHub now? (y/N): " PUSH_NOW
    if [[ "$PUSH_NOW" =~ ^[Yy]$ ]]; then
        CURRENT_BRANCH=$(git branch --show-current)
        echo ""
        echo "🚀 Pushing to GitHub..."
        if git push -u origin "$CURRENT_BRANCH"; then
            echo "✅ Successfully pushed to GitHub!"
        else
            echo ""
            echo "❌ Push failed. Common issues:"
            echo "   1. Authentication: Set up SSH keys or use HTTPS with token"
            echo "   2. Repository doesn't exist: Create it at https://github.com/new"
            echo "   3. Permissions: Ensure you have write access to the repository"
            echo ""
            echo "   You can try pushing manually later with:"
            echo "   git push -u origin $CURRENT_BRANCH"
        fi
    fi
fi

# Make daily_run.sh executable
if [ -f "daily_run.sh" ]; then
    chmod +x daily_run.sh
    echo ""
    echo "✅ Made daily_run.sh executable"
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Test the script manually: ./daily_run.sh"
echo "2. Set up cron job for daily execution:"
echo "   crontab -e"
echo "   # Add this line (runs at 9 AM daily):"
echo "   0 9 * * * cd $SCRIPT_DIR && ./daily_run.sh"
echo ""
echo "   Or test it at a specific time:"
echo "   0 14 * * * cd $SCRIPT_DIR && ./daily_run.sh  # 2 PM daily"
echo ""
echo "3. View logs: tail -f $SCRIPT_DIR/daily_run.log"
echo ""