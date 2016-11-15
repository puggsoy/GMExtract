# GMExtract
This is a tool to extract sprites from the data.win file of games made with Game Maker Studio.

Currently code is being refactored and adding support for extracting audio is being looked into.

## Usage
	Usage: GMExtract inFile outDir [-e]
		inFile: The data.win file to extract from
		outDir: The folder to save the extracted files to
		[-e]: Optionally exclude consecutive duplicates

## Compilation
The code should be compiled as a Neko or C++ command-line program (only tested in Neko).