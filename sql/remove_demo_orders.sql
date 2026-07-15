-- Remove guest/demo orders not linked to a registered user account.
-- Run in MySQL: USE sweetcrumbs_db;

DELETE FROM orders WHERE user_id IS NULL;
