FROM python:3.12.0a7-alpine
ENV PYTHONUNBUFFERED=1

RUN apk --no-cache add curl

WORKDIR /code
COPY /epilog /code/epilog
COPY /scripts /code/scripts
