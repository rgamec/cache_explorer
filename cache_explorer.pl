#! /usr/bin/perl
# 1. Read Chrome's cache directory for all JPEG, PNG, and GIF files.
# 2. Copy these into a local cache folder and rename them with the correct extensions
# 3. Generate the JavaScript array with all the filenames
# 4. Build the HTML file
# 5. Open the HTML file in the default web browser
# TODO: Add help text and version info
# TODO: Add a command-line option for using symlinks instead of copying the files?
use strict;
use warnings;
use File::Copy qw(copy);

# TODO: Rewrite this to accept command-line arguments for different browsers
# Default behaviour is to cycle through all supported browsers and exit the 
# script if none were found.
my $supported_browsers = 0;

# Get current username and attempt to open Chrome's cache folder.
my $username = getpwuid($<);
my @files;
my $chrome_directory = "/Users/$username/Library/Caches/Google/Chrome/Default/Cache/";
if (! -d $chrome_directory){
        print "Google Chrome cache directory could not be found for user '$username'\n";
} else {
        print "Google Chrome cache directory found at " . $chrome_directory . "\n";
        @files = <$chrome_directory/*>;
        $supported_browsers++;
}

# No use in continuing with the script if no cache files have been found.
if ($supported_browsers == 0){
        print "No supported browser cache directories were detected. Exiting.\n";
        exit 1;
}

my $extension;
my $list_of_files = "";
my $images_processed = 0;

# We are using the 'file' tool here to identify the filetypes of each item in the cache
foreach my $file (@files) {
        my $file_info = `file $file`;
        $file_info =~ s|\s+$||g;

        if ($file_info =~ m/image data/){

                if ($file_info =~ m/JPG/){
                        $extension = ".jpg";  		
                } 

                if ($file_info =~ m/PNG/){
                        $extension = ".png";
                } 

                if ($file_info =~ m/GIF/){
                        $extension = ".gif";
                } 
                
                my $new_filename;
                if ($file =~ m/Cache\/(.*?)$/g){
                        $new_filename = "cache_images/" . $1 . $extension;
                        $list_of_files .= "'".$1.$extension."',";
                }

                copy($file, $new_filename);
                $images_processed++;

        }
} 

print "Finished copying " . $images_processed . " images in Chrome's cache to ./cache_images. \n";

# Now writing the HTML file
my $file = "cache_explorer.html";
unless(open FILE, '>'.$file) {
        die "\nUnable to create $file\n";
}

my $file_text = qq#
<!DOCTYPE html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>Cache Explorer</title>
<meta name="viewport" content="width=device-width">
</head>
<body>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
<script>window.jQuery || document.write('<script src="js/vendor/jquery-1.9.0.min.js"><\/script>')</script>
<script src="js/plugins.js"></script>
<script src="js/main.js"></script>
<script>
function createCacheImage () {
var cacheImagesArray = [$list_of_files''];

var img = new Image();
img.src = "cache_images/" + cacheImagesArray[Math.floor(Math.random() * cacheImagesArray.length)];
img.setAttribute('id', "cacheImage"); 
img.style.position = "absolute";
img.style.left = (Math.floor(Math.random() * screen.width) - 150) +"px";
img.style.top = (Math.floor(Math.random() * screen.height) - 150) + "px";
document.body.appendChild( img );
setTimeout( function(){
var elem = document.getElementById("cacheImage");
elem.parentNode.removeChild(elem);
}, 60000);
}

setInterval("createCacheImage()", 300); 
</script>
</body>
</html>
#;

print FILE $file_text;

close FILE;

#system("/usr/bin/open cache_explorer.html");
