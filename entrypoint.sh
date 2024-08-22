#!/bin/sh

# Define the path to the SQLite database
DB_PATH="/app/db/production.sqlite"

# Check if the SQLite database file exists
if [ ! -f "$DB_PATH" ]; then
  echo "Database not found. Running migrations..."
  # Run database migrations
  bundle exec rake db:migrate
else
  echo "Database found. Skipping migrations."
fi

# Precompile assets if necessary
echo "Precompiling assets..."
bundle exec rails assets:precompile

# Start the Rails server
echo "Starting Rails server..."
bundle exec puma -C config/puma.rb
