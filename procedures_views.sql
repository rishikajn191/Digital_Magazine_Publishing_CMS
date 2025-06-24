
-- --------------------------------------------------
-- Digital Magazine Publishing CMS - Procedures, Views, Triggers (with Role Checks and Magazine Logging)
-- --------------------------------------------------

-- --------------------------------
-- Function: Get User Role
-- --------------------------------
DELIMITER //

CREATE FUNCTION GetUserRole(userId INT)
RETURNS VARCHAR(50)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE roleName VARCHAR(50);

    SELECT r.role_name INTO roleName
    FROM Users u
    JOIN Roles r ON u.role_id = r.role_id
    WHERE u.user_id = userId;

    RETURN roleName;
END //

-- --------------------------------
-- Stored Procedure: Publish Article (with role check)
-- --------------------------------
CREATE PROCEDURE PublishArticle(IN art_id INT, IN user_id INT)
BEGIN
    DECLARE userRole VARCHAR(50);

    SET userRole = GetUserRole(user_id);

    IF userRole NOT IN ('admin', 'editor') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Permission Denied: Only admin or editor can publish articles.';
    ELSE
        UPDATE Articles 
        SET status = 'published' 
        WHERE article_id = art_id;

        INSERT INTO AuditTrail (user_id, entity, entity_id, action)
        VALUES (user_id, 'Article', art_id, 'Published via procedure');
    END IF;
END //

-- --------------------------------
-- Stored Procedure: Update Article (with role check)
-- --------------------------------
CREATE PROCEDURE UpdateArticle(
    IN art_id INT,
    IN new_title VARCHAR(255),
    IN new_content TEXT,
    IN new_magazine_id INT,
    IN new_category_id INT,
    IN new_status ENUM('draft', 'under review', 'published', 'archived'),
    IN user_id INT
)
BEGIN
    DECLARE old_status ENUM('draft', 'under review', 'published', 'archived');
    DECLARE userRole VARCHAR(50);

    SET userRole = GetUserRole(user_id);

    IF userRole NOT IN ('admin', 'editor') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Permission Denied: Only admin or editor can update articles.';
    ELSE
        SELECT status INTO old_status FROM Articles WHERE article_id = art_id;

        UPDATE Articles
        SET
            title = new_title,
            content = new_content,
            magazine_id = new_magazine_id,
            category_id = new_category_id,
            status = new_status
        WHERE article_id = art_id;

        IF old_status != new_status THEN
            INSERT INTO AuditTrail (user_id, entity, entity_id, action)
            VALUES (user_id, 'Article', art_id, CONCAT('Status changed from ', old_status, ' to ', new_status));
        ELSE
            INSERT INTO AuditTrail (user_id, entity, entity_id, action)
            VALUES (user_id, 'Article', art_id, 'Article updated');
        END IF;
    END IF;
END //

-- --------------------------------
-- Stored Procedure: Delete Article (with role check)
-- --------------------------------
CREATE PROCEDURE DeleteArticle(
    IN art_id INT,
    IN user_id INT
)
BEGIN
    DECLARE userRole VARCHAR(50);

    SET userRole = GetUserRole(user_id);

    IF userRole != 'admin' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Permission Denied: Only admin can delete articles.';
    ELSE
        DELETE FROM Articles WHERE article_id = art_id;

        INSERT INTO AuditTrail (user_id, entity, entity_id, action)
        VALUES (user_id, 'Article', art_id, 'Article deleted');
    END IF;
END //

-- --------------------------------
-- Stored Procedure: Archive Magazine (logs action)
-- --------------------------------
CREATE PROCEDURE ArchiveMagazine(
    IN mag_id INT,
    IN user_id INT
)
BEGIN
    UPDATE Magazines
    SET status = 'archived'
    WHERE magazine_id = mag_id;

    INSERT INTO AuditTrail (user_id, entity, entity_id, action)
    VALUES (user_id, 'Magazine', mag_id, 'Archived');
END //

-- --------------------------------
-- Stored Procedure: Update Magazine (logs changes)
-- --------------------------------
CREATE PROCEDURE UpdateMagazine(
    IN mag_id INT,
    IN new_title VARCHAR(255),
    IN new_issue_number VARCHAR(20),
    IN new_status ENUM('active', 'archived'),
    IN user_id INT
)
BEGIN
    DECLARE old_title VARCHAR(255);
    DECLARE old_issue VARCHAR(20);
    DECLARE old_status ENUM('active', 'archived');

    SELECT title, issue_number, status
    INTO old_title, old_issue, old_status
    FROM Magazines
    WHERE magazine_id = mag_id;

    UPDATE Magazines
    SET title = new_title,
        issue_number = new_issue_number,
        status = new_status
    WHERE magazine_id = mag_id;

    IF old_title != new_title THEN
        INSERT INTO AuditTrail (user_id, entity, entity_id, action)
        VALUES (user_id, 'Magazine', mag_id, CONCAT('Title changed from ', old_title, ' to ', new_title));
    END IF;

    IF old_issue != new_issue_number THEN
        INSERT INTO AuditTrail (user_id, entity, entity_id, action)
        VALUES (user_id, 'Magazine', mag_id, CONCAT('Issue changed from ', old_issue, ' to ', new_issue_number));
    END IF;

    IF old_status != new_status THEN
        INSERT INTO AuditTrail (user_id, entity, entity_id, action)
        VALUES (user_id, 'Magazine', mag_id, CONCAT('Status changed from ', old_status, ' to ', new_status));
    END IF;
END //

DELIMITER ;

-- --------------------------------
-- Trigger: Audit Article Status Change
-- --------------------------------
DELIMITER //

CREATE TRIGGER trg_article_status_update
AFTER UPDATE ON Articles
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO AuditTrail (user_id, entity, entity_id, action)
        VALUES (
            1, -- Hardcoded due to lack of session info
            'Article',
            NEW.article_id,
            CONCAT('Status changed from ', OLD.status, ' to ', NEW.status)
        );
    END IF;
END //

DELIMITER ;

-- --------------------------------
-- View: Published Articles Summary
-- --------------------------------
CREATE OR REPLACE VIEW PublishedArticlesSummary AS
SELECT 
    a.article_id,
    a.title,
    m.title AS magazine_title,
    au.name AS author_name,
    c.name AS category,
    a.status,
    a.scheduled_date,
    a.created_at
FROM Articles a
JOIN Magazines m ON a.magazine_id = m.magazine_id
JOIN Authors au ON a.author_id = au.author_id
JOIN Categories c ON a.category_id = c.category_id
WHERE a.status = 'published';

-- --------------------------------
-- View: All Comments with Article & User
-- --------------------------------
CREATE OR REPLACE VIEW CommentDetails AS
SELECT 
    cm.comment_id,
    ar.title AS article_title,
    u.username AS commenter,
    cm.comment,
    cm.status,
    cm.created_at
FROM Comments cm
JOIN Articles ar ON cm.article_id = ar.article_id
JOIN Users u ON cm.user_id = u.user_id;


-- ---------------------------------------------
-- View: Top 5 Most Viewed Articles
-- ---------------------------------------------
CREATE OR REPLACE VIEW TopViewedArticles AS
SELECT 
    a.article_id,
    a.title,
    s.views
FROM Articles a
JOIN ArticleStats s ON a.article_id = s.article_id
ORDER BY s.views DESC
LIMIT 5;

-- ---------------------------------------------
-- View: Articles Ordered by Download Count
-- ---------------------------------------------
CREATE OR REPLACE VIEW ArticlesByDownloads AS
SELECT 
    a.article_id,
    a.title,
    s.downloads
FROM Articles a
JOIN ArticleStats s ON a.article_id = s.article_id
ORDER BY s.downloads DESC;

-- ---------------------------------------------
-- Stored Procedure: Increment Article View Count
-- ---------------------------------------------
DELIMITER //
CREATE PROCEDURE IncrementArticleView(IN art_id INT)
BEGIN
    UPDATE ArticleStats
    SET views = views + 1
    WHERE article_id = art_id;
END //

-- ---------------------------------------------
-- Stored Procedure: Increment Article Download Count
-- ---------------------------------------------
CREATE PROCEDURE IncrementArticleDownload(IN art_id INT)
BEGIN
    UPDATE ArticleStats
    SET downloads = downloads + 1
    WHERE article_id = art_id;
END //
DELIMITER ;



-- ---------------------------------------------
-- Stored Procedure: Moderate Comment (with role check)
-- ---------------------------------------------
DELIMITER //

CREATE PROCEDURE ModerateComment(
    IN comment_id INT,
    IN new_status ENUM('approved', 'rejected'),
    IN user_id INT
)
BEGIN
    DECLARE userRole VARCHAR(50);

    SET userRole = GetUserRole(user_id);

    IF userRole NOT IN ('admin', 'moderator') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Permission Denied: Only admin or moderator can moderate comments.';
    ELSE
        UPDATE Comments
        SET status = new_status
        WHERE comment_id = comment_id;

        INSERT INTO AuditTrail (user_id, entity, entity_id, action)
        VALUES (user_id, 'Comment', comment_id, CONCAT('Comment ', new_status));
    END IF;
END //

DELIMITER ;


-- --------------------------------------
-- Full-Text Index for Search (Run Once)
-- --------------------------------------
ALTER TABLE Articles ADD FULLTEXT(title, content);
ALTER TABLE Magazines ADD FULLTEXT(title);

-- -----------------------------------------------------------------------
-- View: Full-Text Search Result for Articles (Run this query as needed)
-- -----------------------------------------------------------------------
-- SELECT * FROM Articles 
-- WHERE MATCH(title, content) AGAINST ('+AI +Quantum' IN BOOLEAN MODE);

-- -----------------------------------------------------------------------
-- View: Full-Text Search Result for Magazines (Run this query as needed)
-- -----------------------------------------------------------------------
-- SELECT * FROM Magazines 
-- WHERE MATCH(title) AGAINST ('Science' IN NATURAL LANGUAGE MODE);

-- ----------------------------------------
-- Scheduled Event: Auto-Publish Articles
-- ----------------------------------------
SET GLOBAL event_scheduler = ON;

CREATE EVENT IF NOT EXISTS auto_publish_scheduled_articles
ON SCHEDULE EVERY 1 MINUTE
DO
  UPDATE Articles
  SET status = 'published'
  WHERE status = 'draft' AND scheduled_date <= NOW();
