-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: CONTROLCOSTOS
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `costohistorial`
--

DROP TABLE IF EXISTS `costohistorial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `costohistorial` (
  `CostoH_Id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `CostoH_CostoID` int unsigned DEFAULT NULL,
  `CostoH_Fecha` datetime DEFAULT NULL,
  `CostoH_Campo` tinyint DEFAULT NULL,
  `CostoH_ValorAntes` decimal(10,2) DEFAULT NULL,
  `CostoH_ValoPosterior` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`CostoH_Id`),
  KEY `COSTOID_FECHA` (`CostoH_CostoID`),
  KEY `COSTOID_Campo` (`CostoH_CostoID`,`CostoH_Campo`),
  CONSTRAINT `FK_CH_Costos` FOREIGN KEY (`CostoH_Id`) REFERENCES `costos` (`Costos_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `costohistorial`
--

LOCK TABLES `costohistorial` WRITE;
/*!40000 ALTER TABLE `costohistorial` DISABLE KEYS */;
/*!40000 ALTER TABLE `costohistorial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `costos`
--

DROP TABLE IF EXISTS `costos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `costos` (
  `Costos_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `Costos_LCPID` smallint unsigned DEFAULT NULL,
  `Costos_ProdID` int unsigned DEFAULT NULL,
  `Costos_PrecioLista` decimal(10,4) unsigned DEFAULT NULL,
  `Costos_Cotizacion` decimal(10,4) DEFAULT '1.0000',
  `Costos_MonedaCorriente` decimal(10,4) DEFAULT NULL,
  `Costos_Dto1` decimal(4,2) DEFAULT NULL,
  `Costos_Dto2` decimal(4,2) DEFAULT NULL,
  `Costos_Dto3` decimal(4,2) DEFAULT NULL,
  `Costos_Dto4` decimal(4,2) DEFAULT NULL,
  `Costos_Dto5` decimal(4,2) DEFAULT NULL,
  `Costos_IVA` decimal(10,4) DEFAULT NULL,
  `Costos_SINIVA` decimal(10,4) DEFAULT NULL,
  `Costos_Fecha` datetime DEFAULT NULL,
  `CostosH_Id` bigint DEFAULT NULL,
  `Costos_Historico` varchar(45) DEFAULT NULL,
  `CostosH_Costosid` varchar(45) DEFAULT NULL,
  `CostosH_Fecha` datetime DEFAULT NULL,
  `Costos_Campo` tinyint DEFAULT NULL,
  `CostosH_ValorAnterior` decimal(10,4) DEFAULT NULL,
  `CostosH_ValorPosterior` decimal(10,4) DEFAULT NULL,
  PRIMARY KEY (`Costos_id`),
  KEY `FK_C_LCP_idx` (`Costos_LCPID`),
  KEY `FK_C_Prodcutos_idx` (`Costos_ProdID`),
  CONSTRAINT `FK_C_LCP` FOREIGN KEY (`Costos_LCPID`) REFERENCES `lista_costoprecios` (`LCP_Id`),
  CONSTRAINT `FK_C_Prodcutos` FOREIGN KEY (`Costos_ProdID`) REFERENCES `prodcutos` (`Prod_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `costos`
--

LOCK TABLES `costos` WRITE;
/*!40000 ALTER TABLE `costos` DISABLE KEYS */;
/*!40000 ALTER TABLE `costos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lista_costoprecios`
--

DROP TABLE IF EXISTS `lista_costoprecios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lista_costoprecios` (
  `LCP_Id` smallint unsigned NOT NULL,
  `LCP_Nombre` varchar(45) DEFAULT NULL,
  `LCP_CP` enum('C','P') DEFAULT NULL,
  `LCP_Status` char(1) DEFAULT NULL,
  `LCP_FechaDesde` date DEFAULT NULL,
  `LCP_FechaHasta` date DEFAULT NULL,
  PRIMARY KEY (`LCP_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_costoprecios`
--

LOCK TABLES `lista_costoprecios` WRITE;
/*!40000 ALTER TABLE `lista_costoprecios` DISABLE KEYS */;
/*!40000 ALTER TABLE `lista_costoprecios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `precios`
--

DROP TABLE IF EXISTS `precios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `precios` (
  `Precios_Id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `Precios_LCPID` smallint unsigned DEFAULT NULL,
  `Precios_ProdId` int unsigned DEFAULT NULL,
  `Precioscol` varchar(45) DEFAULT NULL,
  `Precios_Margen` decimal(5,2) DEFAULT NULL,
  `Precios_Precios` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`Precios_Id`),
  KEY `FK_P_LCP_idx` (`Precios_LCPID`),
  KEY `FK_P_Prodcutos_idx` (`Precios_ProdId`),
  CONSTRAINT `FK_P_LCP` FOREIGN KEY (`Precios_LCPID`) REFERENCES `lista_costoprecios` (`LCP_Id`),
  CONSTRAINT `FK_P_Prodcutos` FOREIGN KEY (`Precios_ProdId`) REFERENCES `prodcutos` (`Prod_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `precios`
--

LOCK TABLES `precios` WRITE;
/*!40000 ALTER TABLE `precios` DISABLE KEYS */;
/*!40000 ALTER TABLE `precios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `precioshistorial`
--

DROP TABLE IF EXISTS `precioshistorial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `precioshistorial` (
  `PH_ID` bigint unsigned NOT NULL,
  `PH_PreciosH` bigint unsigned DEFAULT NULL,
  `PH_Fecha` datetime DEFAULT NULL,
  `PH_MargenrAnt` decimal(5,2) unsigned DEFAULT NULL,
  `PH_MargenPos` decimal(5,2) unsigned DEFAULT NULL,
  `PH_PreciosAnt` decimal(10,4) unsigned DEFAULT NULL,
  `PH_PrecioPos` decimal(10,4) unsigned DEFAULT NULL,
  PRIMARY KEY (`PH_ID`),
  KEY `PRECIOID_Fecha` (`PH_Fecha`),
  KEY `FK_ph_p_idx` (`PH_PreciosH`),
  CONSTRAINT `FK_ph_p` FOREIGN KEY (`PH_PreciosH`) REFERENCES `precios` (`Precios_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `precioshistorial`
--

LOCK TABLES `precioshistorial` WRITE;
/*!40000 ALTER TABLE `precioshistorial` DISABLE KEYS */;
/*!40000 ALTER TABLE `precioshistorial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prodcutos`
--

DROP TABLE IF EXISTS `prodcutos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prodcutos` (
  `Prod_id` int unsigned NOT NULL AUTO_INCREMENT,
  `Prod_Descripcion` varchar(60) DEFAULT NULL,
  `Prod_ColorID` smallint unsigned DEFAULT NULL,
  `Prod_UnimedID` smallint unsigned DEFAULT NULL,
  `Prod_Medida` decimal(10,2) DEFAULT NULL,
  `Prod_ProvID` int unsigned DEFAULT NULL,
  `Prod_CompraSuspendido` bit(1) DEFAULT NULL,
  `Prod_VentaSuspendio` bit(1) DEFAULT NULL,
  `Prod_Status` char(1) DEFAULT NULL,
  PRIMARY KEY (`Prod_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prodcutos`
--

LOCK TABLES `prodcutos` WRITE;
/*!40000 ALTER TABLE `prodcutos` DISABLE KEYS */;
/*!40000 ALTER TABLE `prodcutos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-08-09  7:38:45
