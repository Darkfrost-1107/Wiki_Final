#!"c:/Strawberry/perl/bin/perl.exe"
use strict;
use warnings;
use DBI;
use CGI;


my $q = CGI->new;
my $titulo=$q->param("titulo");
my $contenido;

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.13";
my $dbh = DBI ->connect($dsn,$user,$password) or die ("No se pudo conectar");

my $sth = $dbh->prepare("DELETE FROM wiki WHERE Titulo=?" );

$sth->execute($titulo) or die "error"; 
$sth ->finish;
$dbh->disconnect;   


print $q->redirect("listado.pl");