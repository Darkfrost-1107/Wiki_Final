#!"c:/Strawberry/perl/bin/perl.exe"
use strict;
use warnings;
use DBI;
use CGI;



my $q=CGI->new;
my $formulario=$q->param("formulario");
my $owner=$q->param("owner");
my $title=$q->param("title");

if($formulario){
    print "Content-type: text/html\n\n";
    print <<HTML;
<!DOCTYPE html>
<html>
<head>
    
    <link rel="stylesheet" type="text/css" href="../estilosPerl124.css">
    <title>Ver Archivo</title>
</head>
<body>
    <form action="article.pl">
        <p>titulo</p>    
        <input type="text" name="title">
        <p>usuario</p>    
        <input type="text" name="owner">
        <input type="submit">
        <a href="inicio.html">cancelar</a>
    </form>  
HTML
}elsif(!($owner eq "") and !($title eq "")){
    print $q -> header('text/xml,utf-8');
    my @row=selectText($owner,$title);
    if(@row){
        my $contenido=" $row[0] ";

        seEncontro($owner,$title,$contenido);
     }
     else{
        noEncontro();
     }
}
else{
    print $q -> header('text/xml,utf-8');

    noEncontro();
}

sub selectText{
    my $owner=$_[0];
    my $title=$_[1];

    my $user = 'alumno';
    my $password1= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.13';
    my $dbh = DBI ->connect($dsn,$user,$password1) or die ("No se pudo conectar");


    my $sth=$dbh->prepare("SELECT text FROM Articles WHERE owner=? AND title=?");
    $sth->execute($owner,$title);
    my @row=$sth->fetchrow_array;
    $sth->finish;
    $dbh->disconnect;
    return @row;
}

sub seEncontro{            
    my $owner= $_[0];
    my $title= $_[1];
    my $text = $_[2];

    print <<XML;

    <article>
        <owner>$owner</owner>
        <title>$title</title>
        <text>$text</text>
    </article>
XML

}

sub noEncontro{
    print <<XML;
    <article>
    </article>
XML
}

