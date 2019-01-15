# markov_handwriter
A program made with processing that generates handwritten pages of text generated with markov chains, from two text sources. 

## Description

This is a processing based Markov chain text generator, who feeds on the files.txt located in the data folder. The generated are displayed in shapes mimicking handwriting. The program allows to finetune this handwriting font width, height, spacing, interline and the amount of noise added to the vertexes. New pages of text can be generated using the 'refresh' button, and svg files can be saved in the 'output' from the current appearance by using the 'export' button. 
It is set to export file in a A4 format. In my project, the svg paths are the used to trace the handwriting using actual pens or pencils on a CNC plotter, to produce artefact that like like they were produced by the human hand, when they were in fact generated with the program from top to bottom. 

### Prerequisites

You need to have Processing 3 installed on your computer to be able to run the program. Get Processing here: 
    https://processing.org/download/ 

Besides Processing 3, you also need to import: 

— controlP5.* library
    http://www.sojamo.de/libraries/controlP5/
    
—processing.svg.* library
    https://github.com/processing/processing/blob/master/java/libraries/svg/README.md
    
— rita.* library
    https://rednoise.org/rita/


### Installing

open the markov_handwriter.pde file in Processing 3, and run the program. The window will display an initial generated text from your defined source texts (located in the 'data' folder, and called in the global variables: "bible.txt", "simpson.txt"). Use the various controllers to generate new texts, adjust the letters style and hit export when happy. You can then retrieve the svg file in the 'output' folder. And repeat.


## Built With

* [Processing](https://processing.org/download/) - The framework used
* [controlP5.*](http://www.sojamo.de/libraries/controlP5/) - Library used for the controllers/buttons.
* [processing.svg.*](https://rometools.github.io/rome/) - Library used for the svg exporting.
* [rita.*](https://rednoise.org/rita/) - Library used for the Markov chain text generator.

## Authors

* **Julien Mercier** - *Markov Handwriter* - [djebel-amila](https://github.com/djebel-amila)

This project was made as part of the 'Programming for artists' class taught by Lior Ben Gai. Goldmsmiths University, MA Computational Arts 2019. 


## License

This project is licensed under the GNU General Public License v3.0 - see the https://www.gnu.org/licenses/gpl-3.0.txt for details. 

## Acknowledgments

References used for the project: 

* https://rosettacode.org/wiki/Execute_a_Markov_algorithm#Java

* https://rednoise.org/rita/

* Daniel Schiffman tutorials (on P5.js) for a Markov chain text generator
  https://shiffman.net/a2z/markov/

* Daniel Schiffman’s “Thesis generator” using Markov chains
  https://github.com/shiffman/A2Z-F16/blob/gh-pages/week7-markov/07_Thesis_Project_Generator/index.html
  
* Allison Parish’s “Generative Course Descriptions” using Markov chains
  http://static.decontextualize.com/toys/next_semester?

* Chris Harrison’s “Web Trigrams” using Markov chains
  http://www.chrisharrison.net/index.php/Visualizations/WebTrigrams

* “Learning Processing”, Daniel schiffman, chapter 8: “Objects”.

* A list of every Bart Simpson’s blackboard quote to date: 
  http://simpsons.wikia.com/wiki/List_of_chalkboard_gags

* King James’ Bible on the Gutenberg project: 
  http://www.gutenberg.org/files/10/10-h/10-h.htm

* A little theory on Markov chains
  https://www.analyticsvidhya.com/blog/2014/07/markov-chain-simplified/

* Even more theory on Markov chains
  http://www.cs.princeton.edu/courses/archive/spr05/cos126/assignments/markov.html
