#!/usr/bin/perl -I ../src
                 
use Test::More;
 
use_ok('Signal');


#
#  Checks that the file is properly splitted.
#

open $fh, "<", "data/9778"
    or die "could not open $file: $!";

$results = Signal::STDIN2Array($fh);
@results = @{$results};

is( $#results => 3, "Several messages within the same sync event");

$result = Signal::raw2Org($results[0]);
is( %{$result}{"body"} => '- <2019-06-21> Test 1'
    , "it extracted the first short message");

$result = Signal::raw2Org($results[$#results]);
is( %{$result}{"body"} => '- <2019-06-21> Test 4'
    , "it extracted the last short message");


#
#  Single image with payload.
#

$rawMessage = "Envelope from: +573046414121 (device: 1)
Timestamp: 1621785289028 (2021-05-23T15:54:49.028Z)
Sender: +573046414121 (device: 1)
Server timestamps: received: 1621785301086 (2021-05-23T15:55:01.086Z) delivered: 1621785304610 (2021-05-23T15:55:04.610Z)
Message timestamp: 1621785289028 (2021-05-23T15:54:49.028Z)
Body: Test image
Expires in: 3600 seconds
Profile key update, key length: 32
Attachments:
- Attachment:
  Content-Type: image/jpeg
  Type: Pointer
  Id: 1T-sdxojoKGLR7Qj1dU2 Key length: 64
  Upload timestamp: 1621785282234 (2021-05-23T15:54:42.234Z)
  Size: 78182 bytes
  Voice note: no
  Borderless: no
  Dimensions: 1080x866
  Stored plaintext in: /root/.local/share/signal-cli/attachments/1T-sdxojoKGLR7Qj1dU2;";


$result = Signal::raw2Org($rawMessage);
is( %{$result}{"body"} => '- <2021-05-23> Test image
  - [[/small/SMALL/images/1T-sdxojoKGLR7Qj1dU2.jpeg][1T-sdxojoKGLR7Qj1dU2.jpeg]]', 'Payload with single image');


#
#  Several messages with payload
#

open $fh, "<", "data/3909"
    or die "could not open $file: $!";

$results = Signal::STDIN2Array($fh);
@results = @{$results};

is( $#results => 1, "several messages with payload");

$result = Signal::raw2Org($results[0]);
is( %{$result}{"body"} => '- <2019-06-21> aaBB 90_ pf:
  - [[/small/SMALL/images/ucTGM0Zp6j6RxuKckdFH.jpeg][ucTGM0Zp6j6RxuKckdFH.jpeg]]'
    , "it extracted the first message with its image");

$result = Signal::raw2Org($results[$#results]);
is( %{$result}{"body"} => '- <2019-05-17> xxyyzz 112233. +:
  - [[/small/SMALL/images/zcHkwVpJV8pA9EWi06py.jpeg][zcHkwVpJV8pA9EWi06py.jpeg]]'
    , "it extracted the first message with its image");


#

####
####  Large message reduced to paylad
###
###open $fh, "<", "data/5265"
###    or die "could not open $file: $!";
###
###$results = Signal::STDIN2Array($fh);
###@A = @{$results};
###is( $#A => 2, "it found the right number of messages");
###
###$result = Signal::raw2Org($A[0]);
###is( %{$result}{"body"} => '- <2019-06-21> askdjklasjdkla sdnklasjdkljmakls sjdkljaskldjklasj k823798273.'
###    , "it extracted the first short message");
###
###
###$result = Signal::raw2Org($A[1]);
###is( %{$result}{"body"} => '- <2019-06-21> Expires in 1800 seconds (ALsahjsk Aaiwei).
###  - https://a.wordpress.com/sdjlkjasdkl-sdjsdkljklj/
###    - Es aa sdjsl;kdjklj0 payr sdfjkl;sdjf sdj sdk;lskd.
###  - AAAAAA
###    - bb ccc ddddddd eee fff ggggggg hhhhhhhhh, iii jjjjj k lllllll
###  mmm nn oooooooo.
###  - Pp qq rrr sssssssss tt xxxxxxx yyyyyyyy zzz aaa bbbbbbb.
###    - cc ddd eeeeeeeeeeee ffff gg hhhhhhhh
###    - ii oooooooo pp qqqqqqqq rr sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz
###  ashnljkajasl sdjskljklsdj sdjlsjdklsjd a ajskljsalk sdjlsjdklj.
###  - aaaa bbbbbb c dd eee fff gggggggg, hh iiiiiiii j kkkkkk.
###    - lllllllll mm nnnnnn oooooooo.
###  - BBBBBBBBB
###    - bb ccc ddddddd eee fff ggggggg hhhhhhhhh, iii jjjjj k lllllll
###  mmm nn oooooooo.
###  - Pp qq rrr sssssssss tt xxxxxxx yyyyyyyy zzz aaa bbbbbbb.
###    - cc ddd eeeeeeeeeeee ffff gg hhhhhhhh
###    - ii oooooooo pp qqqqqqqq rr sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz
###  ashnljkajasl sdjskljklsdj sdjlsjdklsjd a ajskljsalk sdjlsjdklj.
###  - aaaa bbbbbb c dd eee fff gggggggg, hh iiiiiiii j kkkkkk.
###    - lllllllll mm nnnnnn oooooooo.
###  - ii oooooooo pp qqqqqqqq rr sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz:
###    - cc ddd eeeeeeeeeeee?
###    - nnnnnn oooooooo?
###    - sdjlsjdklsjd a ajskljsalk sdjlsjdklj?
###  - bb ccc ddddddd eee fff.
###    - ii oooooooo pp qqqqqqqq rr sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz.
###  - fff gggggggg, hh iiiiiiii j kkkkkk
###    - fff gggggggg, hh iiiiiiii j kkkkkk.
###    - fff gggggggg, hh iiiiiiii j kkkkkk "sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz
###  fff gggggggg"
###  -  a ajskljsalk  a ajskljsalk  a ajskljsalk  a ajskljsalk.
###  - sdjlsjdklsjd
###    - sdjlsjdklsjd a ajskljsalk
###    - ashnljkajasl sdjskljklsdj sdjlsjdklsjd a ajskljsalk sdjlsjdklj
###  sdjlsjdklsjd a ajskljsalk.
###  -
###  - [[/small/SMALL/images/631166565003315923.txt][631166565003315923.txt]]', "the larger message was reduced to a payload");
###
###
###$result = Signal::raw2Org(@{$results}[2]);
###is( %{$result}{"body"} => '- <2019-06-21> Expires in 1800 seconds (ALsahjsk Aaiwei).
###  - https://a.wordpress.com/sdjlkjasdkl-sdjsdkljklj/
###    - Es aa sdjsl;kdjklj0 payr sdfjkl;sdjf sdj sdk;lskd.
###  - AAAAAA
###    - bb ccc ddddddd eee fff ggggggg hhhhhhhhh, iii jjjjj k lllllll
###  mmm nn oooooooo.
###  - Pp qq rrr sssssssss tt xxxxxxx yyyyyyyy zzz aaa bbbbbbb.
###    - cc ddd eeeeeeeeeeee ffff gg hhhhhhhh
###    - ii oooooooo pp qqqqqqqq rr sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz
###  ashnljkajasl sdjskljklsdj sdjlsjdklsjd a ajskljsalk sdjlsjdklj.
###  - aaaa bbbbbb c dd eee fff gggggggg, hh iiiiiiii j kkkkkk.
###    - lllllllll mm nnnnnn oooooooo.
###  - BBBBBBBBB
###    - bb ccc ddddddd eee fff ggggggg hhhhhhhhh, iii jjjjj k lllllll
###  mmm nn oooooooo.
###  - Pp qq rrr sssssssss tt xxxxxxx yyyyyyyy zzz aaa bbbbbbb.
###    - cc ddd eeeeeeeeeeee ffff gg hhhhhhhh
###    - ii oooooooo pp qqqqqqqq rr sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz
###  ashnljkajasl sdjskljklsdj sdjlsjdklsjd a ajskljsalk sdjlsjdklj.
###  - aaaa bbbbbb c dd eee fff gggggggg, hh iiiiiiii j kkkkkk.
###    - lllllllll mm nnnnnn oooooooo.
###  - ii oooooooo pp qqqqqqqq rr sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz:
###    - cc ddd eeeeeeeeeeee?
###    - nnnnnn oooooooo?
###    - sdjlsjdklsjd a ajskljsalk sdjlsjdklj?', 'the third message was properly found');
###
###
####
#### Link largo 
####
###
###$rawMessage = "Envelope from: +593001112131 (device: 1)
###Timestamp: 1561328937220 (2019-06-23T22:28:57.220Z)
###Message timestamp: 1561328937220 (2019-06-23T22:28:57.220Z)
###Body: askdjklasjdkla sdnklasjdkljmakls sjdkljaskldjklasj: https://www.google.com/url?sa=t&source=web&rct=j&url=https://chrome.google.com/webstore/detail/web-server-for-chrome/ofhbbkphhbklhfoeikjpcbhemlocgigb%3Fhl%3Den&ved=2ahUKEwipuuid04DjAhWswVkKHdkFAwEQFjABegQIDxAJ&usg=AOvVaw37MqUO7yBo81gh1Cz1IBP4&cshid=1561328884694
###Expires in: 1800 seconds
###Profile key update, key length:32";
###
###$result = Signal::raw2Org($rawMessage);
###is( %{$result}{"body"} => '- <2019-06-23> askdjklasjdkla sdnklasjdkljmakls sjdkljaskldjklasj: https://www.google.com/url?sa=t&source=web&rct=j&url=https://chrome.google.com/webstore/detail/web-server-for-chrome/ofhbbkphhbklhfoeikjpcbhemlocgigb%3Fhl%3Den&ved=2ahUKEwipuuid04DjAhWswVkKHdkFAwEQFjABegQIDxAJ&usg=AOvVaw37MqUO7yBo81gh1Cz1IBP4&cshid=1561328884694', 'Link largo');
###
###
###
###
####
####  Png payload
####
###
###$rawMessage = "Envelope from: +593001112131 (device: 4)
###Timestamp: 1561127605099 (2019-06-21T14:33:25.099Z)
###Message timestamp: 1561127605099 (2019-06-21T14:33:25.099Z)
###Body: Pp qq rrr sssssssss tt xxxxxxx yyyyyyyy zzz aaa bbbbbbb
###Expires in: 1800 seconds
###Profile key update, key length:32
###Attachments: 
###- image/png (Pointer)
###  Id: 8340409706930788346 Key length: 64
###  Filename: image.png
###  Size: 105030 bytes
###  Voice note: no
###  Dimensions: 784x465
###  Stored plaintext in: /root/.local/share/signal-cli/attachments/8340409706930788346";
###
###$result = Signal::raw2Org($rawMessage);
###is( %{$result}{"body"} => '- <2019-06-21> Pp qq rrr sssssssss tt xxxxxxx yyyyyyyy zzz aaa bbbbbbb
###  - [[/small/SMALL/images/8340409706930788346.png][8340409706930788346.png]]', 'Png payload');
###
###
###

done_testing();
