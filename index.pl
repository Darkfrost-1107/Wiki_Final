#!\xampp\perl\bin\perl
use strict;
use warnings;
use CGI;
use DBI;
#my $q = CGI->new;
my $user1 = 'root';
my $password1= '';
my $dsn ='DBI:mysql:database=pweb1';
my $dbh = DBI ->connect($dsn,$user1,$password1) or die ("No se pudo conectar");

#CreateEverithing
my $Query = "";
open(SQL,"./sql/CreateEverything.sql") or die ("No se puede abrir el query");
while(my $line = <SQL>){
    $Query = $Query.$line;   
};
#Query
my $sth=$dbh->prepare($Query);
$sth->execute();
$sth ->finish;
$dbh->disconnect;
print $query;
#End
#print $q->redirect("./html/");