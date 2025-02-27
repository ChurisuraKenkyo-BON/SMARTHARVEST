-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 26, 2025 at 10:20 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smartharvest`
--

-- --------------------------------------------------------

--
-- Table structure for table `alerts`
--

CREATE TABLE `alerts` (
  `id` int(11) NOT NULL,
  `parameter` varchar(255) DEFAULT NULL,
  `sensor_value` float DEFAULT NULL,
  `threshold_min` float DEFAULT NULL,
  `threshold_max` float DEFAULT NULL,
  `datetime` timestamp NOT NULL DEFAULT current_timestamp(),
  `solved` tinyint(1) DEFAULT 0,
  `breached_threshold` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `alerts`
--

INSERT INTO `alerts` (`id`, `parameter`, `sensor_value`, `threshold_min`, `threshold_max`, `datetime`, `solved`, `breached_threshold`) VALUES
(1, 'Humidity', 1, 15, 70, '2025-01-25 14:36:58', 1, 'min'),
(2, 'pH', 1, 5, 8, '2025-01-25 14:36:58', 1, 'min'),
(3, 'Temperature', 1, 25, 50, '2025-01-25 14:36:58', 1, 'min'),
(4, 'Humidity', 2, 15, 70, '2025-01-25 14:37:34', 1, 'min'),
(5, 'pH', 2, 5, 8, '2025-01-25 14:37:34', 1, 'min'),
(6, 'Temperature', 2, 25, 50, '2025-01-25 14:37:34', 1, 'min'),
(7, 'Temperature', 20, 25, 50, '2025-01-26 05:50:35', 1, 'min'),
(8, 'pH', 3, 5, 8, '2025-01-26 06:42:18', 1, 'min'),
(9, 'Temperature', 20, 25, 50, '2025-01-26 06:42:18', 1, 'min'),
(10, 'pH', 1, 5, 8, '2025-01-26 06:43:14', 1, 'min'),
(11, 'Temperature', 20, 25, 50, '2025-01-26 06:43:14', 1, 'min');

-- --------------------------------------------------------

--
-- Table structure for table `harvest_predictions`
--

CREATE TABLE `harvest_predictions` (
  `id` int(11) NOT NULL,
  `prediction` tinyint(1) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `harvest_predictions`
--

INSERT INTO `harvest_predictions` (`id`, `prediction`, `timestamp`) VALUES
(1, 1, '2025-01-26 06:25:55');

-- --------------------------------------------------------

--
-- Table structure for table `sensordata`
--

CREATE TABLE `sensordata` (
  `ID` int(11) NOT NULL,
  `PHDATA` int(11) NOT NULL,
  `HUMIDDATA` int(11) NOT NULL,
  `TEMPDATA` int(11) NOT NULL,
  `TDSDATA` int(11) NOT NULL,
  `DATADATE` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sensordata`
--

INSERT INTO `sensordata` (`ID`, `PHDATA`, `HUMIDDATA`, `TEMPDATA`, `TDSDATA`, `DATADATE`) VALUES
(1, 1, 1, 1, 1, '2025-01-25 14:36:58'),
(2, 2, 2, 2, 2, '2025-01-25 14:37:34'),
(3, 6, 20, 20, 20, '2025-01-26 05:50:35'),
(4, 3, 20, 20, 20, '2025-01-26 06:42:18'),
(5, 1, 20, 20, 20, '2025-01-26 06:43:14');

--
-- Triggers `sensordata`
--
DELIMITER $$
CREATE TRIGGER `log_humidity_alert` AFTER INSERT ON `sensordata` FOR EACH ROW BEGIN
    DECLARE humidity_min INT;
    DECLARE humidity_max INT;
    
    -- Fetch threshold values for Humidity
    SELECT min_value, max_value INTO humidity_min, humidity_max
    FROM settings
    WHERE parameter = 'Humidity';

    -- Check if the new sensor data breaches the threshold
    IF NEW.HUMIDDATA < humidity_min THEN
        INSERT INTO alerts (parameter, sensor_value, threshold_min, threshold_max, breached_threshold)
        VALUES ('Humidity', NEW.HUMIDDATA, humidity_min, humidity_max, 'min');
    ELSEIF NEW.HUMIDDATA > humidity_max THEN
        INSERT INTO alerts (parameter, sensor_value, threshold_min, threshold_max, breached_threshold)
        VALUES ('Humidity', NEW.HUMIDDATA, humidity_min, humidity_max, 'max');
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_ph_alert` AFTER INSERT ON `sensordata` FOR EACH ROW BEGIN
    DECLARE ph_min INT;
    DECLARE ph_max INT;
    
    -- Fetch threshold values for pH
    SELECT min_value, max_value INTO ph_min, ph_max
    FROM settings
    WHERE parameter = 'pH';

    -- Check if the new sensor data breaches the threshold
    IF NEW.PHDATA < ph_min THEN
        INSERT INTO alerts (parameter, sensor_value, threshold_min, threshold_max, breached_threshold)
        VALUES ('pH', NEW.PHDATA, ph_min, ph_max, 'min');
    ELSEIF NEW.PHDATA > ph_max THEN
        INSERT INTO alerts (parameter, sensor_value, threshold_min, threshold_max, breached_threshold)
        VALUES ('pH', NEW.PHDATA, ph_min, ph_max, 'max');
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_tds_alert` AFTER INSERT ON `sensordata` FOR EACH ROW BEGIN
    DECLARE tds_min INT;
    DECLARE tds_max INT;
    
    -- Fetch threshold values for TDS
    SELECT min_value, max_value INTO tds_min, tds_max
    FROM settings
    WHERE parameter = 'TDS';

    -- Check if the new sensor data breaches the threshold
    IF NEW.TDSDATA < tds_min THEN
        INSERT INTO alerts (parameter, sensor_value, threshold_min, threshold_max, breached_threshold)
        VALUES ('TDS', NEW.TDSDATA, tds_min, tds_max, 'min');
    ELSEIF NEW.TDSDATA > tds_max THEN
        INSERT INTO alerts (parameter, sensor_value, threshold_min, threshold_max, breached_threshold)
        VALUES ('TDS', NEW.TDSDATA, tds_min, tds_max, 'max');
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_temperature_alert` AFTER INSERT ON `sensordata` FOR EACH ROW BEGIN
    DECLARE temperature_min INT;
    DECLARE temperature_max INT;
    
    -- Fetch threshold values for Temperature
    SELECT min_value, max_value INTO temperature_min, temperature_max
    FROM settings
    WHERE parameter = 'Temperature';

    -- Check if the new sensor data breaches the threshold
    IF NEW.TEMPDATA < temperature_min THEN
        INSERT INTO alerts (parameter, sensor_value, threshold_min, threshold_max, breached_threshold)
        VALUES ('Temperature', NEW.TEMPDATA, temperature_min, temperature_max, 'min');
    ELSEIF NEW.TEMPDATA > temperature_max THEN
        INSERT INTO alerts (parameter, sensor_value, threshold_min, threshold_max, breached_threshold)
        VALUES ('Temperature', NEW.TEMPDATA, temperature_min, temperature_max, 'max');
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `ID` int(11) NOT NULL,
  `parameter` varchar(50) NOT NULL,
  `min_value` int(11) NOT NULL,
  `max_value` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`ID`, `parameter`, `min_value`, `max_value`) VALUES
(1, 'Humidity', 10, 70),
(2, 'Temperature', 25, 50),
(3, 'pH', 5, 8),
(4, 'TDS', 0, 500);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`) VALUES
(1, 'BON', '$2y$10$0vlzhioNSTET7ZJ3OuxY1efkWZ7Q.t4yVYXaz3EkAMzyBRuqLM/UG');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alerts`
--
ALTER TABLE `alerts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sensordata`
--
ALTER TABLE `sensordata`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `alerts`
--
ALTER TABLE `alerts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `sensordata`
--
ALTER TABLE `sensordata`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
