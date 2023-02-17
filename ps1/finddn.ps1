# Function Find Distinguished Name 
function find-dn { param([string]$adfindtype, [string]$cName) 
    # Create A New ADSI Call 
    $root = [ADSI]'' 
    # Create a New DirectorySearcher Object 
    $searcher = new-object System.DirectoryServices.DirectorySearcher($root) 
    # Set the filter to search for a specific CNAME 
    $searcher.filter = "(&(objectClass=$adfindtype) (samAccountName=$cName))" 
    # Set results in $adfind variable 
    $adfind = $searcher.findone() 
     
    # If Search has Multiple Answers  
    if ($adfind.count -gt 1) { 
        $count = 0  
        foreach($i in $adfind) 
        { 
            # Write Answers On Screen 
            write-host $count ": " $i.path 
            $count += 1 
        } 
        # Prompt User For Selection 
        $selection = Read-Host "Please select item: " 
        # Return the Selection 
        return $adfind[$selection].path 
    } 
	
	if ($adfind.count -gt 0) {
	    write-host "First (only) result: " $adfind[0].path
	}
	else {
		write-host "Not found"
	}
	
    # Return The Answer 
    return $adfind[0].path 
}

Write-Output "Find start"

# To use the function to find a User: 
find-dn "user" "phowlett" 

Write-Output "Find complete"

# Write-Output $P
 
# To use the function to find a Group: 
#$P = find-dn "group" "staff"
#Write-Output $P