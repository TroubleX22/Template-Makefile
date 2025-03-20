# This creates the necessary functions to make running the program easier
printf "\033[5m\033[94m+-------------------------------------------------------------------------------+\n"
printf "|\033[0m\033[93mMust type \". ./innit\" or \"source ./innit\" for this to work propperly.\033[5m\033[94m          |\n"
printf "|\033[0m\033[93mType \"run\" followed by arguments to run the contents of the compiled program.\033[5m\033[94m  |\n"
printf "+-------------------------------------------------------------------------------+\n\033[0m"

run() {
    LD_LIBRARY_PATH=./bin/ ./bin/program.bin $*;
}