FROM python:3.10-alpine
ENV PYTHONUNBUFFERED=1

WORKDIR /code
COPY ./epilog/ /code
