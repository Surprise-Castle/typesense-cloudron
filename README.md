# Typesense Cloudron Package

A production-ready Cloudron package for [Typesense](https://typesense.org), a fast, typo-tolerant search engine that's an open-source alternative to Algolia and easier-to-use alternative to ElasticSearch.

## 🚀 Quick Start

```bash
# Build the package
./build.sh

# Or manually:
docker build -t your-username/typesense-cloudron:29.0.0 .
docker push your-username/typesense-cloudron:29.0.0

# Install on Cloudron
cloudron install --image your-username/typesense-cloudron:29.0.0
```

## ✨ Features

- **Fast Search**: Typo-tolerant, real-time search with sub-second response times
- **RESTful API**: Simple HTTP API with auto-generated secure API keys
- **Cloudron Integration**: Native Cloudron app with automatic backups and SSL
- **Production Ready**: Includes health checks, logging, and performance tuning
- **CORS Support**: Ready for web application integration

## 📋 Requirements

- Cloudron 7.0.0 or higher
- Minimum 512MB RAM (1GB+ recommended for production)
- Docker (for building the package)

## 🔧 Configuration

The package automatically generates secure API keys and configures itself. Key environment variables:

- `TYPESENSE_API_KEY`: Master API key (auto-generated)
- `TYPESENSE_DATA_DIR`: Data directory (default: `/app/data/typesense`)
- `TYPESENSE_LOG_LEVEL`: Log level (default: `INFO`)
- `TYPESENSE_ENABLE_CORS`: CORS support (default: `true`)

## 📚 Documentation

- [Detailed Installation Guide](readme_instructions.md)
- [Typesense API Documentation](https://typesense.org/docs/29.0/api/)
- [Cloudron Documentation](https://docs.cloudron.io/)

## 🤝 Contributing

This package is open source and contributions are welcome! Please read the [LICENSE](LICENSE) file for details.

## 📄 License

This package is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ for the Cloudron community**
