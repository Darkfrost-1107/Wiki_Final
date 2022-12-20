#!"c:/Strawberry/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use DBI;


my $q=CGI->new;
my $formulario=$q->param("formulario");
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
    <form action="list.pl">
        <p>usuario</p>    
        <input type="text" name="owner">
        <input type="submit">
        <a href="inicio.html">cancelar</a>
    </form>
<body>    
HTML

}elsif(!($owner eq "")){
    print $q -> header('text/xml,utf-8');

    if(obtenerArticulos($owner)){
        my @articulos=obtenerArticulos($owner);
        print "<articles>";

        for(my $i=0;$i<@articulos;$i++){
            articleEncontrado($owner,$articulos[$i]);
        }
        print "</articles>";
        
     }
     else{
         noEncontrado();
     }
}
else{
    print $q -> header('text/xml,utf-8');

    noEncontrado();
}

sub obtenerArticulos{
    my $owner=$_[0];

    my $user1 = 'alumno';
    my $password1= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.13';
    my $dbh = DBI ->connect($dsn,$user1,$password1) or die ("No se pudo conectar");
    
    
    my $sql = "SELECT title FROM Articles WHERE owner=?";
    my $sth=$dbh->prepare($sql);
    $sth->execute($owner);
    my @articulos;
    my $i=0;
    while(my @row=$sth->fetchrow_array){
        $articulos[$i]=$row[0];
        $i++;
    }
    
    $sth->finish;
    $dbh->disconnect;
    return @articulos;
}

sub articleEncontrado{            
    my $owner=$_[0];
    my $title=$_[1];

    print <<XML;
    <article>
        <owner>$owner</owner>
        <title>$title</title>
    </article>
XML

}

sub noEncontrado{
    print <<XML;
    <articles>
    </articles>
XML
}
