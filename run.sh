#!/bin/bash
echo "indexed_file: "$1 > config/settings.local.yml
bundle exec rackup
