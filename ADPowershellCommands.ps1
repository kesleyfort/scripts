#Buscar usuários em determinado grupo com login de rede.
#Get-ADGroupMember "Group - Inside Sales" | %{Get-ADUser $_.samaccountname -Properties mail} | select name, SamAccountName | Export-csv -path C:\Users\kalves\Documents\Output\usuarios.csv -NoTypeInformation
#Busca grupo no AD pelo nome
#Get-ADGroup -Properties mail -Filter {name -like "*inside*"} | Select Name, mail
#Pega todas as OU de Projeto
#Get-ADOrganizationalUnit -Filter 'Name -like "Projeto *SNR*"' | select name
#adiciona o usuário no grupo.
#Add-ADGroupMember -Identity "GroupNAME" -Member USERNAME
#Buscar usuários com determinada string no login de rede
#Get-ADUser -Filter {SamAccountName -like "c.pea.*"} | Select SamAccountName | Export-csv -path C:\Users\kalves\Documents\usuarios.csv -NoTypeInformation
#Buscar login de rede por nome do usuário
#Get-ADUser -Filter {name -like "*Steinmetz"} | Select name, SamAccountName


$username = "admin.kesley"
$password = Read-Host -Prompt "Digite a senha para $username" -AsSecureString
$credential = New-Object System.Management.Automation.PSCredential($username,$password)

function AdicionarUsuarioEmGruposPorSigla{
    $array=@("clhol","clker","clak","clsrv","clpos")
    #adicionar usuário aos grupos contidos em Array
    $users=@("maroliveira")
    for ($i = 0; $i -lt $array.Count; $i++) {
        $grupo="confluence-{0}-edicao" -f $array[$i]
        $user="{0}" -f $users[$i]
      Add-ADGroupMember -Credential  $credential -Identity $grupo -Members "vochiliski"
      #Set-ADAccountPassword -Credential $credential -Identity $user -NewPassword (ConvertTo-SecureString -AsPlainText "inicial" -Force)
  
    }
}

#Script para buscar todos os logins de usuários presentes em um determinado grupo.
# os critérios para select são DistinguishedName	Enabled	GivenName	mail	Name	ObjectClass	ObjectGUID	SamAccountName	SID	Surname	UserPrincipalName
function BuscarNomeDeProjeto{
    $projetos=@("HOLCIM","KERRY","AKASTOR","AKER","SARAIVA","Whirlpool","POSITIVO","BLOUNT","THÁ")
    $Siglas=[System.Collections.ArrayList]@()
    for ($i = 0; $i -lt $projetos.Count; $i++) {
        $projeto="*{0}*" -f $projetos[$i]
        $nome=Get-ADOrganizationalUnit -Filter {name -like $projeto} | select name | Out-String
        $nome=$nome.ToLower()
        $Siglas.Add($nome.Split('-')[-1].Trim())
        #clear
    }
        write "Siglas:"
    foreach ($element in $Siglas) {
    $element
    }

}