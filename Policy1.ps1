[String]$SubscriptionID = (Get-AzContext).Subscription.id
[String]$Scope = "/subscriptions/$SubscriptionID/"
[String]$PolicyDefinitionFileURI = "https://raw.githubusercontent.com/Benoitsautierecellenza/DemoPolicy/master/Policies/AZ-DEFAULTTAG/AZ-DEFAULTTAG-01-RULE.json"
[String]$PolicyParameterFileURI = "https://raw.githubusercontent.com/Benoitsautierecellenza/DemoPolicy/master/Policies/AZ-DEFAULTTAG/AZ-DEFAULTTAG-01-PARAMETERS.json"
[String]$PolicyName = "DefautltValue4UpdatePolicy"
[String]$PolicyDisplayName = "$PolicyName"
New-AzPolicyDefinition -Name $PolicyName `
    -DisplayName $PolicyDisplayName `
    -Policy $PolicyDefinitionFileURI `
    -Parameter $PolicyParameterFileURI `
    -Subscription $SubscriptionID `
    -Mode All


# SHow Azure Policy list at Subscription level
#
Get-AzPolicyDefinition -SubscriptionId $SubscriptionID -Custom
#
# Demo en Powershell Assignation Policy
#
[String]$UpdatePolicyTagName = "UpdatePolicy" 
[String]$DefaultTagValue = "AlwaysReboot"
[String]$PolicyName = "DefautltValue4UpdatePolicy"
[String]$PolicyAssignname = "MGMT01-VM-P1"
[String]$Scope = "/subscriptions/$SubscriptionID/"
$PolicyDefinition = Get-AzPolicyDefinition -SubscriptionId $SubscriptionID -Custom | Where-Object {$_.name -eq $PolicyName}
$AssignParameters = @{
    'UpdatePolicyTagName' = $UpdatePolicyTagName; 
    'DefaultTagValue'=$DefaultTagValue   
}
New-AzPolicyAssignment -Name $PolicyAssignname `
    -PolicyDefinition $PolicyDefinition `
    -Scope $Scope `
    -PolicyParameterObject $AssignParameters


