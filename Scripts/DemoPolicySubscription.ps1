#
# Demo en Powershell Importation Policy
# OK
[String]$SubscriptionID = (Get-AzContext).Subscription.id
[String]$Scope = "/subscriptions/$SubscriptionID/"
[String]$PolicyDefinitionFileURI = "https://raw.githubusercontent.com/Benoitsautierecellenza/DemoPolicy/master/Policies/AZ-ALLOWEDTAGVALUES/AZ-ALLOWEDTAGVALUES-02-RULE.json"
[String]$PolicyParameterFileURI = "https://raw.githubusercontent.com/Benoitsautierecellenza/DemoPolicy/master/Policies/AZ-ALLOWEDTAGVALUES/AZ-ALLOWEDTAGVALUES-02-PARAMETERS.json"
[String]$PolicyName = "AllowedTagValues4UpdatePolicy"
[String]$PolicyDisplayName = "$PolicyName"
[String]$PolicyMetaData = '{"Category":"Compliance"}'
$definition = New-AzPolicyDefinition -Name $PolicyName `
    -DisplayName $PolicyDisplayName `
    -Policy $PolicyDefinitionFileURI `
    -Parameter $PolicyParameterFileURI `
    -Metadata $PolicyMetaData `
    -Subscription $SubscriptionID `
    -Mode All 
$definition
#
# SHow Azure Policy list at Subscription level
#
Get-AzPolicyDefinition -SubscriptionId $SubscriptionID -Custom
#
# Demo en Powershell Assignation Policy
#
[String]$PolicyAssignname = "Assign-$PolicyName"
$UpdatePolicyTagName = "UpdatePolicy" 
$AllowedValues = @("AlwaysReboot","RebootIfRequired","OnlyReboot","NeverReboot")
$PolicyDefinition = Get-AzPolicyDefinition -SubscriptionId $SubscriptionID | Where-Object {$_.Properties.displayname -eq $PolicyDisplayName} 
$PolicyDefinition
$AssignParameters = @{
    'UpdatePolicyTagName' = $UpdatePolicyTagName; 
    'UpdatePolicyTagAllowedValues'=($AllowedValues)   
}
New-AzPolicyAssignment -Name $PolicyAssignname -PolicyDefinition $PolicyDefinition -Scope $Scope -PolicyParameterObject $AssignParameters