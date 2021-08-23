#! /usr/bin/pwsh

For ($i = 0; $i -lt $Args.Count; $i++)
{
    $Arg = $Args[$i]

    If ($Arg.ToLower() -eq "-module")
    {
        $ModuleName = $Args[$i + 1]

        Import-Module -Name $ModuleName

        Continue
    }

    If ($Arg.ToLower() -eq "-outputfolder")
    {
        $OutputFolder = $Args[$i + 1]

        If (Test-Path -Path $OutputFolder)
        {
            Remove-Item -Path $OutputFolder -Recurse -Force
        }

        Continue
    }
}

New-MarkdownHelp @Args | Out-Null
