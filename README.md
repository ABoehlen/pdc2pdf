# pdc2pdf

## Purpose
pdc2pdf is a simple PDF processor written in AWK.

## Background
PDF files can be represented in a form that uses only 7-bit ASCII character codes \[1\], but its strict structuring makes editing in an editor very difficult or almost impossible. pdc2pdf creates a PDF from a simple text format named PDC (PDF Command File) which contains only the mandatory information, necessary for building a PDF. 

PDC based on the concept of "little languages", which the authors of AWK explain in their famous 1988 book \[2\].

The parameterisation of the PDC is done in common units of measurement, which are then converted internally into the values needed by PDF.

Currently only text and lines can be processed, but this is already sufficient for many purposes. Fonts cannot be included, so you are bound to the 14 standard fonts. For details please have a look at the PDF Reference \[1\], p. 319.

## System requirements

The programme requires Gawk 4.0 or higher. It has been used and tested on various Linux systems. It's also possible to run it on Windows, but it must be done within _git for Windows_ or _Cygwin_, where Gawk is also available. Since the application is optimised for the German language, the environment variable `LC_ALL=de_DE` must be assigned so that "umlaute" and special characters are processed correctly:

```
export LC_ALL=de_DE
```

## Installation

Download the repository into your desired directory:

```
cd <directory>
git clone https://github.com/ABoehlen/pdc2pdf
cd pdc2pdf
```

The programme can then be started directly via `pdc2pdf_main.awk`, as since Gawk 4.0 additional modules can be included. It is also possible to derive a standalone version using the shell script `build_pdc`. The name is to be defined by the user, e.g.:

```
./build_pdc pdc2pdf.awk
```

This file no longer has any dependencies and can be stored in any location.

## Usage

The only argument to be given is the PDC file, because the PDF to be created has to be defined there. It will be saved in the same directory as the PDC file. A test file `hello_world.pdc` is enclosed. To convert it into a PDF just type:

```
./pdc2pdf_main.awk hello_world.pdc
```

Maybe you have to call the interpreter with the script file as argument, like this:

```
awk -f pdc2pdf_main.awk hello_world.pdc
```

## Documentation

A documentation about the PDC syntax is to be found as comments within the `hello_world.pdc` (currently in german).

To better understand PDF, take a look at the file `PDF_muster_kommentiert.pdf`. Opened in a PDF viewer it shows a simple text "Hello World" with some lines and a polygon, but opened in a text editor however it's a fully documented example file, explaining each PDF command (currently in german).

## License

This project is licensed under the MIT License - see the LICENSE file for details

## Literature
\[1\] Adobe Systems Incorporated: PDF Reference, Third Edition, 2001 (https://www.adobe.com/content/dam/acom/en/devnet/pdf/pdfs/pdf_reference_archives/PDFReference.pdf )

\[2\] Aho et al.: The Awk Programming Language, 1988, pp. 135 et seq.

