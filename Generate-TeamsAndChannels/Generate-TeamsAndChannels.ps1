# Read the JSON file
$rootFolder = "C:\data\"
$jsonFile = "Teams-and-Channels.json"
$jsonData = Get-Content $jsonFile | ConvertFrom-Json
$timestamp = (Get-Date).toString("yyyyMMddHHmm")
$logFileName = "Log_" + $timestamp + ".txt"
$logFileAndPath = $rootFolder + $logFileName

New-Item -Path $rootFolder -Name $logFileName -type file

# Connect to Microsoft Teams
try {
		Connect-MicrosoftTeams
		$messageTimestamp = (Get-Date).toString("yyyyMMdd-HH:mm:ss")
		$message = "Successfully connected to  Microsoft Teams!"
		Write-Host $messageTimestamp - $message
	} catch {
		$messageTimestamp = (Get-Date).toString("yyyyMMdd-HH:mm:ss")
		$message = "Could not connect to  Microsoft Teams!"
		Write-Host $messageTimestamp - $message
	}
	
Add-Content -Path $logFileAndPath -Value "$messageTimestamp - $message"

# Iterate through each team in the JSON file
foreach ($teamData in $jsonData) {
    $teamName = $teamData.TeamName

    # Create Team if not already exists
    if (-not (Get-Team -DisplayName $teamName)) {
        New-Team -DisplayName $teamName -Description "Team created via PowerShell"
		$messageTimestamp = (Get-Date).toString("yyyyMMdd-HH:mm:ss")
		$message = "Created Team: " + $teamName
        Write-Host $messageTimestamp - $message
		Add-Content -Path $logFileAndPath -Value "$messageTimestamp - $message"
    }
	
	#Wait for the team to be created before adding channels
	Write-Host "Waiting 20 seconds for the team to be properly created..."
	Start-Sleep -Seconds 20
	Write-Host "The wait is over. Continuing with the channels"
	
    # Get the Team's ID
    $team = Get-Team -DisplayName $teamName
    $teamId = $team.GroupId

    # Iterate through each channel in the JSON file
    foreach ($channelData in $teamData.Channels) {
        $channelName = $channelData.ChannelName
        $membershipType = $channelData.MembershipType

        # Check if channel already exists and creates it
        try {
            New-TeamChannel -GroupId $teamId -DisplayName $channelName -Description "Channel created via PowerShell" -MembershipType $membershipType
			$messageTimestamp = (Get-Date).toString("yyyyMMdd-HH:mm:ss")
			$message = "Created channel: " + $channelName
			Write-Host $messageTimestamp - $message           
        } catch {
			$messageTimestamp = (Get-Date).toString("yyyyMMdd-HH:mm:ss")
			$message = "Could not create channel. Already exists?: " + $channelName
            Write-Host $messageTimestamp - $message
        }
		Add-Content -Path $logFileAndPath -Value "$messageTimestamp - $message"
    }
}

# Disconnect from Microsoft Teams
Disconnect-MicrosoftTeams
$messageTimestamp = (Get-Date).toString("yyyyMMdd-HH:mm:ss")
$message = "Disconnected from Microsoft Teams!"
Write-Host $messageTimestamp - $message
Add-Content -Path $logFileAndPath -Value "$messageTimestamp - $message"
