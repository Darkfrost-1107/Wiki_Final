#!"c:/Strawberry/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use DBI;

my $q=CGI->new;
print $q -> header('text/xml');
my $userName=$q->param("userName");
my $password=$q->param("password");

if(defined($userName) and defined($password) ){
    if(checkLogin($user,$password)){
        my @arr=checkLogin($user,$password);
        successLogin($arr[0],$arr[3],$arr[2]);
    }
    else{
        showLogin();
    }
}
else{
    showLogin();
}

sub checkLogin{
    my $userQuery=$_[0];
    my $passwordQuery=$_[1];

    my $user = 'alumno';
    my $password= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.9';
    my $dbh = DBI ->connect($dsn,$user,$password) or die ("No se pudo conectar");

    my $sql="SELECT * FROM Users WHERE userName=? AND password=?";
    my $sth=$dbh->prepare($sql);
    $sth->execute($userQuery,$passwordQuery);
    my @row=$sth->fetchrow_array;
    $sth->finish;
    $dbh->disconnect;
    return @row;
}

sub successLogin{            
    my $owner= $_[0];
    my $firstNameQuery1= $_[1];
    my $lastNameQuery1 = $_[2];
    my $body=<<XML;
    <user>
        <owner>$owner</owner>
        <firstName>$firstNameQuery1</firstName>
        <lastName>$lastNameQuery1</lastName>
    </user>
XML
        print(renderBody($body));
}


sub showRegister{            
    my $body=<<XML;
    <user>
    </user>
XML
        print(renderBody($body));
}
sub renderBody{
    my $body=$_[0];
    my $xml=<<XML;
<?xml version="1.0" encoding="UTF-8"?>
$body
XML
    return $xml;
}