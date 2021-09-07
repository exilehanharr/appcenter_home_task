# Description

```powershell
Get-BuildStatus
   [-OwnerName] <string>
   [-AppName] <string>
   [-ApiToken] <string>
   [<CommonParameters>]
```

This function returns list of branches and builds for the application from AppCenter as list of strings. Example of string:
```
<branch name> build <completed/failed> in 125 seconds. Link to build logs: <link>
```

# Parameters

```powershell
[-OwnerName] <string>
```

Name of the application owner in AppCenter. Parameter is mandatory.

```powershell
[-OwnerName] <string>
```

Name of the application in AppCenter. Parameter is mandatory.

```powershell
[-OwnerName] <string>
```

App Token or User Token. Parameter is mandatory.

# Examples

## Example 1

Displays a list of branches for the app and builds them.

```powershell
    Get-BuildStatus -OwnerName <Name> -AppName <Name> -ApiToken <Token>
```

Example of output:

```output
develop build failed in 32 seconds. Link to build logs: https://build.appcenter.ms/v0.1/public/apps/...     
main build failed in 43 seconds. Link to build logs: https://build.appcenter.ms/v0.1/public/apps/...    
main build failed in 36 seconds. Link to build logs: https://build.appcenter.ms/v0.1/public/apps/...
```