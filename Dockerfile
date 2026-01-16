FROM node:22-alpine

# Install pnpm
RUN corepack enable && corepack prepare pnpm@10.20.0 --activate

WORKDIR /app

# Copy workspace metadata first
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./

# Copy package manifests so pnpm can resolve workspace deps
COPY apps/home-assistant-matter-hub/package.json apps/home-assistant-matter-hub/
COPY packages ./packages

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy full repo
COPY . .

# Build ALL workspace packages (frontend, backend, common, app)
RUN pnpm run build

# Expose Matter Hub port
EXPOSE 5580

# Run the CLI directly
ENTRYPOINT ["node", "apps/home-assistant-matter-hub/dist/backend/cli.js", "start"]
