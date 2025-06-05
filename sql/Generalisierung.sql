-- Tabelle löschen
DROP TABLE tbl_fahrer;

-- Wiederherstellen mit ursprünglichem Code
CREATE TABLE tbl_fahrer (
    Fahrer_ID INT AUTO_INCREMENT PRIMARY KEY,
    FuehrerscheinNr VARCHAR(20),
    Name VARCHAR(50),
    Vorname VARCHAR(30),
    Telefonnummer VARCHAR(12)
) DEFAULT CHARSET = utf8mb4;
