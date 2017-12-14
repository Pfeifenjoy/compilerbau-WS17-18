# Testsuite

Die Testsuite enthält: 

- Java Programme (Class.java) 
- Die dazugehöriger Abstrakter Syntax (ABS.hs)
- Die zugehörige getypte Abstrackte Syntax (TypedABS.hs) 
- Den zugehörigen Java Bytecodes (Class.class)

Die Struktur ist wie folgt (Ordnername):

| Ordnername         | #Instanzvariablen |  #Methoden | Besonderheit                                                    |
|--------------------|:-----------------:|:----------:|-----------------------------------------------------------------|
| InstanzVariable    | 3                 | 0          | Basisklasse mit Definition von Instnazvariablen                 |
|  LocalVariable     | 0                 |  1         | Eine lokale Variable in einer Methode                           |
| ClassMethod        | 1                 | 3          | Konstantenrückgabe, Parameterrückgabe, Instanzvariablenrückgabe |
| ClassAssign        | 1                 | 1          | Variablenzuweisung innerhalb der Methode                        |
| Simple-If          | 1                 | 1          | Simple If-Condition mit Else-Branch                             |
| WhileLoop          | 0                 | 1          | Endlos While-Loop                                               |
| WhileLoopCondition | 0                 |  1         | While-Loop mit Condition                                        |
| ForLoop            |  0                |  1         | Einfache ForLoop mit einfachem Body                             |

**ToDo:** Testfunktionalität für einfachen Vergleich zwischen Compilter-Ergebnis und händischem Ergebnis
