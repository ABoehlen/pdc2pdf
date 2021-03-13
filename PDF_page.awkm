function pdf_page(laenge, hoehe,    pdf) {

##########################################################################################
#
# PDF_page V1.0.2  19.02.2018
#
# Autor: Adrian Boehlen
#
# 3. Modul der PDF-Library
# erzeugt das Seitenobjekt eines PDF-Files
# als Argumente werden die Laenge und Hoehe des Dokumentes in PostScript Point benoetigt
#
##########################################################################################

pdf = objectnr_max + 1 " 0 obj\n";
pdf = pdf "<<\n";
pdf = pdf " /Type /Page\n";
pdf = pdf " /Parent 3 0 R\n";
pdf = pdf " /MediaBox [0 0 " mm2dtp(laenge) " " mm2dtp(hoehe) "]\n";
pdf = pdf " /Contents " objectnr_max + 2 " 0 R\n"; # Nummer des Inhaltsobjektes festlegen
pdf = pdf ">>\n";
pdf = pdf "endobj\n";

objectnr_max++;

return pdf;

}

