
# Digital_Magazine_Publishing_CMS

This project implements a full-featured backend **Content Management System (CMS)** for publishing digital magazines using **pure MySQL**. It supports rich functionalities like content publishing workflows, role-based permissions, media management, analytics, and moderation.

Designed as part of the **DevifyX Assignment**, the system is built entirely using SQL — including schema definitions, sample data, stored procedures, triggers, views, and scheduled events.

---

## Features Implemented

### Core Functionalities

- **Magazine Management**
  - Create, update, and archive magazine issues
  - Metadata: title, issue number, publication date, and status
  - Includes audit logging

- **Article Management**
  - Link articles to specific magazines, authors, categories
  - Add, update, and delete articles with stored procedures
  - Status-based workflow: draft → under review → published → archived

- **Media Management**
  - Associate media (images, videos, PDFs) with articles

- **Author Management**
  - Manage author profiles and assign articles to authors

- **Category & Tagging System**
  - Categorize articles and allow multiple tags per article

- **Publication Workflow**
  - Track article statuses and transitions
  - Audit trail logs all significant changes

- **User Roles & Permissions**
  - Supports roles: admin, editor, author, moderator, viewer
  - Role checks enforced via stored procedures

- **Audit Trail**
  - Logs user actions on articles, magazines, and comments with timestamps

---

### Bonus Features

- **Full-Text Search**
  - Search articles (`title`, `content`) and magazines (`title`) using MySQL full-text indexes

- **Scheduled Publishing**
  - Auto-publish articles using scheduled `DATETIME` and MySQL `EVENT`

- **Statistics Tracking**
  - Track article `views` and `downloads`
  - Views: `TopViewedArticles`, `ArticlesByDownloads`
  - Procedures: `IncrementArticleView`, `IncrementArticleDownload`

- **Comment System with Moderation**
  - Readers can submit comments on articles
  - Admins/Moderators can approve or reject via `ModerateComment` procedure

---

## Setup Instructions

### STEP 1: Set Up MySQL Environment

You can use:
- MySQL Workbench
- MySQL CLI / Terminal
- XAMPP / MAMP / LAMP stack
- VS Code with SQL extension

### STEP 2: Create Database

```sql
CREATE DATABASE digital_magazine_cms;
USE digital_magazine_cms;
```

### STEP 3: Run SQL Scripts

#### 1. Schema Setup (`schema.sql`)
Defines all required tables and relations.

#### 2. Sample Data (`sample_data.sql`)
Inserts sample users, roles, articles, magazines, authors, media, tags, stats, and comments.

#### 3. Procedures, Views, Triggers (`procedures_views.sql`)
Implements all business logic, auditing, moderation, statistics, and scheduled events.

```sql
SOURCE schema.sql;
SOURCE sample_data.sql;
SOURCE procedures_views.sql;
```

### STEP 4: Enable Event Scheduler (for scheduled publishing)

```sql
SET GLOBAL event_scheduler = ON;
```

---

## How to Use

- **Publish an Article**
```sql
CALL PublishArticle(2, 1);  -- Publish article ID 2 by user ID 1 (admin)
```

- **Moderate a Comment**
```sql
CALL ModerateComment(8, 'approved', 6);  -- Approve comment ID 8 by moderator ID 6
```

- **Full-Text Search**
```sql
SELECT * FROM Articles WHERE MATCH(title, content) AGAINST ('Quantum' IN NATURAL LANGUAGE MODE);
SELECT * FROM Magazines WHERE MATCH(title) AGAINST ('TechX' IN BOOLEAN MODE);
```

- **Top Viewed Articles**
```sql
SELECT * FROM TopViewedArticles;
```

- **Auto-Publishing Test**
  - Insert article with status = 'draft' and `scheduled_date` = NOW() + INTERVAL 1 MINUTE
  - Wait 1–2 mins and run:
```sql
SELECT * FROM Articles WHERE status = 'published';
```

---

## 👩‍💻 Author

**Rishika Jain**  \  
Computer Science Engineer  \  
📧 rishika.jn191@gmail.com

---

All features tested and verified using the latest MySQL 8.x environment.
