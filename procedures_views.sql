-- --------------------------------------------------
-- Digital Magazine Publishing CMS - Procedures, Views, Triggers
-- --------------------------------------------------

-- --------------------------------
-- Stored Procedure: Publish Article
-- --------------------------------
DELIMITER //

CREATE PROCEDURE PublishArticle(IN art_id INT, IN user_id INT)
BEGIN
    UPDATE Articles 
    SET status = 'published' 
    WHERE article_id = art_id;

    INSERT INTO AuditTrail (user_id, entity, entity_id, action)
    VALUES (user_id, 'Article', art_id, 'Published via procedure');
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
            1, -- You may dynamically supply this later
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

-- --------------------------------
-- Full-Text Index for Search (Run Once)
-- --------------------------------
ALTER TABLE Articles ADD FULLTEXT(title, content);

-- --------------------------------
-- View: Full-Text Search Result for Articles (Run this query as needed)
-- --------------------------------
-- SELECT * FROM Articles 
-- WHERE MATCH(title, content) AGAINST ('+AI +Quantum' IN BOOLEAN MODE);

-- --------------------------------
-- Scheduled Event: Auto-Publish Articles
-- --------------------------------
SET GLOBAL event_scheduler = ON;

CREATE EVENT IF NOT EXISTS auto_publish_scheduled_articles
ON SCHEDULE EVERY 1 MINUTE
DO
  UPDATE Articles
  SET status = 'published'
  WHERE status = 'draft' AND scheduled_date <= NOW();
