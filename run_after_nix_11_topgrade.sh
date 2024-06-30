#!/bin/bash
echo "💡 Upgrade all the things..."
chezmoi upgrade
topgrade || true
