# build environment
FROM node:14.17.3-alpine as build

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm ci --silent
RUN npm install react-scripts@4.0.3 -g --silent

# add app
COPY . ./

# start app
RUN npm run build

# production environment with Ngnix
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# start app without Ngnix
#EXPOSE 80
#CMD ["npm", "start"]