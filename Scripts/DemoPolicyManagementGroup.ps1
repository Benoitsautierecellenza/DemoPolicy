#
# Demo en Powershell Importation Policy au niveau du Management group
#
[String]$PolicyMetaData = '{"Category":"Compliance"}'
[String]$ManagementgroupName = "MGMT01" # Not the DisplayName!!
[String]$UpdatePolicyTagName = "UpdatePolicy" 
[String]$DefaultTagValue = "AlwaysReboot"
$AllowedValues = @("AlwaysReboot","RebootIfRequired","OnlyReboot","NeverReboot")
#
# AZ-DEFAULTTAG-01
# OK
[String]$PolicyDefinitionFileURI = "https://raw.githubusercontent.com/Benoitsautierecellenza/DemoPolicy/master/Policies/AZ-DEFAULTTAG/AZ-DEFAULTTAG-01-RULE.json"
[String]$PolicyParameterFileURI = "https://raw.githubusercontent.com/Benoitsautierecellenza/DemoPolicy/master/Policies/AZ-DEFAULTTAG/AZ-DEFAULTTAG-01-PARAMETERS.json"
[String]$PolicyName = "DefautltValue4UpdatePolicy"
[String]$PolicyDisplayName = "$PolicyName"

$definition = New-AzPolicyDefinition -Name $PolicyName `
    -DisplayName $PolicyDisplayName `
    -Policy $PolicyDefinitionFileURI `
    -Parameter $PolicyParameterFileURI `
    -Metadata $PolicyMetaData `
    -ManagementGroupName $ManagementgroupName `
    -Mode All
$definition
#
# AZ-ALLOWEDTAGVALUES
# OK
[String]$PolicyDefinitionFileURI = "https://raw.githubusercontent.com/Benoitsautierecellenza/DemoPolicy/master/Policies/AZ-ALLOWEDTAGVALUES/AZ-ALLOWEDTAGVALUES-02-RULE.json"
[String]$PolicyParameterFileURI = "https://raw.githubusercontent.com/Benoitsautierecellenza/DemoPolicy/master/Policies/AZ-ALLOWEDTAGVALUES/AZ-ALLOWEDTAGVALUES-02-PARAMETERS.json"
[String]$PolicyName = "AllowedTagValues4UpdatePolicy"
[String]$PolicyDisplayName = "$PolicyName"
$definition = New-AzPolicyDefinition -Name $PolicyName `
    -DisplayName $PolicyDisplayName `
    -Policy $PolicyDefinitionFileURI `
    -Parameter $PolicyParameterFileURI `
    -Metadata $PolicyMetaData `
    -ManagementGroupName $ManagementgroupName `
    -Mode All 
$definition
#
# Show Custom Policies at Management Group level
#
Get-AzPolicyDefinition -ManagementGroupName $ManagementgroupName -Custom
#####################################################################################################
#
# Assign DefautltValue4UpdatePolicy at Management Group level
# OK
[String]$PolicyName = "DefautltValue4UpdatePolicy"
[String]$PolicyAssignname = "MGMT01-VM-P1"
[String]$scope = (Get-AzManagementGroup -GroupName $ManagementgroupName).id
#$PolicyDefinition = Get-AzPolicyDefinition -ManagementGroupName $ManagementgroupName -Custom | Where-Object {$_.ExtensionResourceName -eq $PolicyName}
$PolicyDefinition = Get-AzPolicyDefinition -ManagementGroupName $ManagementgroupName -Custom | Where-Object {$_.name -eq $PolicyName}
$PolicyDefinition
$AssignParameters = @{
    'UpdatePolicyTagName' = $UpdatePolicyTagName; 
    'DefaultTagValue'=$DefaultTagValue   
}
New-AzPolicyAssignment -Name $PolicyAssignname -PolicyDefinition $PolicyDefinition -Scope $Scope -PolicyParameterObject $AssignParameters
#
# Assign AllowedTagValues4UpdatePolicy at Management Group level
#
[String]$PolicyName = "AllowedTagValues4UpdatePolicy"
[String]$PolicyAssignname = "MGMT01-VM-P2" 
$PolicyDefinition = Get-AzPolicyDefinition -ManagementGroupName $ManagementgroupName -Custom | Where-Object {$_.name -eq $PolicyName}
$PolicyDefinition
$AssignParameters = @{
    'UpdatePolicyTagName' = $UpdatePolicyTagName; 
    'UpdatePolicyTagAllowedValues'=($AllowedValues)   
}
[String]$scope = (Get-AzManagementGroup -GroupName $ManagementgroupName).id
New-AzPolicyAssignment -Name $PolicyAssignname -PolicyDefinition $PolicyDefinition -Scope $Scope -PolicyParameterObject $AssignParameters
