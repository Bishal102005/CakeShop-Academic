-- Run in MySQL (sweetcrumbs_db) to enable order status tracking.

ALTER TABLE orders ADD COLUMN order_status VARCHAR(50) DEFAULT 'Received';

UPDATE orders SET order_status = 'Received' WHERE order_status IS NULL OR order_status = '';
