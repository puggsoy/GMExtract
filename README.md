# GMExtract
This is a tool to extract sprites from the data.win file of games made with Game Maker Studio.

## Usage
You can either double-click on the executable to bring up dialogues to choose the input file and output directory, or run it via the command-line:

	Usage: $pName inFile outDir [-s|-a]
		inFile: The data.win file to extract from
		outDir: The folder to save the extracted files to
		-s: Only extract sprites
		-a: Only extract audio

Note that if run using the first method it will extract both sprites and audio.

## Compilation
The code should be compiled as a Neko or C++ command-line program (only tested in Neko).