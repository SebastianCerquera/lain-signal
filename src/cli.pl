#!/usr/bin/perl -I /opt

use Signal;

$rawMessages = Signal::STDIN2Array(STDIN);
@messages = @{ Signal::proccessRawMessages($rawMessage) };

for(@messages){
    my %message =  %{$_};
    `cp -f $message{"file"} $message{"finalname"}`;
    print $message{"body"};
}
