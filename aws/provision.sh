#!/bin/bash
sudo dnf install -y epel-release
sudo dnf install -y nginx
sudo systemctl start nxinx
sudo systemctl enable nginx