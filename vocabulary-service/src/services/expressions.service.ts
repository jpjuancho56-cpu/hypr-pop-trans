import * as repository from '../repositories/expressions.repository.js';

interface RegisterExpressionInput {
  normalized_text: string;
  source_language: string;
  original_text: string;
  word_count: number;
}

interface RegisterExpressionResult {
  saved: boolean;
  action: 'created' | 'incremented' | 'ignored';
  reason?: string;
  data?: any;
}

export async function registerExpression({
  normalized_text,
  original_text,
  source_language,
  word_count,
}: RegisterExpressionInput): Promise<RegisterExpressionResult> {
  if (!normalized_text || normalized_text.trim().length === 0) {
    return {
      saved: false,
      action: 'ignored',
      reason: 'Empty text provide',
    };
  }

  if (word_count > 12) {
    return {
      saved: false,
      reason: 'exceeds_limit',
      action: 'ignored',
    };
  }

  try {
    const existingExpression = await repository.findByNormalizedText(normalized_text);
    if (existingExpression) {
      repository.incrementTranslationCount(normalized_text);

      return {
        saved: true,
        action: 'created',
        data: existingExpression,
        reason: 'Expression already existed, incremented count',
      };
    }

    const createExpression = await repository.createExpression({
      normalized_text,
      source_language,
      original_text,
    });

    return {
      saved: true,
      action: 'created',
      reason: 'New expression created successfully',
      data: createExpression,
    };
  } catch (error) {
    console.log('Database error:', error);
    return {
      saved: false,
      action: 'ignored',
      reason: `Database error: ${error}`,
    };
  }
}
