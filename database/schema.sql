-- Habilitar restricciones de integridad referencial (claves foráneas)
-- Importante: SQLite requiere activar esto por sesión para respetar las relaciones entre tablas
PRAGMA foreign_keys = ON;

-- 1. TABLA PRINCIPAL: Lemas y Algoritmo de Aprendizaje
CREATE TABLE IF NOT EXISTS expressions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    lemma TEXT NOT NULL UNIQUE,              -- Guardará el lema limpio de Python (ej: "develop")
    translation TEXT NOT NULL,               -- La traducción de la raíz
    pos_tag TEXT,                            -- Tipo de palabra: VERB, NOUN, ADJ (dado por spaCy)
    translation_count INTEGER DEFAULT 1,     -- Cuántas veces has necesitado traducir variantes de esta palabra
    
    -- Campos del Algoritmo de Repetición Espaciada (SRS)
    next_review_date TEXT NOT NULL,          -- Fecha formato 'YYYY-MM-DD' para comparar fácil
    interval_days INTEGER DEFAULT 1,         -- Cuántos días esperar para el próximo repaso
    ease_factor REAL DEFAULT 2.5,            -- Factor de dificultad (estilo Anki)
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creación de un índice único explícito para búsquedas instantáneas por lema
CREATE UNIQUE INDEX IF NOT EXISTS idx_expressions_lemma ON expressions(lemma);

-- 2. TABLA DE CONTEXTO: Variantes reales capturadas
CREATE TABLE IF NOT EXISTS expression_variants (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    expression_id INTEGER NOT NULL,          -- Enlace a la palabra raíz
    variant_text TEXT NOT NULL,              -- La palabra exacta copiada (ej: "developed")
    context_sentence TEXT,                   -- La frase completa del portapapeles para dar contexto
    source_app TEXT,                         -- Opcional: Kitty, Firefox, etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Si borras un lema principal, se borran automáticamente todas sus variantes (Cascada)
    FOREIGN KEY (expression_id) REFERENCES expressions(id) ON DELETE CASCADE
);

-- 3. TABLA DE HISTORIAL: Registro de repasos diarios
CREATE TABLE IF NOT EXISTS review_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    expression_id INTEGER NOT NULL,
    rating INTEGER NOT NULL,                 -- Calificación de tu autoevaluación (ej: 1 al 5)
    reviewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (expression_id) REFERENCES expressions(id) ON DELETE CASCADE
);