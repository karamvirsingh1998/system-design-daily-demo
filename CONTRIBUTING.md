# Contributing to System Design Interactive Demos

Thank you for your interest in contributing! This project aims to make system design concepts accessible through interactive, game-based learning experiences.

## How to Contribute

### Adding New Demos

1. **Set up your environment:**
   ```bash
   pip install -r requirements.txt
   echo "OPENAI_API_KEY=your-key-here" > .env
   ```

2. **Generate a new demo:**
   ```bash
   python3 generator.py
   ```

3. **Test the demo:**
   - Start the server: `python3 server.py`
   - Open the demo in your browser
   - Verify all interactive elements work

4. **Submit a pull request** with your new demo

### Improving Existing Demos

- Fix bugs or improve visualizations
- Enhance explanations or examples
- Improve mobile responsiveness
- Add more interactive elements

### Improving the Generator

- Enhance the prompt engineering
- Improve HTML generation quality
- Add new features to the generator
- Optimize performance

## Guidelines

- **Keep demos self-contained**: Each HTML file should work independently
- **Maintain quality**: Ensure demos are educational and engaging
- **Test thoroughly**: Verify demos work across different browsers
- **Follow the style**: Maintain consistency with existing demos

## Questions?

Feel free to open an issue for questions or suggestions!
