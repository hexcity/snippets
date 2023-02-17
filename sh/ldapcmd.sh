#!/bin/sh
#

#/local/ldap/bin/ldapsearch -h "homer.aliant.icn" -D "CN=phpldapadmin,OU=SMG,DC=aliant,DC=net" -w "ldapadmin1" "(objectclass=user)"

/local/ldap/bin/ldapsearch -H "ldaps://homer.aliant.icn/" -x -D "CN=phpldapadmin,OU=SMG,DC=aliant,DC=net" -w "ldapadmin1" -v -b "OU=SMG,DC=aliant,DC=net" "(uid=phowlett)"


