FROM ruby:2.7.7-slim-bullseye AS builder
MAINTAINER Gregory Wiedeman gwiedeman@albany.edu

ENV RAILS_ENV=production

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential apt-utils git cron curl nodejs
# The regular apt install yarn isn't as up to date as we need
RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn

# Add crontab file in the cron directory
COPY ./config/history-cron /etc/cron.d/history-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/history-cron

# Apply cron job to clean up the db
RUN crontab /etc/cron.d/history-cron

# specifying the version is needed in older ruby image. Should not be needed in ruby 3+.
RUN gem install bundler -v 2.4.22

# Install gems
WORKDIR /app
COPY Gemfile* ./
RUN bundle install

# Copy application code
COPY . /app

# Precompile assets using environment variable
ARG MASTER_KEY
RUN mkdir -p /app/config && echo "$MASTER_KEY" > /app/config/master.key && \
    RAILS_ENV=production MASTER_KEY=$MASTER_KEY bundle exec rails assets:precompile && \
    rm /app/config/master.key

# Final image
FROM ruby:2.7.7-slim-bullseye

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential apt-utils git cron curl nodejs
# The regular apt install yarn isn't as up to date as we need
RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn

# Copy application code and precompiled assets from the builder stage
COPY --from=builder /app /app

# Expose port 3000
ARG DEFAULT_PORT 3000
EXPOSE ${DEFAULT_PORT}

# Copy the entrypoint script
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Start cron and Rails server
CMD ["sh", "-c", "cron && /usr/bin/entrypoint.sh"]
