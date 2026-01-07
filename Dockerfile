# -------- Stage 1 : Build Angular App --------
FROM node:20-alpine AS build

WORKDIR /app

RUN apk add --no-cache python3 make g++

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

ENV NODE_OPTIONS=--max_old_space_size=4096

RUN npx ng build --configuration=production

# -------- Stage 2 : Serve using Nginx --------
FROM nginx:alpine

COPY --from=build /app/dist/ecs-angular-app/browser /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
