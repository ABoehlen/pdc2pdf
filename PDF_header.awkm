function pdf_header(author, title, subject,    now, pdf) {

#########################################################################################
#
# PDF_header V1.0.0  10.03.2015
#
# Autor: Adrian Boehlen
#
# 1. Modul der PDF-Library
# erzeugt den Header und das Metadatenobjekt eines PDF-Files
# als Argumente werden der Autor, der Titel und die Beschreibung benoetigt
#
#########################################################################################

now = strftime("%Y%m%d%H%M%S", systime()) "Z";
pdf = "%PDF-1.2\n";
pdf = pdf "1 0 obj\n";
pdf = pdf "<<\n";
pdf = pdf " /Type /Catalog\n";
pdf = pdf " /Title 2 0 R\n";
pdf = pdf " /Pages 3 0 R\n";
pdf = pdf ">>\n";
pdf = pdf "endobj\n";
pdf = pdf "2 0 obj\n";
pdf = pdf "<<\n";
pdf = pdf " /Title (" title ")\n";
pdf = pdf " /Author (" author ")\n";
pdf = pdf " /Creator (pdc2pdf.awk)\n";
pdf = pdf " /Producer (pdc2pdf.awk)\n";
pdf = pdf " /Subject (" subject ")\n";
pdf = pdf " /Keywords (have fun)\n";
pdf = pdf " /CreationDate (" now ")\n";
pdf = pdf ">>\n";
pdf = pdf "endobj\n";

return pdf;

}

