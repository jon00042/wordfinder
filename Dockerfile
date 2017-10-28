FROM alpine

RUN \
apk update && \
apk upgrade && \
apk add bash && \
apk add curl && \
apk add file && \
apk add gcc && \
apk add git && \
apk add make && \
apk add musl-dev && \
apk add perl && \
apk add perl-dev && \
apk add tzdata && \
apk add vim

RUN \
curl -L https://cpanmin.us > /usr/local/bin/cpanm && \
chmod +x /usr/local/bin/cpanm && \
cpanm --no-wget Dancer && \
cpanm --no-wget YAML

RUN \
cd /tmp && \
git clone https://github.com/jon00042/wordfinder && \
/bin/sh -x /tmp/wordfinder/deploy.sh

CMD /usr/local/wordfinder/bin/app.pl
