from core.database import get_db
import datetime

class ItemModel:
    @staticmethod
    def get_by_incident(incident_id):
        db = get_db()
        return db.execute("""
            SELECT * FROM items 
            WHERE incident_id = ? 
            ORDER BY 
                CASE 
                    WHEN type = 'RESPONSE' THEN deadline 
                    ELSE occurred_at 
                END ASC
        """, (incident_id,)).fetchall()

    @staticmethod
    def get(id):
        db = get_db()
        return db.execute("SELECT * FROM items WHERE id = ?", (id,)).fetchone()

    @staticmethod
    def get_next_display_id(incident_id, type_):
        db = get_db()
        row = db.execute("SELECT MAX(display_id) FROM items WHERE incident_id = ? AND type = ?", (incident_id, type_)).fetchone()
        current_max = row[0] if row and row[0] else 0
        return current_max + 1

    @staticmethod
    def create(incident_id, type_, title=None, status=None, system_name=None, description=None, occurred_at=None, rank=None, deadline=None, assignee=None, start_at=None, end_at=None, full_scale_response=None, display_id=None):
        db = get_db()
        
        updated_at_val = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        if not display_id:
            display_id = ItemModel.get_next_display_id(incident_id, type_)
        
        db.execute("""
            INSERT INTO items (incident_id, type, title, status, system_name, description, occurred_at, rank, deadline, assignee, start_at, end_at, full_scale_response, display_id, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (incident_id, type_, title, status, system_name, description, occurred_at, rank, deadline, assignee, start_at, end_at, full_scale_response, display_id, updated_at_val))
        db.commit()

    @staticmethod
    def update(id, title=None, status=None, system_name=None, description=None, occurred_at=None, rank=None, deadline=None, assignee=None, start_at=None, end_at=None, full_scale_response=None, display_id=None):
        db = get_db()
        new_updated_at = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        db.execute("""
            UPDATE items SET title=?, status=?, system_name=?, description=?, occurred_at=?, rank=?, deadline=?, assignee=?, start_at=?, end_at=?, full_scale_response=?, display_id=?, updated_at=?
            WHERE id=?
        """, (title, status, system_name, description, occurred_at, rank, deadline, assignee, start_at, end_at, full_scale_response, display_id, new_updated_at, id))
        db.commit()

    @staticmethod
    def delete(id):
        db = get_db()
        db.execute("DELETE FROM items WHERE id=?", (id,))
        db.commit()

    @staticmethod
    def get_updated_at(id):
        db = get_db()
        row = db.execute("SELECT updated_at FROM items WHERE id=?", (id,)).fetchone()
        return row['updated_at'] if row else None
