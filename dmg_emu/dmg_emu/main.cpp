#include "CPU.h"
#include "Video.h"

int main(int argc, char** argv) {

	if (argc != 3) {
		std::cout << "Usage: dmg_cpu <output file> <input file>\n";
		return(0);
	}

	char* cartridgePath = argv[2];
	char* outputFilePath = argv[1];

	std::cout << "Memory file: " << cartridgePath << "\n";
	std::cout << "Output file: " << outputFilePath << "\n";

	// Create the emulator with disabled sound and video
	Sound* sound = NULL;
	Video* video = new Video(NULL);
	CPU cpu = CPU(video, sound);
	//char* cartridgePath = "C:\\Users\\Joseph\\Documents\\F13\\18545\\programs\\asm\\out.x";
	char* batteriesPath = "";

	Cartridge* cartridge = new Cartridge(cartridgePath, batteriesPath, 1);

	cpu.LoadCartridge(cartridge);
	cpu.ResetDebug();

	//cpu.ExecuteInstructions(10);
	cpu.ExecuteUntilHalt(1000);

	std::ofstream outputFile;
	outputFile.open(outputFilePath);

	if (!outputFile.is_open()) {
		std::cout << "Error opening file " << outputFilePath << "\n";
		return 0;
	}

	//std::cout << cpu.GetPtrRegisters()->RegDump();

	outputFile << cpu.GetPtrRegisters()->RegDump();

	outputFile.close();

	//getchar();

	return 0;
}