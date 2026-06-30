import db from '../db/sqlite.js';

interface CreateExpressionDTO {
  lemma: string;
  translation: string;
  pos_tag: string;
  next_review_date: string;
}

interface CreateVariantDTO {
  expression_id: number | bigint;
  variant_text: string;
  context_sentence: string;
  source_app?: string;
}

export function findByLemma(lemma: string): any {
  return db
    .prepare(
      `
    SELECT *
    FROM expressions
    WHERE lemma = ?
    `,
    )
    .get(lemma);
}

export function findByNormalizedText(normalizedText: string) {
  return db
    .prepare(
      `
            SELECT *
            FROM expressions
            WHERE normalized_text = ?
        `,
    )
    .get(normalizedText);
}

export function createExpression({
  lemma,
  next_review_date,
  pos_tag,
  translation,
}: CreateExpressionDTO) {
  console.log(`data: ${lemma}, ${next_review_date}, ${pos_tag}, ${translation}`);
  const result = db
    .prepare(
      `
            INSERT INTO expressions (
                lemma,
                translation,
                pos_tag,
                next_review_date
            )
            VALUES (?, ?, ?, ?)
        `,
    )
    .run(lemma, translation, pos_tag, next_review_date);
  console.log(result.lastInsertRowid);

  return result.lastInsertRowid;
}

export function incrementTranslationCount(lemma: string) {
  return db
    .prepare(
      `
            UPDATE expressions
            SET
                translation_count = translation_count + 1,
            WHERE lemma = ?
        `,
    )
    .run(lemma);
}

export function createVariant(data: CreateVariantDTO) {
  return db
    .prepare(
      `
      INSERT INTO expression_variants (
          expression_id,
          variant_text,
          context_sentence,
          source_app
      )
      VALUES (?, ?, ?, ?)
      `,
    )
    .run(data.expression_id, data.variant_text, data.context_sentence, data.source_app || null);
}
