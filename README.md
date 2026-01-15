# System Design Interactive Demos

A curated collection of **interactive, game-based HTML demos** that explain system design concepts through engaging visualizations, cartoon characters, and progressive learning experiences.

## 🎯 What is This?

Each demo is a self-contained, interactive HTML page that explains a specific system design concept through:
- **Game-based interface** with engaging UI
- **Cartoon characters** that guide you through concepts
- **Story-driven examples** that start simple and build complexity
- **Interactive animations** and visualizations
- **Progressive learning** from beginner to advanced

## 📚 Available Demos

Browse our collection of interactive system design demos:

- [API Gateway - Request Transformation and Routing](demos/api_gateway___request_transformation_and_routing.html)
- [API Rate Limiting - Leaky Bucket Algorithm](demos/api_rate_limiting___leaky_bucket_algorithm.html)
- [Data Consistency - Eventual Consistency in Distributed Databases](demos/data_consistency___eventual_consistency_in_distributed_databases.html)
- [Data Partitioning - Vertical Partitioning in Relational Databases](demos/data_partitioning___vertical_partitioning_in_relational_databases.html)
- [Data Replication - Synchronous vs. Asynchronous Replication](demos/data_replication___synchronous_vs_asynchronous_replication.html)
- [Data Serialization - Protocol Buffers vs JSON](demos/data_serialization___protocol_buffers_vs_json.html)
- [Data Warehousing - Slowly Changing Dimensions Type 2](demos/data_warehousing___slowly_changing_dimensions_type_2.html)
- [Dependency Injection - Constructor Injection vs Setter Injection](demos/dependency_injection___constructor_injection_vs_setter_injection.html)
- [Service Discovery - DNS Based Service Registration](demos/service_discovery___dns_based_service_registration.html)
- [Service Mesh - Sidecar Proxy Pattern](demos/service_mesh___sidecar_proxy_pattern.html)

## 🚀 Quick Start

### View Demos Locally

1. **Clone the repository:**
   ```bash
   git clone https://github.com/karamvirsingh1998/system-design-daily-demo.git
   cd system-design-daily-demo
   ```

2. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Start the web server:**
   ```bash
   python3 server.py
   ```

4. **Open in browser:**
   - Homepage: http://localhost:8080/
   - Browse all demos or navigate directly to any demo

### View Demos Directly

You can also open any HTML file directly in your browser - each demo is completely self-contained!

## 🎮 Features

Each interactive demo includes:

- **🎨 Game-Based Interface**: Engaging, game-like UI that makes learning fun
- **👥 Cartoon Characters**: Personified components with personalities that explain concepts
- **📖 Story Examples**: Real-world scenarios (restaurants, libraries, games) that illustrate concepts
- **🎬 Interactive Animations**: Canvas-based visualizations that animate concepts
- **📈 Progressive Learning**: Start with simple examples, then build to advanced concepts
- **🖱️ Interactive Elements**: Clickable components, animated flows, and step-by-step highlighting
- **📱 Responsive Design**: Works beautifully on desktop, tablet, and mobile

## 🏗️ Project Structure

```
system-design-daily-demo/
├── demos/              # Interactive HTML demo files
├── server.py           # Local web server for browsing demos
├── generator.py        # Tool for generating new demos
├── requirements.txt    # Python dependencies
└── README.md          # This file
```

## 🛠️ For Contributors

### Generating New Demos

If you'd like to generate a new demo on a specific system design topic:

1. **Set up environment:**
   ```bash
   # Create .env file with your OpenAI API key
   echo "OPENAI_API_KEY=your-key-here" > .env
   ```

2. **Generate a demo:**
   ```bash
   python3 generator.py
   ```

The generator will:
- Discover a new, granular system design topic
- Create an interactive, game-based HTML demo
- Save it to the `demos/` directory

## 📖 How It Works

Each demo is generated with:
1. **Topic Discovery**: AI identifies a specific, granular system design concept
2. **Content Generation**: Creates game-based HTML with characters, stories, and explanations
3. **Interactive Elements**: Adds animations, clickable components, and visualizations
4. **Progressive Structure**: Organizes content from simple examples to advanced concepts

## 🎓 Learning Path

These demos are designed for:
- **Beginners**: Start with story examples and simple explanations
- **Intermediate**: Progress through interactive diagrams and visualizations
- **Advanced**: Deep dive into technical implementations and trade-offs

## 🤝 Contributing

Contributions are welcome! Whether it's:
- Improving existing demos
- Adding new system design topics
- Enhancing the generator tool
- Fixing bugs or improving documentation

Please feel free to open issues or submit pull requests.

## 📄 License

This project is open source and available for educational purposes.

## 🔗 Resources

- [System Design Primer](https://github.com/donnemartin/system-design-primer)
- [High Scalability](http://highscalability.com/)
- [System Design Interview](https://www.educative.io/courses/grokking-the-system-design-interview)

---

**Made with ❤️ for the system design community**
