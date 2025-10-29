# Saxon Library mit Treiberskripten


## Library

Die Saxon-Library findet sich unter `./share/java/saxon9he.jar`

## Treiberskripte

Die Treiberskripte können wie folgt aufgerufen werden. Die Skripte in `bin/` müssen dafür in `$PATH` verfügbar sein oder direkt über ihren Systempfad aufgerufen sein:

### XQuery

```shell
saxon-xquery -s:inputfile.xml query.xql
```

#### Parameter

Die wichtigsten Parameter im Überblick

```
saxon-xquery [options] <query-file>

options:

| -?          | Display command line help text                                                         |
| -backup     | Save updated documents before overwriting                                              |
| -catalog    | Use specified catalog file to resolve URIs                                             |
| -config     | Use specified configuration file                                                       |
| -cr         | Use specified collection URI resolver class                                            |
| -dtd        | Validate using DTD                                                                     |
| -expand     | Expand attribute defaults from DTD or Schema                                           |
| -explain    | Display compiled expression tree and optimization decisions                            |
| -ext        | Allow calls to Java extension functions and xsl:result-document                        |
| -init       | User-supplied net.sf.saxon.lib.Initializer class to initialize the Saxon Configuration |
| -l          | Maintain line numbers for source documents                                             |
| -mr         | Use named ModuleURIResolver class                                                      |
| -now        | Run with specified current date/time                                                   |
| -o          | Use specified file for primary output                                                  |
| -opt        | Enable/disable optimization options [-]cfgklmsvwx                                      |
| -outval     | Action when validation of output file fails                                            |
| -p          | Recognize query parameters in URI passed to doc()                                      |
| -projection | Use source document projection                                                         |
| -q          | Query filename                                                                         |
| -qs         | Query string (usually in quotes)                                                       |
| -quit       | Quit JVM if query fails                                                                |
| -r          | Use named URIResolver class                                                            |
| -repeat     | Run N times for performance measurement                                                |
| -s          | Source file for primary input                                                          |
| -sa         | Run in schema-aware mode                                                               |
| -scmin      | Pre-load schema in SCM format                                                          |
| -stream     | Execute in streamed mode                                                               |
| -strip      | Handling of whitespace text nodes in source documents                                  |
| -t          | Display version and timing information                                                 |
| -T          | Use named TraceListener class, or standard TraceListener                               |
| -TB         | Trace hotspot bytecode generation to specified XML file                                |
| -TJ         | Debug binding and execution of extension functions                                     |
| -Tlevel     | Level of detail for trace listener output                                              |
| -Tout       | File for trace listener output                                                         |
| -TP         | Use profiling trace listener, with specified output file                               |
| -traceout   | File for output of trace() messages                                                    |
| -tree       | Use specified tree model for source documents                                          |
| -u          | Interpret filename arguments as URIs                                                   |
| -update     | Enable or disable XQuery updates, or enable the syntax but discard the updates         |
| -val        | Apply validation to source documents                                                   |
| -wrap       | Wrap result sequence in XML elements                                                   |
| -x          | Use named XMLReader class for parsing source documents                                 |
| -xi         | Expand XInclude directives in source documents                                         |
| -xmlversion | Indicate whether XML 1.1 is supported                                                  |
| -xsd        | List of schema documents to be preloaded                                               |
| -xsdversion | Indicate whether XSD 1.1 is supported                                                  |
| -xsiloc     | Load schemas named in xsi:schemaLocation (default on)                                  |

```

### XSLT

```shell
saxon-xslt -s:inputfile.xml tranform_authors.xsl
```

#### Parameter

```shell
saxon-xslt [options] <query-file>

options:

| -?          | Display command line help text                                                         |
| -a          | Use <?xml-stylesheet?> processing instruction to identify stylesheet                   |
| -catalog    | Use specified catalog file to resolve URIs                                             |
| -config     | Use specified configuration file                                                       |
| -cr         | Use specified collection URI resolver class                                            |
| -diag       | Display runtime diagnostics                                                            |
| -dtd        | Validate using DTD                                                                     |
| -ea         | Enable assertions                                                                      |
| -expand     | Expand attribute defaults from DTD or Schema                                           |
| -explain    | Display compiled expression tree and optimization decisions in human-readable form     |
| -export     | Display compiled expression tree and optimization decisions for exportation            |
| -ext        | Allow calls to Java extension functions and xsl:result-document                        |
| -im         | Name of initial mode                                                                   |
| -init       | User-supplied net.sf.saxon.lib.Initializer class to initialize the Saxon Configuration |
| -it         | Name of initial template                                                               |
| -jit        | Just-in-time compilation                                                               |
| -l          | Maintain line numbers for source documents                                             |
| -lib        | List of file names of library packages used by the stylesheet                          |
| -license    | Check for local license file                                                           |
| -m          | Use named class to handle xsl:message output                                           |
| -nogo       | Compile only, no evaluation                                                            |
| -now        | Run with specified current date/time                                                   |
| -o          | Use specified file for primary output                                                  |
| -opt        | Enable/disable optimization options [-]cfgjklmrsvwx                                    |
| -or         | Use named OutputURIResolver class                                                      |
| -outval     | Action when validation of output file fails                                            |
| -p          | Recognize query parameters in URI passed to doc()                                      |
| -quit       | Quit JVM if transformation fails                                                       |
| -r          | Use named URIResolver class                                                            |
| -relocate   | Produce relocatable packages                                                           |
| -repeat     | Run N times for performance measurement                                                |
| -s          | Source file for primary input                                                          |
| -sa         | Run in schema-aware mode                                                               |
| -scmin      | Pre-load schema in SCM format                                                          |
| -strip      | Handling of whitespace text nodes in source documents                                  |
| -t          | Display version and timing information, and names of output files                      |
| -T          | Use named TraceListener class, or standard TraceListener                               |
| -target     | Target Saxon edition for execution via -export                                         |
| -TB         | Trace hotspot bytecode generation to specified XML file                                |
| -threads    | Run stylesheet on directory of files divided in N threads                              |
| -TJ         | Debug binding and execution of extension functions                                     |
| -Tlevel     | Level of detail for trace listener output                                              |
| -Tout       | File for trace listener output                                                         |
| -TP         | Use profiling trace listener, with specified output file                               |
| -traceout   | File for output of trace() and -T output                                               |
| -tree       | Use specified tree model for source documents                                          |
| -u          | Interpret filename arguments as URIs                                                   |
| -val        | Apply validation to source documents                                                   |
| -versionmsg | No longer used                                                                         |
| -warnings   | Handling of recoverable dynamic errors                                                 |
| -x          | Use named XMLReader class for parsing source documents                                 |
| -xi         | Expand XInclude directives in source documents                                         |
| -xmlversion | Indicate whether XML 1.1 is supported                                                  |
| -xsd        | List of schema documents to be preloaded                                               |
| -xsdversion | Indicate whether XSD 1.1 is supported                                                  |
| -xsiloc     | Load schemas named in xsi:schemaLocation (default on)                                  |
| -xsl        | Main stylesheet file                                                                   |
| -y          | Use named XMLReader class for parsing stylesheet and schema documents                  |

```
