CREATE TABLE IF NOT EXISTS incidents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    date TEXT NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    incident_id INTEGER NOT NULL,
    type TEXT NOT NULL, -- CAUSE, EVENT, IMPACT, RESPONSE
    title TEXT NOT NULL,
    status TEXT, -- OPEN, CLOSED, NOT_STARTED, IN_PROGRESS, COMPLETED
    system_name TEXT,
    description TEXT,
    occurred_at TEXT, -- CAUSE, EVENT, IMPACT
    rank TEXT, -- IMPACT (A, B, C)
    deadline TEXT, -- RESPONSE
    assignee TEXT, -- RESPONSE
    start_at TEXT, -- RESPONSE
    end_at TEXT, -- RESPONSE
    full_scale_response TEXT, -- ALL types
    display_id INTEGER,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (incident_id) REFERENCES incidents(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS relationships (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    from_item_id INTEGER NOT NULL,
    to_item_id INTEGER NOT NULL,
    FOREIGN KEY (from_item_id) REFERENCES items(id) ON DELETE CASCADE,
    FOREIGN KEY (to_item_id) REFERENCES items(id) ON DELETE CASCADE
);
