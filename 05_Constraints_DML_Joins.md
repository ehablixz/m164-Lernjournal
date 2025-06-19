# 5. SQL: Constraints, DML und Joins

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

## **Daten einfügen und referenzielle Integrität**

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

**Beispiel (Fahrer ohne zugewiesenen Bus finden):**
```sql
SELECT f.Vorname, f.Nachname
FROM tbl_Fahrer f
LEFT JOIN tbl_Bus b ON f.tbl_Bus_ID_Bus = b.ID_Bus
WHERE b.ID_Bus IS NULL;
```

---

## **Löschen von Daten und FK-Optionen**

In der Praxis werden Daten selten hart per `DELETE` gelöscht, um historische Informationen zu erhalten. Stattdessen werden Datensätze oft als "inaktiv" markiert (Soft Delete).

Falls doch gelöscht wird, steuern `ON DELETE`-Optionen das Verhalten bei Fremdschlüssel-Beziehungen:

| Option | Bedeutung |
| :--- | :--- |
| **`RESTRICT` / `NO ACTION`** | (Standard) Löschen wird verhindert, wenn abhängige Datensätze existieren. |
| **`CASCADE`** | Löscht den Datensatz und **automatisch alle abhängigen Datensätze**. (Vorsicht: kann zu massivem Datenverlust führen!) |
| **`SET NULL`** | Löscht den Datensatz und setzt die Fremdschlüssel in den abhängigen Datensätzen auf `NULL` (Spalte muss `NULL` erlauben). |
| **`SET DEFAULT`** | Setzt die Fremdschlüssel auf einen vordefinierten Standardwert. |

Die `ON UPDATE`-Regeln sind meist irrelevant, da Primärschlüssel in der Regel nie geändert werden.