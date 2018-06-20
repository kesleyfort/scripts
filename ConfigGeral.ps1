
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")){   
        $arguments = "& '" + $myinvocation.mycommand.definition + "'"
        Start-Process powershell -Verb runAs -ArgumentList $arguments
        Break
    }


function Wait-For-Keypress([string] $message, [bool] $shouldExit=$FALSE) {
	Write-Host "$message" -foregroundcolor yellow
	$key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	if ($shouldExit) {
		exit
	}
}
Function Get-Folder($initialDirectory){
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")| Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.rootfolder = "MyComputer"

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
        return $folder
    }
    if($foldername.ShowDialog() -eq "Cancel"){
        return 1
    }
}
function CopyFiles () {
    Robocopy $PastaInicial $PastaDestino /e /s /R:1 /W:0 /NP /XD "Microsoft" "Temp" "VirtualBox VMs" "Android" "atom" "Dropbox" "Onedrive" "Ambiente de Impressão" "Dados de Aplicativos" "Ambiente de Rede" /LOG:"log.txt" /ETA
}
function Menu () {
    param (
           [string]$Title = 'Ferramentas da TI'
     )
     Clear-Host
     Write-Host "================ $Title ================"
     
     Write-Host "1: Pressione '1' realizar o Backup."
     Write-Host "2: Pressione '2' para restaurar o Backup."
     Write-Host "3: Pressione '3' para adicionar o Computador ao Domínio."
     Write-Host "2: Pressione '4' para adicionar Usuário de rede como administrador local."
     Write-Host "Q: Pressione 'Q' para sair."
}
function MakeBackup () {
    #$PastaInicial = "$USER_PROFILE"
    Write-Output "Selecione a Pasta de Origem"
    $PastaInicial = Get-Folder
    Write-Output "Selecione a Pasta de Destino"
    $PastaDestino = Get-Folder 
    if ($PastaDestino -eq '1') {
        Wait-For-Keypress "Processo Cancelado."
    }
    else{
        $PastaDestino+="\$env:USERNAME"
        "Copiando Pasta $PastaInicial para $PastaDestino"
        CopyFiles
        "Arquivos Copiados."
    }
}
function RestoreBackup () {
    Write-Output  "Selecione a Pasta onde o backup está localizado"
    $PastaInicial = Get-Folder
    Write-Output  "Selecione a Pasta C:\Users\$env:USERNAME"
    $PastaDestino = Get-Folder
    if ($PastaDestino -eq '1') {
        "Processo Cancelado."
    }
    else{
        "Copiando Pasta $PastaInicial para $PastaDestino"
        CopyFiles
        "Arquivos Copiados."
    }
}
function AddDomain () {
    if (!(Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain){
    $domain = "fh.com.br"
    $username = Read-Host -Prompt "Login de admin do dominio"
    $password = Read-Host -Prompt "Digite a senha para $username" -AsSecureString
    $credential = New-Object System.Management.Automation.PSCredential($username,$password)
    Add-Computer -DomainName $domain -Credential $credential
    }
    else {
        Write-Output "Computador já está inserido no domínio"
    }
}
function AddUserAsAdmin () {
    $UserName = Read-Host "Login do Usuario"
    $Group = "Administradores"
    $domain = "FH\"
    Add-LocalGroupMember -Group $Group -Member $domain$UserName
}
do{
     Menu
     $entrada = Read-Host "Opção: "
     switch ($entrada)
     {
           '1' {
                Clear-Host
                MakeBackup
           } '2' {
                Clear-Host
                RestoreBackup
           } '3' {
            Clear-Host
            AddDomain
           } '4' {
            Clear-Host
            AddUserAsAdmin
       } 'q' {
                return
           }
     }
     pause
}
until ($entrada -eq 'q')



