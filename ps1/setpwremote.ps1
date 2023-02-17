<#
    Original code dos not work on a non-domain joined member system
#>
function Set-PasswordRemotely {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $UserName,
        [Parameter(Mandatory = $true)][securestring] $OldPassword,
        [Parameter(Mandatory = $true)][securestring] $NewPassword,
        [Parameter(Mandatory = $true)][alias('DC', 'Server', 'ComputerName')][string] $DomainController
    )
    $DllImport = @'
[DllImport("netapi32.dll", CharSet = CharSet.Unicode)]
public static extern bool NetUserChangePassword(string domain, string username, string oldpassword, string newpassword);
'@
    $NetApi32 = Add-Type -MemberDefinition $DllImport -Name 'NetApi32' -Namespace 'Win32' -PassThru
    $result = $NetApi32::NetUserChangePassword($DomainController, $UserName, $OldPassword, $NewPassword)
    if ($result) {
        Write-Output -InputObject 'Password change failed. Please try again.'
    } else {
        Write-Output -InputObject 'Password change succeeded.'
    }
}
