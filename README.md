# pdc2pdf

## Purpose
pdc2pdf is a simple PDF processor written in AWK.

## Background
PDF is basically a text-based format, but its strict structuring makes editing in an editor very difficult or almost impossible. pdc2pdf creates a PDF from a text format named PDC (PDF Command File) which contains only the mandatory information, necessary for building a PDF. 

PDC based on the concept of "little languages", which the authors of AWK explain in their famous 1988 book [1\].

The parameterisation of the PDC is done in common units of measurement, which are then converted internally into the values needed by PDF.

Currently, only text and lines can be processed, but this is already sufficient for many purposes. Fonts cannot be included, so you are bound to the PDF standard fonts according to http://www.p2501.ch/pdf-howto/grundlagen/metadaten/schriften.

## System requirements

The programme requires Gawk 4.0 or higher. It has been used and tested on various Linux systems. It's also possible to use it on Windows, but it must be done within _git for Windows_ or _Cygwin_, where Gawk is also available. Since the application is optimised for the German language, the environment variable `LC_ALL=de_DE` must be assigned so that "umlaute" and special characters are processed correctly:

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

The programme can then be started directly via `pdc2pdf_main.awk`, as since Gawk 4.0 additional modules (marked with the extension .awkm for clarification) can be included. With the shell script `build_pdc` it is also possible to derive a standalone version. The name is to be defined by the user, e.g.:

```
./build_pdc pdc2pdf.awk
```

This file no longer has any dependencies and can be stored in any location.

## Usage

The only argument to be given is the PDC file, because the PDF to be created is already defined there. It will be saved in the same directory as the PDC file. A test file `hello_world.pdc` is enclosed. To convert it into a PDF just type:

```
./pdc2pdf_main.awk hello_world.pdc
```

## Documentation

A documentation about the PDC syntax is to be found as comments within the `hello_world.pdc` (currently in german).

## License

This project is licensed under the MIT License - see the LICENSE file for details

## Literature
\[1\] Aho et al.: The Awk Programming Language, 1988, S. 131ff.

