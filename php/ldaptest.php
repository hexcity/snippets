<?php
// THESE DO NOT WORK
//$host = 'ldaps://homer.aliant.icn';
//$port = 8634; // LDAPS Port for Development Environment

$host = 'ldaps://homer.aliant.icn';
$port = 636; // LDAPS Port for Development Environment
 
// THESE DO NOT WORK
//$host = 'ldap://homer.aliant.icn';
//$port = 8387; // LDAP Port for Development Environment
 
// THESE WORK
//$host = 'homer.aliant.icn';
//$port = 8387; // LDAP Port for Development Environment
 
//$dn = 'CN=test@awrootbeer.com,OU=Users,OU=A%26W%20Rootbeer,OU=MSSP,DC=aliant,DC=net';
$dn = 'CN=phpldapadmin,OU=SMG,DC=aliant,DC=net';
$password = 'ldapadmin1';
 
echo "Connecting to $host on port $port...\n";
$connection = ldap_connect($host, $port);
if($connection === false)
{
 echo "Could not connect.\n";
 exit(1);
}
 
echo "Binding...\n";
if(!ldap_bind($connection, $dn, $password))
{
 echo "Could not bind.\n";
 echo "ldap_errno: " . ldap_errno($connection) . "\n";
 echo "ldap_error: " . ldap_error($connection) . "\n";
 exit(1);
}
 
echo "Bind was successfull.\n";
 
echo "Closing connection...\n";
if(!ldap_close($connection))
{
 echo "Could not close connection.\n";
 echo "ldap_errno: " . ldap_errno($connection) . "\n";
 echo "ldap_error: " . ldap_error($connection) . "\n";
 exit(1);
}
 
echo "Connection closed.\n";
exit(0);
?>
