#!/usr/local/bin/awk -f
#########################################################################################
#
# pdc2pdf V1.0.2 10.04.2021
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

@include "PDF_header.awk";
@include "PDF_pages_font.awk";
@include "PDF_page.awk";
@include "PDF_inhalt.awk";
@include "PDF_xref.awk"
@include "PDF_trailer.awk";
@include "PDF_funktionen.awk";

BEGIN {
  # Scriptname ermitteln (siehe https://unix.stackexchange.com/questions/228072/how-to-print-own-script-name-in-mawk)
  getline t < "/proc/self/cmdline";
  split(t, a, "\0");
  scriptname = sprintf("%s", a[3]);

  # Druckbare Zeichen im erweiterten ASCII-Zeichensatz (128-255)
  sonderzeichen_regex = "[ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜø£Ø×áíóúñÑªº¿®¬½¼¡«»ÁÂÀ©¢¥ãÃ¤ðÐÊËÈÍÎÏ¦ÌÓßÔÒõÕµþÞÚÛÙýÝ¯´­±¾¶§÷¸°¨·¹³²]";

  # Usage ausgeben, wenn Anzahl Argumente nicht stimmt und Programm beenden
  if (ARGC != 2) {
    printf("\n***************************************************\n") > "/dev/stderr";
    printf("     Usage: %s <pdc file>\n", scriptname)                 > "/dev/stderr";
    printf("***************************************************\n\n") > "/dev/stderr";
    beende = 1; # um END-Regel zum sofortigen Beenden zu erzwingen
    exit;
  }
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
    sub(/[0-9]+[.]?[0-9]*-[0-9]+[.]?[0-9]*/,"");         # Strichstil loeschen
  }
  if ($1 ~ /rgb/) {                                      # pruefen, ob Farbe definiert
    linienfarbe[anz_lin] = $1;                           # Farbe festhalten
    sub(/rgb,[0-9]+,[0-9]+,[0-9]+/,"");                  # Farbe loeschen
  }
  linie_koord[anz_lin] = $0;                             # Rest als Koordinaten speichern
}
$1 == "text" {
  anz_text++;                                            # Anzahl Textobjekte ermitteln
  sub(/^ *text */,"");                                   # "text" am Zeilenanfang loeschen
  if ($1 ~ /rgb/) {                                      # pruefen, ob Farbe definiert
    textfarbe[anz_text] = $1;                            # Farbe festhalten
    sub(/rgb,[0-9]+,[0-9]+,[0-9]+/,"");                  # Farbe loeschen
  }
  text_kuerzel[anz_text] = $1;                           # Kuerzel F1, F2 etc uebernehmen
  text_groesse[anz_text] = $2;                           # Schriftgroesse
  text_x[anz_text] = $3;                                 # x-Koordinate
  text_y[anz_text] = $4;                                 # y-Koordinate
  sub(/^ *F[1-9] [0-9]+ [0-9]+ [0-9]+ */,"");            # oben uebernommener Inhalt loeschen
  text[anz_text] = $0;                                   # Rest als Textinhalt speichern
}

########## PDF aufbauen ##########

END {
  # damit END nicht ausgefuehrt wird, falls kein File gelesen wird
  if (beende == 1)
    exit;

  pdf = pdf_header(autor, titel, thema);                              # Header aufbauen
  for (i = 1; i <= anz_font; i++) {                                   # Anzahl Fonts ermitteln
    if (i == 1)
      font_str = font[i];
    else
      font_str = font_str " " font[i];                                # Inputstring fuer pdf_pages_font aufbauen
  }
  pdf = pdf pdf_pages_font(font_str);
  pdf = pdf pdf_page(seitengr["x"], seitengr["y"]);

  # Linien zeichnen
  for (i = 1; i <= anz_lin; i++) {
    if (i in linienfarbe) {                                           # Linienfarbe ergaenzen, wenn definiert
      linienf_pdf = "";                                               # Farbe zuruecksetzen
      split(linienfarbe[i], linienf_arr, ",");                        # Farbstring in Elemente aufteilen
      for (f = 2; f <= (length(linienf_arr)); f++)                    # alle Werte ab dem 2. durchgehen
        linienf_pdf = linienf_pdf rgb_value(linienf_arr[f]) " ";      # nach jedem Wert ein Leerschlag ergaenzen
      linienf_pdf = linienf_pdf "RG\n";                               # "RG" anhaengen, Zeile beenden...
      inhalt = inhalt linienf_pdf;                                    # ...und an Inhalt anfuegen
    }
    if (i in strichstil) {                                            # Strichstil ergaenzen, wenn definiert
      strichst_pdf = "[";                                             # Beginn mit [
      split(strichstil[i], strichst_arr, "-");                        # Stil-String in Elemente aufteilen
      for (s = 1; s <= (length(strichst_arr) - 1); s++)               # alle Werte bis zum vorletzten durchgehen
        strichst_pdf = strichst_pdf strichst_arr[s] " ";              # nach jedem Wert ein Leerschlag ergaenzen...
      strichst_pdf = strichst_pdf strichst_arr[length(strichst_arr)]; # ...ausser nach dem letzten
      strichst_pdf = strichst_pdf "] 0 d\n";                          # Formatierungsstring abschliessen...
      inhalt = inhalt strichst_pdf;                                   # ...und an Inhalt anfuegen
    }
    inhalt = inhalt line_width(linie_breite[i]);                      # Linienbreite festlegen
    inhalt = inhalt stroke_line(linie_koord[i]);                      # Linie zeichnen
  }
  
  # Text setzen
  for (i = 1; i <= anz_text; i++) {
    if (i in textfarbe) {                                             # Linienfarbe ergaenzen, wenn definiert
      split(textfarbe[i], textf_arr, ",");                            # Farbstring in Elemente aufteilen
      for (f = 2; f <= (length(textf_arr)); f++)                      # alle Werte ab dem 2. durchgehen
        textf_pdf = textf_pdf rgb_value(textf_arr[f]) " ";            # nach jedem Wert ein Leerschlag ergaenzen
    }
    text_str = "";
    anz_char = split(text[i], text_arr, "");                          # Text in Einzelzeichen aufbrechen
    for (j = 1; j <= anz_char; j++) {
      # Sonderzeichen ermitteln und in oktalen Code umwandeln
      if (text_arr[j] ~ sonderzeichen_regex)
        text_str = text_str sprintf("\\%s", oct(ascii(text_arr[j])));
      else
        text_str = text_str text_arr[j];
    }
    inhalt = inhalt set_text(text_kuerzel[i], text_groesse[i], text_x[i], text_y[i], text_str, textf_pdf);
    textf_pdf = "";                                                   # Farbe zuruecksetzen
    
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
