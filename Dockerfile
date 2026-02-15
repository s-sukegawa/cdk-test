FROM node:20-bookworm-slim

WORKDIR /app

# Dependencies first (cache-friendly)
COPY package.json package-lock.json* ./
# Use ci when lock exists, otherwise install and generate lock
RUN if [ -f package-lock.json ]; then npm ci; else npm install --package-lock-only && npm ci; fi

# CDK CLI (v2)
RUN npm i -g aws-cdk@2

RUN apt-get update && \
    apt-get install -y awscli less ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Source
COPY . .

CMD ["bash"]
