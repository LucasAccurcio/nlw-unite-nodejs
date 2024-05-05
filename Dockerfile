FROM node:18.20.2-alpine3.19 AS build

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

RUN npm run db:migrate

RUN npm run build


FROM node:18.20.2-alpine3.19

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/prisma/ ./prisma
COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/dist ./dist

EXPOSE 3333

CMD ["npm", "start"]