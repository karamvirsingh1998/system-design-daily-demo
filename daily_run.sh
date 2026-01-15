#!/bin/bash
# Daily execution script with git commit and push to GitHub

set -euo pipefail

# Navigate to script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Log file for debugging
LOG_FILE="${SCRIPT_DIR}/daily_run.log"
exec 1>>"$LOG_FILE" 2>&1

echo ""
echo "=========================================="
echo "Daily Demo Run: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

# Activate virtual environment if exists
if [ -d "venv" ]; then
    echo "Activating virtual environment..."
    source venv/bin/activate
fi

# Load .env file if it exists (for API keys)
if [ -f ".env" ]; then
    echo "Loading environment variables from .env..."
    set -a
    source .env
    set +a
fi

# Initialize Git repository if it doesn't exist
if [ ! -d ".git" ]; then
    echo "Initializing Git repository..."
    git init
    echo "✅ Git repository initialized"
fi

# Configure Git user if not already set (optional - only if not configured)
if ! git config user.name >/dev/null 2>&1; then
    git config user.name "Daily Demo Bot"
    git config user.email "demo-bot@localhost"
fi

# Check if remote exists, if not provide instructions
if ! git remote get-url origin >/dev/null 2>&1; then
    echo "⚠️  WARNING: No Git remote configured!"
    echo "   To set up GitHub remote, run:"
    echo "   git remote add origin <your-github-repo-url>"
    echo "   git branch -M main"
    echo "   git push -u origin main"
    echo ""
    echo "   Continuing without push..."
    SKIP_PUSH=true
else
    SKIP_PUSH=false
    REMOTE_URL=$(git remote get-url origin)
    echo "✅ Git remote configured: $REMOTE_URL"
fi

# Detect current branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
if [ -z "$CURRENT_BRANCH" ]; then
    CURRENT_BRANCH="main"
    git checkout -b main 2>/dev/null || true
fi
echo " branch: $CURRENT_BRANCH"

# Run the demo generator
echo ""
echo "🚀 Running demo generator..."
if python3 generate_demo.py; then
    echo "✅ Demo generation completed"
else
    echo "❌ Demo generation failed"
    exit 1
fi

# Git operations
echo ""
echo "📦 Staging changes..."
git add -A

# Check if there are changes to commit
if git diff --staged --quiet; then
    echo "ℹ️  No changes to commit"
else
    COMMIT_MSG="Daily demo: $(date +%Y-%m-%d)"
    
    echo "💾 Committing changes..."
    if git commit -m "$COMMIT_MSG"; then
        echo "✅ Changes committed: $COMMIT_MSG"
        
        # Push to GitHub
        if [ "$SKIP_PUSH" = false ]; then
            echo "🚀 Pushing to GitHub..."
            
            # Try main branch first, then master
            if git push origin "$CURRENT_BRANCH" 2>&1; then
                echo "✅ Successfully pushed to origin/$CURRENT_BRANCH"
            elif [ "$CURRENT_BRANCH" = "main" ]; then
                echo "⚠️  Failed to push to main, trying master..."
                if git push origin master 2>&1; then
                    echo "✅ Successfully pushed to origin/master"
                else
                    echo "❌ Failed to push to GitHub"
                    echo "   Check your authentication and remote URL"
                fi
            else
                echo "❌ Failed to push to GitHub"
                echo "   Check your authentication and remote URL"
            fi
        fi
    else
        echo "❌ Failed to commit changes"
        exit 1
    fi
fi

echo ""
echo "✅ Daily run completed successfully!"
echo "=========================================="
echo ""
