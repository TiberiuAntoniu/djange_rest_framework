FROM python:3.13-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
PYTHONUBEFFERED=1
ARG DEV=false

WORKDIR /app

RUN apt-get update \
&& apt-get install -y curl

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

COPY ./requirements.txt .
COPY ./requirements_dev.txt .
RUN echo DEV
RUN uv pip install -r requirements.txt --system && \
    if [ "$DEV" = "true" ]; \
       then uv pip install -r requirements_dev.txt --system ; \
    fi && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

EXPOSE 8000

COPY ./app /app

USER django-user