import DatabaseConstructor, { type Database } from 'better-sqlite3';
import path from "node:path";
import dotenv from "dotenv"

dotenv.config()

const envPath = path.resolve(process.env.DATABASE_URL!);
const absoluteDbPath = path.resolve(process.cwd(), envPath);

export const db: Database = new DatabaseConstructor(absoluteDbPath);

db.pragma("journal_mode = WAL");

export default db;