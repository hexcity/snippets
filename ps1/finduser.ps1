# Find user in AD
$cName = "phowlett"
$adfindtype = "user"

# Create A New ADSI Call 
$root = [ADSI]'' 
# Create a New DirectorySearcher Object 
$searcher = new-object System.DirectoryServices.DirectorySearcher($root) 
# Set the filter to search for a specific CNAME 
$searcher.filter = "(&(objectClass=$adfindtype) (samAccountName=$cName))" 
# Set results in $adfind variable 
$adfind = $searcher.findone()

if ($adfind -eq $null) {
	write-host "None found"
	exit
}

write-host $adfind[0].path

$myDirectoryEntry = $adfind.GetDirectoryEntry()

write-host "Name: " $myDirectoryEntry.Name

$myResultPropColl = $adfind.Properties
write-host "The properties of the 'adfind' are :"

foreach( $myKey in $myResultPropColl.PropertyNames)  
{  
    $tab = "    ";  
    write-host $myKey + " = "  
    foreach( $myCollection in $myResultPropColl[$myKey])  
    {  
        write-host $tab $myCollection
    }  
}  
 
 