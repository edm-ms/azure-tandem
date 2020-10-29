#Requires -Version 5

$global:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$global:here = Join-Path -Path $here -ChildPath ".."
$global:blueprintFile = "\Templates\Blueprint.json"
$global:artifactPath = "\Templates\Artifacts"
$global:allowedWorkspace = "this-must-match-yourLogWorkspaceId"

Describe "Blueprint Tests" -Tags -Unit {

    Context "Blueprint structure" {

        It "Should convert from JSON and have the expected items" {
            $expectedProperties = `
            'description',
            'displayName',
            'parameters',
            'resourceGroups',
            'targetScope' | Sort-Object

            $blueprintProperties = (Get-Content (Join-Path -Path "$here" -ChildPath "$blueprintFile") | ConvertFrom-Json).properties `
                | Get-Member -MemberType NoteProperty `
                | Sort-Object -Property Name `
                | ForEach-Object Name
            $blueprintProperties | Should -Be $expectedProperties
        }
        
        It "Should have a file named Blueprint.json" {
            Test-Path (Join-Path -Path "$here" -ChildPath "$blueprintFile") | Should -Be $true
        }

        It "Should have an Artifacts folder" {
            Test-Path (Join-Path -Path "$here" -ChildPath "$artifactPath") | Should -Be $true
        }

        It "Should have valid artifact types" {
            $expectedArtifactTypes = `
            'template', `
            'roleAssignment', `
            'policyAssignment' | Sort-Object

            $artifactFileList = Get-ChildItem (Join-Path -Path "$here" -ChildPath "$artifactPath")
            foreach ($item in $artifactFileList) { 
                $expectedArtifactTypes -contains (Get-Content $item.FullName | ConvertFrom-Json).kind | Should -Be $true
            }

        }

        It "Should have matching parameters in Blueprint and ARM template" {
            $artifactFileList = Get-ChildItem (Join-Path -Path "$here" -ChildPath "$artifactPath")
            foreach ($item in $artifactFileList) { 
                $item = Get-Content $item.FullName | ConvertFrom-Json
                if ($item.kind -eq 'template') {
                    $blueprintParameters = ($item.properties.parameters | Get-Member -MemberType NoteProperty).name | Sort-Object
                    $templateParameters = ($item.properties.template.parameters | Get-Member -MemberType NoteProperty).name | Sort-Object

                    $templateParameters | Should -Be $blueprintParameters
                }
            }
        }

        It "Should have valid artifact files if passed as parameter output" {
            $artifactFileList = Get-ChildItem (Join-Path -Path "$here" -ChildPath "$artifactPath")
            foreach ($file in $artifactFileList) {
                $currentFile = Get-Content $file.FullName | ConvertFrom-Json
                $templateParameters = ($currentFile.properties.parameters | Get-Member -Type NoteProperty).Name

                foreach ($parameter in $templateParameters) {

                    If ($currentFile.properties.parameters.$($parameter).value.GetTypeCode() -ne "String") { continue }

                    if ($currentFile.properties.parameters.$($parameter).value.StartsWith("[artifacts") -eq $true) {
                        $artifactFile = $currentFile.properties.parameters.$($parameter).value.split('''')[1] + ".json"
                        Test-Path (Join-Path -Path "$here" -ChildPath "$artifactPath\$artifactFile") | Should -Be $true
                    }
                }
            }
        }

    }

    Context "Resource specific" {

        It "Should contain ASC initiative definition" {
            
            # List all files in artifact directory
            $artifactFileList = Get-ChildItem (Join-Path -Path "$here" -ChildPath "$artifactPath")
            $defId = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"

            foreach ($file in $artifactFileList) {
            
                $currentFile = Get-Content $file.FullName | ConvertFrom-Json
                If ($currentFile.properties.policyDefinitionId -eq $defId) {
                    $defFound = $true
                    $defFound | Should -Be $true
                    break
                 }
            }

            If ($defFound -ne $true) {  $false | Should -Be $true }
        }

        It "Should contain defined VM SKUs definition" {
            
            # List all files in artifact directory
            $artifactFileList = Get-ChildItem (Join-Path -Path "$here" -ChildPath "$artifactPath")
            $defId = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"

            foreach ($file in $artifactFileList) {
            
                $currentFile = Get-Content $file.FullName | ConvertFrom-Json
                If ($currentFile.properties.policyDefinitionId -eq $defId) {
                    $defFound = $true
                    $defFound | Should -Be $true
                    break
                 }
            }

            If ($defFound -ne $true) {  $false | Should -Be $true }
        }

        It "Should contain allowed resource locations" {
            
            # List all files in artifact directory
            $artifactFileList = Get-ChildItem (Join-Path -Path "$here" -ChildPath "$artifactPath")
            $defId = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"

            foreach ($file in $artifactFileList) {
            
                $currentFile = Get-Content $file.FullName | ConvertFrom-Json
                If ($currentFile.properties.policyDefinitionId -eq $defId) {
                    $defFound = $true
                    $defFound | Should -Be $true
                    break
                 }
            }

            If ($defFound -ne $true) {  $false | Should -Be $true }
        }

        It "Should contain allowed resource group locations" {
            
            # List all files in artifact directory
            $artifactFileList = Get-ChildItem (Join-Path -Path "$here" -ChildPath "$artifactPath")
            $defId = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988"

            foreach ($file in $artifactFileList) {
            
                $currentFile = Get-Content $file.FullName | ConvertFrom-Json
                If ($currentFile.properties.policyDefinitionId -eq $defId) {
                    $defFound = $true
                    $defFound | Should -Be $true
                    break
                 }
            }

            If ($defFound -ne $true) {  $false | Should -Be $true }
        }

        It "Should match allowed resource and resource group locations" {
            
            # List all files in artifact directory
            $artifactFileList = Get-ChildItem (Join-Path -Path "$here" -ChildPath "$artifactPath")

            $resourceAllowed = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
            $resourceGroupAllowed = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988"

            foreach ($file in $artifactFileList) {
            
                $currentFile = Get-Content $file.FullName | ConvertFrom-Json

                If ($currentFile.properties.policyDefinitionId -eq $resourceAllowed) {
                    $resourceLocations = $currentFile.properties.parameters.listOfAllowedLocations.value | Sort-Object
                 }
                 If ($currentFile.properties.policyDefinitionId -eq $resourceGroupAllowed) {
                    $resourceGroupLocations = $currentFile.properties.parameters.listOfAllowedLocations.value | Sort-Object
                 }
            }

            $resourceLocations | Should -Be $resourceGroupLocations
        }



        It "Should match VM and VM Scale Set (VMSS) allowed SKUs" {
            
            # List all files in artifact directory
            $artifactFileList = Get-ChildItem (Join-Path -Path "$here" -ChildPath "$artifactPath")

            $vmSKUpolicy = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"
            $vmssSKUpolicyName = "Allowed-VMSS-SKUs"

            foreach ($file in $artifactFileList) {
            
                $currentFile = Get-Content $file.FullName | ConvertFrom-Json

                If ($currentFile.properties.policyDefinitionId -eq $vmSKUpolicy) {
                    $vmSKUs = $currentFile.properties.parameters.listofAllowedSKUs.value | Sort-Object
                 }
                 If ($currentFile.properties.template.variables.policyName -eq $vmssSKUpolicyName) {
                    $vmssSKUs = $currentFile.properties.template.variables.listofAllowedSKUs | Sort-Object
                 }
            }

            $vmSKUs | Should -Be $vmssSKUs
        }


        It "Should match defined log workspace ID" {
            
            $blueprintFile = Get-Content (Join-Path -Path "$here" -ChildPath "$blueprintFile") | ConvertFrom-Json

            $workspaceDefault = $blueprintFile.properties.parameters.workspaceId.defaultValues
            $workspaceAllowed = $blueprintFile.properties.parameters.workspaceId.allowedValues

            $workspaceDefault | Should -Be $allowedWorkspace
            $workspaceAllowed | Should -Be $allowedWorkspace
        }
    }
}





