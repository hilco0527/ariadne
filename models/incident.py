from core.database import get_db

class IncidentModel:
    @staticmethod
    def get_all(query=None, limit=15, offset=0):
        db = get_db()
        if query:
            sql = "SELECT * FROM incidents WHERE title LIKE ? ORDER BY id DESC LIMIT ? OFFSET ?"
            return db.execute(sql, (f'%{query}%', limit, offset)).fetchall()
        else:
            sql = "SELECT * FROM incidents ORDER BY id DESC LIMIT ? OFFSET ?"
            return db.execute(sql, (limit, offset)).fetchall()

    @staticmethod
    def count(query=None):
        db = get_db()
        if query:
            count_sql = "SELECT COUNT(*) FROM incidents WHERE title LIKE ?"
            return db.execute(count_sql, (f'%{query}%',)).fetchone()[0]
        else:
            count_sql = "SELECT COUNT(*) FROM incidents"
            return db.execute(count_sql).fetchone()[0]

    @staticmethod
    def get(id):
        db = get_db()
        return db.execute("SELECT * FROM incidents WHERE id = ?", (id,)).fetchone()

    @staticmethod
    def create(title, date):
        db = get_db()
        cursor = db.execute("INSERT INTO incidents (title, date) VALUES (?, ?)", (title, date))
        new_id = cursor.lastrowid
        db.commit()
        return new_id

    @staticmethod
    def update(id, title, date):
        db = get_db()
        db.execute("UPDATE incidents SET title=?, date=? WHERE id=?", (title, date, id))
        db.commit()
