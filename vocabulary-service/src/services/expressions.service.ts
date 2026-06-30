import { execFileSync } from 'node:child_process';
import path from 'node:path';
import * as repository from '../repositories/expressions.repository.js';

interface RegisterExpressionInput {
  original_text: string; // La palabra o selección exacta (ej: "developed")
  // context_sentence: string; // La frase completa que la rodeaba
  translation: string; // Traducida por tu app de Hyprland
  word_count: number;
  source_app?: string;
}

interface RegisterExpressionResult {
  saved: boolean;
  action: 'created' | 'incremented' | 'ignored';
  reason?: string;
  data?: any;
}

// Función auxiliar para llamar a Python de forma síncrona y limpia
function callPythonLemmatizer(text: string): { lemma: string; pos_tag: string } {
  try {
    const scriptPath = '/home/juan/data/project/hypr-pop-trans/utils/lemmatizer.py';
    const venvPythonPath = '/home/juan/data/project/hypr-pop-trans/utils/venv/bin/python3';

    const jsonResult = execFileSync(venvPythonPath, [scriptPath, text], { encoding: 'utf-8' });
    return JSON.parse(jsonResult);
  } catch (error) {
    console.error('Error ejecutando lemmatizer.py:', error);
    return { lemma: text.trim().toLocaleLowerCase(), pos_tag: 'UNKNOWN' };
  }
}

export async function registerExpression({
  original_text,
  // context_sentence,
  translation,
  word_count,
  source_app,
}: RegisterExpressionInput): Promise<RegisterExpressionResult> {
  if (!original_text || original_text.trim().length === 0) {
    return { saved: false, action: 'ignored', reason: 'Empty text provided' };
  }

  if (word_count > 12) {
    return { saved: false, action: 'ignored', reason: 'Exceeds word limit' };
  }

  try {
    // 1. Obtener Lema y Categoría Gramatical desde Python
    const { lemma, pos_tag } = callPythonLemmatizer(original_text);
    console.log(`Lemma ${lemma} categoria ${pos_tag}`);
    // 2. Buscar si el Lema ya existía en la base de datos
    const existingExpression = repository.findByLemma(lemma);
    let expressionId: number | bigint;

    if (existingExpression && existingExpression.id) {
      // Si ya existe, aumentamos el contador de necesidad
      repository.incrementTranslationCount(lemma);
      expressionId = existingExpression.id;

      const cleanData = {
        expression_id: expressionId,
        variant_text: original_text,
        // context_sentence,
        ...(source_app && { source_app: source_app }),
      };
      // Guardamos la nueva variante de contexto histórico bajo el mismo lema
      // repository.createVariant(cleanData);

      return {
        saved: true,
        action: 'incremented',
        reason: 'Lema existente. Contador incrementado y variante registrada.',
        data: { lemma, original_text, expression_id: expressionId },
      };
    }

    // 3. Si es un lema nuevo, se calcula la fecha de repaso (Hoy)
    const todayStr = new Date().toISOString().split('T')[0]; // Formato YYYY-MM-DD

    expressionId = repository.createExpression({
      lemma,
      translation,
      pos_tag,
      next_review_date: todayStr!,
    });

    const cleanData = {
      expression_id: expressionId,
      variant_text: original_text,
      // context_sentence,
      ...(source_app && { source_app: source_app }),
    };
    // 4. Registrar la variante inicial de contexto
    // repository.createVariant(cleanData);

    return {
      saved: true,
      action: 'created',
      reason: 'Nuevo lema y variante creados con éxito',
      data: { id: expressionId, lemma, translation, pos_tag },
    };
  } catch (error) {
    console.error('Error en el servicio de expresiones:', error);
    return {
      saved: false,
      action: 'ignored',
      reason: `Database/Python error: ${error}`,
    };
  }
}
