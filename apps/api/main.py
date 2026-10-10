"""Placeholder API: exists only so the image, chart and pipeline have something to run."""
import json
from http.server import BaseHTTPRequestHandler, HTTPServer


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path in ("/healthz", "/api/healthz"):
            body, code = {"status": "ok"}, 200
        elif self.path in ("/", "/api", "/api/"):
            body, code = {"service": "api", "message": "hello"}, 200
        else:
            body, code = {"error": "not found"}, 404
        data = json.dumps(body).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)


if __name__ == "__main__":
    HTTPServer(("0.0.0.0", 8000), Handler).serve_forever()
