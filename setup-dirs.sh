#!/bin/bash

# Create the sysadmin_handbook directory structure

# Linux
mkdir -p linux/basics
mkdir -p linux/networking
mkdir -p linux/storage
mkdir -p linux/security
mkdir -p linux/systemd

# Windows
mkdir -p windows/active-directory
mkdir -p windows/powershell
mkdir -p windows/group-policy
mkdir -p windows/troubleshooting

# Automation
mkdir -p automation/ansible/playbooks
mkdir -p automation/ansible/guides
mkdir -p automation/bash-scripts
mkdir -p automation/python-scripts

# Monitoring
mkdir -p monitoring

# Containers
mkdir -p containers/docker
mkdir -p containers/kubernetes

# Cloud
mkdir -p cloud/aws
mkdir -p cloud/azure
mkdir -p cloud/gcp

# Cheatsheets
mkdir -p cheatsheets

# Projects
mkdir -p projects

echo "Directory structure created successfully!"

# To run
# cd into directory
# > chmod +x setup-dirs.sh
# > ./setup-dirs.sh