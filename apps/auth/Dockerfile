FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
Run npm install

FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .

USER node
EXPOSE 3000
CMD ["node","index.js"]