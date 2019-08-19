#!/usr/bin/perl -I ../src
                 
use Test::More;
 
use_ok('Signal');


#
#  The string to array is working properly.
#

$rawMessage = "Envelope from: +593001112131 (device: 1)
Timestamp: 1561060280528 (2019-06-20T19:51:20.528Z)
Message timestamp: 1561060280528 (2019-06-20T19:51:20.528Z)
Body: Es aa sdjsl;kdjklj0 payr sdfjkl;sdjf sdj sdk;lskd.
Expires in: 1800 seconds
Profile key update, key length:32
Attachments: 
- image/jpeg (Pointer)
  Id: 3110560937290313920 Key length: 64
  Filename: -
  Size: 131256 bytes
  Voice note: no
  Dimensions: 1024x1911
  Stored plaintext in: /root/.local/share/signal-cli/attachments/3110560937290313920";

$results = Signal::string2Array($rawMessage);
is( @{$#results} => 0, "String2Array proper result length");
is( @{$results}[0] => $rawMessage, "String2Array the array has the right element");


#
#  JPEG payload'
#

$results = Signal::raw2Org($rawMessage);
is( %{$results}{"body"} => '- <2019-06-20> Es aa sdjsl;kdjklj0 payr sdfjkl;sdjf sdj sdk;lskd.
  - [[/small/SMALL/images/3110560937290313920.jpeg][3110560937290313920.jpeg]]', 'JPEG payload');



#
#  Checks that the file is properly splitted.
#

open $fh, "<", "data/3909"
    or die "could not open $file: $!";

$results = Signal::STDIN2Array($fh);
is( @{$#results} => 0, "file descriptor to array");


#
#  Large message reduced to paylad

open $fh, "<", "data/5265"
    or die "could not open $file: $!";

$results = Signal::STDIN2Array($fh);
@A = @{$results};
is( $#A => 2, "it found the right number of messages");

$result = Signal::raw2Org($A[0]);
is( %{$result}{"body"} => '- <2019-06-21> askdjklasjdkla sdnklasjdkljmakls sjdkljaskldjklasj k823798273.'
    , "it extracted the first short message");


$result = Signal::raw2Org($A[1]);
is( %{$result}{"body"} => '- <2019-06-21> Expires in 1800 seconds (ALsahjsk Aaiwei).
  - https://a.wordpress.com/sdjlkjasdkl-sdjsdkljklj/
    - Es aa sdjsl;kdjklj0 payr sdfjkl;sdjf sdj sdk;lskd.
  - AAAAAA
    - bb ccc ddddddd eee fff ggggggg hhhhhhhhh, iii jjjjj k lllllll
  mmm nn oooooooo.
  - Pp qq rrr sssssssss tt xxxxxxx yyyyyyyy zzz aaa bbbbbbb.
    - cc ddd eeeeeeeeeeee ffff gg hhhhhhhh
    - ii oooooooo pp qqqqqqqq rr sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz
  ashnljkajasl sdjskljklsdj sdjlsjdklsjd a ajskljsalk sdjlsjdklj.
  - aaaa bbbbbb c dd eee fff gggggggg, hh iiiiiiii j kkkkkk.
    - lllllllll mm nnnnnn oooooooo.
  - BBBBBBBBB
    - bb ccc ddddddd eee fff ggggggg hhhhhhhhh, iii jjjjj k lllllll
  mmm nn oooooooo.
  - Pp qq rrr sssssssss tt xxxxxxx yyyyyyyy zzz aaa bbbbbbb.
    - cc ddd eeeeeeeeeeee ffff gg hhhhhhhh
    - ii oooooooo pp qqqqqqqq rr sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz
  ashnljkajasl sdjskljklsdj sdjlsjdklsjd a ajskljsalk sdjlsjdklj.
  - aaaa bbbbbb c dd eee fff gggggggg, hh iiiiiiii j kkkkkk.
    - lllllllll mm nnnnnn oooooooo.
  - ii oooooooo pp qqqqqqqq rr sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz:
    - cc ddd eeeeeeeeeeee?
    - nnnnnn oooooooo?
    - sdjlsjdklsjd a ajskljsalk sdjlsjdklj?
  - bb ccc ddddddd eee fff.
    - ii oooooooo pp qqqqqqqq rr sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz.
  - fff gggggggg, hh iiiiiiii j kkkkkk
    - fff gggggggg, hh iiiiiiii j kkkkkk.
    - fff gggggggg, hh iiiiiiii j kkkkkk "sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz
  fff gggggggg"
  -  a ajskljsalk  a ajskljsalk  a ajskljsalk  a ajskljsalk.
  - sdjlsjdklsjd
    - sdjlsjdklsjd a ajskljsalk
    - ashnljkajasl sdjskljklsdj sdjlsjdklsjd a ajskljsalk sdjlsjdklj
  sdjlsjdklsjd a ajskljsalk.
  -
  - [[/small/SMALL/images/631166565003315923.txt][631166565003315923.txt]]', "the larger message was reduced to a payload");


$result = Signal::raw2Org(@{$results}[2]);
is( %{$result}{"body"} => '- <2019-06-21> Expires in 1800 seconds (ALsahjsk Aaiwei).
  - https://a.wordpress.com/sdjlkjasdkl-sdjsdkljklj/
    - Es aa sdjsl;kdjklj0 payr sdfjkl;sdjf sdj sdk;lskd.
  - AAAAAA
    - bb ccc ddddddd eee fff ggggggg hhhhhhhhh, iii jjjjj k lllllll
  mmm nn oooooooo.
  - Pp qq rrr sssssssss tt xxxxxxx yyyyyyyy zzz aaa bbbbbbb.
    - cc ddd eeeeeeeeeeee ffff gg hhhhhhhh
    - ii oooooooo pp qqqqqqqq rr sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz
  ashnljkajasl sdjskljklsdj sdjlsjdklsjd a ajskljsalk sdjlsjdklj.
  - aaaa bbbbbb c dd eee fff gggggggg, hh iiiiiiii j kkkkkk.
    - lllllllll mm nnnnnn oooooooo.
  - BBBBBBBBB
    - bb ccc ddddddd eee fff ggggggg hhhhhhhhh, iii jjjjj k lllllll
  mmm nn oooooooo.
  - Pp qq rrr sssssssss tt xxxxxxx yyyyyyyy zzz aaa bbbbbbb.
    - cc ddd eeeeeeeeeeee ffff gg hhhhhhhh
    - ii oooooooo pp qqqqqqqq rr sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz
  ashnljkajasl sdjskljklsdj sdjlsjdklsjd a ajskljsalk sdjlsjdklj.
  - aaaa bbbbbb c dd eee fff gggggggg, hh iiiiiiii j kkkkkk.
    - lllllllll mm nnnnnn oooooooo.
  - ii oooooooo pp qqqqqqqq rr sssssssss ttttttt xxxxxxxx yyyyyyyyy zzzzzzz:
    - cc ddd eeeeeeeeeeee?
    - nnnnnn oooooooo?
    - sdjlsjdklsjd a ajskljsalk sdjlsjdklj?', 'the third message was properly found');


#
#  2 mensajes
#

open $fh, "<", "data/5270"
    or die "could not open $file: $!";

$results = Signal::STDIN2Array($fh);

@A = @{$results};
is( $#A => 1, "it found the right number of messages");

$result = Signal::raw2Org(@{$results}[0]);
is( %{$result}{"body"} => '- <2019-06-21> askdjklasjdkla sdnklasjdkljmakls sjdkljaskldjklasj k823798273 sdnklasjdkljmakls sjdkljaskldjklasj k823798273.', 'the first of 2 mensajes');

$result = Signal::raw2Org(@{$results}[1]);
is( %{$result}{"body"} => '- <2019-06-21> askdjklasjdkla sdnklasjdkljmakls sjdkljaskldjklasj k823798273 sdnklasjdkljmakls sjdkljaskldjklasj k823798273 k823798273 sdnklasjdkljmakls.', 'the second of the 2 mensajes');


#
# Link largo 
#

$rawMessage = "Envelope from: +593001112131 (device: 1)
Timestamp: 1561328937220 (2019-06-23T22:28:57.220Z)
Message timestamp: 1561328937220 (2019-06-23T22:28:57.220Z)
Body: askdjklasjdkla sdnklasjdkljmakls sjdkljaskldjklasj: https://www.google.com/url?sa=t&source=web&rct=j&url=https://chrome.google.com/webstore/detail/web-server-for-chrome/ofhbbkphhbklhfoeikjpcbhemlocgigb%3Fhl%3Den&ved=2ahUKEwipuuid04DjAhWswVkKHdkFAwEQFjABegQIDxAJ&usg=AOvVaw37MqUO7yBo81gh1Cz1IBP4&cshid=1561328884694
Expires in: 1800 seconds
Profile key update, key length:32";

$result = Signal::raw2Org($rawMessage);
is( %{$result}{"body"} => '- <2019-06-23> askdjklasjdkla sdnklasjdkljmakls sjdkljaskldjklasj: https://www.google.com/url?sa=t&source=web&rct=j&url=https://chrome.google.com/webstore/detail/web-server-for-chrome/ofhbbkphhbklhfoeikjpcbhemlocgigb%3Fhl%3Den&ved=2ahUKEwipuuid04DjAhWswVkKHdkFAwEQFjABegQIDxAJ&usg=AOvVaw37MqUO7yBo81gh1Cz1IBP4&cshid=1561328884694', 'Link largo');




#
#  Png payload
#

$rawMessage = "Envelope from: +593001112131 (device: 4)
Timestamp: 1561127605099 (2019-06-21T14:33:25.099Z)
Message timestamp: 1561127605099 (2019-06-21T14:33:25.099Z)
Body: Pp qq rrr sssssssss tt xxxxxxx yyyyyyyy zzz aaa bbbbbbb
Expires in: 1800 seconds
Profile key update, key length:32
Attachments: 
- image/png (Pointer)
  Id: 8340409706930788346 Key length: 64
  Filename: image.png
  Size: 105030 bytes
  Voice note: no
  Dimensions: 784x465
  Stored plaintext in: /root/.local/share/signal-cli/attachments/8340409706930788346";

$result = Signal::raw2Org($rawMessage);
is( %{$result}{"body"} => '- <2019-06-21> Pp qq rrr sssssssss tt xxxxxxx yyyyyyyy zzz aaa bbbbbbb
  - [[/small/SMALL/images/8340409706930788346.png][8340409706930788346.png]]', 'Png payload');



#
# Default 
#

$rawMessage = "Envelope from: +593001112131 (device: 4)
Timestamp: 1561129790348 (2019-06-21T15:09:50.348Z)
Message timestamp: 1561129790348 (2019-06-21T15:09:50.348Z)
Body: sdjsl;kdjklj0
Expires in: 1800 seconds
Profile key update, key length:32
Attachments: 
- image/png (Pointer)
  Id: 4012159641720865561 Key length: 64
  Filename: image.png
  Size: 121044 bytes
  Voice note: no
  Dimensions: 870x719
  Stored plaintext in: /root/.local/share/signal-cli/attachments/4012159641720865561";

$result = Signal::raw2Org($rawMessage);
is( %{$result}{"body"} => '- <2019-06-21> sdjsl;kdjklj0
  - [[/small/SMALL/images/4012159641720865561.png][4012159641720865561.png]]', 'Default');


done_testing();
