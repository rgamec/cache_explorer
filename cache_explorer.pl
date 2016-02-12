#! /usr/bin/perl
# 1. Read Chrome's cache directory for all JPEG, PNG, and GIF files.
# 2. Copy these into a local cache folder and rename them with the correct extensions
# 3. Generate the JavaScript array with all the filenames
# 4. Build the HTML file
# 5. Open the HTML file in the default web browser
use File::Copy qw(copy);

 @files = </Users/robertgame/Library/Caches/Google/Chrome/Default/Cache/*>;
 my $extension;

$list_of_files = "";


 foreach $file (@files) {
   $file_info = `file $file`;
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

	   	if ($file =~ m/Cache\/(.*?)$/g){
	   		$new_filename = "/Users/robertgame/Scripts/bin/cache_images/" . $1 . $extension;
	   		$list_of_files .= "'".$1.$extension."',";
	   	}

	   	copy($file, $new_filename);

   	}

   

 } 

print "Finished moving all images in Chrome's cache to a local folder . . .";

# Now writing the HTML file
my $file = "cache_explorer.html";

unless(open FILE, '>'.$file) {

	die "\nUnable to create $file\n";
}





$file_text = qq#
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>Cache Explorer</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width">
    <link rel="stylesheet" href="css/normalize.css">
    <link rel="stylesheet" href="css/main.css">
    <script src="js/vendor/modernizr-2.6.2.min.js"></script>
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
