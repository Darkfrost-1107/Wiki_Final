#!"c:/Strawberry/perl/bin/perl.exe"
use strict;
use warnings;
use DBI;
use CGI;

 print "Content-type: text/html\n\n";
print <<HTML;
<!DOCTYPE html>
<html>
<head>
    
    <link rel="stylesheet" type="text/css" href="../estilosPerl124.css">
    <title>Actor id 5 </title>
</head>
<body>
HTML

my $q = CGI->new;
my $titulo=$q->param("titulo");
my $nuevoContenido=$q->param("nuevoContenido");
my $contenido;


my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.14";
  
my $dbh = DBI ->connect($dsn,$user,$password) or die ("No se pudo conectar");
my $sth;

if(defined $nuevoContenido){

    $sth = $dbh->prepare("UPDATE wiki SET Pagina=? WHERE Titulo=?" );
    
    $sth->execute($nuevoContenido,$titulo) or die "error"; 

}


$sth = $dbh->prepare("SELECT Titulo,Pagina FROM wiki" );

$sth->execute or die "error"; 

while(my @row=$sth->fetchrow_array){
    if($row[0] eq $titulo){
        $contenido=$row[1];
    }
}
 
$sth ->finish;
$dbh->disconnect;   


print <<HTML;
    <form action="editar.pl" method="get">
        <h1>$titulo<h1>
        <p>texto</p>
        <textarea name="nuevoContenido">$contenido</textarea>
        <input name="titulo" type="text" value="$titulo" style="display:none;">
        <input type="submit">
    </form>
    <br>
    <a href="listado.pl">cancelar</a>
HTML
if(defined $nuevoContenido){
    print "<h1>Actualizado con exito</h1>";
}


