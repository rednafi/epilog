FROM python:3.11.1-alpine
ENV PYTHONUNBUFFERED=1

RUN apk --no-cache add curl

WORKDIR /code
COPY /epilog /code/epilog
COPY /scripts /code/scripts
