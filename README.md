# AzureVMMetadata
PowerShell Script to fetch Azure Virtual Machine metadata using Azure Instance Metadata Service 

**Problem Statement**

We have to fetch instance metedata from Windows virtual machines within a subscription and display them as a JSON file.

**Solution**
Before executing the script we should have the necessary Az PowerShell modules installed. We can fetch resource properties directly using Get-Azresource command in PowerShell.
But as we need to get metadata, we will be using **Azure Instance MetaData Service** which can be accessed using the REST API that's available at a well-known, non-routable IP address **(169.254.169.254)**. 


