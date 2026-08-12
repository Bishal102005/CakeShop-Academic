
-- Users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Cakes table
CREATE TABLE cakes (
    id SERIAL PRIMARY KEY,
    number VARCHAR(50),
    code VARCHAR(50),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    tag VARCHAR(100),
    rating DOUBLE PRECISION DEFAULT 0,
    price NUMERIC(10,2) DEFAULT 0,
    image_file TEXT,
    ingredients TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    cake_name VARCHAR(255) NOT NULL,
    cake_price NUMERIC(10,2) DEFAULT 0,
    customer_name VARCHAR(150) NOT NULL,
    customer_phone VARCHAR(50),
    delivery_date DATE,
    customer_address TEXT,
    order_status VARCHAR(50) NOT NULL DEFAULT 'Received',
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT orders_user_fk FOREIGN KEY (user_id) REFERENCES users(user_id)
);