from core.database import get_db

class RelationshipModel:
    @staticmethod
    def get_by_incident(incident_id):
        db = get_db()
        return db.execute("SELECT * FROM relationships WHERE from_item_id IN (SELECT id FROM items WHERE incident_id = ?) OR to_item_id IN (SELECT id FROM items WHERE incident_id = ?)", (incident_id, incident_id)).fetchall()

    @staticmethod
    def create(from_id, to_id):
        db = get_db()
        exists = db.execute("SELECT id FROM relationships WHERE (from_item_id=? AND to_item_id=?) OR (from_item_id=? AND to_item_id=?)", (from_id, to_id, to_id, from_id)).fetchone()
        if not exists:
            db.execute("INSERT INTO relationships (from_item_id, to_item_id) VALUES (?, ?)", (from_id, to_id))
            db.commit()
            return True
        return False

    @staticmethod
    def delete(id):
        db = get_db()
        db.execute("DELETE FROM relationships WHERE id=?", (id,))
        db.commit()

    @staticmethod
    def add(from_id, to_id):
        # Specific add without bidirectional check for sync logic if needed, 
        # but create handles check. Let's just use raw insert if we know it's safe or want to be explicit.
        # But for sync, we just want to ensure it exists.
        db = get_db()
        exists = db.execute("SELECT 1 FROM relationships WHERE from_item_id=? AND to_item_id=?", (from_id, to_id)).fetchone()
        if not exists:
            db.execute("INSERT INTO relationships (from_item_id, to_item_id) VALUES (?, ?)", (from_id, to_id))

    @staticmethod
    def remove(from_id, to_id):
        db = get_db()
        db.execute("DELETE FROM relationships WHERE from_item_id=? AND to_item_id=?", (from_id, to_id))
        
    @staticmethod
    def commit():
        get_db().commit()
