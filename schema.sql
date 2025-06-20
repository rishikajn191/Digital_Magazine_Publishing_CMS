-- SQL Schema for Digital Magazine CMS
CREATE DATABASE digital_magazine_cms;
USE digital_magazine_cms;

-- Stores user roles (admin, editor, etc.)
CREATE TABLE Roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- Users
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    role_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

-- Authors
CREATE TABLE Authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    bio TEXT
);

-- Magazines
CREATE TABLE Magazines (
    magazine_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    issue_number VARCHAR(20) NOT NULL,
    publication_date DATE,
    status ENUM('active', 'archived') NOT NULL
);

-- Categories
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Articles
CREATE TABLE Articles (
    article_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    magazine_id INT NOT NULL,
    author_id INT NOT NULL,
    category_id INT NOT NULL,
    status ENUM('draft', 'under review', 'published', 'archived') DEFAULT 'draft',
    scheduled_date DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (magazine_id) REFERENCES Magazines(magazine_id),
    FOREIGN KEY (author_id) REFERENCES Authors(author_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Tags
CREATE TABLE Tags (
    tag_id INT PRIMARY KEY AUTO_INCREMENT,
    tag_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE ArticleTags (
    article_id INT,
    tag_id INT,
    PRIMARY KEY (article_id, tag_id),
    FOREIGN KEY (article_id) REFERENCES Articles(article_id),
    FOREIGN KEY (tag_id) REFERENCES Tags(tag_id)
);

-- Media
CREATE TABLE Media (
    media_id INT PRIMARY KEY AUTO_INCREMENT,
    media_type ENUM('image', 'video', 'pdf') NOT NULL,
    media_url VARCHAR(255) NOT NULL
);

-- Maps articles to media files (images, videos)
CREATE TABLE ArticleMedia (
    article_id INT,
    media_id INT,
    PRIMARY KEY (article_id, media_id),
    FOREIGN KEY (article_id) REFERENCES Articles(article_id),
    FOREIGN KEY (media_id) REFERENCES Media(media_id)
);

-- Comments (Bonus)
CREATE TABLE Comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    article_id INT,
    user_id INT,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    FOREIGN KEY (article_id) REFERENCES Articles(article_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Audit Trail
CREATE TABLE AuditTrail (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    entity VARCHAR(50),
    entity_id INT,
    action VARCHAR(50),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Article Statistics (Bonus Feature)
CREATE TABLE ArticleStats (
    stat_id INT AUTO_INCREMENT PRIMARY KEY,
    article_id INT,
    views INT DEFAULT 0,
    downloads INT DEFAULT 0,
    FOREIGN KEY (article_id) REFERENCES Articles(article_id) ON DELETE CASCADE
);
