echo Unicode
# Paul Boersma, December 10, 2007

Text reading preferences... UTF-8
Text writing preferences... UTF-8
call test
Text writing preferences... UTF-16
call test
Text writing preferences... try ASCII, then UTF-16
call test
Text writing preferences... try ISO Latin-1, then UTF-16
Text reading preferences... try UTF-8, then ISO Latin-1
call test

Text writing preferences... try ISO Latin-1, then UTF-16
Text reading preferences... try UTF-8, then ISO Latin-1
textgrid = Create TextGrid... 0 1 test
Set interval text... 1 1 åçé
Write to text file... kanweg.TextGrid
textgrid2 = Read from file... kanweg.TextGrid
assert objectsAreIdentical (textgrid, textgrid2)
plus textgrid
Remove

Text writing preferences... try ASCII, then UTF-16
if macintosh
	Text reading preferences... try UTF-8, then MacRoman
elif windows
	Text reading preferences... try UTF-8, then Windows Latin-1
elif unix
	Text reading preferences... try UTF-8, then ISO Latin-1
else
	exit Unknown oprating system.
endif

procedure test

assert length ("éééürtüéŋəü") = 11   ; precomposed (typed into ScriptEditor)
assert length ("éééürtüéŋəü") = 18   ; decomposed (copied from MacOS file icon)
assert "ɦɑlou" + "ɣujədɑx" = "ɦɑlouɣujədɑx"
assert left$ ("ɦɑlou", 3) = "ɦɑl"
assert "ɦɑl" <> "??l"
assert right$ ("ɣujədɑx", 5) = "jədɑx"
assert mid$ ("ɦɑlouɣujədɑx", 4, 5) = "ouɣuj"

# The text I/O commands ">", ">>", and "<":
filedelete kanweg.txt
text$ = "addd"
text$ > kanweg.txt
text$ < kanweg.txt
assert text$ = "addd"
text$ >> kanweg.txt
text$ < kanweg.txt
assert text$ = "adddaddd"   ; 'text$'

# ASCII appending:
filedelete kanweg.txt
fileappend kanweg.txt abc'newline$'
fileappend kanweg.txt def'newline$'
fileappend kanweg.txt ghi'newline$'
text$ < kanweg.txt
assert text$ = "abc" + newline$ + "def" + newline$ + "ghi" + newline$

# UTF-16 appending (or UTF-8, or first ISO Latin-1 then change to UTF-16):
filedelete kanweg.txt
fileappend kanweg.txt åbc'newline$'
fileappend kanweg.txt dëf'newline$'
fileappend kanweg.txt ‘ghi’וּ'newline$'
text$ < kanweg.txt
assert text$ = "åbc" + newline$ + "dëf" + newline$ + "‘ghi’וּ" + newline$

# Append to file first in ASCII, then change the encoding of the whole file to UTF-16:
filedelete kanweg.txt
fileappend kanweg.txt abc'newline$'
fileappend kanweg.txt dëf'newline$'
fileappend kanweg.txt ‘ghi’וּ'newline$'
text$ < kanweg.txt
assert text$ = "abc" + newline$ + "dëf" + newline$ + "‘ghi’וּ" + newline$
assert fileReadable ("kanweg.txt")
filedelete kanweg.txt
assert not fileReadable ("kanweg.txt")

# Unicode file names (precomposed source code):
assert length ("kanweg_abcåbçéü.txt") = 19   ; hopefully not 21
filedelete kanweg_abcåbçéü.txt
fileappend kanweg_abcåbçéü.txt hallo
assert fileReadable ("kanweg_abcåbçéü.txt")
filedelete kanweg_abcåbçéü.txt
assert not fileReadable ("kanweg_abcåbçéü.txt")
fileappend kanweg_abcåbçéü.txt hallo
text$ < kanweg_abcåbçéü.txt
assert text$ = "hallo"

Read from file... åbçéü.wav
select Sound åbçéü
info$ = Info
secondLine = index (info$, "Object type")
header$ = left$ (mid$ (info$, secondLine, 10000), 38)
assert header$ = "Object type: Sound" + newline$ + "Object name: åbçéü" + newline$   ; 'header$'
Remove

Create Strings as file list... list *.txt
n = Get number of strings
for i to n
	fileName$ = Get string... i
	assert right$ (fileName$, 4) = ".txt"
	length = length (fileName$)
	printline 'length' 'fileName$'
	if left$ (fileName$, 10) = "kanweg_abc"
		assert fileName$ = "kanweg_abcåbçéü.txt"   ; 'fileName$'
	endif
endfor
Remove

endproc

printline OK