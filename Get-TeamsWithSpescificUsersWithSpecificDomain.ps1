#Set the domain you are searching for
$domain = "domain.org"

#Import module for Teams
Import-Module -Name MicrosoftTeams

#Connect to Microsoft Teams
Connect-MicrosoftTeams

#List out every team with every member
$AllTeams = Get-Team

#Loop through every Team and sort out users
Foreach ($team in $AllTeams) 
{
	$teamUsers = Get-TeamUser -groupid $team.groupid
	
	#Finds users with the specified domain
	$domainUsers = $teamUsers | Where-Object { $_.User.EndsWith($domain) }
	
	#If found, list out every team with users from that domain
	if ($domainUsers.Count -gt 0) {
		Write-Host -NoNewLine "Users from "
		Write-Host -NoNewLine -BackgroundColor "Darkblue" -ForegroundColor "White" $domain
		Write-Host -NoNewLine " exists in Team: "
		Write-Host -BackgroundColor "Green" -ForegroundColor "Black" $team.DisplayName
	}
}

#Disconnect
Disconnect-MicrosoftTeams
