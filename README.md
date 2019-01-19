===================== EXIFTOOL TESTING SCRIPTS ==================================

1. Create a "target" directory in the scripts location

2. Add files you want to write to into the target directory
(FAQ)
- It will automatically save an _original so you don't lose the files
- If you wish to restore to just the original files use the cleanup.sch script
- Write.sh will cleanup for itself to always process on the original files whether or not a previous run has been done

3. Execute like:
./write.sh 21 1500 3

Where:
21 is the number of fields
1500 is the number of characters in each field
3 (optional) is the number of time to execute so you can generate an average
