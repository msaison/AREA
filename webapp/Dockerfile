FROM node:16.6.0-alpine as base

WORKDIR /webapp
#COPY package*.json /
EXPOSE 8080

FROM base as dev
ENV NODE_ENV=development
COPY ./ /webapp
RUN npm install /webapp
CMD ["npm", "run", "serve"]