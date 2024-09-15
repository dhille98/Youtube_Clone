# Stage 1: Build the React application
FROM node:18-alpine AS build

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the React app for production
RUN npm run build

# Stage 2: Run the application
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy only the build output from the previous stage
COPY --from=build /usr/src/app/build ./build

# Install serve to serve the React production build
RUN npm install -g serve

# Expose the port the app runs on
EXPOSE 3000

# Use "serve" to serve the static files
CMD ["serve", "-s", "build", "-l", "3000"]
