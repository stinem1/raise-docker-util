$CMDS = $args[0..($args.Count - 2)]
if ($CMDS -notcontains 'rsltc' -and $CMDS -notcontains 'sml') {
    Write-Error "Error: No command specified. Please provide one of the following commands: rsltc, sml."
    exit 1
}

$ARG = $args[-1]
if ($ARG -eq $null -or -not (Test-Path -LiteralPath $ARG)) {
    Write-Error "Error: The specified path is either missing or invalid. Please provide a valid file path."
    exit 1
}

$REALDIR = (Get-Item -LiteralPath $ARG).FullName -replace '\\', '/'
$DIR = Split-Path -Parent $REALDIR
$NAME = Split-Path -Leaf $REALDIR

# Convert the file to LF line endings
(Get-Content -Raw -Path $REALDIR) -replace "`r`n", "`n" | Set-Content -NoNewline -Force -Path $REALDIR

# Run the Docker command with the correctly formatted path
docker run --rm -v "${DIR}:/usr/src" ghcr.io/jakuj/raise-tools:main $CMDS "./$NAME"
exit $LastExitCode