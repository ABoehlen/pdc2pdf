function pdf_pages_font(schriften,    font, i, ii, pdf, schriften_arr, schriftobj) {

#########################################################################################
#
# PDF_pages_font V1.0.2  25.10.2018
#
# Autor: Adrian Boehlen
#
# 2. Modul der PDF-Library
# erzeugt das Seitenbereichs- und das Schriftobjekt eines PDF-Files
# als Argumente werden die zu verwendenden Schriften in folgender Sytax definiert:
# "Schriftart1 F1 Schriftart2 F2" etc. Dabei sind Schriftart und Kuerzel jeweils 
#   durch einen Leerschlag zu trennen.
#   Bsp: "Helvetica-Bold F1 Courier F2 Times-BoldItalic F3"
# die hoechste bisher vergebene Objektnummer wird in der globalen Variable
#   objectnr_max gespeichert
#
#########################################################################################

# Fontdictionary aufbauen
split(schriften, schriften_arr, " ");            # Parameter in Array aufsplitten
for (i = 1; i <= length(schriften_arr); i++) {
  if (i % 2 == 0) {                              # jedes 2. Element als Kuerzel verwenden
    font = font "   /" schriften_arr[i] " " 4 + ii " 0 R\n";
    ii++;
  }
}

# Seitenbereichsobjekt aufbauen
pdf = "3 0 obj\n";
pdf = pdf "<<\n";
pdf = pdf " /Type /Pages\n";
pdf = pdf " /Count 1\n";
pdf = pdf " /Kids [" 4 + ii " 0 R]\n"; # Seitenobjekt naechste verfuegbare Nummer zuweisen
pdf = pdf " /Resources <<\n";
pdf = pdf "  /ProcSet [/PDF /Text]\n";
pdf = pdf "  /Font <<\n";
pdf = pdf font;                        # Fontdictionary einfuegen
pdf = pdf "  >>\n";
pdf = pdf " >>\n";
pdf = pdf ">>\n";
pdf = pdf "endobj\n";

# Schriftobjekt(e) aufbauen
ii = 0;
for (i = 1; i <= length(schriften_arr); i++) {
  if (i % 2 == 0) {
    schriftobj = schriftobj 4 + ii " 0 obj\n";
    schriftobj = schriftobj "<<\n";
    schriftobj = schriftobj " /Type /Font\n";
    schriftobj = schriftobj " /Subtype /Type1\n";
    schriftobj = schriftobj " /Name /" schriften_arr[i] "\n";
    schriftobj = schriftobj " /BaseFont /" schriften_arr[i-1] "\n";
    schriftobj = schriftobj " /Encoding /WinAnsiEncoding\n";
    schriftobj = schriftobj ">>\n";
    schriftobj = schriftobj "endobj\n";
    ii++;
  }
}
objectnr_max = 3 + ii; # hoechtste benutzte Objektnummer speichern

return pdf schriftobj;

}

