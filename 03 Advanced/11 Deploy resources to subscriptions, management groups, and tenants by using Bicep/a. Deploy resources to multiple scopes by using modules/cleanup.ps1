$subscriptionId = ( Get-AzContext ).Subscription.Id

Remove-AzPolicyAssignment -Name 'DenyFandGSeriesVMs' -Scope "/subscriptions/$subscriptionId"
Remove-AzPolicyDefinition -Name 'DenyFandGSeriesVMs' -SubscriptionId $subscriptionId -Force
Remove-AzResourceGroup -Name ToyNetworking -Force