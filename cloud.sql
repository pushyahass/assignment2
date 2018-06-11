-- phpMyAdmin SQL Dump
-- version 4.8.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 11, 2018 at 08:53 AM
-- Server version: 10.1.32-MariaDB
-- PHP Version: 7.2.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cloud`
--

-- --------------------------------------------------------

--
-- Table structure for table `earthquake`
--

CREATE TABLE `earthquake` (
  `time1` datetime DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `depth` float DEFAULT NULL,
  `mag` float DEFAULT NULL,
  `magtype` varchar(100) DEFAULT NULL,
  `nst` int(11) DEFAULT NULL,
  `gap` int(11) DEFAULT NULL,
  `dmin` float DEFAULT NULL,
  `rms` float DEFAULT NULL,
  `net` varchar(100) DEFAULT NULL,
  `id` varchar(100) DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `place` varchar(100) DEFAULT NULL,
  `type1` varchar(100) DEFAULT NULL,
  `horizontalerror` float DEFAULT NULL,
  `deptherror` float DEFAULT NULL,
  `magerror` float DEFAULT NULL,
  `magnst` int(11) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `locationsource` varchar(100) DEFAULT NULL,
  `magsource` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Stand-in structure for view `quake`
-- (See below for the actual view)
--
CREATE TABLE `quake` (
`place` varchar(100)
,`time1` datetime
,`location` varchar(100)
,`kms` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `quaketime`
-- (See below for the actual view)
--
CREATE TABLE `quaketime` (
`place` varchar(100)
,`time1` datetime
,`mag` float
,`timeofquake` varchar(13)
);

-- --------------------------------------------------------

--
-- Structure for view `quake`
--
DROP TABLE IF EXISTS `quake`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `quake`  AS  (select `earthquake`.`place` AS `place`,`earthquake`.`time1` AS `time1`,trim(substr(`earthquake`.`place`,(locate(',',`earthquake`.`place`) + 1))) AS `location`,substr(`earthquake`.`place`,1,(locate('k',`earthquake`.`place`) - 1)) AS `kms` from `earthquake`) ;

-- --------------------------------------------------------

--
-- Structure for view `quaketime`
--
DROP TABLE IF EXISTS `quaketime`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `quaketime`  AS  (select `earthquake`.`place` AS `place`,`earthquake`.`time1` AS `time1`,`earthquake`.`mag` AS `mag`,date_format(`earthquake`.`time1`,'%H:%i:%s') AS `timeofquake` from `earthquake`) ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
