# pdc2pdf
## Zweck
pdc2pdf ist ein sehr einfacher PDF-Prozessor, geschrieben in AWK.

## Hintergrund
PDF ist im Grundsatz ein textbasiertes Format, dessen strikte Strukturierung aber eine Bearbeitung in einem Editor sehr erschwert, bzw. fast verunmöglicht. pdc2pdf ermöglicht es, nur die zwingenden Informationen eines zu erstellenden PDFs in Textform festzuhalten. Die Struktur dieses Textformats pdc (PDF Command File) entspricht dem Konzept der «little languages», das die Autoren von AWK in ihrem Standardwerk erläutern (1).

Aktuell können nur Text und schwarze Linien verarbeitet werden, was aber für viele Zwecke bereits ausreicht. Schriften können nicht eingebunden werden, daher ist man an die PDF Standardschriften gemäss http://www.p2501.ch/pdf-howto/grundlagen/metadaten/schriften gebunden.

## Systemvoraussetzungen:
Das Programm wurde auf verschiedenen Linuxsystemen angewendet und getestet. Unter Windows ist die Verwendung auch möglich, muss aber innerhalb von Cygwin geschehen. Da die Anwendung für die deutsche Sprache optimiert ist, muss der Umgebungsvariable `LC_ALL=de_DE` zugewiesen sein, damit Umlaute und Sonderzeichen korrekt prozessiert werden.

## Installation und Ausführung
Das Programm kann direkt über `pdc2pdf_main.awk` gestartet werden, da seit Gawk 4.0 zusätzliche Module (zur Verdeutlichung mit der Erweiterung .awkm gekennzeichnet) eingebunden werden können. Mit dem Shellscript `build_pdc` kann auch eine Standalone-Version abgeleitet werden. Der Name ist dabei selbst zu definieren. Als einziges Argument ist die zu prozessierende pdc-Datei anzugeben, da das zu erzeugende PDF dort bereits festgelegt ist. Das PDF wird dabei im gleichen Verzeichnis gespeichert, wie die pdc-Datei.

## Literatur
(1) Aho et al.: The Awk Programming Language, 1988, S. 131ff.
