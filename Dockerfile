FROM node:18-buster
# Installing libvips-dev for sharp Compatibility
# RUN apt update && apt install build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev musl-dev
RUN apt-get update
RUN apt-get upgrade -y

# RUN apk add gcompat
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY package.json package-lock.json ./
RUN npm config set fetch-retry-maxtimeout 600000 -g && npm install
RUN npm run strapi install documentation
RUN npm install @_sh/strapi-plugin-ckeditor @strapi/plugin-documentation
ENV PATH /opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY . .
RUN chown -R node:node /opt/app
USER node
RUN ["npm", "run", "build"]
EXPOSE 1337
CMD ["npm", "run", "develop"]
