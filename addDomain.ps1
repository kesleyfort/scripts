param($Step="A")
# -------------------------------------
# Imports
# -------------------------------------
$script = $myInvocation.MyCommand.Definition
$scriptPath = Split-Path -parent $script
. (Join-Path $scriptpath functions.ps1)

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

    {   
        $arguments = "& '" + $myinvocation.mycommand.definition + "'"
        Start-Process powershell -Verb runAs -ArgumentList $arguments
        Break
    }

Clear-Any-Restart
if (!(Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain) 
{
    $domain = "fh.com.br"
    $username = Read-Host -Prompt "Login de admin do dominio"
    $password = Read-Host -Prompt "Digite a senha para $username" -AsSecureString
    $credential = New-Object System.Management.Automation.PSCredential($username,$password)
    Add-Computer -DomainName $domain -Credential $credential
	Wait-For-Keypress "O script continuará depois que o computador for reiniciado. Aperte qualquer tecla para reiniciar..." 
	Restart-And-Resume $script "B"
}

if ((Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain) 
{
    
    $UserName = Read-Host "Login do Usuario"
    $Group = "Administradores"
    $domain = "FH\"
    Add-LocalGroupMember -Group $Group -Member $domain$UserName
}


Wait-For-Keypress "PC adicionado ao domínio e usuário criado. Pressione qualquer tecla para sair do script."