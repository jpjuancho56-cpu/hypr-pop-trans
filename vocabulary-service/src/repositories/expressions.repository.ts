import db from "../db/sqlite.js";

export function findByNormalizedText(
    normalizedText: string
) {
    return db
        .prepare(`
            SELECT *
            FROM expressions
            WHERE normalized_text = ?
        `)
        .get(normalizedText);
}

export function createExpression(data: {
    normalized_text: string,
    source_language: string,
    original_text: string,
}) {
    return db
        .prepare(`
            INSERT INTO expressions (
                original_text,
                normalized_text,
                source_language
            )
            VALUES (?, ?, ?)
        `)
        .run(
            data.normalized_text,
            data.original_text,
            data.source_language
        );
}

export function incrementTranslationCount(
    normalizedText: string
) {
    return db
        .prepare(`
            UPDATE expressions
            SET
                translation_count =
                    translation_count + 1,
                updated_at =
                    CURRENT_TIMESTAMP
            WHERE normalized_text = ?
        `)
        .run(normalizedText);
}