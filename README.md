About
=====
This is a ruby script that will download the Android: Netrunner images from the CardGameDB website and save them locally.

Requirements
============
This script is written in Ruby and uses the Watir library. You will need both of these installed to use this script.

The easiest way for Windows users to get started is to download RubyShell from TestWise found [here](https://testwisely.com/en/testwise/downloads). RubyShell includes both Ruby and Watir. 

Usage
=====
Download the cardgamedb-NR-scraper.rb script from this page and save it to locally. 

1. Open a terminal window.
  * E.g. Start > Run > Type "CMD" and hit enter
2. Change directory to the location you saved the script. 
  * E.g. "cd Desktop"
3. Type "ruby cardgamedb-NR-scraper.rb"
4. The script will open your web browser and navigate to the CardGameDB.com page. It will then proceed to download each card from the database.
5. When the script finishes, you should have a new folder on your C:\ drive called "netrunnercards". This folder will contain all the cards that were just downloaded. 
