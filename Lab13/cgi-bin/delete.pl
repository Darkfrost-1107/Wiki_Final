#!"c:/Strawberry/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use DBI;


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
    <title> </title>
</head>
<body>
    <form action="delete.pl">
        <p>owner</p>    
        <input type="text" name="owner">
        <p>title</p>
        <input type="text" name="title">
        <input type="submit">
        <a href="inicio.html">cancelar</a>
    </form>
<body>    
HTML

}elsif(!($owner eq "") and !($title eq "")){
    print $q -> header('text/xml,utf-8');

    if(verArticulo($owner,$title)){
        eliminar($owner,$title);

        siElimino($owner,$title);
     }
     else{
        noElimino();
     }
}
else{
    print $q -> header('text/xml,utf-8');

    noElimino();
}


sub verArticulo{
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

sub siElimino{            
    my $owner= $_[0];
    my $title= $_[1];

    print <<XML;
    <article>
        <owner>$owner</owner>
        <title>$title</title>
    </article>
XML

}

sub noElimino{
    print <<XML;
    <article>
    </article>
XML
}

sub eliminar{

    my $owner=$_[0];
    my $title=$_[1];

    my $user = 'alumno';
    my $password1= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.13';
    my $dbh = DBI ->connect($dsn,$user,$password1) or die ("No se pudo conectar");


    my $sth=$dbh->prepare("DELETE FROM Articles WHERE owner=? AND title=?");
    $sth->execute($owner,$title);
    $sth->finish;
    $dbh->disconnect;
}