# Digital_Magazine_Publishing_CMS

## Overview
This project implements a complete backend **Content Management System (CMS)** for publishing digital magazines using **only MySQL**. It manages magazines, articles, media, authors, categories, and user roles, and supports workflows and content analytics.

Designed as part of the **DevifyX Assignment**, this project is implemented entirely through SQL scripts including schema definition, data insertion, stored procedures, triggers, views, and events.

---

## Features

### Core Features
- **Magazine Management**: Create, update, archive issues with metadata
- **Article Management**: Link articles to magazines, authors, categories
- **Media Management**: Associate images, PDFs, videos with articles
- **Author Management**: Maintain author bios and assignments
- **Category & Tagging**: Organize articles using categories and multiple tags
- **Publication Workflow**: Draft, review, publish, and archive articles
- **User Roles & Permissions**: Roles like admin, editor, author, viewer
- **Audit Trail**: Logs actions with user, entity, and timestamp

### Bonus Features
- **Full-Text Search**: Search articles and magazines by title and content
- **Scheduled Publishing**: Articles can auto-publish at a scheduled date/time
- **Statistics**: Track article views and downloads
- **Comments**: Readers can leave moderated comments on articles

---

## Setup Instructions

### 1. Create Database
```sql
CREATE DATABASE digital_magazine_cms;
USE digital_magazine_cms;
```
### 2. Run Scripts in Order
```sql
SOURCE schema.sql;
SOURCE sample_data.sql;
SOURCE procedures_views.sql;
```
### 3. Enable Event Scheduler (for scheduled publishing)
```sql
SET GLOBAL event_scheduler = ON;
```

## Usage Examples
### 1.  Publish Article via Procedure
```sql
CALL PublishArticle(2, 1);
```
### 2. Search for Articles with "Quantum"
```sql
SELECT * FROM Articles WHERE MATCH(title, content) AGAINST ('Quantum' IN NATURAL LANGUAGE MODE);
```
### 3. View All Published Articles
```sql
SELECT * FROM PublishedArticlesSummary;
```
### 4. View Comments with Article Titles and Usernames
```sql
SELECT * FROM CommentDetails;
```
**👩‍💻 Author** <br>
Rishika Jain <br>
(Computer Science Engineer) <br>
rishika.jn191@gmail.com <br>
