#!"c:/Strawberry/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use DBI;


my $q=CGI->new;
my $formulario=$q->param("formulario");
my $title=$q->param("title");
my $text=$q->param("text");
my $owner=$q->param("owner");

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
    <form action="update.pl">
        <p>titulo</p>    
        <input type="text" name="title">
        <p>texto</p>
        <textarea name="text"></textarea>
        <p>usuario</p>    
        <input type="text" name="owner">
        <input type="submit">
        <a href="inicio.html">cancelar</a>
    </form>
<body>    
HTML

}elsif(!($title eq "")  and !($text eq "") and !($owner eq "")){
    print $q -> header('text/xml,utf-8');

    if(checkExistenciaArticulos($owner,$title)){
       
        actualizar($owner,$title,$text);
        agregado($title,$text);
     }
     else{
         noAgregado();
     }
}
else{
    print $q -> header('text/xml,utf-8');
    noAgregado();
}

sub checkExistenciaArticulos{
    my $owner=$_[0];
    my $title=$_[1];

    my $user1 = 'alumno';
    my $password1= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.13';
    my $dbh = DBI ->connect($dsn,$user1,$password1) or die ("No se pudo conectar");
    
    
    my $sql = "SELECT owner FROM Articles WHERE owner=? AND title=?";
    my $sth=$dbh->prepare($sql);
    $sth->execute($owner,$title);
    my @row=$sth->fetchrow_array;
    $sth->finish;
    $dbh->disconnect;
    return @row;
}

sub agregado{            
    my $title=$_[0];
    my $text=$_[1];

    print <<XML;
    <article>
        <title>$title</title>
        <text>$text</text>
    </article>
XML

}

sub noAgregado{
    print <<XML;
    <article>
    </article>
XML
}

sub actualizar{

    my $owner=$_[0];
    my $title=$_[1];
    my $text=$_[2];

    my $user = 'alumno';
    my $password1= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.13';
    my $dbh = DBI ->connect($dsn,$user,$password1) or die ("No se pudo conectar");


    my $sth=$dbh->prepare("UPDATE Articles SET text=? WHERE owner=? AND title=?");

    $sth->execute($text,$owner,$title);
    $sth ->finish;
    $dbh->disconnect;
}