# X-Technologien

Dieses Repo enthält Materialien für Schulungen und Workshops zum Thema X-Technologien.

# Minimalsetup für den Workshop am Sysbibtreffen am 05.11.2025
Für den Workshop brauchen wir recht wenig.

- Java (z. B. von hier: https://www.java.com/de/download/manual.jsp)
- Ein Texteditor (z. B. [VS Code](https://code.visualstudio.com/))

## Treiberskripte
Es gibt im Verzeichnis bin die beiden Dateien `transform.bat` (für Windows) und `transform.sh` für Linux/MacOS. 

Diese sind so ziemlich das absolute Mininmum an shell-script, das man produzieren kann. Kein Error-Handling, nix. Wirklich nur für die Verwendung im Workshop. Wer ernsthaft etwas machen möchte, braucht auch ein ernsthaftes Setup. Das würde aber den Rahmen sprengen.

Nun, wo das gesagt ist, so verwendet man sie:


**Linux/MacOS (bash)**
```bash
# immer vom Wurzelverzeichnis dieses Projekts aus ausführen!
bin/transform.sh path/to/source.xml path/to/xslt-stylesheet.xsl
```

**Windows Powershell**
```powershell
bin\transform.bat path\to\source.xml path\to\xslt-stylesheet.xsl
```

Damit wird das Ergebnis der Transformation in die Ausgabe geschrieben. Wenn man dieses in einer Datei auffangen möchte, geht das mit output redirection:

```bash
bin/transform.sh path/to/source.xml path/to/xslt-stylesheet.xsl > output-file.xml
```

## Testen des Minimalsetups
### Windows
Diesen Ordner mit PowerShell öffen und folgende Kommandozeile ausführen:

```powershell
.\bin\transform.bat .\setup\test.xsl .\setup\test.xsl
```

Dann sollte ungefähr so etwas herauskommen:

```powershell
C:\Users\stefa\projects\x-technologien>java -jar saxon\share\java\saxon-he-12.8.jar .\setup\test.xsl .\setup\test.xsl 

    *** SUCCESSFULLY INVOKED TRANSFORMATION ***
```

### Linux (und warscheinlich auch MacOS)
Diesen Ordner im Terminal öffen und folgende Kommandozeile ausführen

```bash
bin/transform.sh setup/test.xsl setup/test.xsl
```

Der output sollte folgendermaßen aussehen:

```bash
    *** SUCCESSFULLY INVOKED TRANSFORMATION ***
```