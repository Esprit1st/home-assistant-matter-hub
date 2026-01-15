# Use a lightweight Node.js base image
FROM node:20-alpine

# Create app directory
WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the application
COPY . .

# Expose the default Matter Hub port (optional)
EXPOSE 5580

# Start the Matter Hub application
CMD ["npm", "start"]
