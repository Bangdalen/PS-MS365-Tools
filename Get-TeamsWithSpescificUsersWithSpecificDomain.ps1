#Set the domain you are searching for
$domain = "domain.org"

#Import module for Teams
Import-Module -Name MicrosoftTeams

#Connect to Microsoft Teams
Connect-MicrosoftTeams

#Every Team with every member:
$AllTeams = Get-Team
Foreach ($team in $AllTeams) 
{
	$teamUsers = Get-TeamUser -groupid $team.groupid
	
	$domainUsers = $teamUsers | Where-Object { $_.User.EndsWith($domain) }
	
	if ($domainUsers.Count -gt 0) {
		Write-Host -NoNewLine "Users from "
		Write-Host -NoNewLine -BackgroundColor "Darkblue" -ForegroundColor "White" $domain
		Write-Host -NoNewLine " exists in Team: "
		Write-Host -BackgroundColor "Green" -ForegroundColor "Black" $team.DisplayName
	}
}
