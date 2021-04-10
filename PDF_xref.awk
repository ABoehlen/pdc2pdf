function pdf_xref(    pdf) {

#########################################################################################
#
# PDF_xref V1.0.0  28.02.2018
#
# Autor: Adrian Boehlen
#
# 5. Modul der PDF-Library
# erzeugt die Referenztabelle eines PDF-Files mithilfe des Arrays adresse
# es werden keine Argumente benoetigt
#
#########################################################################################

pdf = "xref\n";
pdf = pdf "0 " ++objectnr_max "\n";
pdf = pdf sprintf("%010i 65535 f \n", 0);
for (i = 1; i <= (objectnr_max - 1); i++)
  pdf = pdf sprintf("%010i 00000 n \n", adresse[i]);
return pdf;

}
