# 1. Generalisierung & Spezialisierung

## **Ausgangslage**

In datenbankgestützten Informationssystemen kommt es oft vor, dass mehrere **Entitätstypen viele gemeinsame Attribute besitzen** (z.B. Name, Adresse, Telefonnummer). Wenn diese mehrfach modelliert werden, entsteht **Redundanz**, was zu inkonsistenten Daten und erhöhtem Wartungsaufwand führen kann.

**Beispiel:** Ein Mitarbeiter kann gleichzeitig **Kunde** sein, oder ein **Fahrer** auch als **Disponent** tätig sein.

---

## **Lösung: Generalisierung und Spezialisierung**

#### **Generalisierung**

Die gemeinsamen Attribute mehrerer Entitätstypen werden in einem **übergeordneten (allgemeinen) Entitätstyp** zusammengefasst.
-> z.B. `Person` mit den Attributen: `Name`, `Adresse`, `Geburtsdatum`

#### **Spezialisierung**

Die **spezifischen Eigenschaften** verbleiben in den spezialisierten Entitätstypen.
-> z.B. `Mitarbeiter`, `Kunde`, `Fahrer`, `Disponent` mit je eigenen Attributen.

Die spezialisierten Entitäten referenzieren den generalisierten Entitätstyp über **Fremdschlüssel**. Dies bildet die **"is_a"-Beziehung** ab (z.B. "Ein Fahrer **ist eine** Person").

In der objektorientierten Modellierung entspricht dieses Prinzip der **Vererbung**: `class Mitarbeiter extends Person { ... }`

---

## **Beispiele**

### Beispiel 1: Person

![Generalisierung Beispiel](media/Bild1.png)

**SQL-Umsetzung:**
```sql
-- Generalisierte Tabelle
CREATE TABLE Person (
    person_id INT PRIMARY KEY,
    name VARCHAR(100),
    adresse VARCHAR(255)
);

-- Spezialisierte Tabelle: Mitarbeiter
CREATE TABLE Mitarbeiter (
    person_id INT PRIMARY KEY,
    personalnummer VARCHAR(20),
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);

-- Spezialisierte Tabelle: Kunde
CREATE TABLE Kunde (
    person_id INT PRIMARY KEY,
    kundennummer VARCHAR(20),
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);
```

### Beispiel 2: Fahrzeug

*   **Allgemeiner Entitätstyp:** `Fahrzeug` (Attribute: `Fahrgestellnummer`, `Marke`, `Modell`, `Baujahr`)
*   **Spezialisierungen:**
    *   `PKW` (Attribut: `Anzahl_Sitze`)
    *   `LKW` (Attribut: `Ladegewicht`)
    *   `Bus` (Attribut: `Anzahl_Passagiere`)

### Weitere Beispiele

*   `Gerät` -> `Laptop`, `Tablet`, `Smartphone`
*   `Buch` -> `E-Book`, `Printbuch`
*   `Nutzerkonto` -> `Admin`, `Standardbenutzer`, `Gast`