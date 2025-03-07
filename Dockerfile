# Stage 1: Builder
FROM node:22-alpine as builder
WORKDIR /app
# Clone repository directly into /app
RUN git clone https://github.com/Parth2710/role-base-app.git
# Install dependencies, generate Prisma client, and build the Next.js app
RUN npm install && npx prisma generate && npm run build

# Stage 2: Runner (Production)
FROM node:22-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
# Adjust file names and paths based on your project structure
COPY --from=builder /app/next.config.ts ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
EXPOSE 3000
CMD ["npm", "start"]
