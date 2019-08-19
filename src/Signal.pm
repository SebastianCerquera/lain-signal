#!/usr/bin/perl -l

package Signal;


## Helper function used by the test.
sub string2Array {
    my ($str) = @_;
    @A = split "\n\n", $str;
    return \@A;
}

sub STDIN2Array {
    my ($fh) = @_;
    @A = do { local $/ = "\n\n"; <$fh> };
    return \@A;
}

sub proccessRawMessages {
    my ($rawMessages) = @_;
    my @orgMessages = (); 
    for(@{rawMessages}){
        push @orgMessages, messageToTask($_);
    }
    return \@orgMessages;
}

sub raw2Org {
    my ($message) = @_; 
    my @A = split("\n", $message);
    my $start = 0;
    my $body = "";
    my $filename;
    my $type;
    my $file;
    my %results = {"body" => undef, "file" => undef, "finalname" => undef};
    
    my $line = 0;
    for(@A){
       if (/Message timestamp:.+\((.+)T.+$/){
           $body = $body."- <$1> ";
           next;
       }
       $line = $line + 1;
       if (/Body:\s(.+)/){
           $start = 1;
           $body = $body.$1;
           next;
       }
       if (/Expires/){
           $line = $line + 1;
           $start = 0;
           last;
       }
       if (/Profile/){
           $start = 0;
           last;
       }
       $body = "$body\n  $_" if($start);
    }

    $results{"body"} = $body;
    if($A[$#A] =~ "Profile key update, key length:32"){
        return \%results;
    }
    
    if($A[$#A] =~ "^\$" && $A[$#A - 1] =~ "Profile key update, key length:32"){
        return \%results;
    }
    
    $filename = $1 if($A[$line + 3] =~ /Id:\s+(\d+)\sKey.+$/);
    $type = $1 if($A[$line + 4] =~ /Filename:\s+.+\.(.+)$/);
    $type = $type || $1 if($A[$line + 2] =~ /-\s.+\/(.+)\s\(Pointer\)$/);
    
    if($filename && $type){
        $file = $1 if($A[$line + 8] =~ /Stored plaintext in:\s+(.+)$/);
        $body = "$body\n  - [[/small/SMALL/images/$filename.$type][$filename.$type]]";
        $results{"body"} = $body;
        $results{"file"} = $file;
        $results{"finalname"} = "/small/SMALL/images/$filename.$type";
    }
    
    return \%results;
} 

return 1;
