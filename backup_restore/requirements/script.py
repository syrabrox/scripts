from flask import Flask, Response, redirect, request
import requests

app = Flask(__name__)

REMOTE_URL = 'https://raw.githubusercontent.com/syrabrox/scripts/refs/heads/main/backup_restore/requirements/index.html'

@app.route('/')
def home():
    r = requests.get(REMOTE_URL)
    return Response(r.text, content_type='text/html')

@app.route('/<path:anything>')
def catch_all(anything):
    return redirect('/')


app.run(host='0.0.0.0', port=80)
