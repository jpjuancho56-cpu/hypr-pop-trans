import { Router } from 'express';
import { registerExpression } from '../services/expressions.service.js';

const router: Router = Router();

router.post('/', async (req, res) => {
  console.log('Received expression:');
  console.dir(req.body, { depth: null });

  const { original_text, context_sentence, translation, word_count, source_app } = req.body;

  const result = await registerExpression({
    original_text,
    translation,
    word_count,
    source_app,
  });

  if (!result.saved) {
    return res.status(204).send();
  }

  res.status(201).json({
    success: true,
    data: result,
  });
});

export default router;
