FROM python:3.9-alpine

ENV JOOMLA_INSTALLATION_DISABLE_LOCALHOST_CHECK=1

RUN echo "http://dl-4.alpinelinux.org/alpine/v3.14/main" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.14/community" >> /etc/apk/repositories

RUN apk update
RUN apk add gcc musl-dev libffi-dev chromium chromium-chromedriver
RUN pip install --upgrade pip
RUN pip install selenium
COPY dist /dist
RUN tar czf joomla-4.1.0.tgz -C /dist . && chmod o+r joomla-4.1.0.tgz

COPY install.py /install
WORKDIR /workdir
ENTRYPOINT /install

