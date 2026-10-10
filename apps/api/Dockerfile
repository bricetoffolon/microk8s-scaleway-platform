FROM python:3.12-slim
RUN useradd --system --uid 10001 app
WORKDIR /app
COPY main.py .
USER 10001
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s CMD python -c "import urllib.request as u; u.urlopen('http://127.0.0.1:8000/healthz')"
CMD ["python", "main.py"]
