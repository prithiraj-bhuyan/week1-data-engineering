# Work only inside the reviews folder (keeps output clean; avoids venv and other parent dirs)
cd reviews

# Hint: Use . to represent the current directory in your commands
############################################################
# TODO 1 — List the names of all .txt files that contain the word "great" (case-insensitive)
# Hint: Use grep with appropriate flags
############################################################
# -r searches subfolders, -i ignores case, and -l lists matching files.
# --include limits the search to the *.txt pattern. * matches any text.
grep -ril --include="*.txt" "great" .

############################################################
# TODO 2 — Count how many .txt files mention the word "programming" (case-insensitive)
# Hint-1: You can use pipes to combine commands
# Hint-2: We are counting files, not occurrences
############################################################
# | sends the file list to wc -l, which counts its lines.
grep -ril --include="*.txt" "programming" . | wc -l

############################################################
# TODO 3 — Replace all email addresses in .txt files with <EMAIL_REMOVED> in place and create a backup with .bak extension
# Hint: Use sed with regex for a single file first
############################################################
# The loop runs once per .txt file. "$file_name" keeps spaces in a name together.
# -E enables extended regex. -i.bak edits the file and saves the original as .bak.
# s/pattern/replacement/g replaces every match on each line. Single quotes keep the script literal.
# [...] matches one character from the set. + means one or more, {2,} means at least two, and \. matches a dot.
for file_name in *.txt; do
  sed -E -i.bak 's/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/<EMAIL_REMOVED>/g' "$file_name"
done

# Alternative: -type f selects files, -name filters names, and -exec ... {} + passes matches in batches.
# A trailing \ continues the command. On macOS, -i '' skips the backup.
# > /dev/null discards output. 2>&1 sends errors to the same destination.
# find . -type f -name "*.txt" -exec \
#   sed -E -i '' 's/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/<EMAIL_REMOVED>/g' {} + > /dev/null 2>&1

############################################################
# TODO 4 — From books_metadata.csv, print only the Title and Price columns (space-separated; skip the header)
# Hint: Use awk to select specific columns (skip header row)
# Challenge: Do it by dynamically finding the column numbers based on the header row
############################################################
# -F sets the field separator. NR is the row number, so NR>1 skips the header.
# $2 and $5 select fields. The comma in print separates them with a space.
awk -F ',' 'NR>1 {print $2, $5}' books_metadata.csv

# Header lookup: NR==1 selects the first row, NF counts fields, and $i reads field i.
# next skips to the next row after saving the column numbers.
# awk -F, '
# NR==1 {
#   for(i=1;i<=NF;i++) if($i=="title") t=i; else if($i=="price") p=i
#   next
# }
# {print $t, $p}
# ' books_metadata.csv

############################################################
# TODO 5 — Count how many books are free (is_free == True)
# Hint: Use awk to filter and count, use END {} to print the final count
# Challenge: Do it by dynamically finding the column number based on the header row
############################################################
# && requires both conditions. == checks equality and n++ adds one per match.
# END runs after all rows. n+0 prints 0 if there were no matches.
awk -F ',' 'NR>1 && $4=="True" {n++} END {print n+0}' books_metadata.csv

# tolower makes the comparison case insensitive.
# awk -F ',' 'NR>1 && tolower($4)=="true" {n++} END {print n+0}' books_metadata.csv

# awk -F, '
# NR==1 { for(i=1;i<=NF;i++) if($i=="is_free") c=i; next }
# tolower($c)=="true" {n++}
# END {print n+0}
# ' books_metadata.csv