FROM python:3.12-alpine AS builder

WORKDIR /build
COPY requirements.txt .
RUN python -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir --no-compile -r requirements.txt

FROM python:3.12-alpine AS prod

ARG LAB_LOGIN=local-dev
ARG LAB_TOKEN=local-test-token

LABEL org.lab.login="${LAB_LOGIN}" \
      org.lab.token="${LAB_TOKEN}"

ENV PATH="/opt/venv/bin:${PATH}" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    TMPDIR=/dev/shm \
    ROCKET_SIZE=Small \
    LAB_LOGIN="${LAB_LOGIN}" \
    LAB_TOKEN="${LAB_TOKEN}"

RUN addgroup -S -g 10001 app \
    && adduser -S -D -H -u 10001 -G app app

WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
COPY app/app.py ./app.py

USER 10001:10001
EXPOSE 8000
STOPSIGNAL SIGTERM

HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
    CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health', timeout=2).read()"]

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "2", \
     "--worker-tmp-dir", "/dev/shm", "--graceful-timeout", "8", \
     "--access-logfile", "-", "--error-logfile", "-", "app:app"]
