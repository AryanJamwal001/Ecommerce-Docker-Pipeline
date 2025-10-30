#!/bin/bash
echo "Building docker image..."
docker build -t <DOCKERHUB_USER>/dockerproject:latest .
