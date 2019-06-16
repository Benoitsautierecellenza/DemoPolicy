#
# Create Deployment Schedules in Azure Automation for Patch Management
#
[String]$UpdatePolicyTagName = "UpdatePolicy" 
[String]$AutomationAccountResourceGroupName = "UpdateManagement"
[String]$AutomationAccountName = "MyUpdateManagement"
$MaintenanceWindows = New-TimeSpan -Hours 2
Function CreateAutomationDeploymentSchedule(
    [String]$PolicyType,    
    [String]$Target
)
{
    [String]$PolicyName = $Target + "-" + $PolicyType
    #
    # Create the Dynamic group for Scoping
    #
    $scope = "/subscriptions/$((Get-AzContext).subscription.id)"
    $QueryScope = @($scope)
    $tag = @{"$UpdatePolicyTagName"= $PolicyType}
    $AzQuery = New-AzAutomationUpdateManagementAzureQuery -ResourceGroupName $AutomationAccountResourceGroupName `
        -AutomationAccountName $AutomationAccountName `
        -Scope $queryScope `
        -Tag $tag
    #
    # Create an Azure Automation schedule
    #
    $AzureQueries = @($AzQuery)
    $startTime = [DateTimeOffset]((Get-date).addhours(2))

    $schedule = New-AzAutomationSchedule -ResourceGroupName $AutomationAccountResourceGroupName `
        -AutomationAccountName $AutomationAccountName `
        -Name $PolicyName `
        -StartTime $startTime `
        -DaysOfWeek Saturday `
        -WeekInterval 1 `
        -ForUpdateConfiguration
    #
    # Create the Azure Automation Software Update configuration (Windows / Linux)
    #
    If ($Target -eq "Windows")
    {
        New-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $AutomationAccountResourceGroupName `
        -AutomationAccountName $AutomationAccountName `
        -Schedule $schedule `
        -Windows `
        -AzureQuery $AzureQueries `
        -IncludedUpdateClassification Critical `
        -Duration $MaintenanceWindows    
    }
    else {
        New-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $AutomationAccountResourceGroupName `
        -AutomationAccountName $AutomationAccountName `
        -Schedule $schedule `
        -Linux `
        -AzureQuery $AzureQueries `
        -IncludedPackageClassification Critical `
        -Duration $MaintenanceWindows    
    }

}
CreateAutomationDeploymentSchedule -PolicyType "AlwaysReboot" -Target "Windows"
CreateAutomationDeploymentSchedule -PolicyType "RebootIfRequired"  -Target "Windows"
CreateAutomationDeploymentSchedule -PolicyType "OnlyReboot"  -Target "Windows"
CreateAutomationDeploymentSchedule -PolicyType "NeverReboot"  -Target "Windows"
CreateAutomationDeploymentSchedule -PolicyType "AlwaysReboot"  -Target "Linux"
CreateAutomationDeploymentSchedule -PolicyType "RebootIfRequired"  -Target "Linux"
CreateAutomationDeploymentSchedule -PolicyType "OnlyReboot"  -Target "Linux"
CreateAutomationDeploymentSchedule -PolicyType "NeverReboot"  -Target "Linux"