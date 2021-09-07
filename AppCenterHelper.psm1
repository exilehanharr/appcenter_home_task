<#
 .Synopsis
  Displays a list of branches for the app and builds them.

 .Description
  This function returns list of branches and builds for the app as list of strings:
    < branch name > build < completed/failed > in 125 seconds. Link to build logs: < link >

 .Parameter OwnerName
  Name of the application owner in AppCenter.

 .Parameter AppName
  Name of the application in AppCenter.

 .Parameter ApiToken
  App Token or User Token.

 .Example
   Get-BuildStatus -OwnerName <Name> -AppName <Name> -ApiToken <Token>
#>
function Get-BuildStatus {
    [CmdletBinding()]
    param(
        [string]
        $OwnerName = $(throw "Parameter 'OwnerName' is mandatory"),
        [string]
        $AppName = $(throw "Parameter 'AppName' is mandatory"),
        [string]
        $ApiToken = $(throw "Parameter 'ApiToken' is mandatory")
    )

    $apiUrl = "https://api.appcenter.ms/v0.1/apps/{0}/{1}" -f $OwnerName, $AppName
    $headers = @{
        "X-API-Token" = $ApiToken
        "accept" = "application/json"
    }

    $buildStatus = New-Object System.Collections.Generic.List[PSCustomObject]

    try {
        $listBranches = Invoke-RestMethod -Method Get -ContentType "application/json" `
                                          -Headers $headers `
                                          -Uri "$($apiUrl)/branches"
    }
    catch {
        throw "Attempt to get a list of branches for application $appName failed with error: $_"
    }

    foreach ($branch in $listBranches.branch.name)
    {
        try {
            $listBuilds = Invoke-RestMethod -Method Get -ContentType "application/json" `
                                            -Headers $headers `
                                            -Uri "$($apiUrl)/branches/$branch/builds"
        }
        catch {
            throw "Attempt to get a list of builds for branch $branch failed with error: $_"
        }

        foreach ($build in $listBuilds)
        {
            try {
                $linkToLogs = Invoke-RestMethod -Method Get -ContentType "application/json" `
                                                -Headers $headers `
                                                -Uri "$($apiUrl)/builds/$($build.id)/downloads/logs"
            }
            catch {
                throw "Attempt to get a link to logs for buildID $($build.id) failed with error: $_"
            }
    
            [int]$buildDuration = ([datetime]$build.finishTime - [datetime]$build.startTime).TotalSeconds
    
            $buildStatus.Add(
                [PSCustomObject]@{
                    message = "$branch build $($build.result) in $buildDuration seconds. Link to build logs: $($linkToLogs.uri)"
                }
            )
        }
    }

    return $buildStatus.message
}

Export-ModuleMember -Function Get-BuildStatus