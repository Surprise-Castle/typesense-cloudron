#!/bin/bash

set -e

# Configuration
PACKAGE_NAME="typesense-cloudron"
VERSION="29.0.1"
TYPESENSE_VERSION="29.0"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Building Typesense Cloudron Package${NC}"
echo "Package: $PACKAGE_NAME"
echo "Version: $VERSION"
echo "Typesense Version: $TYPESENSE_VERSION"
echo ""

# Check prerequisites
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is required but not installed${NC}"
    exit 1
fi

if ! command -v cloudron &> /dev/null; then
    echo -e "${YELLOW}Warning: Cloudron CLI not found. You'll need it to install the package${NC}"
fi

# Get repository name
if [ -z "${REGISTRY_REPO:-}" ]; then
    echo -e "${YELLOW}Enter your Docker registry repository (e.g., 'username/typesense-cloudron' or 'your-registry.com/typesense'):${NC}"
    read -p "Repository: " REGISTRY_REPO
fi

if [ -z "$REGISTRY_REPO" ]; then
    echo -e "${RED}Error: Repository name is required${NC}"
    exit 1
fi

IMAGE_NAME="${REGISTRY_REPO}:${VERSION}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
TIMESTAMPED_IMAGE="${REGISTRY_REPO}:${TIMESTAMP}"

echo ""
echo "Building image: $IMAGE_NAME"
echo "Timestamped image: $TIMESTAMPED_IMAGE"
echo ""

# Build the Docker image
echo -e "${GREEN}Building Docker image...${NC}"
docker build \
    --platform linux/amd64 \
    --build-arg TYPESENSE_VERSION=$TYPESENSE_VERSION \
    -t "$IMAGE_NAME" \
    -t "$TIMESTAMPED_IMAGE" \
    .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Docker image built successfully${NC}"
else
    echo -e "${RED}✗ Docker image build failed${NC}"
    exit 1
fi

# Push to registry
echo -e "${GREEN}Pushing to registry...${NC}"
docker push "$IMAGE_NAME"
docker push "$TIMESTAMPED_IMAGE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Image pushed successfully${NC}"
else
    echo -e "${RED}✗ Image push failed${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}Build completed successfully!${NC}"
echo ""
echo "To install on Cloudron:"
echo "  cloudron install --image $TIMESTAMPED_IMAGE"
echo ""
echo "Or using the version tag:"
echo "  cloudron install --image $IMAGE_NAME"
echo ""
echo -e "${YELLOW}Note: Save the API key that's generated during first startup${NC}"