<#
.SYNOPSIS
Windows does not have a built-in ssh-copy-id command, so I made this one. 

.DESCRIPTION
Ssh-CopyId will use ssh to copy your puclic ssh key to the specified server's ~/.ssh/authorized_keys, 
allowing you to use you public ssh key to login/authenticate to a remote server. This Cmdlet assumes that you have
an existing ssh key pair generated, defaulting to ~/.ssh/id_rsa.pub

.PARAMETER ComputerName
The hostname, fqdn, or IP address of the remote server

.PARAMETER UserName
Username to use on the remote server.

.PARAMETER KeyPath
SSH Public key to copy. 

.EXAMPLE
C:\Projects> Ssh-CopyId -UserName root -ComputerName "10.0.0.9"
The authenticity of host '10.0.0.9 (10.0.0.9)' can't be established.
ECDSA key fingerprint is SHA256:Bo5NFD7nxoBs4ToyQjpZABe57wneP/XtUiWgFMtW4tk.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.0.0.9' (ECDSA) to the list of known hosts.
root@10.0.0.9's password:

This will copy ~/.ssh/id_rsa.pub to the authorized_keys file for the remote server's root user, after prompting for password. 
#>

function Ssh-CopyId {
    param(
        [string]$ComputerName,
        [string]$UserName = $env:USERNAME,
        [string]$KeyPath = "$env:USERPROFILE\.ssh\id_rsa.pub"
    )

    $ssh_copy_cmd = Get-Content $KeyPath | ssh $UserName@$ComputerName "cat >> .ssh/authorized_keys ; echo \$?"

    if ($ssh_copy_cmd -contains "True") {
        Write-Information "Keys Copied Successfully" -InformationAction Continue
        Write-Information "Copied $KeyPath to $UserName@$ComputerName" -InformationAction Continue
        Write-Information "You should now be able to $UserName@$ComputerName without password" -InformationAction Continue
        Write-Information "Try to ssh $UserName@$ComputerName" -InformationAction Continue
    }
}