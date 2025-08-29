FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

RUN mkdir -p /app/code

WORKDIR /app/code

# Install Typesense binary
ARG TYPESENSE_VERSION=29.0
RUN curl -L https://dl.typesense.org/releases/${TYPESENSE_VERSION}/typesense-server-${TYPESENSE_VERSION}-linux-amd64.tar.gz \
    | tar -xz -C /app/code && \
    chmod +x /app/code/typesense-server

# Create configuration template
COPY typesense.ini.template /app/code/typesense.ini.template
COPY start.sh /app/code/start.sh

# Make start script executable
RUN chmod +x /app/code/start.sh

# Create ALL directories that Typesense will need, with proper ownership
RUN mkdir -p /run/typesense /app/data /app/data/db /app/data/meta /app/data/analytics && \
    chown -R cloudron:cloudron /app/data /run/typesense

# Health check
HEALTHCHECK --interval=10s --timeout=3s CMD curl -f http://localhost:8108/health || exit 1

EXPOSE 8108

CMD ["/app/code/start.sh"]