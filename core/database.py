import sqlite3
import os
from bottle import request, hook

DATABASE = 'database.db'

def get_db():
    if 'db' not in request.environ:
        db = sqlite3.connect(DATABASE)
        db.row_factory = sqlite3.Row
        request.environ['db'] = db
    return request.environ['db']

@hook('after_request')
def close_db():
    if 'db' in request.environ:
        request.environ['db'].close()

def init_db():
    with sqlite3.connect(DATABASE) as db:
        with open('schema.sql', mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()

# Initialize DB if it doesn't exist
if not os.path.exists(DATABASE):
    init_db()
