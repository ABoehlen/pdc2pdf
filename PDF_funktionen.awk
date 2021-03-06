#########################################################################################
#
# PDF_funktionen V1.0.12   08.04.2021
#
# Autor: Adrian Boehlen
#
# Modul enthaelt diverse Funktionen zum Generieren des Inhaltes von PDF-Dateien
#
#########################################################################################

######## erzeugt ASCII-Code des angegebenen Zeichens ########

function ascii(inp,    c, n) {
  
  for (n = 0; n <= 255; n++)    # fuer alle 256 ASCII Zeichen...
    char[sprintf("%c", n)] = n; # ...Dictionary mit ASCII Codes erzeugen  
  return char[inp];             # Code des entsprechenden Zeichens zurueckgeben
}

########### rechnet Ganzzahl vom Dezimal- ins Oktalsystem um ###########

function oct(dec,    i, j, octNr, octTmp) {
  dec = int(dec);            # Ganzzahl erzwingen
  i = 1;                     # Zaehler initialisieren
  while (dec != 0) {
    octTmp[i] = dec % 8;     # Rest von Integerdivision speichern
    dec = dec / 8;           # Wert durch 8 teilen...
      dec = int(dec);        # ...und kuerzen
    i++;
  }

  for (j = i; j >= 1; j--)   # Array in umgekehrter Richtung durchlaufen
    octNr = octNr octTmp[j]; # Ziffern zusammenfuegen...
  return octNr;              # ...und ausgeben
}

########### rechnet RGB-Werte um (Input: 0 - 255) ###########

function rgb_value(v) {
  if (v < 0 || v > 255) {
    print "\nFehler: Ungueltiger RGB-Wert!\n";
    print "...Programm wird beendet...\n";
    exit;   
  }	
  return v / 255;
}

########### definiert Strichstaerke (Input: mm) ###########

function line_width(w) {
  return mm2dtp(w) " w\n";
}

########### rechnet mm in PostScript Point um ###########

function mm2dtp(mm) {
  return mm / 0.352778;
}

########### zeichnet eine Linie, die durch n Koordinatenpaare festgelegt wird ###########

# die Koordinaten sind als String mit Leerzeichen getrennt zu definieren

function stroke_line(koordinaten,    i, koord_arr, pdf) {
  split(koordinaten, koord_arr);
  if (length(koord_arr) % 2 == 1) {
    print "\nFehler: Ungerade Anzahl Koordinaten!\n";
    print "...Programm wird beendet...\n";
    exit;
  }
  pdf = pdf mm2dtp(koord_arr[1]) " " mm2dtp(koord_arr[2]) " m\n"; # erstes Koordinatenpaar definieren
  for (i = 3; i <= length(koord_arr); i++) {                      # weitere Koordinatenpaare
    if (i % 2 == 1) 
      pdf = pdf mm2dtp(koord_arr[i]) " "; 
    else
      pdf = pdf mm2dtp(koord_arr[i]) " l\n";
  }
  pdf = pdf "S\n";                                                # Linie abschliessen
  return pdf;
}


########### setzt einen Text ###########

# Benoetigt folgende Argumente: Schriftkuerzel gemaess Schriftobjekt, Groesse in Point, Koordinaten, Text, Textfarbe (optional)

function set_text(font, groesse, x, y, text, textfarbe,   pdf) {
  pdf = "BT\n";
  if (textfarbe)
    pdf = pdf textfarbe "rg\n";
  pdf = pdf "/" font " " groesse " Tf\n";
  pdf = pdf mm2dtp(x) " " mm2dtp(y) " Td\n";
  pdf = pdf "(" text ") Tj\nET\n";
  return pdf;
}


########### beendet das Inhaltsobjekt ###########

function endinhalt() {
  return "endstream\nendobj\n";
}

