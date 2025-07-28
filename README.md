# 🏭 SQL & .NET Izziv: Industrijska proizvodnja z delovnimi nalogi

## 📘 Opis

V tem izzivu boste delali z realistično simulacijo podatkov iz industrijskega proizvodnega okolja. Podatkovna baza vključuje delovne naloge (workorders), operacije, materiale, proizvodne linije in zaposlene.  

Cilj izziva je poglobiti razumevanje:

- **povezovanja tabel (JOIN)** med več entitetami,
- **združevanja podatkov (GROUP BY)** in uporabe **agregatnih funkcij**,
- **filtriranja in sortiranja**,
- ter osnov **normalizacije podatkov**.

Dodaten poudarek je tudi na **učinkovitosti poizvedb** in **merjenju zmogljivosti**.

## 💻 Tehnološke smernice za rešitev

Aplikacijo implementiraj kot **.NET konzolno aplikacijo** (priporočena zadnja različica .NET 8 ali višje), s pomočjo:

- **Entity Framework** za dostop do podatkovne baze,
- **LINQ** za izvajanje poizvedb nad podatki,
- **`Stopwatch`** iz `System.Diagnostics` za merjenje časa izvajanja posameznih poizvedb,
- opcijsko tudi `ILogger` ali `Console.WriteLine()` za logiranje rezultatov.

Cilj je izmeriti, kako hitro se izvedejo poizvedbe nad velikimi količinami podatkov (200.000+ vrstic) in oceniti, ali so poizvedbe ustrezno optimizirane.

### 📌 Primer začetka aplikacije v .NET

```csharp
var stopwatch = Stopwatch.StartNew();

using var context = new ProductionDbContext();

// Primer preproste poizvedbe
var topEmployees = await context.WorkOrderOperations
    .GroupBy(op => op.EmployeeId)
    .Select(g => new {
        EmployeeId = g.Key,
        OperationCount = g.Count()
    })
    .OrderByDescending(x => x.OperationCount)
    .Take(5)
    .ToListAsync();

stopwatch.Stop();
Console.WriteLine($"Čas izvajanja: {stopwatch.ElapsedMilliseconds} ms");
```

## 📊 Struktura baznih tabel

| Tabela               | Namen                                                                 |
|----------------------|------------------------------------------------------------------------|
| `ProductionLines`    | Seznam vseh proizvodnih linij                                          |
| `Employees`          | Podatki o zaposlenih                                                   |
| `Materials`          | Seznam materialov                                                      |
| `WorkOrders`         | Delovni nalogi z datumom, statusom in povezavo na linijo               |
| `WorkOrderOperations`| Operacije, povezane z delovnim nalogom in zaposlenimi                 |
| `WorkOrderMaterials` | Poraba materialov po posameznem delovnem nalogu                        |

---

## 🔍 Opis stolpcev

### `Kreiranje baze`
Uporabi priloženo datoteko [`industry_workorders_200k.sql`](industry_workorders_200k.sql):

### `ProductionLines
| Stolpec   | Pomen                                 |
|-----------|---------------------------------------|
| Id        | Primarni ključ                        |
| Name      | Ime proizvodne linije (npr. 'Line 1') |
| Location  | Lokacija linije (npr. 'Plant A')      |

### `Employees`
| Stolpec    | Pomen                         |
|------------|-------------------------------|
| Id         | Primarni ključ                |
| Name       | Ime zaposlenega               |
| Department | Oddelek (npr. Assembly, ...)  |

### `Materials`
| Stolpec | Pomen              |
|--------|---------------------|
| Id     | Primarni ključ      |
| Name   | Ime materiala       |
| Unit   | Merska enota (kg..) |

### `WorkOrders`
| Stolpec   | Pomen                                   |
|-----------|------------------------------------------|
| Id        | Primarni ključ                          |
| Code      | Koda naloga (npr. WO-00001)             |
| StartDate | Datum začetka                           |
| EndDate   | Datum konca                             |
| LineId    | FK na `ProductionLines.Id`              |
| Status    | Status (Planned, InProgress, Completed) |

### `WorkOrderOperations`
| Stolpec         | Pomen                          |
|-----------------|--------------------------------|
| Id              | Primarni ključ                 |
| WorkOrderId     | FK na `WorkOrders.Id`          |
| OperationName   | Ime operacije                  |
| DurationMinutes | Trajanje v minutah             |
| EmployeeId      | FK na `Employees.Id`           |

### `WorkOrderMaterials`
| Stolpec     | Pomen                       |
|-------------|-----------------------------|
| Id          | Primarni ključ              |
| WorkOrderId | FK na `WorkOrders.Id`       |
| MaterialId  | FK na `Materials.Id`        |
| Quantity    | Porabljena količina         |

---

## 🎯 Izzivi

### 1. Poišči 5 linij z največ delovnimi nalogi
> Prikaži `Line Name`, `št. delovnih nalogov`, razvrščeno po številu v padajočem vrstnem redu.

### 2. Kateri zaposleni je delal na največ operacijah?
> Prikaži `Employee Name`, `št. operacij`, `oddelek`.

### 3. Skupna poraba materialov po enotah
> Prikaži `Unit`, `skupna količina`.

### 4. Povprečno trajanje operacij po statusu delovnih nalogov
> Združi podatke med `WorkOrders` in `WorkOrderOperations`.

### 5. Top 3 materiali po količini za delovne naloge na "Line 1"
> Uporabi JOIN med `WorkOrders`, `WorkOrderMaterials` in `Materials`.

---

## 🛠️ Začetek


1. Ustvariš shemo baze v SQL Server.
2. Uvoziš podatke (približno 200.000 vrstic).
3. Začneš reševati izzive!

---

## 📌 Namigi

- Bodite pozorni na **indekse**, če optimizirate poizvedbe (uporaba lokalne baze).
- Preverite ali lahko rešite izzive z eno samo poizvedbo.
- Uporabite **CTE** (Common Table Expressions) za boljšo berljivost kompleksnih poizvedb.

---

## 📦 Avtorji in podpora

Ta izziv je bil generiran za namen vadbe industrijskih SQL scenarijev in optimizacije poizvedb.  
V primeru težav ali napak se lahko obrnete na avtorja.
