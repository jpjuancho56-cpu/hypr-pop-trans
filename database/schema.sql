CREATE TABLE IF NOT EXISTS expressions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,

    original_text TEXT NOT NULL,
    normalized_text TEXT NOT NULL,

    source_language TEXT NOT NULL,

    translation_count INTEGER NOT NULL DEFAULT 1,

    status TEXT NOT NULL DEFAULT 'learning'
        CHECK (
            status IN (
                'learning',
                'learned',
                'ignored'
            )
        ),

    first_seen_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_seen_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_expression_unique
ON expressions (
    normalized_text,
    source_language
);

CREATE TABLE IF NOT EXISTS translation_events (
    id INTEGER PRIMARY KEY AUTOINCREMENT,

    expression_id INTEGER NOT NULL,

    translated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (expression_id)
        REFERENCES expressions(id)
        ON DELETE CASCADE
);