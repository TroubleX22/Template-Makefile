# MAKEFILE Template for  C/C++
This is a basic template for a MAKEFILE that I created to make it as simple as possible to compile Linux code. It started as a project for Windows, but scrapped it and turned it into a Linux project because this was the environment that I would be handeling for a recent project.

## Instructions
### Directories and their meanings
This MAKEFILE relies on a specific directory structure to work. I do not recomend changing it except at your own risk.

Run `make innit` to generate the folder structure. This will create the following folders:
+ src/ -> Where your standard .c and .cpp files are stored
+ obj/ -> Where the compiled files from src/ and objects from libraries/ are stored.
+ bin/ -> Where the finished compiled binaries and shared objects are stored.
+ shared_src/ -> All these source files are compiled into shared objects and are automatically linked.
+ includes/ -> A place to hold library headers. Will automatically include these.
+ libraries/ -> Hold files for libraries. Library object files are automatically copied to obj/ and shared objects are automatically coppied to bin/. The structure should have a directory for every library and be one directory deep with all object and shared object files  Structure should be: 
```
libraries/
 ├ library_1/
    ├ libmyCode.so (lib- prefix is necessary for linking .so files)
    └ myCode.o
 ├ library_2/
    └ directory/ (Warning: Will not reconize files within this and following directories)
 └ library.../
    └ ...
 ```

### Running the program
While you can easily run the program with some commands, I wanted to streamline it without having to set shared object locations and anything else. So there is a file called **innit.sh**. You run it with either `source ./innit.sh` or `. ./innit.sh` which will source it so that you can use the function it generates. When ran, you should get a box that says how to use it.

If done correctly, you should now be able to run the program by typing `run` into your terminal. You can run with command line arguments by adding them to the end, like this `run Hello! -a --help`.

### Modifying the MAKEFILE
Here are the recomended ways to modify the MAKEFILE:
+ You can change the compiler(s) by changing the CC or CPPC macro. CC stands for C compiler, and CPPC stands for C Plus Plus Compiler. Keep in mind that you might have to change the arguments for the compiler as well.
+ To add libraries or other compiler commands, change the FLAGS and LIBRARIES macros. Example: `FLAGS := -Wall -E` and `LIBRARIES := -lxcb -lncurses`.
+ Main binary name (Will have to also update [innit.sh](#running-the-program))
+ Directory names.

### Cleaning
If you run the `make clean` rule, it will clear the obj/ directory of object files (.o and [.opp](#what-is-opp-file-extension)) and all files in bin/ .

### What is .OPP file extension
**.OPP** is It is a file extension created to help the makefile know between C and C++ objects. I believe it is obsolete now, but I feel no desire to remove it, so it is staying.

### Liscense?s
Feel free to modify and take complete credit. Do not change the original repository. I recomend if you want to make a new public version of this makefile, just fork it.