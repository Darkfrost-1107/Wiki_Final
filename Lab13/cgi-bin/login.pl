#!"c:/Strawberry/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use DBI;


my $q=CGI->new;
my $formulario=$q->param("formulario");
my $userName=$q->param("userName");
my $password=$q->param("password");

my $firstName;
my $lastName;

if($formulario){
    print "Content-type: text/html\n\n";
    print <<HTML;
<!DOCTYPE html>
<html>
<head>
    
    <link rel="stylesheet" type="text/css" href="../estilosPerl124.css">
    <title> </title>
</head>
<body>
    <form action="login.pl">
        <p>username</p>    
        <input type="text" name="userName">
        <p>password</p>
        <input type="text" name="password">
        <input type="submit">
        <a href="inicio.html">cancelar</a>
    </form>
<body>    
HTML

 }elsif(!($userName eq "") and !($password eq "")){
    print $q -> header('text/xml,utf-8');
    my @datos=checkUserName($userName);
    if(@datos){
        $firstName=$datos[1];
        $lastName=$datos[2];
        successLogin($userName,$firstName,$lastName);
     }
     else{
         showLogin();
     }
}
else{
    print $q -> header('text/xml,utf-8');
    showLogin();
}


sub checkUserName{
    my $userName=$_[0];
    
    my $user1 = 'alumno';
    my $password1= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.13';
    my $dbh = DBI ->connect($dsn,$user1,$password1) or die ("No se pudo conectar");
    
    
    my $sql = "SELECT userName,firstName,lastName FROM Users WHERE userName=?";
    my $sth=$dbh->prepare($sql);
    $sth->execute($userName);
    my @row=$sth->fetchrow_array;
    $sth->finish;
    $dbh->disconnect;
    return @row;
}

sub successLogin{            
    my $owner= $_[0];
    my $firstName= $_[1];
    my $lastName = $_[2];

    print <<XML;
    <user>
        <owner>$owner</owner>
        <firstName>$firstName</firstName>
        <lastName>$lastName</lastName>
    </user>
XML

}

sub showLogin{
    print <<XML;
    <user>
    </user>
XML
}
