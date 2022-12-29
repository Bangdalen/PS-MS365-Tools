<#
Script for creating a SharePoint site with a document library for Templates in Office Apps in your Organization
By Tony Bardalen
#>
$Domain = "yourdomain"
$SiteName = "OfficeTemplates"
$Title = "Office Template Site"
$Owner = "user@yourdomain.com"
$Locale = 1044
$TimeZone = 4

Install-Module
Import-Module

#Connecto to the SharePoint Admin site
Connect-PnPOnline -url https://$Domain-admin.sharepoint.com -Interactive

#Create your new site with the specified parameters, and wait until all SharePoint artifacts are finished
New-PnPSite -Type TeamSite -Title $Title -Alias $SiteName -IsPublic -Lcid $Locale -TimeZone $TimeZone -Owner $Owner -Description "SharePoint site for templates in Word, Excel and PowerPoint" -Wait

#Change context to the newly created site
Connect-PnPOnline -url https://$Domain.sharepoint.com/sites/$SiteName -Interactive

#Create the new document library
New-PnPList -Title "Templates" -Template DocumentLibrary -Url Templates -EnableContentTypes -EnableVersioning -OnQuickLaunch

#Add library as a Template Library in your organization. This might give an error about DCN not enabled for tenant, but will work regardless of this
Add-PnpOrgAssetsLibrary -LibraryUrl https://$Domain.sharepoint.com/sites/$SiteName/Templates -OrgAssetType OfficeTemplateLibrary
