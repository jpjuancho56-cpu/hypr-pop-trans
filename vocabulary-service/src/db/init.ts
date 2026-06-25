import fs from 'node:fs';
import db from './sqlite.js';
import path from 'node:path';

export function initializedDatabase() {
  const schema = fs.readFileSync(path.resolve('../database/schema.sql'), 'utf8');

  db.exec(schema);
}
