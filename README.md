# NOTICE:
*This project is no longer being worked on and will not be updated. See this project's successor [GMS Explorer](https://github.com/puggsoy/GMS-Explorer).*

# GMExtract
This is a tool to extract sprites from the data.win file of games made with Game Maker Studio.
Lots of credit to PoroCYon for the info [here](https://gitlab.com/snippets/14944) and Mirrawrs for the info [here](http://undertale.rawr.ws/unpacking), most of the knowledge needed for this came from them.

## Usage
You can either double-click on the executable to bring up dialogues to choose the input file and output directory, or run it via the command-line:

	Usage: GMExtract inFile outDir [-s|-a]
		inFile: The data.win file to extract from
		outDir: The folder to save the extracted files to
		-s: Only extract sprites
		-a: Only extract audio

Note that if run using the first method it will extract both sprites and audio.

## Compilation
The code should be compiled as a Neko or C++ command-line program (only tested in Neko).
