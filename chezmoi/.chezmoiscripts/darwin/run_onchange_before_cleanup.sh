#!/bin/bash
echo "🗑️ Cleanup packages..."

# replaced by musescore
brew remove lilypond || true
brew remove ly || true

