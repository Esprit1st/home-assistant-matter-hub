FROM node:22-alpine

# Install pnpm
RUN corepack enable && corepack prepare pnpm@10.20.0 --activate

WORKDIR /app

# Copy only workspace files needed for dependency resolution
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/home-assistant-matter-hub/package.json apps/home-assistant-matter-hub/
COPY packages ./packages

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy the full repo
COPY . .

# Build the Matter Hub app
RUN pnpm --filter home-assistant-matter-hub run build

# Expose the Matter Hub port (optional)
EXPOSE 5580

# Run the CLI directly so flags pass through
ENTRYPOINT ["node", "apps/home-assistant-matter-hub/dist/backend/cli.js", "start"]
