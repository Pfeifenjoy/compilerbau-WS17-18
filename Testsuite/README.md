# Testsuite

Die Testsuite enthält: 

- Java Programme (.java) 
- Die dazugehöriger Abstrakter Syntax (ABS.hs)
- Die zugehörige getypte Abstrackte Syntax (TypedABS.hs) 
- Den zugehörigen Java Bytecodes (.class)

Die Struktur ist wie folgt (Ordnername):

| Ordnername      | #Instanzvariablen |  #Methoden | Besonderheit                                                    |
|-----------------|:-----------------:|:----------:|-----------------------------------------------------------------|
| InstanzVariable | 3                 | 0          | Basisklasse mit Definition von Instnazvariablen                 |
| ClassMethod     | 1                 | 3          | Konstantenrückgabe, Parameterrückgabe, Instanzvariablenrückgabe |
| ClassAssign     | 1                 | 1          | Variablenzuweisung innerhalb der Methode                        |


**ToDo:** Testfunktionalität für einfachen Vergleich zwischen Compilter-Ergebnis und händischem Ergebnis
