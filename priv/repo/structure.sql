CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" INTEGER PRIMARY KEY, "inserted_at" TEXT);
CREATE TABLE IF NOT EXISTS "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "name" TEXT NOT NULL, "inserted_at" TEXT NOT NULL, "updated_at" TEXT NOT NULL, "email" TEXT NOT NULL COLLATE NOCASE, "hashed_password" TEXT, "confirmed_at" TEXT);
CREATE TABLE sqlite_sequence(name,seq);
CREATE UNIQUE INDEX "users_email_index" ON "users" ("email");
CREATE TABLE IF NOT EXISTS "users_tokens" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "user_id" INTEGER NOT NULL CONSTRAINT "users_tokens_user_id_fkey" REFERENCES "users"("id") ON DELETE CASCADE, "token" BLOB NOT NULL, "context" TEXT NOT NULL, "sent_to" TEXT, "inserted_at" TEXT NOT NULL);
CREATE INDEX "users_tokens_user_id_index" ON "users_tokens" ("user_id");
CREATE UNIQUE INDEX "users_tokens_context_token_index" ON "users_tokens" ("context", "token");
INSERT INTO schema_migrations VALUES(20250413160203,'2025-04-13T19:34:53');
INSERT INTO schema_migrations VALUES(20250413160306,'2025-04-13T19:34:53');
