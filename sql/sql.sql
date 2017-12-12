/*
SQLyog Ultimate v11.33 (64 bit)
MySQL - 5.7.17-log : Database - dbgamekt
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`dbgamekt` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `dbgamekt`;

/*Table structure for table `tbl_account` */

DROP TABLE IF EXISTS `tbl_account`;

CREATE TABLE `tbl_account` (
  `rl_sAccount` char(30) NOT NULL,
  `rl_sRoleID` int(11) NOT NULL,
  PRIMARY KEY (`rl_sAccount`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_hero` */

DROP TABLE IF EXISTS `tbl_hero`;

CREATE TABLE `tbl_hero` (
  `rl_uID` int(11) unsigned NOT NULL,
  `rl_sData` mediumblob NOT NULL,
  PRIMARY KEY (`rl_uID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_player` */

DROP TABLE IF EXISTS `tbl_player`;

CREATE TABLE `tbl_player` (
  `rl_uID` int(11) unsigned NOT NULL,
  `rl_sName` char(21) NOT NULL,
  `rl_uSex` tinyint(1) unsigned DEFAULT NULL,
  `rl_uShape` smallint(4) unsigned DEFAULT NULL,
  `rl_uGrade` tinyint(3) unsigned DEFAULT NULL,
  `rl_uFighter` int(11) unsigned DEFAULT NULL,
  `rl_uGongHuiID` int(11) unsigned DEFAULT NULL,
  `rl_upayall` int(11) unsigned DEFAULT NULL,
  `rl_sGongHuiName` char(21) DEFAULT NULL,
  PRIMARY KEY (`rl_uID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_role` */

DROP TABLE IF EXISTS `tbl_role`;

CREATE TABLE `tbl_role` (
  `rl_uID` int(11) unsigned NOT NULL,
  `rl_sData` mediumblob NOT NULL,
  `rl_sToday` mediumblob,
  `rl_sWeek` mediumblob,
  `rl_sItem` mediumblob,
  `rl_sTask` mediumblob,
  `rl_sEquip` mediumblob,
  `rl_sOther` mediumblob,
  PRIMARY KEY (`rl_uID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
