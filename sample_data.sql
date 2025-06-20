-- MySQL dump 10.13  Distrib 8.0.32, for macos13 (x86_64)
--
-- Host: localhost    Database: digital_magazine_cms
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `ArticleMedia`
--

LOCK TABLES `ArticleMedia` WRITE;
/*!40000 ALTER TABLE `ArticleMedia` DISABLE KEYS */;
INSERT INTO `ArticleMedia` VALUES (2,2),(3,3),(4,4);
/*!40000 ALTER TABLE `ArticleMedia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Articles`
--

LOCK TABLES `Articles` WRITE;
/*!40000 ALTER TABLE `Articles` DISABLE KEYS */;
INSERT INTO `Articles` VALUES (2,'Eco Tech in 2025','A look into green technology.',2,3,1,'published','2025-06-20 00:00:00','2025-06-20 14:29:46','2025-06-20 15:48:23'),(3,'Heart Health Tips','Daily habits for a healthy heart.',3,4,3,'draft',NULL,'2025-06-20 14:29:46','2025-06-20 14:29:46'),(4,'Startup Growth Hacks','Tips for scaling new businesses.',1,1,5,'published','2025-06-10 00:00:00','2025-06-20 14:29:46','2025-06-20 14:29:46'),(5,'Quantum Leap','Exploring quantum computers.',1,1,1,'draft','2025-06-25 00:00:00','2025-06-20 14:41:16','2025-06-20 14:41:16'),(6,'Cybersecurity Trends','2025 analysis of threats.',1,3,1,'draft',NULL,'2025-06-20 15:36:43','2025-06-20 15:36:43'),(7,'Cybersecurity Trends','2025 analysis of threats.',1,3,1,'draft',NULL,'2025-06-20 15:37:03','2025-06-20 15:37:03'),(8,'Test Article','Test content here.',1,1,1,'draft',NULL,'2025-06-20 15:38:00','2025-06-20 15:38:00');
/*!40000 ALTER TABLE `Articles` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_article_update` AFTER UPDATE ON `articles` FOR EACH ROW BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO AuditTrail (user_id, entity, entity_id, action)
        VALUES (1, 'Article', NEW.article_id, CONCAT('Status changed to ', NEW.status));
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping data for table `ArticleStats`
--

LOCK TABLES `ArticleStats` WRITE;
/*!40000 ALTER TABLE `ArticleStats` DISABLE KEYS */;
INSERT INTO `ArticleStats` VALUES (1,2,1200,300),(2,3,700,200),(3,4,1500,400);
/*!40000 ALTER TABLE `ArticleStats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `ArticleTags`
--

LOCK TABLES `ArticleTags` WRITE;
/*!40000 ALTER TABLE `ArticleTags` DISABLE KEYS */;
INSERT INTO `ArticleTags` VALUES (3,1),(4,2),(2,3);
/*!40000 ALTER TABLE `ArticleTags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `AuditTrail`
--

LOCK TABLES `AuditTrail` WRITE;
/*!40000 ALTER TABLE `AuditTrail` DISABLE KEYS */;
INSERT INTO `AuditTrail` VALUES (1,1,'Article',2,'Status updated to under review','2025-06-20 20:00:57'),(2,1,'Article',1,'Status changed to under review','2025-06-20 20:11:21'),(3,1,'Article',3,'Manually Published','2025-06-20 21:06:39'),(4,1,'Article',3,'Manually Published','2025-06-20 21:07:07'),(5,1,'Article',3,'Manually Published','2025-06-20 21:07:14'),(6,1,'Article',2,'Status changed to published','2025-06-20 21:18:23'),(7,1,'Article',2,'Published','2025-06-20 21:18:23'),(8,1,'Article',2,'Published','2025-06-20 22:16:27');
/*!40000 ALTER TABLE `AuditTrail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Authors`
--

LOCK TABLES `Authors` WRITE;
/*!40000 ALTER TABLE `Authors` DISABLE KEYS */;
INSERT INTO `Authors` VALUES (1,'Alice Smith','Tech writer'),(2,'Bob Lee','Science editor'),(3,'Catherine Doe','Writes on environmental tech.'),(4,'David Kim','Focuses on scientific innovation.');
/*!40000 ALTER TABLE `Authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Categories`
--

LOCK TABLES `Categories` WRITE;
/*!40000 ALTER TABLE `Categories` DISABLE KEYS */;
INSERT INTO `Categories` VALUES (5,'Business'),(3,'Health'),(4,'Lifestyle'),(2,'Science'),(1,'Technology');
/*!40000 ALTER TABLE `Categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Comments`
--

LOCK TABLES `Comments` WRITE;
/*!40000 ALTER TABLE `Comments` DISABLE KEYS */;
INSERT INTO `Comments` VALUES (8,3,6,'Please add sources.','2025-06-20 14:32:56','pending'),(9,4,4,'Very informative.','2025-06-20 14:32:56','approved'),(13,2,5,'Needs better structure.','2025-06-20 16:55:21','rejected');
/*!40000 ALTER TABLE `Comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Magazines`
--

LOCK TABLES `Magazines` WRITE;
/*!40000 ALTER TABLE `Magazines` DISABLE KEYS */;
INSERT INTO `Magazines` VALUES (1,'TechX Journal Updated','Issue-101','2025-06-01','archived'),(2,'Science Today','Issue-202','2025-06-15','active'),(3,'Health Weekly','Issue-88','2025-05-01','archived'),(4,'TechX Journal','Vol-45','2025-06-20','active');
/*!40000 ALTER TABLE `Magazines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Media`
--

LOCK TABLES `Media` WRITE;
/*!40000 ALTER TABLE `Media` DISABLE KEYS */;
INSERT INTO `Media` VALUES (1,'image','http://example.com/img1.jpg'),(2,'image','http://example.com/eco.jpg'),(3,'pdf','http://example.com/heart-guide.pdf'),(4,'video','http://example.com/startup-tips.mp4');
/*!40000 ALTER TABLE `Media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Roles`
--

LOCK TABLES `Roles` WRITE;
/*!40000 ALTER TABLE `Roles` DISABLE KEYS */;
INSERT INTO `Roles` VALUES (1,'admin'),(3,'author'),(2,'editor'),(5,'moderator'),(4,'viewer');
/*!40000 ALTER TABLE `Roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Tags`
--

LOCK TABLES `Tags` WRITE;
/*!40000 ALTER TABLE `Tags` DISABLE KEYS */;
INSERT INTO `Tags` VALUES (1,'AI'),(3,'Environment'),(6,'GreenTech'),(4,'Health'),(2,'Machine Learning'),(5,'Startups');
/*!40000 ALTER TABLE `Tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'admin_user',1),(2,'editor_user',2),(3,'author_user1',3),(4,'author_user2',3),(5,'viewer_user1',4),(6,'moderator_user',5),(7,'reader_extra',4);
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-20 22:31:54
