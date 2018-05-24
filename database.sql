-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 16, 2017 at 09:09 PM
-- Server version: 10.1.22-MariaDB
-- PHP Version: 7.1.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fivem`
--
CREATE DATABASE IF NOT EXISTS `fivem` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `fivem`;

-- --------------------------------------------------------

--
-- Table structure for table `characters`
--

CREATE TABLE `characters` (
  `id` int(11) NOT NULL,
  `steamid` varchar(50) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `money` int(11) NOT NULL,
  `job` varchar(50) NOT NULL,
  `job_rank` int(2) NOT NULL,
  `pos_x` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `pos_y` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `pos_z` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `heading` int(3) NOT NULL,
  `jail_time` int(5) NOT NULL,
  `weapons` text NOT NULL,
  `inventory` text NOT NULL,
  `modelName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `charges`
--

CREATE TABLE `charges` (
  `id` int(11) NOT NULL,
  `timestamp` datetime NOT NULL,
  `charID` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `officer_charID` varchar(50) NOT NULL,
  `officer_username` varchar(50) NOT NULL,
  `charge` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `steamid` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `admin_rank` int(2) NOT NULL DEFAULT '0',
  `banned` timestamp NULL DEFAULT NULL,
  `banned_reason` varchar(255) NOT NULL,
  `bank` int(11) NOT NULL DEFAULT '0',
  `register_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_online` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_connected` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `characters`
--
ALTER TABLE `characters`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `characters`
--
ALTER TABLE `characters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
