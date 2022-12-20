#!"c:/Strawberry/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use DBI;


my $q=CGI->new;
my $formulario=$q->param("formulario");
my $userName=$q->param("userName");
my $password=$q->param("password");
my $lastName=$q->param("lastName");
my $firstName=$q->param("firstName");

    

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
    <form action="register.pl">
        <p>username</p>    
        <input type="text" name="userName">
        <p>password</p>
        <input type="text" name="password">
        <p>firstName</p>    
        <input type="text" name="firstName">
        <p>lastName</p>
        <input type="text" name="lastName">
        <input type="submit">
        <a href="inicio.html">cancelar</a>
    </form>
<body>    
HTML

}elsif(!($userName eq "") and !($password eq "") and !($firstName eq "") and !($lastName eq "")){
    print $q -> header('text/xml,utf-8');

    if(!checkUserName($userName)){
        register($userName,$password,$firstName,$lastName);

        successRegister($userName,$firstName,$lastName);
     }
     else{
         showRegister();
     }
}
else{
    print $q -> header('text/xml,utf-8');

    showRegister();
}


sub checkUserName{
    my $userName=$_[0];
    
    my $user1 = 'alumno';
    my $password1= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.13';
    my $dbh = DBI ->connect($dsn,$user1,$password1) or die ("No se pudo conectar");
    
    
    my $sql = "SELECT userName FROM Users WHERE userName=?";
    my $sth=$dbh->prepare($sql);
    $sth->execute($userName);
    my @row=$sth->fetchrow_array;
    $sth->finish;
    $dbh->disconnect;
    return @row;

}

sub successRegister{            
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

sub showRegister{
    print <<XML;
    <user>
    </user>
XML
}

sub register{

    my $userName=$_[0];
    my $password=$_[1];
    my $firstName=$_[2];
    my $lastName=$_[3];


    my $user = 'alumno';
    my $password1= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.13';
    my $dbh = DBI ->connect($dsn,$user,$password1) or die ("No se pudo conectar");


    my $sth=$dbh->prepare("INSERT INTO Users(userName,password,firstName,lastName) VALUES (?,?,?,?)");

    $sth->execute($userName,$password,$firstName,$lastName);
    $sth ->finish;
    $dbh->disconnect;
}