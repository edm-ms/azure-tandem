
#$myFile = Get-Content .\resource-group.json | ConvertFrom-Json

$artifactPath = "$($env:System_DefaultWorkingDirectory)/Blueprints/$($env:blueprintName)/Templates/Artifacts"
$armOutputPath = "$($env:System_DefaultWorkingDirectory)/Blueprints/$($env:blueprintName)/BuildArtifacts"
$artifactFileList = Get-ChildItem $artifactPath

New-Item -Type Directory -Path $armOutputPath

foreach ($file in $artifactFileList) { 
    $fileName = $file.Name
    $file = Get-Content $file.FullName | ConvertFrom-Json
    if ($file.kind -eq 'template') {
        $templateParameters = ($file.properties.template.parameters | Get-Member -Type NoteProperty).Name

        # If parameter has a set of allowed values pick one and set it as default
        foreach ($parameter in $templateParameters) {
            If ($null -ne $file.properties.template.parameters.$($parameter).allowedValues) {
                # Pick the first element of allowedValue
                $defaultValue  = $file.properties.template.parameters.$($parameter).allowedValues.split(' ')[0]
                $file.properties.template.parameters.$($parameter) | Add-Member -NotePropertyName "defaultValue" -NotePropertyValue $defaultValue
            }
        }

        # Check for defaultValue and add if missing
        foreach ($parameter in $templateParameters) {
            If ($null -eq $file.properties.template.parameters.$($parameter).defaultValue) {

                if ($file.properties.template.parameters.$($parameter).Type -eq "string") { $defaultValue = "testtesttest" }
                if ($file.properties.template.parameters.$($parameter).Type -eq "int") { $defaultValue = 1 }
                if ($file.properties.template.parameters.$($parameter).Type -eq "bool") { $defaultValue = "true" }
                if ($file.properties.template.parameters.$($parameter).Type -eq "array") { $defaultValue = '["test0", "test1"]' }
                if ($file.properties.template.parameters.$($parameter).Type -eq "object") { $defaultValue = @{key="value"} }

                $file.properties.template.parameters.$($parameter) | Add-Member -NotePropertyName "defaultValue" -NotePropertyValue $defaultValue
            }
        }

        $file.properties.template | ConvertTo-Json -Depth 50 -Compress | Out-File -FilePath "$armOutputPath\$fileName"

    }
}

