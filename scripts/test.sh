#!/bin/bash
echo "Starting containers for test..."
docker-compose up -d
sleep 5
curl -f http://localhost:5000/health || (echo "Health check failed" && docker-compose down && exit 1)
echo "Health OK"
docker-compose down
