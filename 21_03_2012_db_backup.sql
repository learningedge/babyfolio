-- MySQL dump 10.13  Distrib 5.1.49, for debian-linux-gnu (x86_64)
--
-- Host: mysql.codephonic.com    Database: babyfolio_dev
-- ------------------------------------------------------
-- Server version	5.1.53-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `attachments`
--

DROP TABLE IF EXISTS `attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `media_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `object_id` int(11) DEFAULT NULL,
  `object_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attachments`
--

LOCK TABLES `attachments` WRITE;
/*!40000 ALTER TABLE `attachments` DISABLE KEYS */;
INSERT INTO `attachments` VALUES (6,114,'2012-03-16 11:32:45','2012-03-20 11:16:00',5,'Child'),(7,115,'2012-03-16 13:08:10','2012-03-20 15:12:48',13,'User'),(8,83,'2012-03-16 14:48:22','2012-03-16 14:48:22',1,'Moment'),(9,86,'2012-03-16 14:48:22','2012-03-16 14:48:22',2,'Moment'),(10,87,'2012-03-16 14:48:22','2012-03-16 14:48:22',3,'Moment'),(11,90,'2012-03-16 14:48:22','2012-03-16 14:48:22',4,'Moment'),(12,91,'2012-03-16 14:48:22','2012-03-16 14:48:22',5,'Moment'),(13,92,'2012-03-16 14:48:22','2012-03-16 14:48:22',6,'Moment'),(14,93,'2012-03-19 15:38:51','2012-03-19 15:38:51',7,'Moment'),(15,94,'2012-03-19 15:38:51','2012-03-19 15:38:51',8,'Moment'),(16,95,'2012-03-19 15:38:51','2012-03-19 15:38:51',9,'Moment'),(17,96,'2012-03-19 15:38:51','2012-03-19 15:38:51',10,'Moment'),(18,97,'2012-03-19 15:38:51','2012-03-19 15:38:51',11,'Moment'),(19,98,'2012-03-19 15:38:52','2012-03-19 15:38:52',12,'Moment'),(20,99,'2012-03-19 15:38:52','2012-03-19 15:38:52',13,'Moment'),(21,100,'2012-03-19 15:38:52','2012-03-19 15:38:52',14,'Moment'),(22,101,'2012-03-19 15:38:53','2012-03-19 15:38:53',15,'Moment'),(23,102,'2012-03-19 15:38:53','2012-03-19 15:38:53',16,'Moment'),(24,103,'2012-03-19 15:38:53','2012-03-19 15:38:53',17,'Moment'),(25,104,'2012-03-19 15:38:53','2012-03-19 15:38:53',18,'Moment'),(26,105,'2012-03-19 15:38:53','2012-03-19 15:38:53',19,'Moment'),(27,106,'2012-03-19 15:38:53','2012-03-19 15:38:53',20,'Moment'),(28,107,'2012-03-19 15:38:54','2012-03-19 15:38:54',21,'Moment'),(29,108,'2012-03-19 15:38:54','2012-03-19 15:38:54',22,'Moment'),(30,109,'2012-03-19 15:38:54','2012-03-19 15:38:54',23,'Moment'),(31,110,'2012-03-19 15:38:54','2012-03-19 15:38:54',24,'Moment'),(32,111,'2012-03-19 15:38:54','2012-03-19 15:38:54',25,'Moment'),(33,89,'2012-03-20 11:22:10','2012-03-20 11:22:10',29,'Child');
/*!40000 ALTER TABLE `attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authentications`
--

DROP TABLE IF EXISTS `authentications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authentications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `uid` varchar(255) DEFAULT NULL,
  `index` varchar(255) DEFAULT NULL,
  `create` varchar(255) DEFAULT NULL,
  `destroy` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authentications`
--

LOCK TABLES `authentications` WRITE;
/*!40000 ALTER TABLE `authentications` DISABLE KEYS */;
/*!40000 ALTER TABLE `authentications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `children`
--

DROP TABLE IF EXISTS `children`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `children` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `second_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `birth_date` datetime NOT NULL,
  `family_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `children`
--

LOCK TABLES `children` WRITE;
/*!40000 ALTER TABLE `children` DISABLE KEYS */;
INSERT INTO `children` VALUES (5,'Gucio',NULL,NULL,'2012-02-02 00:00:00',4,'2012-02-23 20:00:05','2012-03-15 13:52:17'),(6,'rafaleczek',NULL,NULL,'2012-02-17 00:00:00',5,'2012-02-23 21:54:25','2012-02-23 21:54:25'),(7,'Ewa',NULL,NULL,'2011-10-11 00:00:00',6,'2012-02-26 10:31:02','2012-02-26 10:31:02'),(8,'Marcin',NULL,NULL,'2012-02-01 00:00:00',6,'2012-02-26 10:31:02','2012-02-26 10:31:02'),(9,'Rafal',NULL,NULL,'2011-09-06 00:00:00',6,'2012-02-27 15:41:00','2012-02-27 15:41:00'),(10,'Ewa',NULL,NULL,'2009-02-03 00:00:00',7,'2012-02-27 15:54:00','2012-02-27 15:54:00'),(11,'Whitney',NULL,NULL,'2007-06-22 00:00:00',8,'2012-02-28 00:11:18','2012-02-28 00:11:18'),(12,'Whitney',NULL,NULL,'2007-06-22 00:00:00',9,'2012-02-28 15:05:01','2012-02-28 15:05:01'),(13,'Jasio',NULL,NULL,'2012-02-10 00:00:00',10,'2012-02-29 13:15:05','2012-02-29 13:15:05'),(15,'Henio',NULL,NULL,'2012-03-09 00:00:00',11,'2012-03-01 13:53:31','2012-03-01 13:53:31'),(16,'Carolyn',NULL,NULL,'2004-11-15 00:00:00',12,'2012-03-02 00:35:20','2012-03-02 00:35:20'),(17,'child_one',NULL,NULL,'2012-03-06 00:00:00',13,'2012-03-06 11:17:18','2012-03-06 11:17:18'),(18,'child_two',NULL,NULL,'2003-03-04 00:00:00',13,'2012-03-06 11:17:18','2012-03-06 11:17:18'),(19,'child_one',NULL,NULL,'2012-03-06 00:00:00',14,'2012-03-06 11:17:39','2012-03-06 11:17:39'),(20,'child_two',NULL,NULL,'2003-03-04 00:00:00',14,'2012-03-06 11:17:39','2012-03-06 11:17:39'),(21,'child_one',NULL,NULL,'2012-03-06 00:00:00',15,'2012-03-06 11:34:17','2012-03-06 11:34:17'),(22,'child_two',NULL,NULL,'2003-03-04 00:00:00',15,'2012-03-06 11:34:17','2012-03-06 11:34:17'),(23,'Lukasz',NULL,NULL,'2012-02-09 00:00:00',16,'2012-03-07 10:00:06','2012-03-07 10:00:06'),(24,'Ewa',NULL,NULL,'2012-02-02 00:00:00',17,'2012-03-07 11:45:49','2012-03-07 11:45:49'),(25,'rafalchild1',NULL,NULL,'2012-03-06 00:00:00',18,'2012-03-14 14:47:35','2012-03-14 14:47:35'),(26,'Henio',NULL,NULL,'2012-03-02 00:00:00',19,'2012-03-19 07:41:21','2012-03-19 07:41:21'),(27,'antek',NULL,NULL,'2012-03-15 00:00:00',20,'2012-03-19 10:02:40','2012-03-19 10:02:40'),(28,'rafalek',NULL,NULL,'2012-03-06 00:00:00',21,'2012-03-19 15:22:18','2012-03-19 15:22:18'),(29,'Rafalcio',NULL,NULL,'2012-03-07 00:00:00',4,'2012-03-20 11:20:22','2012-03-20 11:20:22');
/*!40000 ALTER TABLE `children` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `families`
--

DROP TABLE IF EXISTS `families`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `families` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `zip_code` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `families`
--

LOCK TABLES `families` WRITE;
/*!40000 ALTER TABLE `families` DISABLE KEYS */;
INSERT INTO `families` VALUES (4,'Walczak','2012-02-23 20:00:05','2012-02-23 20:00:05','42-200'),(5,'walczaki','2012-02-23 21:54:25','2012-02-23 21:54:25','42224'),(6,'Kopcinscy','2012-02-26 10:31:02','2012-02-26 10:31:02','10044'),(7,'Kopcinscy2','2012-02-27 15:54:00','2012-02-27 15:54:00','08873'),(8,'Burton','2012-02-28 00:11:18','2012-02-28 00:11:18','06890'),(9,'Burton','2012-02-28 15:05:01','2012-02-28 15:05:01','06890'),(10,'Rodziniaki','2012-02-29 13:15:05','2012-02-29 13:15:05','1234'),(11,'Gutki','2012-03-01 12:51:30','2012-03-01 12:51:30','12345'),(12,'Tanner','2012-03-02 00:35:19','2012-03-02 00:35:19','10128'),(13,'myfamily','2012-03-06 11:17:18','2012-03-06 11:17:18','432220'),(14,'myfamily','2012-03-06 11:17:39','2012-03-06 11:17:39','432220'),(15,'myfamily','2012-03-06 11:34:17','2012-03-06 11:34:17','432220'),(16,'Kopcinscy','2012-03-07 10:00:06','2012-03-07 10:00:06','12345'),(17,'Kopcinscy','2012-03-07 11:45:49','2012-03-07 11:45:49','12332'),(18,'Walczak','2012-03-14 14:47:35','2012-03-14 14:47:35','345678'),(19,'Gutkowie','2012-03-16 11:14:05','2012-03-16 11:14:05','12345'),(20,'galkowski','2012-03-19 10:02:40','2012-03-19 10:02:40','42200'),(21,'walczak','2012-03-19 15:22:18','2012-03-19 15:22:18','42200');
/*!40000 ALTER TABLE `families` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `media_id` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `image_content_type` varchar(255) DEFAULT NULL,
  `image_file_name` varchar(255) DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `image_remote_url` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES (65,'221729674503791','MediaFacebook','2012-03-16 14:40:22','image/jpeg','225919_221729674503791_100000002815276_975956_1614101_n.jpg',60306,'2012-03-16 11:32:44','2012-03-16 14:40:23','http://sphotos.xx.fbcdn.net/hphotos-ash4/225919_221729674503791_100000002815276_975956_1614101_n.jpg',13),(66,'184791624864263','MediaFacebook','2012-03-18 13:55:47','image/jpeg','39434_184791624864263_100000002815276_709623_5351072_n.jpg',54980,'2012-03-16 11:33:08','2012-03-18 13:55:48','http://a7.sphotos.ak.fbcdn.net/hphotos-ak-ash2/39434_184791624864263_100000002815276_709623_5351072_n.jpg',13),(67,'6832653022','MediaFlickr','2012-03-20 14:29:23','image/jpeg','6832653022_06b389f37b_b.jpg',160718,'2012-03-16 11:34:05','2012-03-20 14:29:25','http://farm8.static.flickr.com/7052/6832653022_06b389f37b_b.jpg',13),(68,NULL,'MediaImage','2012-03-16 12:14:30','image/png','default.png',20005,'2012-03-16 12:14:31','2012-03-16 12:14:31',NULL,13),(69,NULL,'MediaImage','2012-03-16 12:15:41','image/png','fotomontaz.png',796058,'2012-03-16 12:15:42','2012-03-16 12:15:42',NULL,13),(70,'184798138196945','MediaFacebook','2012-03-20 10:40:06','image/jpeg','71998_184798138196945_100000002815276_709720_1909137_n.jpg',44693,'2012-03-16 12:56:06','2012-03-20 10:40:07','http://sphotos.xx.fbcdn.net/hphotos-snc7/71998_184798138196945_100000002815276_709720_1909137_n.jpg',13),(71,NULL,'MediaImage',NULL,NULL,NULL,NULL,'2012-03-16 13:08:10','2012-03-16 13:08:10',NULL,13),(72,NULL,'MediaImage',NULL,NULL,NULL,NULL,'2012-03-16 13:32:42','2012-03-16 13:32:42',NULL,13),(73,NULL,'MediaImage',NULL,NULL,NULL,NULL,'2012-03-16 13:33:27','2012-03-16 13:33:27',NULL,13),(74,NULL,'MediaImage',NULL,NULL,NULL,NULL,'2012-03-16 13:34:32','2012-03-16 13:34:32',NULL,13),(75,NULL,'MediaImage','2012-03-16 13:35:59','image/jpeg','DSC00002.JPG',2007082,'2012-03-16 13:36:07','2012-03-16 13:36:07',NULL,13),(76,NULL,'MediaImage',NULL,NULL,NULL,NULL,'2012-03-16 13:45:36','2012-03-16 13:45:36',NULL,13),(77,NULL,'MediaImage',NULL,NULL,NULL,NULL,'2012-03-16 13:46:51','2012-03-16 13:46:51',NULL,13),(78,NULL,'MediaImage',NULL,NULL,NULL,NULL,'2012-03-16 13:51:43','2012-03-16 13:51:43',NULL,13),(79,NULL,'MediaImage',NULL,NULL,NULL,NULL,'2012-03-16 13:57:36','2012-03-16 13:57:36',NULL,13),(80,NULL,'MediaImage',NULL,NULL,NULL,NULL,'2012-03-16 14:00:37','2012-03-16 14:00:37',NULL,13),(81,NULL,'MediaImage','2012-03-16 14:10:46','image/jpeg','DSC00015.JPG',1911321,'2012-03-16 14:10:53','2012-03-16 14:10:53',NULL,13),(82,NULL,'MediaImage','2012-03-16 14:15:18','image/jpeg','DSC00009.JPG',2437776,'2012-03-16 14:15:28','2012-03-16 14:15:28',NULL,13),(83,'248501255242320','MediaFacebook',NULL,NULL,NULL,NULL,'2012-03-16 14:20:24','2012-03-16 14:20:24','http://sphotos.xx.fbcdn.net/hphotos-ash4/429428_248501255242320_100002473421424_527059_1702514438_n.jpg',42),(84,'242616272497485','MediaFacebook',NULL,NULL,NULL,NULL,'2012-03-16 14:20:24','2012-03-16 14:20:24','http://a7.sphotos.ak.fbcdn.net/hphotos-ak-snc7/421369_242616272497485_100002473421424_513749_440987739_n.jpg',42),(85,'242616295830816','MediaFacebook',NULL,NULL,NULL,NULL,'2012-03-16 14:20:24','2012-03-16 14:20:24','http://sphotos.xx.fbcdn.net/hphotos-ash4/420203_242616295830816_100002473421424_513750_1100695113_n.jpg',42),(86,'241895729236206','MediaFacebook',NULL,NULL,NULL,NULL,'2012-03-16 14:20:24','2012-03-16 14:20:24','http://sphotos.xx.fbcdn.net/hphotos-snc7/s720x720/419061_241895729236206_100002473421424_512012_460732842_n.jpg',42),(87,'242615909164188','MediaFacebook',NULL,NULL,NULL,NULL,'2012-03-16 14:20:24','2012-03-16 14:20:24','http://a8.sphotos.ak.fbcdn.net/hphotos-ak-snc7/s720x720/429450_242615909164188_100002473421424_513746_126295834_n.jpg',42),(89,'6829706544','MediaFlickr','2012-03-20 11:22:11','image/jpeg','6829706544_deb7f34cf9_b.jpg',450997,'2012-03-16 14:40:41','2012-03-20 11:22:13','http://farm8.static.flickr.com/7210/6829706544_deb7f34cf9_b.jpg',13),(90,'69993912586140','MediaVimeo',NULL,NULL,NULL,NULL,'2012-03-16 14:48:22','2012-03-16 14:48:22',NULL,85),(91,'69993912581900','MediaVimeo',NULL,NULL,NULL,NULL,'2012-03-16 14:48:22','2012-03-16 14:48:22',NULL,85),(92,'69993912577800','MediaVimeo',NULL,NULL,NULL,NULL,'2012-03-16 14:48:22','2012-03-16 14:48:22',NULL,85),(93,'6832651028','MediaFlickr','2012-03-19 15:38:30','image/jpeg','6832651028_40c953f247_b.jpg',184607,'2012-03-19 15:38:32','2012-03-19 15:38:32','http://farm8.static.flickr.com/7209/6832651028_40c953f247_b.jpg',71),(94,'6978783559','MediaFlickr','2012-03-19 15:38:32','image/jpeg','6978783559_919e31b3c3_b.jpg',113956,'2012-03-19 15:38:34','2012-03-19 15:38:34','http://farm8.static.flickr.com/7047/6978783559_919e31b3c3_b.jpg',71),(95,'6978783651','MediaFlickr','2012-03-19 15:38:34','image/jpeg','6978783651_0b8081b6e2_b.jpg',110421,'2012-03-19 15:38:36','2012-03-19 15:38:36','http://farm8.static.flickr.com/7189/6978783651_0b8081b6e2_b.jpg',71),(96,'6975830187','MediaFlickr','2012-03-19 15:38:37','image/jpeg','6975830187_0d489f72fd_b.jpg',416260,'2012-03-19 15:38:38','2012-03-19 15:38:38','http://farm8.static.flickr.com/7207/6975830187_0d489f72fd_b.jpg',71),(97,'6829706544','MediaFlickr','2012-03-19 15:38:39','image/jpeg','6829706544_deb7f34cf9_b.jpg',450997,'2012-03-19 15:38:41','2012-03-19 15:38:41','http://farm8.static.flickr.com/7210/6829706544_deb7f34cf9_b.jpg',71),(98,'6832652920','MediaFlickr','2012-03-19 15:38:41','image/jpeg','6832652920_bc4ddca0fd_b.jpg',127575,'2012-03-19 15:38:43','2012-03-19 15:38:43','http://farm8.static.flickr.com/7068/6832652920_bc4ddca0fd_b.jpg',71),(99,'6829707218','MediaFlickr','2012-03-19 15:38:43','image/jpeg','6829707218_2c63b201dd_b.jpg',449603,'2012-03-19 15:38:45','2012-03-19 15:38:45','http://farm8.static.flickr.com/7177/6829707218_2c63b201dd_b.jpg',71),(100,'6978783133','MediaFlickr','2012-03-19 15:38:46','image/jpeg','6978783133_90040115c3_b.jpg',190264,'2012-03-19 15:38:47','2012-03-19 15:38:47','http://farm8.static.flickr.com/7063/6978783133_90040115c3_b.jpg',71),(101,'9NusvsKMSE4','MediaYoutube',NULL,NULL,NULL,NULL,'2012-03-19 15:38:48','2012-03-19 15:38:48',NULL,143),(102,'quuM0RKKFyM','MediaYoutube',NULL,NULL,NULL,NULL,'2012-03-19 15:38:48','2012-03-19 15:38:48',NULL,143),(103,'zzk1PvfteAw','MediaYoutube',NULL,NULL,NULL,NULL,'2012-03-19 15:38:48','2012-03-19 15:38:48',NULL,143),(104,'KkXM5Xor7cU','MediaYoutube',NULL,NULL,NULL,NULL,'2012-03-19 15:38:48','2012-03-19 15:38:48',NULL,143),(105,'r4EeHojMa5E','MediaYoutube',NULL,NULL,NULL,NULL,'2012-03-19 15:38:48','2012-03-19 15:38:48',NULL,143),(106,'tHj1kUvXWDI','MediaYoutube',NULL,NULL,NULL,NULL,'2012-03-19 15:38:48','2012-03-19 15:38:48',NULL,143),(107,'P0xdKyuBn1w','MediaYoutube',NULL,NULL,NULL,NULL,'2012-03-19 15:38:48','2012-03-19 15:38:48',NULL,143),(108,'5COAtusDbWU','MediaYoutube',NULL,NULL,NULL,NULL,'2012-03-19 15:38:49','2012-03-19 15:38:49',NULL,143),(109,'I9-lS8pwnbg','MediaYoutube',NULL,NULL,NULL,NULL,'2012-03-19 15:38:49','2012-03-19 15:38:49',NULL,143),(110,'aMQvINo6k9g','MediaYoutube',NULL,NULL,NULL,NULL,'2012-03-19 15:38:49','2012-03-19 15:38:49',NULL,143),(111,'Ly842PGONvw','MediaYoutube',NULL,NULL,NULL,NULL,'2012-03-19 15:38:50','2012-03-19 15:38:50',NULL,143),(112,'221731794503579','MediaFacebook','2012-03-20 15:10:40','image/jpeg','227784_221731794503579_100000002815276_975968_4739211_n.jpg',57883,'2012-03-20 10:10:09','2012-03-20 15:10:42','http://sphotos.xx.fbcdn.net/hphotos-snc6/227784_221731794503579_100000002815276_975968_4739211_n.jpg',13),(113,'6832651028','MediaFlickr','2012-03-20 10:35:05','image/jpeg','6832651028_40c953f247_b.jpg',184607,'2012-03-20 10:35:04','2012-03-20 10:35:07','http://farm8.static.flickr.com/7209/6832651028_40c953f247_b.jpg',13),(114,'6975830187','MediaFlickr','2012-03-20 11:16:01','image/jpeg','6975830187_0d489f72fd_b.jpg',416260,'2012-03-20 11:16:00','2012-03-20 11:16:03','http://farm8.static.flickr.com/7207/6975830187_0d489f72fd_b.jpg',13),(115,NULL,'MediaImage','2012-03-20 15:12:39','image/jpeg','S7302280.JPG',3471690,'2012-03-20 15:12:48','2012-03-20 15:12:48',NULL,13);
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `moments`
--

DROP TABLE IF EXISTS `moments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `moments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moments`
--

LOCK TABLES `moments` WRITE;
/*!40000 ALTER TABLE `moments` DISABLE KEYS */;
INSERT INTO `moments` VALUES (1,NULL,'2012-03-16 14:48:22','2012-03-16 14:48:22'),(2,NULL,'2012-03-16 14:48:22','2012-03-16 14:48:22'),(3,NULL,'2012-03-16 14:48:22','2012-03-16 14:48:22'),(4,NULL,'2012-03-16 14:48:22','2012-03-16 14:48:22'),(5,NULL,'2012-03-16 14:48:22','2012-03-16 14:48:22'),(6,NULL,'2012-03-16 14:48:22','2012-03-16 14:48:22'),(7,NULL,'2012-03-19 15:38:51','2012-03-19 15:38:51'),(8,NULL,'2012-03-19 15:38:51','2012-03-19 15:38:51'),(9,NULL,'2012-03-19 15:38:51','2012-03-19 15:38:51'),(10,NULL,'2012-03-19 15:38:51','2012-03-19 15:38:51'),(11,NULL,'2012-03-19 15:38:51','2012-03-19 15:38:51'),(12,NULL,'2012-03-19 15:38:52','2012-03-19 15:38:52'),(13,NULL,'2012-03-19 15:38:52','2012-03-19 15:38:52'),(14,NULL,'2012-03-19 15:38:52','2012-03-19 15:38:52'),(15,NULL,'2012-03-19 15:38:53','2012-03-19 15:38:53'),(16,NULL,'2012-03-19 15:38:53','2012-03-19 15:38:53'),(17,NULL,'2012-03-19 15:38:53','2012-03-19 15:38:53'),(18,NULL,'2012-03-19 15:38:53','2012-03-19 15:38:53'),(19,NULL,'2012-03-19 15:38:53','2012-03-19 15:38:53'),(20,NULL,'2012-03-19 15:38:53','2012-03-19 15:38:53'),(21,NULL,'2012-03-19 15:38:54','2012-03-19 15:38:54'),(22,NULL,'2012-03-19 15:38:54','2012-03-19 15:38:54'),(23,NULL,'2012-03-19 15:38:54','2012-03-19 15:38:54'),(24,NULL,'2012-03-19 15:38:54','2012-03-19 15:38:54'),(25,NULL,'2012-03-19 15:38:54','2012-03-19 15:38:54');
/*!40000 ALTER TABLE `moments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relations`
--

DROP TABLE IF EXISTS `relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `family_id` int(11) DEFAULT NULL,
  `member_type` varchar(255) DEFAULT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `accepted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relations`
--

LOCK TABLES `relations` WRITE;
/*!40000 ALTER TABLE `relations` DISABLE KEYS */;
INSERT INTO `relations` VALUES (12,13,4,'parent','Rafal','LlgGxfYuwqibc81OQ3Mt',1),(14,15,4,'other','rafal','TZQB1HEm57pFYUTmBnK',1),(15,16,5,'parent','Animowykaszlak','3IHPRfMpZs289bLT2dM4',1),(18,15,5,'aunt','ciocia rafcia','hJkYTCdj4ZGM5hYpeHrW',1),(19,19,6,'parent','Lukasz.kopcinski','A0yPi6BLhZyYZR0z3Mq',1),(20,20,6,'parent','Lukasz','CzHPp5q0pb6Y8lwbcYTf',1),(21,21,6,'aunt','Alan','D2YhaTpfImKgQ6SWjziP',1),(22,22,6,'cousin','Martin','OeFQOXgBXbxnLvQqxpX',1),(23,23,7,'parent','Lukasz+4','tooGzF5S7rxoKCsAJhp',1),(24,25,7,'parent','Slawomir','KSb8VHOOW11VaZqIEZ9V',1),(28,27,4,'great-grandmother','rafal','Zzl4n7eFpCy4AFJ9UR',1),(29,28,4,'other','rafal+4','nGkC5aTUsv8I6UAG4DVq',1),(30,29,8,'parent','Don.c.burton','3zdRKFGnpeYw1axdltS',1),(33,29,9,'parent','Don.c.burton','Cza4XXDOkYRACdOMrI0N',1),(35,12,10,'parent','Admin','9KTOBk9OMPIABtsV0nj8',1),(36,32,11,'parent','Gutz','6Qwu10rDecSVAnrE2bjr',1),(37,35,12,'parent','Brooks ','awmCacUPQUgOez6NAo',1),(40,15,13,'father','Raf.walczak','cWM4UrSOMRzLYq3ljeCS',1),(41,15,14,'father','Raf.walczak','dWImPZQVsbgmJs1MOCbj',1),(42,15,15,'father','Raf.walczak','a0DkMlFGJdinudpmYd',1),(45,37,16,'mother','Lukasz+22','Jz5tvvrXBKHlq8SnhnP',1),(46,38,17,'mother','Lukasz.kopcinski','FpJbJL84AQ35A8zi3QhW',1),(47,39,18,'mother','Raf.walczak+5','rZMi0BlJMw1r8bsUOnJo',1),(49,42,19,'mother','Augustyn','24LU9JS5RmSulmTTXxwb',1),(50,44,20,'father','Rafal','gaErvhKTtyV8iDava8xE',1),(54,71,21,'father','Rafal+5','oiSEGrgsNHkkDEXed5MZ',1);
/*!40000 ALTER TABLE `relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20120210123132'),('20120210130041'),('20120210143315'),('20120210143500'),('20120213151323'),('20120214120205'),('20120215104158'),('20120217082123'),('20120220111856'),('20120222134351'),('20120228130729'),('20120228171620'),('20120228180915'),('20120229103729'),('20120301144109'),('20120301155852'),('20120305093257'),('20120306152406'),('20120309102930'),('20120309102952'),('20120309105821'),('20120312132147'),('20120315090014'),('20120315153153'),('20120316095441'),('20120316122014');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `uid` varchar(255) DEFAULT NULL,
  `uname` varchar(255) DEFAULT NULL,
  `uemail` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  `secret` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (14,38,'facebook','712208227','Lukasz Kopcinski','lukasz.kopcinski@gmail.com','2012-03-07 11:50:32','2012-03-07 11:50:32','AAADvNv5NpcwBAPNkwRo5jSZAKdDSQVrZAn55RhJ7Ultlgg4MSXcMBnif5xVGOOFGsE4o3R2hG4wZCWJ1yWu3FR9m79iZApvczA8IPRGOtQZDZD',NULL),(67,17,'facebook','100002965122327','Jarek Nowak','jarek@codephonic.com','2012-03-14 10:26:43','2012-03-14 10:26:43','AAADvNv5NpcwBABKVa7keOjaLTTZBP0mKdw0YRS6bMVKzZBvUxJjZAPj3WZAz1uo63wZAjDuj6wZCoH0ULZCwIKyzkI1rwrZA8ZALmFAJxwVNvZCwZDZD',NULL),(72,15,'flickr','77872871@N02','animowykaszlak',NULL,'2012-03-14 13:36:16','2012-03-14 13:36:16','72157629568364747-9bba26d7cead3a15','e7bdec84fb714445'),(78,13,'vimeo','10875630','Rafal Walczak',NULL,'2012-03-16 07:40:32','2012-03-16 07:40:32','3a7a3323de5f50b6b29abe8564c91652','2ab543914da370798819ff5bc0ede552b48b4e72'),(89,32,'vimeo','10820701','vimgut',NULL,'2012-03-19 10:19:11','2012-03-19 13:50:58','c8ead587a43a29ab0c782687d8fab1a5','97b50a237cadd5685d6a97a6c4189c6c31656f72'),(115,32,'facebook','100002473421424','Facezbooka Facezbookb','gutz@o2.pl','2012-03-19 13:50:46','2012-03-19 13:50:46','AAADvNv5NpcwBAG6NH9jREsIuFTIO5nFOgrKyUmxzN0W1wxKlZBrnk1TiOUl4mqyxPHoXoFURgSdgmt5ge37U52g5HnTFAa73N7PRYMwZDZD',NULL),(116,71,'youtube','if8_s2lRkzKoxokOrquFAQ','kudlaty2309',NULL,'2012-03-19 15:23:33','2012-03-19 15:37:06','1/ZEZcDMm-_wztG-Z5MHYBsCoLh-iCBZ7JtT6VSSGEbuw','q5JIPhHtGa3FQOqgT7kylfe2'),(117,71,'flickr','77872871@N02','animowykaszlak',NULL,'2012-03-19 15:26:03','2012-03-19 15:26:03','72157629568364747-9bba26d7cead3a15','e7bdec84fb714445'),(124,13,'facebook','100000002815276','Rafał Walczak','raf.walczak@gmail.com','2012-03-20 15:12:25','2012-03-20 15:12:25','AAADvNv5NpcwBAJAGw5xznSSZB6jUp2zOuYM3G2pkkAoNtwkzRn8XvRgnJhZCZB9jVcGe0cOS0mOIks4zn3uFVTKhytZCCHn0BWK1Jn0rYgZDZD',NULL),(125,13,'flickr','77872871@N02','animowykaszlak',NULL,'2012-03-20 15:12:39','2012-03-20 15:12:40','72157629568364747-9bba26d7cead3a15','e7bdec84fb714445');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_sessions`
--

DROP TABLE IF EXISTS `user_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `update_at` date DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_sessions_on_session_id` (`session_id`),
  KEY `index_user_sessions_on_update_at` (`update_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_sessions`
--

LOCK TABLES `user_sessions` WRITE;
/*!40000 ALTER TABLE `user_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `crypted_password` varchar(255) NOT NULL,
  `password_salt` varchar(255) NOT NULL,
  `persistence_token` varchar(255) NOT NULL,
  `single_access_token` varchar(255) NOT NULL,
  `perishable_token` varchar(255) NOT NULL,
  `login_count` int(11) NOT NULL DEFAULT '0',
  `failed_login_count` int(11) NOT NULL DEFAULT '0',
  `last_request_at` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `current_login_ip` varchar(255) DEFAULT NULL,
  `last_login_ip` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `current_login_at` date DEFAULT NULL,
  `email_confirmed` tinyint(1) DEFAULT '0',
  `avatar_file_size` int(11) DEFAULT NULL,
  `avatar_file_name` varchar(255) DEFAULT NULL,
  `avatar_updated_at` datetime DEFAULT NULL,
  `avatar_content_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (12,NULL,NULL,'admin@codephonic.com','26c11fb286cb381738c98280fbb54b76540b7e7dc9a8a39feafde63ca83a8d9f433a1b18eeb2311108feb160b60a36ffa0ee676a6606d0673468a525929bd772','NClnP8b1D3x975bGkDq','447df62a5c743fb0078460c5fc124019c53796d452423056ab047975d3578579e75949a07aae7b1262cebb167c0f85ae572ebca26725e2b8a99218ca6f0452a8','VWZn5b7RbEVLa2CoRO90','6Br6Oy9Nk34iKnC0nGk',19,0,'2012-03-19 15:06:07','2012-03-19 07:00:00','193.93.91.134','193.93.91.134','2012-02-23 19:58:06','2012-03-19 15:06:07','2012-03-19',1,NULL,NULL,NULL,NULL),(13,'Rafal','Walczak','rafal@codephonic.com','182096ee1372f2f78ac8fe2b7bcca14088a210972848ee0515f508f26fade83e9d5198a1e38de0161a1e7f9d139c58df95296435cb708cfbca41598e9c58ba0c','bj3BPBHf1fSFPsPKL5z','3ba59dc7a47d69f5d9a22e6502161e2d3ad7e0305d622cb4c21034c9645e6d005e4bea88de8bf5117c971d081683e34261312ddd2d038b198efc12352f928158','lMM0UV99kufeWbUVxfho','sychFoHFnuKvtF442wp',58,0,'2012-03-20 15:18:07','2012-03-20 07:00:00','188.95.28.132','188.95.28.132','2012-02-23 19:59:00','2012-03-20 15:18:07','2012-03-20',1,NULL,NULL,NULL,NULL),(17,'Jarek','Nowak','jarek@codephonic.com','c2d876761239465331db3875444e15618962bf22f71995580ecef3f140727e806f9a51468fd66529f19b0d7cf805b081501dd41ad6c0e3d58c7433011f44c4d7','RKeEGChRWUupaUPgYkE3','e64627c5b92d117a09270307e4b99459db71b0c8de5c798605cd732499bbbbf38a6bbfb3a0a1db456888dd46a7bd7c88e51d39e052151dd02c2fb9b5928dc98b','Ya2RPOXcqa54bwf1DrM','L599lxqzlZNuyznkpuf',20,0,'2012-03-16 09:08:56','2012-03-16 07:00:00','188.95.28.132','188.95.28.132','2012-02-23 21:54:25','2012-03-16 09:08:56','2012-03-16',0,NULL,NULL,NULL,NULL),(18,NULL,NULL,'lukasz@codephonic.com','b50fb4c637043cc3ad4b4d5af0cf2653155f9d608f4f2e1e014c7539a78558394e178f0e71062222ad547abe055a7af59e74b4e2f8dec6c13b987125f1d2a079','UY7CzDQmOMUI6cqfwzNK','050fcc1167afaf3cd8aad93cfba5de69a54f0d0dbe57313b2fc8471e4679bec9f4989290e5eb05e1fad254d4d7f8f4554a271aa19cb6d4b66921d3c828ca13f8','PUvUWO1NlKL0B8GUHTEJ','uQFzmnXPGMjdAS74q2FG',0,9,NULL,NULL,NULL,NULL,'2012-02-23 21:55:37','2012-03-14 01:39:15',NULL,0,NULL,NULL,NULL,NULL),(20,'lukasz+1','SecondLastNam','lukasz+1@codephonic.com','37c4e3dd3584f8512217674b15c9142170c2e2cb068001457916d654b9d755a5f35e075dc329389e32c24fb1178f4673686a09816cd289fbf2834c69d6517743','kYkEbS4qTXSOe2qTVrKl','dc7c7b57b8fdf88a68e34a034a78f59c030b5342bc2c6534034b4f97cdce063eb91e1effa5a3588f7069a337e737e03681f304b0638bc7ccc1e0c59824576755','kN26h93PBD7J7BriB','TuwpBkspM64cuxowD11d',4,0,'2012-02-27 16:04:48','2012-02-27 08:00:00','91.213.255.7','91.213.255.7','2012-02-26 10:31:02','2012-02-27 16:04:48','2012-02-27',1,NULL,NULL,NULL,NULL),(21,'lukasz+2','SecondLastName','lukasz+2@codephonic.com','b640ef357876f5fbc072a983f70257097c35feb2b2880b5f27e23e784e86075ba61ece90a146fcdca2250df5f5a128cee04c8543e4c0447d3e83d167bfa90ddf','2bmV3LGaJ1LjpLjCk','015b8a7c7670493ce0fc9d3ff2d106d5c0b56a9b30442a10efe86ee290e272a22fc421149cf0fd9b0fb12e7f255ff2fb21ff349744016bd0e73aa092828c6e6d','6sV82HCZYnobXy1T2BQ','PgMdTu73GGc6Kr7VSYu4',3,0,'2012-02-29 09:10:05','2012-02-27 08:00:00','91.213.255.7','91.213.255.7','2012-02-26 10:32:13','2012-02-29 09:10:05','2012-02-27',1,NULL,NULL,NULL,NULL),(22,'lukasz+3','SecondLastName','lukasz+3@codephonic.com','9b87a9609295b5be0515653a71842ed009ddb77d26014d6db8c5ed42311b98a83d8bbdcf976a34784092e795b0bc529ecc9dfc19f841875b304ca061199e0cf4','onheSfLdTQhPeXEc2bX','0099a715ab073ecd8ae0c80ef73caff7c79dcf64547834e673e6e01c49436124e93ec2f81ed3836d350fe31066a36d3771a01da8f8ead17357bcc05be2e3bca6','3tjxOFIS1ZEjcXl0xow','imyutII5hFbzrl5lHXCO',2,0,'2012-02-27 16:05:04','2012-02-27 08:00:00','91.213.255.7','91.213.255.7','2012-02-26 10:32:16','2012-02-27 16:05:04','2012-02-27',1,NULL,NULL,NULL,NULL),(23,'Lukasz','SecondLastName2','lukasz+4@codephonic.com','b14dae33bf2a892e8ca7ff3c735d2db9eca6bdac6a2b0511274ce124c88fda9f2f65c43977746969b3adb6e75f3d7ea73978c3f565034e881a016d8c6cbaa3b1','sDGbvPU3H41RyoUQTnr7','03814d2094327a93af71795cc03ceda45b6e618109f47b1d1e7587bca4d672537858092eeb45f53ac87ccf6602d09f04011adef082b21bb3efd7a66a42d6b0b5','yol40v9X0Ozh0MzSJzh3','IiEzEyjqxEIgIXEzlD99',1,0,'2012-02-27 16:01:35',NULL,'91.213.255.7',NULL,'2012-02-27 15:46:16','2012-02-27 16:01:35','2012-02-27',1,NULL,NULL,NULL,NULL),(24,'rafcio','walczak','rafal+babyfolio@codephonic.com','9871e02732ffb1a26fcf7f39e44ee61ef2291804234cc05cfae06005ebcafb56177a638f3c98151ba26ba8bda5ebcac78965ff728077a7d5d8a31c0dd9af9db4','xVmoR1diRKhRhrcf5tBC','d9be6e0d8dd166956a2fd4d39f7b1ee13180262279b58429c13266b5e0528e6c21972ec10231af66c44f2f03da3bf80a211d4b4f97adc05267f83411dd7ce89d','GGgL7nslhTYDFrrnjecZ','jttAfr3TfXY8RFr5WrdD',1,0,'2012-02-27 15:55:35',NULL,'188.95.28.132',NULL,'2012-02-27 15:47:43','2012-02-27 15:55:35','2012-02-27',1,NULL,NULL,NULL,NULL),(25,'lukasz+10','SecondLastName','lukasz+10@codephonic.com','7f729ec73d44e101e6048ded3144dfd83aef2685fe350ac4efae02849cdf0396521491a65298a21577acedeb15f276e0c26fee41b4e8f8000456f79ec7e3fe26','Xg5e51xS0LOjZwij7r1f','8e4e48713e2cb433dea03a720664d6edb815449107f868be72a4a22a9878e28ece40252a84d8e22de3edcc2961a7587373c9ce818b4536b17a755a11d4872180','VVQ2o9DyFHAoGLxS8F7','DJhUDC9LirX3ERiQNDeA',2,0,'2012-02-27 16:04:22','2012-02-27 08:00:00','91.213.255.7','91.213.255.7','2012-02-27 15:54:00','2012-02-27 16:04:22','2012-02-27',1,NULL,NULL,NULL,NULL),(26,NULL,NULL,'lukasz+1@codephnic.com','8ebd2400414f4bdc76062232cb519585b220587bbeb0552e7689f793d6cdf52c6837d3c5ea37f6d3b3461d1918c7feffd4296e3b15148cab5dd3faf17aefe25e','yOL4uk9ys4fbocTEm9YF','efd486d1325d31494371db3e02382ebdd59d46f51aec80db0a550fabaa7cd64df37266f0ad4854807ddde1628f4ab0695b28e2da7de009844e65196cdb700f50','Un83C3vLDlY1frjIw4','bAHouXPLUzqpliscqCKl',0,0,NULL,NULL,NULL,NULL,'2012-02-27 16:04:25','2012-02-27 16:04:25',NULL,0,NULL,NULL,NULL,NULL),(27,'rafal+3','rafal','rafal+3@codephonic.com','429f3d5ee78eefd45bc40a372d6b86509489a6daa871392eb98b216fe38dbaab93eb7bc5fbb3e2eb50418422b201aba15bc3e9cce979fb822d15c819c97b3285','gTPEohGConlUFzpzPh3','20f826f78a17182c46543b5ea984ce51757b979bce6039a86a91af4d2d3f78dfd9b879b4c036f6e55d3c8c729ee9871c086497ecf12aba6ca09cd8117076250f','3fFpjwrgMwgTeqHV87c','Vdd8VciUfrXvpMPDNsyB',2,0,'2012-02-27 16:18:07','2012-02-27 08:00:00','188.95.28.132','188.95.28.132','2012-02-27 16:05:55','2012-02-27 16:18:07','2012-02-27',1,NULL,NULL,NULL,NULL),(28,'rafal+4','walczak','rafal+4@codephonic.com','a3f03f6b2200292ce1ca4b9e64578cf819cec38f566a12e1f7767dde138dccaeacabc636e975b07cdff11c26e9a2489a05ce6a091e4c5e653c6d52d5c3a0a823','epaWPESkqBhaGdrmwvl','1111fe23bc5b2945bdd595771570181a30a74b3986684cd3e41ae88beb6bfcd3bc79ed2fa63f9615003d5f0adb3ba7bb971bdaa6a6929c3d85111cf6f369ea2f','H2oqAjO9pV3KGVPqz6GO','pw44QkKN7YnkIw39kEa',2,0,'2012-02-27 16:11:52','2012-02-27 08:00:00','188.95.28.132','188.95.28.132','2012-02-27 16:05:56','2012-02-27 16:11:52','2012-02-27',1,NULL,NULL,NULL,NULL),(29,'don','burton','don.c.burton@gmail.com','4b9225fd9d2164e5cf324f099acde0845c2d4b305b4844f746ad04a85df09eeb902ce20920a065c60365324bb9d96b342e0ca28a7d826beddd6afaf991846e5c','Ix4Owso9VgsVbWcrVFFo','9a801f604ccd77621a1cb362ffa9034c76c13176388cf8847346fdd4c08a9f6e2da05681487070886725859dad56716dd99e755bb2b64577b382bbe768f28f7c','8TAR4Rd0Y5OA9lQzdxNa','skvCa5YojFxHUUPErqR8',1,0,'2012-02-28 15:05:05',NULL,'24.44.139.250',NULL,'2012-02-28 00:03:47','2012-02-28 15:05:05','2012-02-28',1,NULL,NULL,NULL,NULL),(30,NULL,NULL,'letitia.b.burton@accenture.com','f8e45e5b36303479bf82d4537a06769affa80474632249c4bc08421bc528df0cf87d9410047ab677474c14603dcffc205a39355ecd8098d850b6f00bad8db095','PyniVendpJRG2oGJarZc','76ecab86ed664563f91e5792ebd3e3a3afe92fbae4f611f61dd14985d83bcc4f7e15f48e6e11d0f120b4166671f2b5382450ba388bc8a46d37e3b0f4b03c8833','4VCjjnpn0Pm55QMzVf2k','Hw7lRdbTAn33AC1ixGT',0,0,NULL,NULL,NULL,NULL,'2012-02-28 00:11:18','2012-02-28 15:05:01',NULL,0,NULL,NULL,NULL,NULL),(31,NULL,NULL,'dbburton.2@juno.com','8feab94b9d96d09b2b78048807b0af800f615321d4c97f82d713d6d4abbfe63f149fd38fab7c673c9b1e85be18ddd8e1bcca0e71662cefdd1ab51b1a48010458','kxfNRgsmE9UCivwrZFE8','1d18465e9f4a67d89450bb23486579a8c78bfb1ac9f89a591ef8fd3623b1a407452072295d6f3edc2b8bfe413504d8b51185a0241839b4eb5c29355c1a0bd240','verBjWJVtZws36xhMXXA','7GhLaE3PvDGYx4S2Njnk',0,0,NULL,NULL,NULL,NULL,'2012-02-28 00:13:38','2012-02-28 00:13:38',NULL,0,NULL,NULL,NULL,NULL),(32,'Facezbooka','Facezbookb','gutz@o2.pl','6bd488a35c6c7bd63a51c50280f9224d1a8508633d9ccacf89180fe76d0cd15a42745e2cf38c92c883c685ebcd50e912d10c1d4a7a822e852a451904987d5f44','Yjf4pnNyQ9boU95FfvT','e48e9108fd7e0d0b7f92b227aed48bc450b9811e5f2e1c2bb085dc6a25fdbdb6d578996d91f314638acfdbe429ddcb2688b08a25f3dfd08ef2253b9e9c6028bb','xcJLl8f8Wv5SWb9wy8Xj','39SdsvIZqITy6f6pdihs',87,0,'2012-03-21 08:23:41','2012-03-20 07:00:00','77.254.5.141','178.36.229.166','2012-03-01 10:40:24','2012-03-21 08:23:41','2012-03-21',1,NULL,NULL,NULL,NULL),(35,'Brooks','Tanner','brookstanner@hotmail.com','ca4b0eee27b776c77f5be112c076de796ed7385715a1207c622686427942b15a1af0d67edbd2215b9271b056a6f27e3fda75e6f89b12923c38c487c7a07d73d8','tLaELiz01JpVuOsRKzZB','d86ed9a4696019a26b68fc40dfe16283fc14bcc8a4dbc2cac92d214a08d4d809b8d9a45b5af6bf0eed542ccb48efd8243200cfcb8d7a148697d934e9164e88db','stm0XKVLmQfX0eIQC4','sBQVFrJUtvpgdYpy8BI',3,0,'2012-03-05 19:03:51','2012-03-02 08:00:00','98.113.216.140','98.113.216.140','2012-03-02 00:00:04','2012-03-05 19:03:51','2012-03-05',1,NULL,NULL,NULL,NULL),(36,NULL,NULL,'Dianefryetanner@hotmail.com','a487ac775fcd16020296a31cd460894c3b26575c8fe9c3d9996b13acedf4a8634467f8608a8c1853740c88c8226a68087329960af1dcd06ad96082384500c4d9','uySvK0nyDL8YJphrpJk3','f95e316de0814c99454abbcd6a6f6565d6b4bca83c1ade2840964d80e534d633f24307208c8dbf69f0e0c4b2b56c4008502a42961f26264377f43e0e699c3f73','RgOMJ23cfDXD2t8NCFT','CeS3cdXYNUaIE3Vt1Ms',0,0,NULL,NULL,NULL,NULL,'2012-03-02 00:36:05','2012-03-02 00:36:05',NULL,0,NULL,NULL,NULL,NULL),(37,'Lukasz','SecondLastName','lukasz+22@codephonic.com','d250fc3e1b1659930d8bc4d9bb3cfd654fa6968bd81f998fe08a265f9c01625b6d6c935a289c2fd2e303ff3eecc3e465f7875bb0eb990e8af11ba19dbddd3014','D6PwMzWaLCJvBx239yD2','0e5b8ac70638e87be04813fa02172cbb9ddcbdf2a08c40e315802b36d3142e4426170157d79cb3f16911d63c0b87c36ed4fd962944f05bd26dcc316b4f4d44a2','T5xrEm4EvmsHspp20sC','QTOSXz5rYlfM58O6YZW',1,0,'2012-03-07 11:44:54',NULL,'89.68.11.141',NULL,'2012-03-07 09:59:00','2012-03-07 11:44:54','2012-03-07',1,NULL,NULL,NULL,NULL),(38,'Lukasz','Kopcinski','lukasz.kopcinski@gmail.com','dbaa488f01575eaaf6af3ad3886418558cc762ce5110734cbe87c20d52fe6ca9db4c11f07633df359db1164cacaf6a8db5886a32d6c8001e248064ede320662e','ACc1jWaaWJ4bnEHugZYP','67145e0ab25197d6ead4d914f4009a0f2046ce6fcf62f353c462b588a97be1ca219f9f1ce4364a7f21da227c7e292a2366c47fd5f4cedcf29772d751e76e207a','7AY68hqmnfi3Y489xoa','rHQX1QvUmPOZ0jiy49Z',3,0,'2012-03-14 01:43:45','2012-03-07 08:00:00','74.73.179.6','89.68.11.141','2012-03-07 11:45:12','2012-03-14 01:43:45','2012-03-14',1,NULL,NULL,NULL,NULL),(42,'Henio','','augustyn@codephonic.com','81739672d12a8d253253964a8c0137bfe271fd31461245fae9950bf3d780c9c03a97dad8ac4366837142771ab3553fc51daa7cfc7ca3e4fbe972821f2df8d2b6','mtzH55iEWucvIaMg2aX','7261ba8028db0760b479f868ff06beadfee5afee30fd043f0f0f4cf1a6ba4b953ddffeba7749e1b6d59cc5356791f5af2d23f39ee969622448aa909a437712c4','un32Ww79paNiwsJHonv9','TmzMycDg9gi3DZtZ6SHG',24,0,'2012-03-19 11:53:44','2012-03-19 07:00:00','193.93.91.134','188.95.28.132','2012-03-16 10:42:14','2012-03-19 11:53:44','2012-03-19',1,479359,'cat.jpg','2012-03-16 10:42:14','image/jpeg'),(45,'rafal','walczak','raf.wlczak_1234@gmail.com','d9b0aab999caa665e7cb2b0e8b2eee786ba815e6a944a111a8d88ccf35d38897f6fe1f9a86b5d830067587c9cc93879527e63435c5050202d9af699daecf6566','jkR7pfa06QouzUcuOSuB','05fb01de047ad65f60246e28a351f241ce9e4e0b403cdccec635a2058be8972ba75c12c89b0030690183879ef6cc9b66b66d5a49f80f60aa901ba57b371d6b83','FhsOlYBmHYPfJbdXs4k','G5HP2lKD1ta9XS9fen',1,0,'2012-03-19 10:12:50',NULL,'178.37.4.203',NULL,'2012-03-19 10:11:10','2012-03-19 10:12:50','2012-03-19',0,NULL,NULL,NULL,NULL),(67,'nirvana','nirvana','raf.walczak@gmail.com','ec635d07babaa7a7fa01f7e6f44fa02b1da417b23783769143e20e29cb4750a0ed3c1a760e27e084decb3f178ba8c79f263dcf636eb85d41c7d6ff7e7c5ca911','1RDvjf7t5b1susQWVx9s','fa7df4c0528a4c64c5a6b6928fc4cc41be36b2e5ab640ffd8929b51366ed0534e50daaeded0daacee05f4ebe6c6d586c860459552661478c153ee93c2d7a400d','wfyregmSeDIWJ22n5Ex','4fvlQBItNLQ6f0XTocN',1,0,'2012-03-19 13:41:15',NULL,'178.37.4.203',NULL,'2012-03-19 13:26:50','2012-03-19 13:41:15','2012-03-19',1,NULL,NULL,NULL,NULL),(68,'qwe','','goo_tech@interia.pl','32dfceaae3094ee8063f5d8c7ed8208860c42aeb8b8112abfddd4af8e3e7b9d0517c1aefd47f6b745783448b8fd9296764d25e58341f9fdcde87351b91f69107','R8ksS3aGvVnH5KQd2P0','46c03e4b6c974b5a4ab522fb18345e6455f46145650e5184962b9bf7bcf8706b9fd481b9e4852db73ca3e888f7cb92f98fe6f2deac0c560ef9bfee59aee3cb15','IhC5af3e73CMo1bgji','Vb8SHd0ZoiExkqJ6xzL',1,0,'2012-03-19 14:49:47',NULL,'193.93.91.134',NULL,'2012-03-19 13:29:38','2012-03-19 14:49:47','2012-03-19',1,NULL,NULL,NULL,NULL),(69,'rafal','rafal','raf.walczak+1@gmail.com','3308f28e25015ec978249ca210c420c3dafcad0a08570e63141d20c1f8082ddc728c7e5517b2aec69297ea2aac7499fe55f474fafb580c5286a420a75a5b1920','iT3q2oSCi2CxGtGt5Zdm','714a8f701e9abd11234a7983ad8edb950742cc00fa1e99643055b98e16549186322c871135e36ba17b4359ddc4f781c6d3eac2b2fecc3436eeb99032a307ae23','yg588KPDoKJ7UXmvZ6fH','tRFZh2Vr6SFssNI40JC',1,0,'2012-03-19 14:47:06',NULL,'178.37.4.203',NULL,'2012-03-19 13:47:53','2012-03-19 14:47:07','2012-03-19',0,NULL,NULL,NULL,NULL),(70,'G','Gutt','augustyn+1@codephonic.com','333576c313c4bfb95af57a9b4e38535cd511f17ca7f3e3b3eca9060d0a57945acde5e88dd6d13fec6d4f0f25d2469b9a40d99fe2b714f227344fd8c3a3c9ca99','hq9REiHmaIw6p6siRD8d','7287093711bfd6ca55f0b2e3418d1eecd91125876afec66c4e99b077a382adf5756d0db1069720923ea41d15ba8ef07bfbca1acc124fe1ff022a17ce54c68bb0','vXD7wl9JUt1N1EPupzzg','eiYIXzCVEf7xBF2hhjP',2,0,'2012-03-19 15:41:23','2012-03-19 07:00:00','193.93.91.134','193.93.91.134','2012-03-19 14:49:01','2012-03-19 15:41:23','2012-03-19',0,NULL,NULL,NULL,NULL),(71,'rafal','work','rafal+5@codephonic.com','68dc62e5d6c542b91ae4abb0ec8b26557c874ed7d3383d0e8138f27bed8905221c9285226406bf7de3465f6fab1997958de4b351a68c5018d1d7713d491de457','Ts0vVRt6fC6xcqOqrOsx','4f56cda076525b71c42202e78cc5d12b9d2e70371c1fbb55f8f60711b0cb51670e13ac51e3dcff30aec44b27223c244f9c98a2f87ec3af66a77488da5be6d182','cPJlSjQpHH2rKnyNLH4O','5OPhRbqVBBXWWNT6PXj',4,0,'2012-03-20 13:33:12','2012-03-19 07:00:00','188.95.28.132','178.37.4.203','2012-03-19 14:52:06','2012-03-20 13:33:12','2012-03-20',1,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-03-21  1:25:39
