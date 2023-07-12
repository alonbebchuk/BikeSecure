# Requirements:
# 1) open powershell as administrator
# 2) install az module (takes some time): https://learn.microsoft.com/en-us/powershell/azure/install-azps-windows?view=azps-10.0.0&tabs=windowspowershell&pivots=windows-psgallery
# 3) install bicep cli: https://github.com/Azure/bicep/releases/latest/download/bicep-setup-win-x64.exe
# 4) install sqlserver module: Install-Module sqlserver
# 5) run before script: Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Set variables
$location = "eastus"
$random = $(Get-Random)
# ---
$resourceGroupPrefix = "sds-rg"
$resourceGroupName = "$resourceGroupPrefix-$random"
# ---
$serverName = "sds-server-$random"
$adminLogin = "sds-admin"
$adminPassword = 'Pa$5word'
# ---
$firewallRuleName = "sds-firewall-rule-$random"
$ipAddress = (Invoke-WebRequest ifconfig.me/ip).Content.Trim()
# ---
$databaseName = "sds-db-$random"

# Sign in to Azure
Connect-AzAccount

# Clean resources
Get-AzResourceGroup -Name $resourceGroupPrefix* | Remove-AzResourceGroup -Force -AsJob

# Create resource group
Write-host "Creating resource group" $resourceGroupName
$resourceGroup = New-AzResourceGroup -Name $resourceGroupName -Location $location
$resourceGroup

# Create server and database
Write-host "Creating server" $serverName "and database" $databaseName
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile ./setup.bicep -TemplateParameterObject @{
	location = $location
	# ---
	serverName = $serverName
	adminLogin = $adminLogin
	adminPassword = $adminPassword
	# ---
	firewallRuleName = $firewallRuleName
	ipAddress = $ipAddress
	# ---
	databaseName = $databaseName
}

# Create tables
Write-host "Creating tables Users, Locks, and Processes"
Invoke-Sqlcmd -ServerInstance "$serverName.database.windows.net" -Database $databaseName -Username $adminLogin -Password $adminPassword -InputFile ./setup.sql