# Vitamin-R_to_Calendar
Automation for sync Vitamin-R (pomodoro app) with Calendar (Fantastical)

### Requirements:

- Hazel. This app tracks changes in files and can run embedded script to do something that you want
- Vitamin-R. Pomodoro technik app
- Fantastical. Calendar-app. It has CLI interface that we will use

### Hazel configuration, 3 rules:

- **01.Creating TXT-copy**. Creating TXT copy of RTFD log-file of Vitamin-R 4 by shell-script: command: textutil -convert txt "$1"
- **02.Creating counter file**. Creating counter-file for log-file. We need it because when you add new event to Vitamin-R log - you should understanding when you finished. I have shell checker for Hazel + easy shell-script in action that create empty counter file
- **03.Parse TXT-file and create event in Fantastical**. Parsing TXT log-file and creating events in Fantastical. IMPORTANT: for new day you will find events in Fantastical since second record because of Hazel Match checker.	

#### Screenshots of Hazel rules:

![01.Creating TXT-copy](src/01.png)

![02.Creating counter file](src/02.png)

![03.Parse TXT-file and create event in Fantastical](src/03.png)
