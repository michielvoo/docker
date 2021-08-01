#! /usr/bin/pwsh

$ConfigurationIndex = -1
For ($i = 0; $i -lt $Args.Count; $i++)
{
    $Arg = $Args[$i]
    If ($Arg.ToLower() -eq "-configuration")
    {
        $ConfigurationIndex = $i + 1
    }
}

If ($ConfigurationIndex -ne -1)
{
    $Args[$ConfigurationIndex] = ConvertFrom-Json -InputObject $Args[$ConfigurationIndex]
}

Invoke-Pester @Args
