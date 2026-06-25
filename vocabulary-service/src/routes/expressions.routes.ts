import { Router } from 'express';
import { registerExpression } from '../services/expressions.service.js';

const router: Router = Router();

router.post('/', async (req, res) => {
  console.log('Received expression:');
  console.dir(req.body, { depth: null });

  const { original_text, normalized_text, source_language, word_count } = req.body;

  const result = await registerExpression({
    normalized_text,
    source_language,
    original_text,
    word_count,
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
