#!/usr/bin/perl -l
local $/ = "\n\n";

for(<>){
    @A = split("\n", $_);
    my $start = 0;
    my $body = "";
 
    my $line = 0;
    for(@A){
       if (/Message timestamp:.+\((.+)T.+$/){
           $body = $body."- <$1>\n";
           next;
       }
       $line = $line + 1;
       if (/Body:\s(.+)/){
           $start = 1;
           $body = $body."  ".$1;
           next;
       }
       if (/Profile/){
           $start = 0;
           last;
       }
       $body = "$body\n  $_" if($start);
    }

    if(! ($A[$#A] =~ "Profile key update, key length:32")){
       $body = "$body " if(!($body =~ "- <.+>\n"));
       $filename = $1 if($A[$line + 3] =~ /Id:\s+(\d+)\sKey.+$/);
       $file = $1 if($A[$line + 8] =~ /Stored plaintext in:\s+(.+)$/);
       `cp $file /small/SMALL/images/$filename`;
       $body = "$body  - [[/small/SMALL/images/$filename][$filename]]" 
    }
 
    print $body;
}
                       
