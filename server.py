#!/usr/bin/env python3
"""
Web Server for System Design Demos
Serves HTML demos at localhost/system_design/{topic}
"""

from flask import Flask, send_from_directory, redirect, url_for
import os
from pathlib import Path

app = Flask(__name__)
DEMOS_DIR = "demos"

@app.route('/')
def index():
    """Main index page listing all demos"""
    html = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>System Design Demos</title>
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                padding: 40px 20px;
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
                background: white;
                border-radius: 20px;
                padding: 40px;
                box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            }
            h1 {
                color: #333;
                margin-bottom: 30px;
                font-size: 3em;
                border-bottom: 3px solid #667eea;
                padding-bottom: 15px;
            }
            .subtitle {
                color: #666;
                font-size: 1.2em;
                margin-bottom: 40px;
            }
            .demos-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 20px;
                margin-top: 30px;
            }
            .demo-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 25px;
                border-radius: 15px;
                text-decoration: none;
                transition: transform 0.3s, box-shadow 0.3s;
                display: block;
            }
            .demo-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 30px rgba(102, 126, 234, 0.5);
            }
            .demo-card h2 {
                margin-bottom: 10px;
                font-size: 1.5em;
            }
            .demo-card p {
                opacity: 0.9;
                font-size: 0.9em;
            }
            .info {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 30px;
                border-left: 4px solid #667eea;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🎯 System Design Interactive Demos</h1>
            <p class="subtitle">Learn system design concepts through engaging, game-based interactive visualizations</p>
            
            <div class="info">
                <strong>✨ What makes these demos special:</strong> Each demo features game-based interfaces, cartoon characters, 
                story-driven examples, and interactive animations that make learning system design concepts fun and engaging.
            </div>
            
            <h2>Available Demos</h2>
            <div class="demos-grid">
"""
    
    # List all HTML files in demos directory
    if os.path.exists(DEMOS_DIR):
        html_files = sorted([f for f in os.listdir(DEMOS_DIR) if f.endswith('.html')], reverse=True)
        for html_file in html_files:
            topic_name = html_file.replace('.html', '').replace('_', ' ').title()
            html += f"""
                <a href="/system_design/{html_file.replace('.html', '')}" class="demo-card">
                    <h2>{topic_name}</h2>
                    <p>View interactive demo →</p>
                </a>
"""
    else:
        html += '<p>No demos available yet. Run <code>python3 generator.py</code> to create one!</p>'
    
    html += """
            </div>
        </div>
    </body>
    </html>
    """
    return html

@app.route('/system_design/<topic>')
def show_demo(topic):
    """Serve a specific demo HTML file"""
    # Add .html extension if not present
    if not topic.endswith('.html'):
        topic += '.html'
    
    if os.path.exists(os.path.join(DEMOS_DIR, topic)):
        return send_from_directory(DEMOS_DIR, topic)
    else:
        return f"Demo '{topic}' not found. <a href='/'>Back to index</a>", 404

if __name__ == '__main__':
    # Create demos directory if it doesn't exist
    os.makedirs(DEMOS_DIR, exist_ok=True)
    
    print("=" * 60)
    print("System Design Demos Web Server")
    print("=" * 60)
    print(f"\n🌐 Server running at: http://localhost:8080/")
    print(f"📁 View demos at: http://localhost:8080/system_design/{{topic}}")
    print(f"\n📌 Example: http://localhost:8080/system_design/dependency_injection___constructor_injection_vs_setter_injection")
    print(f"\n💡 Press Ctrl+C to stop the server\n")
    print("=" * 60)
    
    app.run(debug=True, host='0.0.0.0', port=8080)
