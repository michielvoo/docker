#! /usr/bin/pwsh

For ($i = 0; $i -lt $Args.Count; $i++)
{
    $Arg = $Args[$i]

    If ($Arg.ToLower() -eq "-module")
    {
        $ModuleName = $Args[$i + 1]

        Import-Module -Name $ModuleName

        Break
    }
}

New-MarkdownHelp @Args
