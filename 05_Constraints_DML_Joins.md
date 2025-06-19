# 5. SQL: DML, Joins und Aggregation

## **Foreign Key Constraints und Indizes**

*   **`NOT NULL` bei Fremdschlüsseln:** Wird als Spalteneigenschaft (`INT NOT NULL`) definiert und erzwingt, dass immer eine Referenz vorhanden sein muss.
*   **Automatische Indizes:** MySQL erstellt für jeden Fremdschlüssel automatisch einen Index. Dies ist für die Performance bei Joins und zur schnellen Überprüfung der referenziellen Integrität notwendig und wird vom System verlangt.
*   **`UNIQUE` bei Fremdschlüsseln:** Um eine 1:1-Beziehung abzubilden, kann auf die Fremdschlüsselspalte ein `UNIQUE`-Constraint gelegt werden.

**Allgemeine Syntax für einen Fremdschlüssel-Constraint:**
```sql
CONSTRAINT `fk_constraint_name`
  FOREIGN KEY (`fremdschluessel_spalte`)
  REFERENCES `zieltabelle` (`primaerschluessel_spalte`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
```

---

## **Daten einfügen und referenzielle Integrität (DML)**

Die Reihenfolge beim Einfügen von Daten muss der Logik der Beziehungen folgen: **zuerst die Master-Tabelle, dann die Detail-Tabelle**.

*   **Gültiger Fremdschlüssel:** `INSERT` ist erfolgreich.
*   **Ungültiger Fremdschlüssel** (Wert existiert nicht in der Master-Tabelle): `INSERT` schlägt mit einem Fehler zur Verletzung der referenziellen Integrität fehl (z.B. `ERROR 1452`).
*   **`NULL` als Fremdschlüssel:**
    *   Wenn die Spalte `NOT NULL` ist, schlägt `INSERT` fehl (`ERROR 1048`).
    *   Wenn die Spalte `NULL` erlaubt, ist `INSERT` erfolgreich (optionale Beziehung).

### **Sonderfall: Rekursive Beziehungen**

Bei einer rekursiven Beziehung (eine Tabelle verweist auf sich selbst, z.B. `tbl_Projekt` hat ein `parent_projekt_id`), muss die Fremdschlüsselspalte **`NULL` erlauben**, damit das erste Wurzelelement ohne Referenz eingefügt werden kann.

---

## **Mengenlehre und SQL-Joins**

SQL-Joins lassen sich als Operationen der Mengenlehre verstehen, wobei Tabellen Mengen und Zeilen Elemente sind.

| SQL Join | Mengenlehre (Konzept) | Bedeutung |
| :--- | :--- | :--- |
| `INNER JOIN` | **Schnittmenge** (`A ∩ B`) | Nur Datensätze, die in **beiden** Tabellen einen passenden Partner haben. |
| `LEFT JOIN` | Alle aus **A**, ergänzt um passende aus **B** | Zeigt **alle** Datensätze aus der linken Tabelle (A), auch wenn es rechts (B) keine Übereinstimmung gibt (`NULL` in B-Spalten). |
| `RIGHT JOIN` | Alle aus **B**, ergänzt um passende aus **A** | Zeigt **alle** Datensätze aus der rechten Tabelle (B), auch wenn es links (A) keine Übereinstimmung gibt. |
| `FULL OUTER JOIN` ✳ | **Vereinigung** (`A ∪ B`) | Zeigt **alle** Datensätze aus beiden Tabellen. |
| `LEFT JOIN ... WHERE B.id IS NULL` | **Differenz** (`A \ B`) | Nur die Datensätze aus A, die **keinen** Partner in B haben. |

> ✳ MySQL unterstützt `FULL OUTER JOIN` nicht direkt. Es muss mit `UNION` aus einem `LEFT JOIN` und `RIGHT JOIN` simuliert werden.

---

## **Abfragen optimieren: Alias (AS)**

Ein **Alias** in SQL wird verwendet, um Spalten oder Tabellen temporär umzubenennen. Dies verbessert die Lesbarkeit, verkürzt die Schreibweise und vereinfacht die Verwendung, insbesondere bei Joins.

**Spaltenalias:**
```sql
SELECT vorname AS 'Vorname des Kunden', nachname AS 'Nachname des Kunden'
FROM kunden;
```

**Tabellenalias:**
```sql
SELECT k.vorname, k.nachname
FROM kunden AS k;
```

---

## **Daten zusammenfassen: Aggregatsfunktionen**

Aggregatsfunktionen fassen Daten aus mehreren Zeilen zu einem einzigen Wert zusammen.

| Funktion | Beschreibung | Beispiel |
| :--- | :--- | :--- |
| **`COUNT()`** | Zählt Datensätze | `SELECT COUNT(*) FROM kunden;` |
| **`SUM()`** | Berechnet die Summe | `SELECT SUM(gehalt) FROM mitarbeiter;` |
| **`AVG()`** | Berechnet den Durchschnitt | `SELECT AVG(gehalt) FROM mitarbeiter;` |
| **`MIN()`** | Findet den kleinsten Wert | `SELECT MIN(gehalt) FROM mitarbeiter;` |
| **`MAX()`** | Findet den größten Wert | `SELECT MAX(gehalt) FROM mitarbeiter;` |

---

## **Daten gruppieren: GROUP BY und HAVING**

### **GROUP BY**

*   **Zweck:** Gruppiert Datensätze anhand einer oder mehrerer Spalten.
*   **Anwendung:** Wird zusammen mit Aggregatsfunktionen verwendet, um für jede Gruppe einen aggregierten Wert zu berechnen.
*   **Syntax:**
    ```sql
    SELECT spalte, AGGREGATSFUNKTION(spalte)
    FROM tabelle
    GROUP BY spalte;
    ```

### **HAVING**

*   **Zweck:** Filtert die Ergebnisse **nachdem** die Gruppierung mit `GROUP BY` und die Aggregation stattgefunden haben.
*   **Unterschied zu `WHERE`:** `WHERE` filtert einzelne Zeilen **vor** der Gruppierung, `HAVING` filtert ganze Gruppen **nach** der Aggregation.
*   **Syntax:**
    ```sql
    SELECT spalte, AGGREGATSFUNKTION(spalte)
    FROM tabelle
    GROUP BY spalte
    HAVING bedingung_fuer_aggregat;
    ```

---

## **Praktische Anwendung und Übungen**

### **Szenario 1: Umgang mit fehlerhaften Daten**

**Frage: Wie korrigiert man einen falschen Datensatz, der noch referenziert wird?**

**Situation:** In `tbl_ort` wurde versehentlich "4000 Basel" statt "3000 Bern" eingetragen. Ein `DELETE` schlägt fehl, da andere Tabellen auf diesen Ort verweisen.

**Beste Vorgehensweise (Korrigieren):**
Der bestehende Datensatz wird direkt aktualisiert. Alle verknüpften Tabellen verweisen automatisch auf die korrigierten Daten.
```sql
UPDATE tbl_ort
SET plz = '3000', ort = 'Bern'
WHERE plz = '4000' AND ort = 'Basel';
```

### **Szenario 2: Testen von `ON DELETE`-Optionen**

Diese Übung demonstriert das Verhalten verschiedener `ON DELETE`-Regeln.

| Option | Verhalten |
| :--- | :--- |
| **`RESTRICT` / `NO ACTION`** | **Verhindert** das Löschen, wenn abhängige Datensätze existieren. (Standard & sicherste Option) |
| **`CASCADE`** | **Löscht automatisch** alle abhängigen Datensätze mit. (Mächtig, aber gefährlich) |
| **`SET NULL`** | Setzt den Fremdschlüssel in abhängigen Datensätzen auf **`NULL`**. (Benötigt eine `NULL`-erlaubende Spalte) |

### **Szenario 3: Übungen zu Aggregatsfunktionen**

**1. Welches ist das niedrigste/höchste Gehalt eines Lehrers?**
```sql
SELECT MIN(Gehalt) AS niedrigstes_Gehalt, MAX(Gehalt) AS hoechstes_Gehalt FROM lehrer;
```

**2. Was ist das niedrigste Gehalt eines Mathelehrers?**
```sql
SELECT MIN(l.Gehalt) AS niedrigstes_Mathe_Gehalt
FROM lehrer AS l
JOIN unterrichtet AS u ON l.LehrerID = u.LehrerID
JOIN fach AS f ON u.FachID = f.FachID
WHERE f.Bezeichnung = 'Mathe';
```

**3. Wie viele Einwohner hat der Ort mit den meisten/wenigsten Einwohnern?**
```sql
SELECT MAX(Einwohner) AS Hoechste_Einwohnerzahl, MIN(Einwohner) AS Niedrigste_Einwohnerzahl FROM ort;
```

**4. Wie groß ist die Differenz zwischen dem Ort mit den meisten und dem mit den wenigsten Einwohnern?**
```sql
SELECT (MAX(Einwohner) - MIN(Einwohner)) AS Differenz FROM ort;
```

**5. Wie viele Schüler sind in der Datenbank erfasst?**
```sql
SELECT COUNT(*) AS Anzahl_Schueler FROM schueler;
```

**6. Wie viele Schüler wohnen in Waldkirch?**
```sql
SELECT COUNT(*) AS Anzahl_Schueler
FROM schueler AS s
JOIN ort AS o ON s.OrtID = o.OrtID
WHERE o.Bezeichnung = 'Waldkirch';
```

**7. Wie viele Schüler, die bei Herrn Bohnert Unterricht haben, wohnen in Emmendingen?**
```sql
SELECT COUNT(DISTINCT s.SchuelerID) AS Anzahl_Schueler
FROM schueler AS s
JOIN ort AS o ON s.OrtID = o.OrtID
JOIN unterrichtet AS u ON s.SchuelerID = u.SchuelerID
JOIN lehrer AS l ON u.LehrerID = l.LehrerID
WHERE o.Bezeichnung = 'Emmendingen' AND l.Name = 'Bohnert';
```

**8. Welcher Lehrer verdient am meisten?**
```sql
SELECT Name, Vorname, Gehalt
FROM lehrer
WHERE Gehalt = (SELECT MAX(Gehalt) FROM lehrer);
```


---
[Voriges Thema: DDL und Datentypen](./04_DDL_Datentypen.md) | [Zurück zum Inhaltsverzeichnis](./README.md)

