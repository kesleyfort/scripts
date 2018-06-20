$username = "admin.kesley"
#$password = Read-Host -Prompt "Digite a senha para $username" -AsSecureString
#$credential = New-Object System.Management.Automation.PSCredential($username,$password)
$user="rsteinmetz"
$projetos=@("Activate","Cloud Guepardo","REINF","COPEL","SANTA CRUZ","ARAUCO","MEXICHEM","F. PERINI","CLHE", "GESTAMP", "ADAMA", "HOLCIM", "BOTICARIO", "AERO", "POSITIVO", "INCEPA", "SNR", "PRATI", "LHOIST", "J MACEDO", "VIDEPLAST", "ANGLOGOLD", "ASHANT", "CELESC", "LEAR", "EMBRACO", "WHIRLPOOL", "AKER", "DESTRO", "BELAGRICOLA", "GRIFOLS")
$Siglas=[System.Collections.ArrayList]@()
for ($i = 0; $i -lt $projetos.Count; $i++) {
    $projeto="*{0}*" -f $projetos[$i]
    Get-ADOrganizationalUnit -Filter {name -like $projeto} | select name
}
$Grupos=[System.Collections.ArrayList]@()
for ($i = 0; $i -lt $Siglas.Count; $i++) {
    $grupo="confluence-{0}-visualizacao" -f $Siglas[$i]
    Get-ADGroup -Filter {name -like $grupo} | Select Name
    $i
    #Add-ADGroupMember -Credential $credential -Identity $nome -Members $user
}
