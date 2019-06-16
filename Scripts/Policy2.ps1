[String]$SubscriptionID = (Get-AzContext).Subscription.id
[String]$Scope = "/subscriptions/$SubscriptionID/"
[String]$PolicyDefinitionFileURI = "https://raw.githubusercontent.com/Benoitsautierecellenza/DemoPolicy/master/Policies/AZ-ALLOWEDTAGVALUES/AZ-ALLOWEDTAGVALUES-02-RULE.json"
[String]$PolicyParameterFileURI = "https://raw.githubusercontent.com/Benoitsautierecellenza/DemoPolicy/master/Policies/AZ-ALLOWEDTAGVALUES/AZ-ALLOWEDTAGVALUES-02-PARAMETERS.json"
[String]$PolicyName = "AllowedTagValues4UpdatePolicy"
[String]$PolicyDisplayName = "$PolicyName"
New-AzPolicyDefinition -Name $PolicyName `
    -DisplayName $PolicyDisplayName `
    -Policy $PolicyDefinitionFileURI `
    -Parameter $PolicyParameterFileURI `
    -Subscription $SubscriptionID `
    -Mode All 

[String]$PolicyAssignname = "Assign-$PolicyName"
$UpdatePolicyTagName = "UpdatePolicy" 
$AllowedValues = @("AlwaysReboot","RebootIfRequired","OnlyReboot","NeverReboot")
$PolicyDefinition = Get-AzPolicyDefinition -SubscriptionId $SubscriptionID | Where-Object {$_.Properties.displayname -eq $PolicyDisplayName} 
$AssignParameters = @{
        'UpdatePolicyTagName' = $UpdatePolicyTagName; 
        'UpdatePolicyTagAllowedValues'=($AllowedValues)   
    }
New-AzPolicyAssignment -Name $PolicyAssignname `
    -PolicyDefinition $PolicyDefinition `
    -Scope $Scope `
    -PolicyParameterObject $AssignParameters


