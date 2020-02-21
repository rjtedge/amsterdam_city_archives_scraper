Amsterdam City Archives Scraper
================================

Ruby script to scrape images from the Amsterdam City Archives

The software is run as a script, so you will need some familiarity with the command line. This has been developed and tested on ubuntu but has also been tested on Mac and Windows with no errors.

You'll need at least [Ruby](http://ruby-lang.org) 2.1 to run this, or better yet the latest stable release. 

To intall and set up the script follow the instructions below:

### Mac

-


### Windows
- Download the [RubyInstaller for Windows](https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.5-1/rubyinstaller-devkit-2.6.5-1-x64.exe). 
- Open the rubyinstaller-devkit-2.6.5-1-x64.exe file and follow the prompts
- Open CMD by hitting the Windows followed by c m d keys and then hit Enter (You should see a sceen reminicent to a very old DOS computer). 
- In CMD, type or copy/paste the following and then hit Enter
```
ruby -v
```
- You should see "ruby 2.6.5' or similar. If you don't see this an error in installing has occured. 
- Once Ruby is installed you can proceed to the next step
- While still in CMD type  or copy/paste the following and then hit Enter to install required dependencies
```
gem install httparty activesupport pp fileutils yaml
```
- You should see some new lines of text and eventually "4 gems installed"
- Download the [amsterdam_city_archives_scraper script](https://github.com/rjtedge/amsterdam_city_archives_scraper/archive/master.zip)
- Unpack the zip file to a new folder on your computer. 
- You are now read to get started. 

## Use
### CONFIG
Open the folder where you unpacked the script and then open the config.cfg file in a basic text editor TextEdit on Mac or Notepad on Windows. 

The following options are required and you edit each option after the ":" 
```
inventory_number: 30123
archive_ref: 3.3.1
archive_abriviation: NOT
```
#### inventory_number
This is the main Inventory number from the archive. You find this by examining the url of the inventory you are going to download. e.g. https://archief.amsterdam/inventarissen/details/5075/withscans/0/start/0/limit/10/flimit/5 is the inventory  Inventory of the Archive of Notaries in Amsterdam. In the url you will see ...details/5075/... the number is the inventory number. This number is also on the heading of the Inventory page. 

#### archive_ref
This is the specific cache of images you want to download. You can find this by click on one of the images you want download and examining the url. For example https://archief.amsterdam/inventarissen/scans/5075/44.1.1/start/0/limit/10/highlight/1 is the url for the first book of the notary Benedict Baddel. 
In the url you will see .../scans/5075/44.1.1/... the second numbers with the fullstops (not the inventory number) is the archive reference number. 
Depending on what you are looking to download this could be 1 number (44), 2 numbers seperatd by a fullstop (2.2) or 3 or more numbers serperated by a fullstop (50.6.3.2.1). You will need to copy all parts of this number into the config file. 

#### archive_abriviation
This is a reference that you want to use to name your files. It is best to keep this to three charaters. You can use what ever you want for this. E.g PJC for Portuguese jewsih community or NOT for Notary etc etc. 

Ok save the config.cfg file and close the text editor. 

### RUN
Now you need to open up the command line Terminal(Mac) or CMD (Windows) - (For Mac Hit Apple Space Bar then type terminal and hit enter. For Windows hit the Windows key followed by c m d keys and then hit Enter) 

In the command line you need to change the working directory to where you unpacked the zip file. 

** On Windows ** you need to type or paste the following and hit enter (note the backslash on windows)
```
cd path\to\your\uppacked\zip\
```
If your folder is on the desktop the path will be something like Users\USERAME\Desktop\amsterdam_city_archives_scraper\ you can find it my right clicking on the folder and click Properties and looking for the 'Location' info. 

** On Mac ** you need to type or paste the following and hit enter
```
cd path/to/your/uppacked/zip/
```
If your folder is on the desktop the path will be something like /Users/USERAME/Desktop/amsterdam_city_archives_scraper/ you can find it my right clicking on the folder and click Get Info and looking for the 'Where' info.

Once you are at the right directory you need to type or paste the following and hit enter.
```
ruby amstarch.rb
```

At this point you will get a constant feed of information on what is happening and eventually end with "FINISHED: Downloaded images". The steps displayed are:
1. "Inventory Found" (meaning the connection seems ok)
2. "Getting page X of X" (it will load the images 50 at a time so if there are 200 images, there will be 4 pages)
3. "Downloading image X of X" (displays how many images are remaining)
4. "FINISHED: Downloaded images" (this is the end)

### Your new files
Your files will save in a new folder inside the folder where the script is found. The script will display the folder name at the end o the run. Folder naming is <inventory_number><archive_abriviation><archive_ref>

Each file is named <inventory_number><archive_abriviation><archive_ref><p><pagenumber>.jpg For example, the first image in the first book of the notary Benedict Baddel will be 5075NOT44.1.1p1.jpg the 10th image will be 5075NOT44-1-1p10.jpg








