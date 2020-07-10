#Requires -Version 5

$global:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$global:here = Join-Path -Path $here -ChildPath ".."
$global:blueprintFile = "\Templates\Blueprint.json"
$global:artifactPath = "\Templates\Artifacts"

Describe "Blueprint Tests" -Tags -Unit {

    Context "Blueprint file syntax" {

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

        It "Should have valid artifact files if passed as parameter values" {
            $artifactFileList = Get-ChildItem (Join-Path -Path "$here" -ChildPath "$artifactPath")
            
            foreach ($file in $artifactFileList) {
                $currentFile = Get-Content $file.FullName | ConvertFrom-Json
                $templateParameters = ($currentFile.properties.parameters | Get-Member -Type NoteProperty).Name

                foreach ($parameter in $templateParameters) {
                    If ($currentFile.properties.parameters.$($parameter).value.GetTypeCode() -ne "String") { continue }
                    
                    if ($currentFile.properties.parameters.$($parameter).value.StartsWith("[artifacts")) {
                        $artifactFile = $currentFile.properties.parameters.$($parameter).value.split('''')[1] + ".json"

                        Test-Path (Join-Path -Path "$here" -ChildPath "$artifactPath\$artifactFile") | Should -Be $true
                    }
                }
            }
        }

    }
}