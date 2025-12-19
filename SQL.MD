-- ====================================
-- HENRY CRAFTING - DATABASE SCHEMA
-- Wird automatisch von server/main.lua erstellt
-- Hier als Referenz
-- ====================================

-- Skills Table
CREATE TABLE IF NOT EXISTS henry_crafting_skills (
    identifier VARCHAR(50) PRIMARY KEY,
    level INT DEFAULT 0,
    xp INT DEFAULT 0,
    crafted_items INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Blueprints Table
CREATE TABLE IF NOT EXISTS henry_crafting_blueprints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(50),
    recipe_id VARCHAR(100),
    acquired_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_identifier (identifier),
    INDEX idx_recipe (recipe_id),
    UNIQUE KEY unique_blueprint (identifier, recipe_id)
);

-- Optional: Crafting History Table (for analytics)
CREATE TABLE IF NOT EXISTS henry_crafting_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(50),
    recipe_id VARCHAR(100),
    success BOOLEAN,
    xp_gained INT,
    crafted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_identifier (identifier),
    INDEX idx_date (crafted_at)
);
