# 4. SQL: DDL und Datentypen

## **DDL: Datenbanken und Tabellen anlegen**

In MySQL ist ein **Schema** synonym mit einer **Datenbank**. Ein Datenbanksystem kann mehrere Datenbanken enthalten, um Daten logisch zu gruppieren.

**Befehl zum Anlegen einer Datenbank:**
```sql
CREATE DATABASE beispiel_datenbank
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
```
*   `CHARACTER SET`: Legt den Zeichensatz fest (`utf8mb4` für volle Unicode-Unterstützung inkl. Emojis).
*   `COLLATE`: Definiert die Sortier- und Vergleichsregeln.

---

## **MariaDB/MySQL Datentypen**

| Kategorie | Datentyp(en) | Beispiel | Bemerkung |
| :--- | :--- | :--- | :--- |
| **Ganze Zahlen** | `TINYINT`, `SMALLINT`, `INT`, `BIGINT` | `INT` | Standard für ganze Zahlen. Bereich beachten. |
| **Festkommazahlen** | `DECIMAL(M,D)` | `DECIMAL(8,2)` | Präzise Speicherung, ideal für Finanzdaten. |
| **Gleitkommazahlen** | `FLOAT`, `DOUBLE` | `DOUBLE` | Annähernde Speicherung, nicht für exakte Berechnungen. |
| **Logische Werte** | `BOOLEAN`, `TINYINT(1)` | `BOOLEAN` | Alias für `TINYINT(1)`. `0` ist `FALSE`, alles andere `TRUE`. |
| **Zeichenketten** | `CHAR(L)`, `VARCHAR(L)` | `VARCHAR(255)` | `CHAR` hat feste Länge, `VARCHAR` variable Länge. |
| **Datum & Zeit** | `DATE`, `TIME`, `DATETIME`, `TIMESTAMP` | `DATETIME` | `TIMESTAMP` wird oft automatisch aktualisiert. |
| **Binärdaten** | `BLOB`, `TINYBLOB`, `MEDIUMBLOB`, `LONGBLOB` | `MEDIUMBLOB` | Zur Speicherung von Dateien wie Bildern oder Dokumenten. |
| **Aufzählung** | `ENUM('Wert1', ...)` | `ENUM('aktiv', 'inaktiv')` | Wert muss aus einer vordefinierten Liste stammen. |
| **JSON** | `JSON` | `JSON` | Speicherung von JSON-Dokumenten in semi-strukturierten Feldern. |

![Modell mit 1 2 3 4](media/Modell%20bis%201%202%203%204.png)