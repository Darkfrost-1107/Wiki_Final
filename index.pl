#!\xampp\perl\bin\perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $user1 = 'root';
my $password1= '';
my $dsn ='DBI:mysql:database=wiki';
my $dbh = DBI ->connect($dsn,$user1,$password1) or die ("No se pudo conectar");

#CreateEverithing
my $Query = "";
open(SQL,"./sql/CreateEverything.sql") or die ("No se puede abrir el query");
while(my $line = <SQL>){
    $Query = $Query.$line;
    if(index($Query,";") != -1){ 
        my $sth=$dbh->prepare($Query);
        $sth->execute() or die("no se puede hacer execute");
        $sth ->finish; 
        $Query = "";
    }  
}

$dbh->disconnect;

#End
print $q->redirect("./html/");