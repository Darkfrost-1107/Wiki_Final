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
    <a href="listado.pl">retroceder</a>
HTML

my $q = CGI->new;
my $titulo=$q->param("titulo");
my $contenido;
my $expresionRegular;
print "<h1> $titulo </h1>";

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.14";
  
my $dbh = DBI ->connect($dsn,$user,$password) or die ("No se pudo conectar");

my $sth = $dbh->prepare("SELECT Titulo,Pagina FROM wiki" );

$sth->execute or die "error"; 

while(my @row=$sth->fetchrow_array){
    if($row[0] eq $titulo){
        $contenido=$row[1];
    }
}
 
$sth ->finish;
$dbh->disconnect;   

#regular expresions
#             titulos  
$contenido =~ s/([^#]#[^#][^(#\*\~\`)]+)|(^#[^#][^(#\*\~\`)]+)/<h1>$&<\/h1> /g;
$contenido =~ s/([^#]##[^#][^(#\*\~\`)]+)|(^##[^#][^(#\*\~\`)]+)/<h2>$&<\/h2> /g;
$contenido =~ s/([^#]###[^#][^(#\*\~\`)]+)|(^###[^#][^(#\*\~\`)]+)/<h3>$&<\/h3> /g;
$contenido =~ s/([^#]####[^#][^(#\*\~\`)]+)|(^####[^#][^(#\*\~\`)]+)/<h4>$&<\/h4> /g;
$contenido =~ s/([^#]#####[^#][^(#\*\~\`)]+)|(^#####[^#][^(#\*\~\`)]+)/<h5>$&<\/h5> /g;
$contenido =~ s/([^#]######[^#][^(#\*\~\`)]+)|(^######[^#][^(#\*\~\`)]+)/<h6>$&<\/h6> /g;
#             otros simbolos
$expresionRegular=expresionRegularEntreSimbolos("*",2);
$contenido =~ s/$expresionRegular/<p><strong>$&<\/strong><\/p> /g;
$expresionRegular=expresionRegularEntreSimbolos("*",1);
$contenido =~ s/$expresionRegular/<p><em>$&<\/em><\/p> /g;
$expresionRegular=expresionRegularEntreSimbolos("~",2);
$contenido =~ s/$expresionRegular/<p>$&<\/p> /g;
$expresionRegular=expresionRegularEntreSimbolos("_",1);
$contenido =~ s/$expresionRegular/<em>$&<\/em> /g;
$expresionRegular=expresionRegularEntreSimbolos("*",3);
$contenido =~ s/$expresionRegular/<p><strong><em>$&<\/em><\/strong><\/p> /g;
$expresionRegular=expresionRegularEntreSimbolos("`",3);
$contenido =~ s/$expresionRegular/<p><code>$&<\/code><\/p> /g;
#links
$contenido =~ s//<p><code>$&<\/code><\/p> /g;
print "$contenido";


sub expresionRegularEntreSimbolos{
    my $simboloCostados=$_[0];
    my $repeticiones=$_[1];

    my $simboloDeNoEsteSimbolo="[^\\$simboloCostados]";

    my $simboloCantidadDeVeces="";
    my $expresionTotal;


    for(my $i=0;$i<$repeticiones;$i++){
        $simboloCantidadDeVeces.="\\$simboloCostados";
    }
    #medio
    $expresionTotal="($simboloDeNoEsteSimbolo$simboloCantidadDeVeces($simboloDeNoEsteSimbolo+)$simboloCantidadDeVeces$simboloDeNoEsteSimbolo)";
    #principio
    $expresionTotal.="|(^$simboloCantidadDeVeces($simboloDeNoEsteSimbolo+)$simboloCantidadDeVeces$simboloDeNoEsteSimbolo)";
    #final
    $expresionTotal.="|($simboloDeNoEsteSimbolo$simboloCantidadDeVeces($simboloDeNoEsteSimbolo+)$simboloCantidadDeVeces\$)";
    #principio y final
    $expresionTotal.="|(^$simboloCantidadDeVeces($simboloDeNoEsteSimbolo+)$simboloCantidadDeVeces\$)";
    return $expresionTotal;
}