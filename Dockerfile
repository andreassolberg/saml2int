FROM nginx

WORKDIR /srv/www

ADD default.conf /etc/nginx/conf.d/default.conf

RUN apt-get update && apt-get install -y curl npm python2.7 git
RUN cd /tmp && curl -LOk http://ftp.ruby-lang.org/pub/ruby/2.2/ruby-2.2.5.tar.gz && \
	tar -xvzf ruby-2.2.5.tar.gz && \
	cd ruby-2.2.5/ && \
	./configure --prefix=/usr/local && \
	make && \
	make install && \
	rm -rf ruby-2.2.5.tar.gz && \
	rm -rf ruby-2.2.5
RUN ln -s `which nodejs` /usr/bin/node
RUN rm -rf /var/lib/apt/lists/*

RUN gem install jekyll --no-ri --no-rdoc
RUN gem install rouge --no-ri --no-rdoc

COPY site /srv/www/site
COPY .bowerrc /srv/www/.bowerrc
COPY _config.yml /srv/www/_config.yml
COPY package.json /srv/www/package.json
COPY bower.json /srv/www/bower.json

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
