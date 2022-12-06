# file-generator

## file generator
***filegen.sh*** is a MALWARE tool made in educational purposes. It's functionality is clogging the system with files and reducing its available hard disk memory. Launch at your own risk.

***filegen.sh*** has two working modes:
    1. local
    2. global

Important note:

To start the execution of the script, call ```./filegen.sh``` from the terminal.


## file cleaner
***cleaner.sh*** is a file cleaning tool that will remove all the redundant files previously created by ***filegen.sh***.

***cleaner.sh*** supports clearint the previously generated files by:
    1. log file (requires the absolute path to the file to be inserted as the 2nd parameter)
    2. creation date and time (in the exact format of *YYYY-MM-DD_HH:MM--YYYY-MM-DD_HH:MM*)
    3. name mask (i.e. characters, underlining and date, in the exact format of *abc_YYMMDD*)

Important note:

To start the execution of the script, call ```./cleaner.sh``` from the terminal.