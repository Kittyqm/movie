-- MySQL dump 10.13  Distrib 5.7.19, for Linux (x86_64)
--
-- Host: localhost    Database: movies
-- ------------------------------------------------------
-- Server version	5.7.19-0ubuntu0.16.04.1

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
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `pwd` varchar(100) DEFAULT NULL,
  `is_super` smallint(6) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `role_id` (`role_id`),
  KEY `ix_admin_addtime` (`addtime`),
  CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'python','pbkdf2:sha256:50000$hub7dUpF$bb584942078eb465db50f3d198d91d41ac7a150f9e6e62f1bb99bcaeeed6be59',0,NULL,'2017-09-24 11:44:23'),(3,'adc','pbkdf2:sha256:50000$oladkO2L$732ef57283f2ee998d30eecc95cfb28c65a3843b18e7417860fa87575a3f959d',NULL,NULL,'2017-10-14 11:32:18');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adminlog`
--

DROP TABLE IF EXISTS `adminlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adminlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `ip` varchar(100) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_id` (`admin_id`),
  KEY `ix_adminlog_addtime` (`addtime`),
  CONSTRAINT `adminlog_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adminlog`
--

LOCK TABLES `adminlog` WRITE;
/*!40000 ALTER TABLE `adminlog` DISABLE KEYS */;
INSERT INTO `adminlog` VALUES (1,1,'127.0.0.1','2017-10-10 21:53:16'),(2,1,'127.0.0.1','2017-10-10 21:53:22'),(3,1,'127.0.0.1','2017-10-12 21:12:54'),(4,1,'127.0.0.1','2017-10-14 11:15:20'),(5,1,'127.0.0.1','2017-10-14 11:39:18'),(6,1,'127.0.0.1','2017-10-14 21:37:42'),(7,1,'127.0.0.1','2017-10-16 21:00:33'),(8,1,'127.0.0.1','2017-10-18 22:26:46');
/*!40000 ALTER TABLE `adminlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth`
--

DROP TABLE IF EXISTS `auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `url` (`url`),
  KEY `ix_auth_addtime` (`addtime`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth`
--

LOCK TABLES `auth` WRITE;
/*!40000 ALTER TABLE `auth` DISABLE KEYS */;
INSERT INTO `auth` VALUES (1,'添加标签','/admin/tag/add/','2017-10-10 22:50:02'),(2,'编辑标签','/admin/tag/edit/<int:id>/','2017-10-10 22:50:46'),(3,'标签列表','/admin/tag/list/<int:page>','2017-10-10 22:51:21'),(4,'删除标签','/admin/tag/del/<int:id>/','2017-10-10 22:51:48'),(5,'添加电影','/movie/add/','2017-10-14 21:44:17'),(6,'电影列表','/movie/list/<int:page>','2017-10-14 21:44:38'),(7,'删除电影','/movie/del/<int:id>/','2017-10-14 21:45:09'),(8,'电影编辑','/movie/edit/<int:id>','2017-10-14 21:45:30'),(9,'电影预告添加','/preview/add/','2017-10-14 21:45:53'),(10,'电影预告列表','/preview/list/<int:page>','2017-10-14 21:46:16'),(11,'电影预告编辑','/preview/edit/<int:id>','2017-10-14 21:46:40'),(12,'电影预告删除','/preview/del/<int:id>','2017-10-14 21:47:16'),(13,'后台会员列表','/user/list/<int:page>','2017-10-14 21:47:56'),(14,'后台会员详情','/user/view/<int:id>','2017-10-14 21:48:24'),(15,'后台会员删除','/user/del/<int:id>','2017-10-14 21:48:39'),(17,'评论详情列表','/comment/list/<int:page>','2017-10-14 21:50:14'),(18,'评论删除','/comment/del/<int:id>','2017-10-14 21:50:31'),(19,'电影收藏列表','/moviecol/list/<int:page>','2017-10-14 21:50:57'),(20,'电影收藏删除','/moviecol/del/<int:id>','2017-10-14 21:51:33'),(21,'后台操作日志','/oplog/list/<int:page>','2017-10-14 21:52:13'),(22,'后台登陆日志','/adminloginlog/list/<int:page>','2017-10-14 21:52:56'),(23,'后台会员登陆日志','/userloginlog/list/<int:page>','2017-10-14 21:53:19'),(24,'后台角色添加','/role/add/','2017-10-14 21:53:45'),(25,'后台角色列表','/role/list/<int:page>','2017-10-14 21:54:04'),(26,'后台角色删除','/role/del/<int:id>','2017-10-14 21:54:19'),(27,'后台角色编辑','/role/edit/<int:id>','2017-10-14 21:54:40'),(28,'后台权限添加','/auth/add/','2017-10-14 21:55:02'),(29,'后台权限列表','/auth/list/<int:page>','2017-10-14 21:55:17'),(30,'后台权限删除','/auth/del/<int:id>','2017-10-14 21:55:31'),(31,'后台权限编辑','/auth/edit/<int:id>','2017-10-14 21:55:46'),(32,'后台管理员添加','/admin/add/','2017-10-14 21:56:04'),(33,'后台管理员列表','/admin/list/<int:page>','2017-10-14 21:56:19');
/*!40000 ALTER TABLE `auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text,
  `movie_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `movie_id` (`movie_id`),
  KEY `user_id` (`user_id`),
  KEY `ix_comment_addtime` (`addtime`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`),
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (2,'好看',7,1,'2017-09-24 12:21:11'),(3,'不错',7,2,'2017-09-24 12:21:11'),(4,'经典',7,3,'2017-09-24 12:21:11'),(5,'给力',7,4,'2017-09-24 12:21:11'),(9,'给力',2,4,'2017-09-24 12:21:54'),(10,'难看',3,6,'2017-09-24 12:21:54'),(11,'无聊',5,5,'2017-09-24 12:21:54'),(12,'乏味',2,4,'2017-09-24 12:21:54'),(13,'<p><img src=\"http://img.baidu.com/hi/jx2/j_0002.gif\"/></p>',3,15,'2017-10-18 23:27:44'),(14,'<p><img src=\"http://img.baidu.com/hi/jx2/j_0008.gif\"/></p>',3,15,'2017-10-18 23:28:07'),(15,'<p><img src=\"http://img.baidu.com/hi/jx2/j_0071.gif\"/></p>',4,15,'2017-10-18 23:41:29'),(16,'<p><img src=\"http://img.baidu.com/hi/jx2/j_0074.gif\"/></p>',4,15,'2017-10-18 23:41:34'),(17,'<p><img src=\"http://img.baidu.com/hi/jx2/j_0006.gif\"/></p>',5,14,'2017-10-19 16:21:01'),(18,'<p>sefwefwefsdfsdfdsfsdfsdfsdfdsfdfsffdsfdsf</p>',5,14,'2017-10-19 16:22:25'),(19,'<p><img src=\"http://img.baidu.com/hi/jx2/j_0017.gif\"/></p>',2,14,'2017-10-19 17:33:35'),(20,'<p><img src=\"http://img.baidu.com/hi/jx2/j_0073.gif\"/></p>',2,14,'2017-10-19 17:33:51');
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie`
--

DROP TABLE IF EXISTS `movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `info` text,
  `logo` varchar(255) DEFAULT NULL,
  `star` smallint(6) DEFAULT NULL,
  `playnum` bigint(20) DEFAULT NULL,
  `commentnum` bigint(20) DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `release_time` date DEFAULT NULL,
  `length` varchar(100) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`),
  UNIQUE KEY `url` (`url`),
  UNIQUE KEY `logo` (`logo`),
  KEY `tag_id` (`tag_id`),
  KEY `ix_movie_addtime` (`addtime`),
  CONSTRAINT `movie_ibfk_1` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie`
--

LOCK TABLES `movie` WRITE;
/*!40000 ALTER TABLE `movie` DISABLE KEYS */;
INSERT INTO `movie` VALUES (1,'测试一号','20170924115331f1ff8e7641f24743a2f5667366d73d5d.mp4','测试一号','20170924115331b5cb0c43fd3047e6886554a9c71b1786.jpg',1,2,0,1,'测试一号','2017-09-28','100','2017-09-24 11:53:32'),(2,'测试二号','2017092411541082b8cd549c4649ff9bcac4879ddc72b3.mp4','测试二号','20170924115410c3a22e9358224a0786f62cda02f9665e.jpg',2,6,0,2,'测试二号','2017-09-30','100','2017-09-24 11:54:11'),(3,'测试三号','2017092411544778a4506801b14c75a9b2932a629486a8.mp4','测试三号','20170924115447f3afc07ad1254b0bb2ac7b9cc7ca878d.jpg',3,13,0,4,'测试三号','2017-09-25','100','2017-09-24 11:54:47'),(4,'测试四号','201709241155161f1da3fce4ae4795a06872fb9aa7f2cc.mp4','测试四号','20170924115516c20aa7753d294c7caf80832b8616aa94.jpg',4,5,0,4,'测试四号','2017-09-16','100','2017-09-24 11:55:16'),(5,'测试五号','20170924115546f34bdd45d0364c0eadafe1d64e254795.mp4','测试五号','2017092411554656316d74289b4501ad4de7b7eca6b95b.jpg',5,6,0,5,'测试五号','2017-09-08','100','2017-09-24 11:55:46'),(6,'测试七号','20170924121808482010bbffa1424d82c505a1984a85c0.mp4','测试七号','20170924121808e628713cc0974aa6a319ffe8f2d7a227.jpg',1,4,0,8,'测试七号','2017-09-20','100','2017-09-24 12:18:08'),(7,'测试八号','20170924121835795fee43c4694a26a8fe4248dcb7d980.mp4','测试八号','2017092412183501cb379afec841d9984b5cde5f011db6.jpg',1,1,0,1,'测试八号','2017-09-10','100','2017-09-24 12:18:36');
/*!40000 ALTER TABLE `movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `moviecol`
--

DROP TABLE IF EXISTS `moviecol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `moviecol` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `movie_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `movie_id` (`movie_id`),
  KEY `user_id` (`user_id`),
  KEY `ix_moviecol_addtime` (`addtime`),
  CONSTRAINT `moviecol_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`),
  CONSTRAINT `moviecol_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moviecol`
--

LOCK TABLES `moviecol` WRITE;
/*!40000 ALTER TABLE `moviecol` DISABLE KEYS */;
INSERT INTO `moviecol` VALUES (1,6,14,'2017-10-23 17:34:39');
/*!40000 ALTER TABLE `moviecol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oplog`
--

DROP TABLE IF EXISTS `oplog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oplog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `ip` varchar(100) DEFAULT NULL,
  `reason` varchar(600) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_id` (`admin_id`),
  KEY `ix_oplog_addtime` (`addtime`),
  CONSTRAINT `oplog_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oplog`
--

LOCK TABLES `oplog` WRITE;
/*!40000 ALTER TABLE `oplog` DISABLE KEYS */;
INSERT INTO `oplog` VALUES (1,1,'127.0.0.1','添加标签56','2017-10-09 23:55:11');
/*!40000 ALTER TABLE `oplog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preview`
--

DROP TABLE IF EXISTS `preview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `preview` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`),
  UNIQUE KEY `logo` (`logo`),
  KEY `ix_preview_addtime` (`addtime`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preview`
--

LOCK TABLES `preview` WRITE;
/*!40000 ALTER TABLE `preview` DISABLE KEYS */;
INSERT INTO `preview` VALUES (1,'测试八号','2017092412185876f6a3f26e124dde937ca2887dcebe02.jpg','2017-09-24 12:18:59'),(2,'测试七号','201709241219107ebedeb851af4ea9ae6ae5739b2aef4f.jpg','2017-09-24 12:19:11'),(3,'测试六号','20170924121921c1562c108835463c803e8b224ab486b6.jpg','2017-09-24 12:19:22'),(4,'测试五号','20170924121930c2fe2258de0d4b54adf8f34ce4c4f8e3.jpg','2017-09-24 12:19:31'),(5,'测试四号','2017092412194346b91f460bd846afbced2558e1cbf7aa.jpg','2017-09-24 12:19:44'),(6,'测试三号','20170924121953fcef4c90e7d04896b936c79bf92dfb61.jpg','2017-09-24 12:19:54'),(7,'测试二号','20170924122004e3932c4f15494ba6aaac80f9edf26ab1.jpg','2017-09-24 12:20:04'),(8,'测试一号','20170924122014887c8af5047e49e7b8da2707fc942c5c.jpg','2017-09-24 12:20:14');
/*!40000 ALTER TABLE `preview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `auths` varchar(600) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ix_role_addtime` (`addtime`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (5,'超级管理员->具备所有功能','1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33','2017-10-14 22:03:34'),(6,'标签管理员','1,2,3,4','2017-10-14 22:06:39'),(7,'电影管理员','5,6,7,8,9,10,11,12','2017-10-14 22:07:05'),(8,'会员管理员','13,14,15','2017-10-14 22:07:27'),(9,'评论管理员','17,18','2017-10-14 22:07:44'),(10,'日志管理员','21,22,23','2017-10-14 22:08:20'),(11,'角色管理员','24,25,26,27','2017-10-14 22:08:55'),(12,'权限管理员','28,29,30,31','2017-10-14 22:09:22'),(13,'管理员','32,33','2017-10-14 22:09:37');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ix_tag_addtime` (`addtime`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES (1,'现代','2017-09-24 11:51:13'),(2,'恐怖','2017-09-24 11:51:17'),(3,'言情','2017-09-24 11:51:22'),(4,'玄幻','2017-09-24 11:51:29'),(5,'惊恐','2017-09-24 11:51:34'),(6,'警匪','2017-09-24 11:51:40'),(7,'香港','2017-09-24 11:51:48'),(8,'美剧','2017-09-24 11:51:52'),(10,'项目入驻 - 基本信息',NULL),(11,'现代5',NULL),(13,'gtryu',NULL),(15,'ds','2017-09-26 10:32:30'),(16,'afsdfds','2017-09-26 10:33:30'),(19,'665',NULL),(20,'9',NULL),(21,'99',NULL),(22,'qwe',NULL),(23,'qwe33',NULL),(24,'qwe336',NULL),(25,'qwe336999',NULL),(27,'poi',NULL),(28,'dasdas','2017-10-09 23:54:50'),(29,'56','2017-10-09 23:55:11');
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `pwd` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(11) DEFAULT NULL,
  `info` text,
  `face` varchar(255) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `face` (`face`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `ix_user_addtime` (`addtime`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'鼠','1231','1231@123.com','13888888881','鼠','1f401.png','2017-09-24 11:46:26','d32a72bdac524478b7e4f6dfc8394fc0'),(2,'牛','1232','1232@123.com','13888888882','牛','1f402.png','2017-09-24 11:46:26','d32a72bdac524478b7e4f6dfc8394fc1'),(3,'虎','1233','1233@123.com','13888888883','虎','1f405.png','2017-09-24 11:46:26','d32a72bdac524478b7e4f6dfc8394fc2'),(4,'兔','1234','1234@123.com','13888888884','兔','1f407.png','2017-09-24 11:46:26','d32a72bdac524478b7e4f6dfc8394fc3'),(5,'龙','1235','1235@123.com','13888888885','龙','1f409.png','2017-09-24 11:46:26','d32a72bdac524478b7e4f6dfc8394fc4'),(6,'蛇','1236','1236@123.com','13888888886','蛇','1f40d.png','2017-09-24 11:46:26','d32a72bdac524478b7e4f6dfc8394fc5'),(7,'马','1237','1237@123.com','13888888887','马','1f434.png','2017-09-24 11:46:26','d32a72bdac524478b7e4f6dfc8394fc6'),(8,'羊','1238','1238@123.com','13888888888','羊','1f411.png','2017-09-24 11:46:26','d32a72bdac524478b7e4f6dfc8394fc7'),(9,'猴','1239','1239@123.com','13888888889','猴','1f412.png','2017-09-24 11:46:26','d32a72bdac524478b7e4f6dfc8394fc8'),(10,'鸡','1240','1240@123.com','13888888891','鸡','1f413.png','2017-09-24 11:46:26','d32a72bdac524478b7e4f6dfc8394fc9'),(11,'狗','1241','1241@123.com','13888888892','狗','1f415.png','2017-09-24 11:46:26','d32a72bdac524478b7e4f6dfc8394fd0'),(12,'猪','1242','1242@123.com','13888888893','猪','1f416.png','2017-09-24 11:46:26','d32a72bdac524478b7e4f6dfc8394fd1'),(13,'admin','pbkdf2:sha256:50000$pPKJkgkU$f0732f644233981458e5aba72d115218d51397fda94fd67f4d3fe7abb951cf1c','aa931912343@qq.com','13865516434','修改信息','20171015193301d2232cb9ab7c4f39a8710b10aee83c04.jpg','2017-10-15 16:21:22','25fe3f2c9e484de0a08777278ca032c4'),(14,'zfc','pbkdf2:sha256:50000$l69WmTBW$df6d9748080e1a92abc0103acc2459616e2ea6e04aceb1882c9df5fe6ea4a23d','aa31912343@qq.com','13865516433',NULL,NULL,'2017-10-15 21:03:38','b3031e2b14cc42c886d70dd747497282'),(15,'admin1','pbkdf2:sha256:50000$vdt67Pvr$79ee02a3b0cc3495d0d8de8a36ec23da361a61a2de1572eddca5fa2aa1344e39','a31912343@qq.com','13865516439',NULL,NULL,'2017-10-18 23:26:32','781aad9e4f99402793d3718ef8a7af3f');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userlog`
--

DROP TABLE IF EXISTS `userlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `ip` varchar(100) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `ix_userlog_addtime` (`addtime`),
  CONSTRAINT `userlog_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userlog`
--

LOCK TABLES `userlog` WRITE;
/*!40000 ALTER TABLE `userlog` DISABLE KEYS */;
INSERT INTO `userlog` VALUES (1,1,'192.168.4.1','2017-09-24 11:47:39'),(2,2,'192.168.4.2','2017-09-24 11:47:39'),(3,3,'192.168.4.3','2017-09-24 11:47:39'),(4,4,'192.168.4.4','2017-09-24 11:47:39'),(5,5,'192.168.4.5','2017-09-24 11:47:39'),(6,6,'192.168.4.6','2017-09-24 11:47:39'),(7,7,'192.168.4.7','2017-09-24 11:47:39'),(8,8,'192.168.4.8','2017-09-24 11:47:39'),(9,9,'192.168.4.9','2017-09-24 11:47:39'),(10,13,'127.0.0.1','2017-10-15 16:54:51'),(11,13,'127.0.0.1','2017-10-15 17:02:37'),(12,13,'127.0.0.1','2017-10-15 17:04:23'),(13,13,'127.0.0.1','2017-10-15 17:04:54'),(14,13,'127.0.0.1','2017-10-15 17:05:46'),(15,13,'127.0.0.1','2017-10-15 17:06:23'),(16,13,'127.0.0.1','2017-10-15 19:00:41'),(17,13,'127.0.0.1','2017-10-15 19:35:19'),(18,13,'127.0.0.1','2017-10-15 20:33:18'),(19,13,'127.0.0.1','2017-10-15 21:01:02'),(20,14,'127.0.0.1','2017-10-15 21:03:45'),(21,14,'127.0.0.1','2017-10-15 21:32:58'),(22,14,'127.0.0.1','2017-10-15 21:33:27'),(23,13,'127.0.0.1','2017-10-15 21:46:39'),(24,15,'127.0.0.1','2017-10-18 23:26:38'),(25,14,'127.0.0.1','2017-10-19 16:20:22'),(26,14,'127.0.0.1','2017-10-23 17:29:52');
/*!40000 ALTER TABLE `userlog` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-10-25 21:38:35
