-- 创建数据库
CREATE DATABASE IF NOT EXISTS cuisine_blog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE cuisine_blog;

-- 创建dishes表
CREATE TABLE dishes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    name_cn VARCHAR(255),
    name_by VARCHAR(255),
    cuisine_type ENUM('Chinese', 'Belarusian') NOT NULL,
    description TEXT,
    description_cn TEXT,
    description_by TEXT,
    cooking_time INT,
    difficulty ENUM('Easy', 'Medium', 'Hard'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建ingredients表
CREATE TABLE ingredients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    name_cn VARCHAR(255),
    name_by VARCHAR(255),
    description TEXT,
    unit VARCHAR(50)
);

-- 创建dish_ingredients表
CREATE TABLE dish_ingredients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    dish_id INT,
    ingredient_id INT,
    amount DECIMAL(10,2),
    FOREIGN KEY (dish_id) REFERENCES dishes(id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);

-- 创建recipe_steps表
CREATE TABLE recipe_steps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    dish_id INT,
    step_number INT,
    instruction TEXT,
    instruction_cn TEXT,
    instruction_by TEXT,
    image_url VARCHAR(255),
    FOREIGN KEY (dish_id) REFERENCES dishes(id)
);

-- 创建categories表
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    name_cn VARCHAR(255),
    name_by VARCHAR(255),
    description TEXT
);

-- 创建dish_categories表
CREATE TABLE dish_categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    dish_id INT,
    category_id INT,
    FOREIGN KEY (dish_id) REFERENCES dishes(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- 创建users表
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    preferred_language ENUM('en', 'cn', 'by'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建comments表
CREATE TABLE comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    dish_id INT,
    user_id INT,
    content TEXT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dish_id) REFERENCES dishes(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 创建索引
CREATE INDEX idx_dishes_name ON dishes(name);
CREATE INDEX idx_dishes_cuisine_type ON dishes(cuisine_type);
CREATE INDEX idx_ingredients_name ON ingredients(name);
CREATE UNIQUE INDEX idx_users_email ON users(email);
CREATE INDEX idx_comments_dish_id ON comments(dish_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);

-- 添加约束
ALTER TABLE comments
ADD CONSTRAINT chk_rating_range CHECK (rating >= 1 AND rating <= 5);

ALTER TABLE dishes
MODIFY name VARCHAR(255) NOT NULL,
MODIFY cuisine_type ENUM('Chinese', 'Belarusian') NOT NULL;

ALTER TABLE users
MODIFY username VARCHAR(255) NOT NULL,
MODIFY email VARCHAR(255) NOT NULL,
MODIFY password_hash VARCHAR(255) NOT NULL;
