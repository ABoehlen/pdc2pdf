#!/usr/local/bin/awk -f
#########################################################################################
#
# pdc2pdf V0.7 24.09.2018
# Autor: Adrian Boehlen
#
# Programm konvertiert ein PDC-File in ein PDF
# Es werden diverse Module im gleichen Verzeichnis benoetigt
# Zum Ableiten einer Standalone Version das Script 'build_pdc' verwenden
#
# erfordert Gawk 4.0.0 oder hoeher - ftp://ftp.gnu.org/gnu/gawk/
#
#########################################################################################

########## eingebundene Module ##########

@include "PDF_header.awkm";
@include "PDF_pages_font.awkm";
@include "PDF_page.awkm";
@include "PDF_inhalt.awkm";
@include "PDF_xref.awkm"
@include "PDF_trailer.awkm";
@include "PDF_funktionen.awkm";

BEGIN {
  number = "^[-+]?([0-9]+[.]?[0-9]*|[.][0-9]+)" \
           "([eE][-+]?[0-9]+)?$";
}

########## Inputfile einlesen ##########

$1 ~ /^#/ {                  # Kommentarzeilen ueberspringen 
  next;
}
$1 == "filename" {
  pdf_file = $2;
}
$1 == "author" {
  sub(/^ *author */,"");
  autor = $0;
}
$1 == "title" {
  sub(/^ *title */,"");
  titel = $0;
}
$1 == "subject" {
  sub(/^ *subject */,"");
  thema = $0;
}
$1 == "count" {              # derzeit nicht implementiert
  anzahl = $2;
}
$1 == "page_size" {
  seitengr["x"] = $2;
  seitengr["y"] = $3;
}
$1 == "width" {
  breite = $2;
}
$1 == "hight" {
  hoehe = $2;
}
$1 == "margin_left" {
  rand_links = $2;
}
$1 == "margin_right" {
  rand_rechts = $2;
}
$1 == "font" {
  sub(/^ *font */,"");
  anz_font++;
  font[anz_font] = $0;
}
$1 == "line" {
  anz_lin++;                                             # Anzahl Linien ermitteln
  linie_breite[anz_lin] = $2;                            # Linienbreite speichern
  sub(/^line[[:space:]][0-9]+[.]?[0-9]*[[:space:]]/,""); # "line" und Breite loeschen
  if ($1 ~ /-/) {                                        # pruefen, ob Stichstil definiert
    if ($1 ~ /^0/)                                       # wenn mit 0 beginnend...
      strichstil[anz_lin] = "";                          # ...Stichstil auf den Leerstring setzen
    else                                                 # sonst...
      strichstil[anz_lin] = $1;                          # ...Strichstil festhalten
    $1 = "";
  }
  linie_koord[anz_lin] = $0;                             # Rest als Koordinaten speichern
}
$1 == "text" {
  anz_text++;                                            # Anzahl Textobjekte ermitteln
  sub(/^ *text */,"");                                   # "text" am Zeilenanfang loeschen
  text_kuerzel[anz_text] = $1;                           # Kuerzel F1, F2 etc uebernehmen
  text_groesse[anz_text] = $2;                           # Schriftgroesse
  text_x[anz_text] = $3;                                 # x-Koordinate
  text_y[anz_text] = $4;                                 # y-Koordinate
  sub(/^ *F[1-9] [0-9]+ [0-9]+ [0-9]+ */,"");            # oben uebernommener Inhalt loeschen
  text[anz_text] = $0;                                   # Rest als Textinhalt speichern
}

########## PDF aufbauen ##########

END {
  pdf = pdf_header(autor, titel, thema);                 # Header aufbauen
  for (i = 1; i <= anz_font; i++) {                      # Anzahl Fonts ermitteln
    if (i == 1)
      font_str = font[i];
    else
      font_str = font_str " " font[i];                   # Inputstring fuer pdf_pages_font aufbauen
  }
  pdf = pdf pdf_pages_font(font_str);
  pdf = pdf pdf_page(seitengr["x"], seitengr["y"]);

  # Linien zeichnen
  for (i = 1; i <= anz_lin; i++) {
    if (i in strichstil) {                                            # Strichstil ergaenzen, wenn definiert
      strichst_pdf = "[";                                             # Beginn mit [
      split(strichstil[i], strichst_arr, "-");                        # String in Elemente aufteilen
      for (s = 1; s <= (length(strichst_arr) - 1); s++)               # alle Werte bis zum vorletzten durchgehen
        strichst_pdf = strichst_pdf strichst_arr[s] " ";              # nach jedem Wert einen Leerschlag ergaenzen...
      strichst_pdf = strichst_pdf strichst_arr[length(strichst_arr)]; # ...ausser nach dem letzten
      strichst_pdf = strichst_pdf "] 0 d\n";                          # Formatierungsstring abschliessen...
      inhalt = inhalt strichst_pdf;                                   # ...und an Inhalt anfuegen
    }
    inhalt = inhalt line_width(linie_breite[i]);                      # Linienbreite festlegen
    inhalt = inhalt stroke_line(linie_koord[i]);                      # Linie zeichnen
  }
  # Text setzen
  for (i = 1; i <= anz_text; i++) {
    text_str = "";
    anz_char = split(text[i], text_arr, "");  # Text in Einzelzeichen aufbrechen
    for (j = 1; j <= anz_char; j++) {
      # Sonderzeichen ermitteln und in oktalen Code umwandeln
      if (text_arr[j] ~ /[ÄÖÜÀÈÉäöüàèéçß]/)
        text_str = text_str sprintf("\\%s", oct(ascii(text_arr[j])));
      else
        text_str = text_str text_arr[j];
    }
    inhalt = inhalt set_text(text_kuerzel[i], text_groesse[i], text_x[i], text_y[i], text_str);
    
  }
    
  # PDF abschliessen und speichern
  pdf = pdf pdf_inhalt(length(inhalt));          # Inhaltsobjekt eroeffnen
  pdf = pdf inhalt;                              # Inhalt anfuegen
  pdf = pdf endinhalt();                         # Inhaltsobjekt abschliessen
  
  for (i = 1; i <= objectnr_max; i++) {          # alle Objekte durchgehen
    pat = i " 0 obj.*";                          # Muster fuer jedes Objekt festlegen
    pdf_part = pdf;                              # Kopie von pdf erstellen
    sub(pat, "", pdf_part);                      # alles ab dem Muster loeschen
    adresse[i] = length(pdf_part);               # Laenge des restlichen Codes festhalten
  }
  
  pdf = pdf pdf_xref();                          # Referenztabelle berechnen und anfuegen
  
  pdf_part = pdf;                                # Kopie von pdf erstellen
  sub(/xref.*/, "", pdf_part);                   # alles ab xref loeschen
  adresse[objectnr_max] = length(pdf_part);      # Laenge des Rests im hoechsten Arrayindex festhalten
  pdf = pdf pdf_trailer();                       # Trailer anfuegen
  print pdf > pdf_file;                          # PDF File speichern
  close(pdf_file);                               # PDF File schliessen
}
