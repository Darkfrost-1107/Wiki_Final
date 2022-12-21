#!\xampp\perl\bin\perl
use strict;
use warnings;
use CGI;
use DBI;

my $q=CGI->new;
print $q->header('text/xml');
print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print "<report>";

my $userName=$q->param("userName");
my $password=$q->param("password");
my $lastName=$q->param("lastName");
my $firstName=$q->param("firstName");

# --- las funciones se definen primero, si no, no compila :D

#register($userName,$password,$firstName,$lastName);

sub checkUserName{
    my $UNameQuery=$_[0];
    my $UPassQuery=$_[1];
    my $user1 = 'root';
    my $password1= '';
    my $dsn ='DBI:mysql:database=wiki';
    my $dbh = DBI ->connect($dsn,$user1,$password1) or die ("No se pudo conectar"); 

    my $sql = "SELECT * FROM Users WHERE userName like '$UNameQuery' OR password like '$UPassQuery'"; 
    my $sth=$dbh->prepare($sql);
    $sth->execute();
    my @row=$sth->fetchrow_array;
    print "<content>@row</content>";
    $sth->finish;
    $dbh->disconnect;
    
    return @row;
}

sub successRegister{            
    my $owner= $_[0];
    my $firstNameQuery1= $_[1];
    my $lastNameQuery1 = $_[2];
    print <<XML;
        <message>Success</message>
        <user>
            <owner>$owner</owner>
            <firstName>$firstNameQuery1</firstName>
            <lastName>$lastNameQuery1</lastName>
        </user>  
XML
}

sub showRegister{            
    print <<XML;
        <message>Failure</message>
        <user>
        </user>
XML
}

sub register{

    my $userNameQuery=$_[0];
    my $passwordQuery=$_[1];
    my $firstNameQuery=$_[2];
    my $lastNameQuery=$_[3];


    my $user1 = 'root';
    my $password1= '';
    my $dsn ='DBI:mysql:database=wiki';
    my $dbh = DBI ->connect($dsn,$user1,$password1) or die ("No se pudo conectar");

    my $sth=$dbh->prepare("INSERT INTO Users(userName,password,lastName,firstName) VALUES (?,?,?,?)");

    #my $sql = "INSERT INTO Users(userName,password,firstName,lastName) VALUES(?,?,?,?)";
    #my $sth=$dbh->prepare($sql);

    $sth->execute($userNameQuery,$passwordQuery,$lastNameQuery,$firstNameQuery);
    $sth ->finish;
    $dbh->disconnect;
}

if(defined($userName) && defined($password) && defined($firstName) && defined($lastName)){
    if(!checkUserName($userName)){
        register($userName,$password,$firstName,$lastName);
        successRegister($userName,$firstName,$lastName);
    }
    else{
        showRegister();
    }
}
else{
    showRegister();
}

print "</report>";
