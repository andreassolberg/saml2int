FROM kasperrt/static_uninett:build-2

COPY site /srv/www/site
COPY .bowerrc /srv/www/.bowerrc
COPY _config.yml /srv/www/_config.yml
COPY package.json /srv/www/package.json
COPY bower.json /srv/www/bower.json

WORKDIR /srv/www

RUN npm install
RUN node_modules/bower/bin/bower install --config.interactive=false -p --allow-root
RUN jekyll build
RUN rm -rf /srv/www/dist/bower_components/uninett-theme/
RUN cd /srv/www/dist/bower_components/ && git clone https://github.com/andreassolberg/uninett-bootstrap-theme.git uninett-theme && cd uninett-theme && /srv/www/node_modules/bower/bin/bower install --allow-root
RUN curl -o /srv/www/dist/bower_components/uninett-theme/fonts/colfaxLight.woff http://mal.uninett.no/uninett-theme/fonts/colfaxLight.woff
RUN curl -o /srv/www/dist/bower_components/uninett-theme/fonts/colfaxMedium.woff http://mal.uninett.no/uninett-theme/fonts/colfaxMedium.woff
RUN curl -o /srv/www/dist/bower_components/uninett-theme/fonts/colfaxRegular.woff http://mal.uninett.no/uninett-theme/fonts/colfaxRegular.woff
RUN curl -o /srv/www/dist/bower_components/uninett-theme/fonts/colfaxThin.woff http://mal.uninett.no/uninett-theme/fonts/colfaxThin.woff
RUN curl -o /srv/www/dist/bower_components/uninett-theme/fonts/colfaxRegularItalic.woff http://mal.uninett.no/uninett-theme/fonts/colfaxRegularItalic.woff


EXPOSE 80