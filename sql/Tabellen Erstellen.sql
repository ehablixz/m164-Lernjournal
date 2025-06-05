-- Schema erstellen
CREATE SCHEMA IF NOT EXISTS firma DEFAULT CHARACTER SET utf8mb4;
USE firma;

-- Tabelle: tbl_fahrer
CREATE TABLE tbl_fahrer (
    Fahrer_ID INT AUTO_INCREMENT PRIMARY KEY,
    FuehrerscheinNr VARCHAR(20),
    Name VARCHAR(50),
    Vorname VARCHAR(30),
    Telefonnummer VARCHAR(12)
) DEFAULT CHARSET = utf8mb4;

-- Tabelle: tbl_disponent
CREATE TABLE tbl_disponent (
    Disponent_ID INT AUTO_INCREMENT PRIMARY KEY,
    Abteilung VARCHAR(50),
    Name VARCHAR(50),
    Vorname VARCHAR(30),
    Telefonnummer VARCHAR(12)
) DEFAULT CHARSET = utf8mb4;
