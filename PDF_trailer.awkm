function pdf_trailer(    pdf) {

#########################################################################################
#
# PDF_trailer V1.0.2  28.02.2018
#
# Autor: Adrian Boehlen
#
# 6. Modul der PDF-Library
# erzeugt den Trailer eines PDF-Files. Die Adresse der Referenztabelle wird anhand
# des letzten Eintrags des Arrays adresse festgelegt
# es werden keine Argumente benoetigt
#
#########################################################################################

pdf = "trailer\n";
pdf = pdf "<<\n";
pdf = pdf " /Size " objectnr_max "\n";
pdf = pdf " /Root 1 0 R\n";
pdf = pdf " /Info 2 0 R\n";
pdf = pdf ">>\n";
pdf = pdf "startxref\n";
pdf = pdf adresse[objectnr_max] "\n";
pdf = pdf "%%EOF\n";

return pdf;

}

