To run our processor, you have to change the file location in intr_ROM to find the correct machine code file depending on if you are running program 1, 2, or 3. Also, when you create your simulation project in Questa or ModelSim, make sure to only include PC_LUT1, 2, or 3 depnding on which rpogram you are using. Do not upload all three SV files to the project as all of them contain a module with the same name, "PC_LUT", and the simulation will not work.