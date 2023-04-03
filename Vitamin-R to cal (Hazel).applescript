(*
Script was written by Alexander Orokhovatskiy. 2023
If you want to help edit script - write me in email orokhovatskiy@gmail.com

For correcting work you need:
	Hazel app. This app tracks changes in files and can run embedded script to do something that you want
	Fantasticl - Calendar-app. It has CLI interface that we will use
	
In Hazel I have three rules:
	"01.Creating TXT-copy" Creating TXT copy of RTFD log-file of Vitamin-R 4 by shell-script: command: textutil -convert txt "$1"
	"02.Create counter file" Creating counter-file for log-file. We need it because when you add new event to Vitamin-R log - you should understanding when you finished. I have shell checker for Hazel + easy shell-script in action that create empty counter file
	"03.Parse TXT-file and create event in Fantastical" Parsing TXT log-file and creating events in Fantastical. IMPORTANT: for new day you will find events in Fantastical since second record because of Hazel Match checker.	
	
Changelog:
	v.1.1 - Add parsing tags in objects. Tags using for understanding to which calendar create event. Also did code a little bit easier
	v.1.0 - Initial script
*)

-- Define variables
set objectiveData to "" -- Saving filtering parameters that I want to extract for my events in Fantastical
set LastLineInLogThatAdded to "" -- Saving parsing position and start parsing since the saved anchor
set FileCounterVALUE to ""
set CounterFileSumPath to ""
set objective to ""
set tags to ""
set actualDuration to ""
set startDate to ""

-- Debug-path. Uncomment it to use path to specific log instead of use it in Hazel
-- set theFile to "Users:orokhovatskiy:Library:Containers:net.publicspace.mas.vitaminr4:Data:Library:Application Support:Vitamin-R 4:System Logs:System Log Day 2023-04-03 (bcd0745ec37c).txt"

-- Read the counter-file and placen when we finished before
set CounterFileSumPath to theFile & ".count" as text -- Concatenate theFile variable from Hazel (it gives full path to the file that Hazel works with)
set CounterFilePATH to file CounterFileSumPath as alias -- Create alias to counter-file
set CounterFile to read file CounterFilePATH -- Read file
set LastLineInLogThatAdded to CounterFile -- Read value

-- Read and parsing the general LOG-file
set LogFilePATH to file theFile as alias -- Create alias to parsing-file (to .txt Log-file)
set LogFile to read file LogFilePATH as «class utf8» -- Read the Log-file
set timeSlices to paragraphs of LogFile -- Split the log file into separate time slices

-- Parse each time slice
repeat with i from 1 to count timeSlices
	set timeSlice to item i of timeSlices
	
	if (i > LastLineInLogThatAdded) then -- Start since the place when we finished
		-- Extract the objective from the time slice
		if timeSlice contains "#objective" then
			set i to i + 1
			set timeSlice to item i of timeSlices
			set objective to timeSlice
		end if
		
		-- Extract tags from the time slice
		if timeSlice contains "#tags" then
			set i to i + 1
			set timeSlice to item i of timeSlices
			set tags to timeSlice
		end if
		
		-- Extract the duration from the time slice
		if timeSlice contains "#actualDuration" then
			set i to i + 1
			set timeSlice to item i of timeSlices
			set timeSlice to timeSlice / 60
			set actualDuration to timeSlice
		end if
		
		-- Extract the date from the time slice
		if timeSlice contains "#startDate" then
			set i to i + 1
			set timeSlice to item i of timeSlices
			set startDate to timeSlice
		end if
		set objectiveData to "/" & tags & " for " & actualDuration & " min " & objective & " " & startDate
	end if
	set MaximumLinesInLog to i
end repeat

-- Write position when we finished
set CounterFileSumPath to theFile & ".count" as text
set CounterFilePATH to file CounterFileSumPath as alias
set full_message to return & MaximumLinesInLog
set CounterFile to open for access file CounterFilePATH with write permission
set eof CounterFile to 0
write full_message to CounterFile starting at eof
close access CounterFile 
	
-- Creating events in fantastical
set timeSlices to paragraphs of objectiveData

repeat with i from 1 to count timeSlices
	set object to item i of timeSlices
	-- display dialog object -- Debug command to check what Fantastical will get
	tell application "Fantastical"
		parse sentence object with add immediately
	end tell
end repeat