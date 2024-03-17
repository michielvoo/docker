# Find the -Configuration argument
$configurationIndex = -1
for ($i = 0; $i -lt $args.Count; $i++)
{
    if ($args[$i].ToLower() -eq "-configuration")
    {
        $configurationIndex = $i + 1
    }
}

if ($configurationIndex -ne -1)
{
    # Assume the -Configuration argument was given as a JSON string
    $args[$configurationIndex] = ConvertFrom-Json -InputObject $args[$configurationIndex]
}

Invoke-Pester @args
