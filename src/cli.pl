#!/usr/bin/perl -I /opt

use Signal;

@rawMessages = @{ Signal::STDIN2Array(STDIN) };
@messages = @{ Signal::proccessRawMessages(\@rawMessages) };

my %message =  %{$messages[2]};

for(@messages){
    my %message =  %{$_};
    ## `cp -f $message{"file"} $message{"finalname"}`;
    my $body = $message{"body"};
    print $body;
}
