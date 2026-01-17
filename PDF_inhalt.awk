function pdf_inhalt(bytes,    pdf) {

#########################################################################################
#
# PDF_pages V1.0.1  12.02.2018
#
# Autor: Adrian Boehlen
#
# 4. Modul der PDF-Library
# erzeugt den Beginn des Inhaltsobjekts
# als Argument wird die Bytelaenge des Inhalts benoetigt
#
#########################################################################################

pdf = ++objectnr_max " 0 obj\n";
pdf = pdf "<<\n";
pdf = pdf " /Length " bytes "\n";
pdf = pdf ">>\n";
pdf = pdf "stream\n";

return pdf;

}

