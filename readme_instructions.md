# Typesense Cloudron Package

A custom Cloudron package for [Typesense](https://typesense.org), a fast, typo-tolerant search engine that's an open-source alternative to Algolia and easier-to-use alternative to ElasticSearch.

**This package installs Typesense directly on your Cloudron instance** - no separate installation needed. Build once, deploy to Cloudron, and you're ready to use Typesense's search API.

## Features

- Fast, typo-tolerant search
- RESTful API
- Auto-generated secure API keys
- CORS support for web applications
- Persistent data storage
- Built-in health checks
- Configurable logging levels

## Installation

This is a complete Cloudron package for Typesense. You'll build it once, then install it on your Cloudron instance.

### Prerequisites (for building the package)

- Docker installed on your local machine (for building)
- Cloudron CLI tool installed
- Access to a Docker registry (Docker Hub, private registry, etc.)

### Build and Deploy to Cloudron

1. **Download these package files** to a directory on your local machine

2. **The icon.png file is already included** in this package.

3. **Build the Cloudron package** (creates Docker image):
   ```bash
   # Replace 'your-username' with your Docker Hub username or registry path
   docker build -t your-username/typesense-cloudron:29.0.0 .
   ```

4. **Push to registry**:
   ```bash
   docker push your-username/typesense-cloudron:29.0.0
   ```

5. **Install on your Cloudron instance**:
   ```bash
   cloudron install --image your-username/typesense-cloudron:29.0.0
   ```

**That's it!** Typesense will now be running on your Cloudron instance with automatic backups, user management, and SSL.

### Alternative: Using Cloudron Build Command

You can also use the Cloudron CLI's build command (which automates the above steps):

```bash
# Set your repository (first time only)
cloudron build --set-repository your-username/typesense-cloudron

# Build and push the package
cloudron build

# Install on your Cloudron instance
cloudron install --image your-username/typesense-cloudron:$(date +%Y%m%d-%H%M%S)
```

## Configuration

### Environment Variables

The following environment variables can be configured:

- `TYPESENSE_API_KEY`: Master API key (auto-generated if not provided)
- `TYPESENSE_DATA_DIR`: Data directory (default: `/app/data/typesense`)
- `TYPESENSE_LOG_LEVEL`: Log level - INFO, DEBUG, WARN, ERROR (default: `INFO`)
- `TYPESENSE_ENABLE_CORS`: Enable CORS (default: `true`)

### Memory Requirements

- Minimum: 512MB RAM
- Recommended: 1GB+ RAM for production use
- Memory usage scales with your data size and query volume

## Usage

### API Access

Once installed, Typesense will be available at your Cloudron app URL on port 8108.

**Health Check**: `GET /health`
**Debug Info**: `GET /debug`
**API Documentation**: https://typesense.org/docs/29.0/api/

### Basic API Examples

#### Create a Collection
```bash
curl -X POST 'https://your-app.yourdomain.com/collections' \
-H 'X-TYPESENSE-API-KEY: your-api-key' \
-H 'Content-Type: application/json' \
-d '{
  "name": "books",
  "fields": [
    {"name": "title", "type": "string"},
    {"name": "authors", "type": "string[]"},
    {"name": "publication_year", "type": "int32"},
    {"name": "ratings_count", "type": "int32"},
    {"name": "average_rating", "type": "float"}
  ],
  "default_sorting_field": "ratings_count"
}'
```

#### Add a Document
```bash
curl -X POST 'https://your-app.yourdomain.com/collections/books/documents' \
-H 'X-TYPESENSE-API-KEY: your-api-key' \
-H 'Content-Type: application/json' \
-d '{
  "title": "The Great Gatsby",
  "authors": ["F. Scott Fitzgerald"],
  "publication_year": 1925,
  "ratings_count": 12345,
  "average_rating": 4.2
}'
```

#### Search
```bash
curl -X GET 'https://your-app.yourdomain.com/collections/books/documents/search?q=gatsby&query_by=title' \
-H 'X-TYPESENSE-API-KEY: your-api-key'
```

## Data Persistence

- Data is stored in `/app/data/typesense` which is backed up by Cloudron
- Logs are stored in `/run/typesense` (not backed up)
- Configuration is generated at startup in `/run/typesense/typesense.ini`

## Troubleshooting

### View Logs
```bash
cloudron logs
```

### Access Shell
```bash
cloudron exec
```

### Check Health
```bash
curl https://your-app.yourdomain.com/health
```

### Debug Information
```bash
curl https://your-app.yourdomain.com/debug
```

## Security Notes

1. **API Keys**: The master API key is auto-generated on first startup. You can find it in the app logs or generate scoped API keys via the API.

2. **Network Access**: By default, the app is accessible to anyone with the URL. Configure access control in Cloudron if needed.

3. **CORS**: CORS is enabled by default for web application integration. Disable if not needed.

## Performance Tuning

For production deployments:

1. **Increase Memory Limit**: Adjust in Cloudron app settings
2. **Monitor Resource Usage**: Use Cloudron's monitoring features
3. **Optimize Collections**: Use appropriate field types and sorting fields
4. **Index Management**: Regularly monitor index size and performance

## Support

- [Typesense Documentation](https://typesense.org/docs/)
- [Typesense GitHub](https://github.com/typesense/typesense)
- [Cloudron Forum](https://forum.cloudron.io/)

## Version Information

- Typesense Version: 29.0
- Cloudron Base Image: 4.2.0
- Package Version: 29.0.0

## License

This package follows Typesense's GPL v3 license. The package files are provided as-is for community use.