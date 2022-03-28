FROM node:16.6.0-alpine as base

WORKDIR /BackExpress
#COPY package*.json /
EXPOSE 3000

FROM base as dev
ENV NODE_ENV=development
ENV DATABASE_URL="mysql://root:S3cret@mariadb:3306/area_db"
COPY ./ /BackExpress
RUN npm install
RUN npx prisma generate
CMD ["npm", "run", "start:dev"]

FROM base as production
ENV NODE_ENV=production
ENV DATABASE_URL="mysql://root:S3cret@mariadb:3306/area_db"
COPY ./ /BackExpress
RUN npm ci
RUN npx prisma generate
CMD ["node", "server"]