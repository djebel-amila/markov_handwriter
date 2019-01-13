/////////////////////////////////////////
// markov_handwriter.pde               //
// Julien Mercier                      //
// January 2019                        //
///////////////////////////////////////////////////////////////////////////
//  Goldsmiths University/MA Computational Arts                          //
//  PFAD: Programming for artists and designers, taught by               //
//  Lior Ben-Gai                                                         //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Acknowledgments:                                                                                            //
//  https://rosettacode.org/wiki/Execute_a_Markov_algorithm#Java                                                //
//  Daniel Schiffman tutorials (on P5.js) for a Markov chain text generator:                                    //
//    https://shiffman.net/a2z/markov/                                                                          //
//  Daniel Schiffman’s “Thesis generator”                                                                       //
//    https://github.com/shiffman/A2Z-F16/blob/gh-pages/week7-markov/07_Thesis_Project_Generator/index.html     //
//  Allison Parish’s “Generative Course Descriptions”                                                           //
//    http://static.decontextualize.com/toys/next_semester?                                                     //
//  Chris Harrison’s “Web Trigrams”                                                                             //
//    http://www.chrisharrison.net/index.php/Visualizations/WebTrigrams                                         //
//  Every Bart Simpson’s blackboard quote to date:                                                              //
//    http://simpsons.wikia.com/wiki/List_of_chalkboard_gags                                                    //
//  King James’ Bible on the Gutenberg project:                                                                 //
//    http://www.gutenberg.org/files/10/10-h/10-h.htm                                                           //
//  A little theory on Markov chains                                                                            //
//    https://www.analyticsvidhya.com/blog/2014/07/markov-chain-simplified/                                     //
//  More theory on Markov chains                                                                                //
//    http://www.cs.princeton.edu/courses/archive/spr05/cos126/assignments/markov.html                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////
// LIBRARIES
///////////////////////////////////////////////
import controlP5.*;        // ControlP5 (2.2.6) library by Schlegel Andreas. (2010). Retrieved from www.sojamo.de/libraries/controlp5
import processing.svg.*;   // P8gGraphicsSVG (2.0) library by Lhoste, Philippe. (2015). Retrieved from https://github.com/processing/processing/blob/master/java/libraries/svg/README.md
import rita.*;             // RiTa (1.3.86) library by Howe, Daniel. C. (2015). Retrieved from https://rednoise.org/rita

///////////////////////////////////////////////
// GLOBALS 
///////////////////////////////////////////////
RiMarkov markov;
ControlP5 cp5;
Slider2D b;
String[] files = { "bible.txt", "simpson.txt" }; // source texts. Try other by placing .txt files in the 'data' folder, and changing names here. 
String line;
float unitX, unitY, spacing, interline, noiseValue, charPerLine, currentLine, marginX = 50, marginY = 80;
float[] n = new float[1001];
int amtSentence = 40, amtWordsMarkov = 2;
boolean record;

///////////////////////////////////////////////
// SETUP
///////////////////////////////////////////////
void setup() {
  size(595, 842); // this results in A4-sized .svg files when exported.
  background(255);
  noFill();
  strokeWeight(.6);
  strokeCap(ROUND);
  strokeJoin(ROUND);

  markov = new RiMarkov(amtWordsMarkov); // “reads” the sources by looking at 'amtWordsMarkov' amount of words, and storing statistics on which word comes next. 
  markov.loadFrom(files, this); 
  if (!markov.ready()) return;

  cp5 = new ControlP5(this);           

  String[] lines = markov.generateSentences(amtSentence);  //  Generates 'amtSentence' amount of sentences and stores them in string array. 
  line = RiTa.join(lines, "\n"); // regroup the strings of the array in one string. 

  // REFRESH BUTTON STYLE
  Controller a = cp5.addButton("refresh").setPosition(marginX, 20).setSize(60, 35).setColorBackground(color(255, 0, 0, 255));
  a.getCaptionLabel().setColor(color(0, 0, 0, 100)).getStyle().setPadding(0, 4, 4, 2);
  a.setColorForeground(color(255, 0, 0, 100));
  a.setColorActive(color(255, 0, 0, 50));

  // SIZE 2D SLIDER STYLE
  b = cp5.addSlider2D("size").setPosition(170, 20).setSize(35, 35).setMinMax(0, 0, 30, 30).setValue(8, 8);
  b.disableCrosshair().setColorBackground(color(200, 200, 200, 255)).setColorForeground(color(0, 0, 0, 255)).setColorValueLabel(color(255, 0, 255, 50));
  b.getCaptionLabel().setColor(color(0, 0, 0, 100)).getStyle().setPadding(-3, 0, 0, 0);
  b.getValueLabel().setVisible(false);
  b.setColorActive(color(0, 0, 0, 100));

  // INTERLINE SLIDER STYLE
  Controller e = cp5.addSlider("interline").setPosition(250, 20).setRange(2, 50).setValue(25);
  e.getCaptionLabel().setColor(color(0, 0, 0, 100));
  e.setHeight(10);
  e.getCaptionLabel().getStyle();
  e.setColorBackground(color(200, 200, 200, 255));
  e.setColorForeground(color(0, 0, 0, 255));
  e.getCaptionLabel().getStyle().setMargin(10, 20, 20, -103);
  e.setColorActive(color(0, 0, 0, 100));
  e.getValueLabel().setVisible(false);

  // SPACING SLIDER STYLE
  Controller c = cp5.addSlider("spacing").setPosition(250, 45).setRange(2, 50).setValue(10);
  c.getCaptionLabel().setColor(color(0, 0, 0, 100));
  c.setHeight(10);
  c.setColorBackground(color(200, 200, 200, 255));
  c.setColorForeground(color(0, 0, 0, 255));
  c.getCaptionLabel().getStyle().setMargin(10, 20, 20, -103);
  c.setColorActive(color(0, 0, 0, 100));
  c.getValueLabel().setVisible(false);

  // NOISEVALUE KNOB STYLE
  Controller z = cp5.addKnob("noiseValue").setRange(0, 20).setRadius(17.5).setDragDirection(Knob.VERTICAL);
  z.setValue(4); 
  z.setPosition(390, 20);
  z.setColorBackground(color(200, 200, 200, 255));
  z.setColorForeground(color(0, 0, 0, 255));
  z.setColorActive(color(0, 0, 0, 100));
  z.getCaptionLabel()
    .setColor(color(0, 0, 0, 100))
    .setPadding(0, 1)
    .getStyle();
  z.getValueLabel().setVisible(false);

  // EXPORT BUTTON STYLE
  Controller b = cp5.addButton("export")
    .setPosition(475, 20)
    .setSize(60, 35)
    .setColorBackground(color(0, 255, 0, 255));
  b.getCaptionLabel()
    .setColor(color(0, 0, 0, 100))
    .getStyle()
    .setPadding(4, 4, 4, 2)
    .setMargin(-4, 0, 0, 0); 
  b.setColorForeground(color(0, 255, 0, 100));
}


///////////////////////////////////////////////
// DRAW
///////////////////////////////////////////////
void draw() {

  background(255);

  unitX = b.getArrayValue()[0];  //  get X value of the 'size' controller 
  unitY = b.getArrayValue()[1];  //  get Y value of the 'size' controller

  for (int i = 0; i < n.length; i++) {  //  create noise values multiplied by the varying 'noiseValue' 
    n[i] = noise(random(1000)) * noiseValue;
  }

  if (record) {  //  start recording the output file
    beginRecord(SVG, "output/frame-####.svg");
  }

  handwriter();  //  call the 'handwriter' function, that turn each character in the generated string in its corresponding 'handwritten' glyph.

  if (record) {
    endRecord();  //  stop recording the output file
    record = false;
  }
}


///////////////////////////////////////////////
// REFRESH BUTTON: GENERATES NEW SENTENCES
///////////////////////////////////////////////
public void refresh() {
  if (!markov.ready()) return;  
  String[] lines = markov.generateSentences(amtSentence);
  line = RiTa.join(lines, "\n");
}

///////////////////////////////////////////////
// EXPORT BUTTON: SETS BOOL RECORD TO TRUE, AND PRINTS A CONFIRMATION IN CONSOLE 
///////////////////////////////////////////////
public void export() {
  record = true;
  println("frame-"+(frameCount+1) +".svg was exported");
}

///////////////////////////////////////////////
// HANDWRITER 
///////////////////////////////////////////////
void handwriter() {
  for (int i = 0; i < line.length(); i++) {
    currentLine = 0; 
    float posX = marginX + (i * spacing);  //  the first letter’s X location
    float posY = marginY;  //  the first letter’s Y location
    charPerLine = floor((width - marginX - marginY) / (spacing));  //  count the amount of character per line (depends on spacing)
    float maxLine = (height - marginY - marginY)/interline;  //  calculates the maximum amount of lines possible (depends on interline)
    int maxChar = round(charPerLine * maxLine);  //  calculates the total maximum amount of character on a page (depends on interline and spacing)

    // 'break line'
    while (posX >= width - marginX - 5) {  //  if posX reaches marginX on the right…
      posX -= (width - marginX - marginX);  //   …return to marginX on the left…
      currentLine += 1;  //  …add 1 to the line counter… 
      posY = marginY + (currentLine * interline);  //  … and add interline to posY.
    }

    // break loop when maximum amount of character per page is met
    if (i >= maxChar && currentLine >= maxLine) {
      break;
    }

    // lowercase glyphs
    if (line.charAt(i) == 'a' || line.charAt(i) == 'à' || line.charAt(i) == 'ä' || line.charAt(i) == 'â') a(posX, posY);
    else if (line.charAt(i) == 'b') b(posX, posY);
    else if (line.charAt(i) == 'c' || line.charAt(i) == 'ç') c(posX, posY);
    else if (line.charAt(i) == 'd') d(posX, posY);
    else if (line.charAt(i) == 'e' || line.charAt(i) == 'é' || line.charAt(i) == 'è' || line.charAt(i) == 'ê' || line.charAt(i) == 'ë') e(posX, posY);
    else if (line.charAt(i) == 'f') f(posX, posY);
    else if (line.charAt(i) == 'g') g(posX, posY);
    else if (line.charAt(i) == 'h') h(posX, posY);
    else if (line.charAt(i) == 'i' || line.charAt(i) == 'î') i(posX, posY);
    else if (line.charAt(i) == 'j') j(posX, posY);
    else if (line.charAt(i) == 'k') k(posX, posY);
    else if (line.charAt(i) == 'l') l(posX, posY);
    else if (line.charAt(i) == 'm') m(posX, posY);
    else if (line.charAt(i) == 'n') n(posX, posY);
    else if (line.charAt(i) == 'o' || line.charAt(i) == 'ô' || line.charAt(i) == 'ö') o(posX, posY);
    else if (line.charAt(i) == 'p') p(posX, posY);
    else if (line.charAt(i) == 'q') q(posX, posY);
    else if (line.charAt(i) == 'r') r(posX, posY);
    else if (line.charAt(i) == 's') s(posX, posY);
    else if (line.charAt(i) == 't') t(posX, posY);
    else if (line.charAt(i) == 'u' || line.charAt(i) == 'û' || line.charAt(i) == 'ü'|| line.charAt(i) == 'ù') u(posX, posY);
    else if (line.charAt(i) == 'v') v(posX, posY);
    else if (line.charAt(i) == 'w') w(posX, posY);
    else if (line.charAt(i) == 'x') x(posX, posY);
    else if (line.charAt(i) == 'y') y(posX, posY);
    else if (line.charAt(i) == 'z') z(posX, posY);

    // uppercase glyphs
    else if (line.charAt(i) == 'A') A(posX, posY);
    else if (line.charAt(i) == 'B') B(posX, posY);
    else if (line.charAt(i) == 'C') C(posX, posY);
    else if (line.charAt(i) == 'D') D(posX, posY);
    else if (line.charAt(i) == 'E') E(posX, posY);
    else if (line.charAt(i) == 'F') F(posX, posY);
    else if (line.charAt(i) == 'G') G(posX, posY);
    else if (line.charAt(i) == 'H') H(posX, posY);
    else if (line.charAt(i) == 'I') I(posX, posY);
    else if (line.charAt(i) == 'J') J(posX, posY);
    else if (line.charAt(i) == 'K') K(posX, posY);
    else if (line.charAt(i) == 'L') L(posX, posY);
    else if (line.charAt(i) == 'M') M(posX, posY);
    else if (line.charAt(i) == 'N') N(posX, posY);
    else if (line.charAt(i) == 'O') O(posX, posY);
    else if (line.charAt(i) == 'P') P(posX, posY);
    else if (line.charAt(i) == 'Q') Q(posX, posY);
    else if (line.charAt(i) == 'R') R(posX, posY);
    else if (line.charAt(i) == 'S') S(posX, posY);
    else if (line.charAt(i) == 'T') T(posX, posY);
    else if (line.charAt(i) == 'U') U(posX, posY);
    else if (line.charAt(i) == 'V') V(posX, posY);
    else if (line.charAt(i) == 'W') W(posX, posY);
    else if (line.charAt(i) == 'X') X(posX, posY);
    else if (line.charAt(i) == 'Y') Y(posX, posY);
    else if (line.charAt(i) == 'Z') Z(posX, posY);

    // punctuation glyphs
    else if (line.charAt(i) == '.') period(posX, posY);
    else if (line.charAt(i) == ',') comma(posX, posY);
    else if (line.charAt(i) == '-' || line.charAt(i) == '–' || line.charAt(i) == '—' || line.charAt(i) == ':' || line.charAt(i) == ';'|| line.charAt(i) == '('|| line.charAt(i) == ')'|| line.charAt(i) == '['|| line.charAt(i) == ']') dash(posX, posY);
    else if (line.charAt(i) == '?') question(posX, posY);
    else if (line.charAt(i) == '!') exclam(posX, posY);
    else if (line.charAt(i) == '’' || line.charAt(i) == '"' || line.charAt(i) == '“' || line.charAt(i) == '”' || line.charAt(i) == '«' || line.charAt(i) == '»') quote(posX, posY);
  }
}
