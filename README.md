# System Design Daily Demos

A simple program that automatically generates **interactive system design UI demos** daily using OpenAI API.

## Features

- **Dynamic Topic Discovery**: Uses OpenAI API to discover new system design topics daily (not from a predefined list)
- **Interactive Visualizations**: Each demo includes an interactive HTML page with:
  - Canvas-based animated diagrams (runtime-generated per topic)
  - Clickable components and steps
  - Flow animations
  - Step-by-step highlighting
  - Dynamic visualizations
- **Topic Tracking**: Automatically tracks covered topics in `topics.json`
- **Web Server**: View demos at `http://localhost:5000/system_design/{topic}`
- **Automated Git Workflow**: Daily cron job commits and pushes changes

## Setup

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. The program will automatically create a `topics.json` file on first run to track discovered topics.

3. Run manually to generate a demo:
```bash
python3 generate_demo.py
```

## Viewing Demos

### Start Web Server

Run the Flask web server to view demos in your browser:

```bash
python3 server.py
```

The server will start at: **http://localhost:5000/**

- **Homepage**: http://localhost:5000/ (lists all demos)
- **View a demo**: http://localhost:5000/system_design/{topic-name}
  - Example: `http://localhost:5000/system_design/dependency_injection___constructor_injection_vs_setter_injection`

### Animations

**Yes, animations are runtime-created per topic!** Each demo:
- Reads diagram data from the API response (nodes, connections, flow direction)
- Dynamically generates the canvas visualization based on that topic's structure
- Creates animations specific to that topic's diagram
- No fixed templates - each topic gets its own unique visualization

## Daily Automation

### Quick Setup (Recommended)

1. **Run the setup script** to configure GitHub repository:
```bash
chmod +x setup_github.sh
./setup_github.sh
```

This script will:
- Initialize Git repository (if needed)
- Configure Git user
- Set up GitHub remote
- Create initial commit
- Optionally push to GitHub

### Manual Setup

If you prefer manual setup:

1. **Initialize GitHub repository:**
```bash
git init
git remote add origin <your-github-repo-url>
git branch -M main
```

2. **Make scripts executable:**
```bash
chmod +x daily_run.sh setup_github.sh
```

### Setting Up Daily Automation (macOS)

**Recommended: Use launchd (macOS native - no permission prompts)**

```bash
./setup_launchd.sh
```

This will:
- Install a launchd service (macOS native scheduler)
- Schedule daily runs at 9 AM
- Avoid permission prompts that cron jobs trigger
- Automatically start on system boot

**Alternative: Cron Job (may trigger permission prompts)**

If you prefer cron:
```bash
crontab -e
# Add this line:
0 9 * * * cd /Users/karamvirsingh/Downloads/Repos/system-design-daily-demos && ./daily_run.sh >> /Users/karamvirsingh/Downloads/Repos/system-design-daily-demos/daily_run.log 2>&1
```

**View logs:**
```bash
tail -f daily_run.log
```

**Manage launchd service:**
```bash
# View status
launchctl list | grep com.systemdesign.daily

# Unload service
launchctl unload ~/Library/LaunchAgents/com.systemdesign.daily.plist

# Reload service
launchctl unload ~/Library/LaunchAgents/com.systemdesign.daily.plist && launchctl load ~/Library/LaunchAgents/com.systemdesign.daily.plist
```

### How It Works

The `daily_run.sh` script:
1. ✅ Runs `generate_demo.py` to create a new demo
2. ✅ Commits all changes with timestamp
3. ✅ Pushes to GitHub automatically
4. ✅ Logs everything to `daily_run.log`
5. ✅ Handles errors gracefully

**Note:** The script will automatically:
- Initialize Git if not present
- Detect the correct branch (main/master)
- Handle push failures gracefully
- Create log files for debugging

## Project Structure

```
system-design-daily-demos/
├── generate_demo.py      # Main script with OpenAI API integration
├── server.py             # Flask web server
├── daily_run.sh          # Daily cron script (commits & pushes to GitHub)
├── setup_github.sh       # GitHub repository setup script
├── topics.json           # Topics tracking (auto-generated)
├── daily_run.log         # Execution logs (auto-generated)
├── demos/                # Generated interactive HTML demos
├── requirements.txt      # Python dependencies
└── README.md            # This file
```

## How It Works

1. **Topic Discovery**: Uses OpenAI API to discover/generate a new, granular system design topic
2. **Content Generation**: Uses OpenAI API to generate comprehensive content including:
   - Title and explanation
   - Key components
   - Step-by-step flow
   - Diagram structure (nodes, connections, flow direction)
3. **Interactive UI Creation**: Creates an HTML file with:
   - Canvas-based visualizations (runtime-generated from diagram data)
   - Interactive diagrams with animations
   - Clickable components and steps
   - Flow animation controls
4. **Topic Tracking**: Adds the discovered topic to `topics.json` to avoid duplicates

## Interactive Features

Each demo includes:
- **Animated Diagram**: Canvas-based visualization with nodes and connections (dynamically generated per topic)
- **Animate Flow Button**: Shows flow animation through connections
- **Highlight Step Button**: Highlights current step with pulse effects
- **Clickable Steps**: Click any step to highlight it
- **Clickable Components**: Click component cards to highlight in diagram
- **Responsive Design**: Works on desktop and mobile devices

## Notes

- Topics are discovered dynamically using OpenAI API - no predefined list
- Each demo is a self-contained, interactive HTML file
- **Animations are runtime-created** - each topic's diagram structure determines its visualization
- Topics are tracked to avoid duplicates
- The program will continue discovering new topics indefinitely
- Access demos daily at `http://localhost:5000/system_design/{topic}`
