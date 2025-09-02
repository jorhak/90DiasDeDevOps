FROM node:18-alpine
WORKDIR /app
COPY package.json .
RUN npm install express && \
    npm install mongoose && \
    npm install cors && \
    npm install dotenv && \
    npm install
COPY . .
CMD ["node", "server.js"]