#!/usr/bin/env python3
"""
Daily System Design Demo Generator
Uses OpenAI API to discover new topics daily and create interactive UI demos
"""

import json
import os
import sys
from datetime import datetime
from pathlib import Path
from openai import OpenAI

# Load .env file if it exists
def load_env_file():
    """Load environment variables from .env file"""
    env_path = Path(__file__).parent / ".env"
    if env_path.exists():
        with open(env_path, 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = line.split('=', 1)
                    os.environ[key.strip()] = value.strip()

# Load .env file
load_env_file()

# Configuration
API_KEY = os.getenv("OPENAI_API_KEY")
if not API_KEY:
    print("❌ Error: OPENAI_API_KEY environment variable not set!")
    print("   Set it with: export OPENAI_API_KEY='your-api-key'")
    print("   Or create a .env file with: OPENAI_API_KEY=your-api-key")
    sys.exit(1)

client = OpenAI(api_key=API_KEY)
TOPICS_FILE = "topics.json"
DEMOS_DIR = "demos"

def load_topics():
    """Load covered topics from JSON file"""
    if os.path.exists(TOPICS_FILE):
        with open(TOPICS_FILE, 'r') as f:
            return json.load(f)
    else:
        # Initialize with empty list - topics will be discovered dynamically
        topics = {
            "covered": []
        }
        save_topics(topics)
        return topics

def save_topics(topics):
    """Save topics to JSON file"""
    with open(TOPICS_FILE, 'w') as f:
        json.dump(topics, f, indent=2)

def discover_topic(topics):
    """Use OpenAI API to discover a new system design topic"""
    try:
        covered_list = topics.get("covered", [])
        covered_text = ", ".join(covered_list[-10:]) if covered_list else "none"
        
        prompt = f"""Generate a new, interesting, and granular system design topic that hasn't been covered yet.

Already covered topics (last 10): {covered_text}

Generate a specific, granular system design topic. Examples of good granular topics:
- "Load Balancer - Round Robin Algorithm"
- "Database Sharding - Horizontal Partitioning"
- "Caching Strategy - Cache-Aside Pattern"
- "Message Queue - Pub/Sub Pattern"
- "Rate Limiting - Token Bucket Algorithm"
- "Consistent Hashing in Distributed Systems"
- "Circuit Breaker Pattern in Microservices"
- "Event Sourcing in Event-Driven Architecture"

Return ONLY the topic name (no quotes, no explanation, just the topic title). Make it specific and granular, not too broad."""
        
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "user", "content": prompt}
            ],
            temperature=0.7,
            max_tokens=100
        )
        
        topic = response.choices[0].message.content.strip()
        
        # Clean up the response
        topic = topic.strip('"\'`').strip()
        if topic.startswith("Topic:"):
            topic = topic.replace("Topic:", "").strip()
        if "\n" in topic:
            topic = topic.split("\n")[0].strip()
        
        # Ensure it's not already covered
        if topic in covered_list:
            print(f"Topic '{topic}' already covered, discovering another...")
            return discover_topic(topics)
        
        return topic
    except Exception as e:
        print(f"Error discovering topic: {e}")
        # Fallback topic
        return f"System Design Topic - {datetime.now().strftime('%Y-%m-%d')}"

def generate_demo_content(topic):
    """Use OpenAI API to generate complete HTML game-based demo with cartoon characters"""
    try:
        prompt = f"""Create a COMPLETE, INTERACTIVE HTML GAME for explaining: {topic}

Generate a FULL, WORKING HTML file with:
1. GAME-BASED INTERFACE - make it like an educational game
2. CARTOON CHARACTERS - create 2-4 personified components with names, emojis, and personalities
3. START WITH EXAMPLE - begin with a simple story/scenario (restaurant, library, game, etc.)
4. PROGRESSIVE FLOW - story -> explanation -> interactive diagram
5. INTERACTIVE ANIMATIONS - characters move, show emotions, explain concepts
6. CANVAS-BASED VISUALIZATIONS - animated diagrams showing the concept
7. GAME-LIKE PROGRESSION - levels, achievements, interactive elements

Requirements:
- Complete HTML file (from DOCTYPE html to closing html tag)
- Embedded CSS and JavaScript
- Canvas-based animations for diagrams
- Interactive elements (buttons, clickable characters, animated flows)
- Responsive design
- Fun, engaging, game-like UI
- Start with a story example, then build to technical explanation
- Characters should speak through speech bubbles
- Animations should be topic-specific to {topic}

The HTML should include:
- Game-style header with title
- Character introduction section with emojis and personalities
- Story section (simple example first)
- Progressive learning with levels
- Interactive diagram with canvas animations
- Character interactions that explain the concept
- Visual feedback and messages

Return ONLY the complete HTML code, starting with DOCTYPE html and ending with closing html tag.
Make sure all CSS and JavaScript are embedded within style and script tags.
"""
        
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "user", "content": prompt}
            ],
            temperature=0.7,
            max_tokens=12000
        )
        
        response_text = response.choices[0].message.content.strip()
        
        # Extract complete HTML from response
        html_content = response_text
        
        # If wrapped in code blocks, extract it
        if "```html" in response_text:
            html_start = response_text.find("```html") + 7
            html_end = response_text.find("```", html_start)
            if html_end != -1:
                html_content = response_text[html_start:html_end].strip()
        elif "```" in response_text:
            html_start = response_text.find("```") + 3
            html_end = response_text.find("```", html_start)
            if html_end != -1:
                html_content = response_text[html_start:html_end].strip()
        
        # Ensure it starts with <!DOCTYPE or <html
        if not html_content.strip().startswith("<!DOCTYPE") and not html_content.strip().startswith("<html"):
            # If no HTML found, look for HTML tags
            start_tag = html_content.find("<html")
            if start_tag != -1:
                html_content = html_content[start_tag:]
        
        return html_content
    except Exception as e:
        print(f"Error generating HTML: {e}")
        # Return minimal fallback HTML
        return f"""<!DOCTYPE html>
<html>
<head><title>{topic}</title></head>
<body><h1>{topic}</h1><p>Error generating content. Please try again.</p></body>
</html>"""

def create_interactive_html(topic, html_content):
    """Save complete HTML file generated by AI"""
    os.makedirs(DEMOS_DIR, exist_ok=True)
    
    # Create filename from topic
    filename = topic.lower().replace(" ", "_").replace("-", "_").replace("/", "_")
    filename = "".join(c for c in filename if c.isalnum() or c in ("_", "-"))
    filepath = os.path.join(DEMOS_DIR, f"{filename}.html")
    
    # Save the complete HTML generated by AI directly
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(html_content)
    
    return filepath

def main():
    """Main function"""
    print("Daily System Design Demo Generator")
    print("=" * 50)
    
    # Load topics
    topics = load_topics()
    
    # Discover new topic using OpenAI API
    print("Discovering new topic with OpenAI API...")
    topic = discover_topic(topics)
    print(f"Discovered topic: {topic}")
    
    # Generate HTML content
    print("Generating HTML content with OpenAI API...")
    html_content = generate_demo_content(topic)
    
    # Create interactive HTML file
    print("Creating interactive HTML demo...")
    filepath = create_interactive_html(topic, html_content)
    print(f"Demo created: {filepath}")
    
    # Add topic to covered list and save
    if "covered" not in topics:
        topics["covered"] = []
    topics["covered"].append(topic)
    save_topics(topics)
    print(f"Topic '{topic}' added to covered list")
    
    return 0

if __name__ == "__main__":
    sys.exit(main())
