# Define the path to your repositories list file
$repoFile = "repos.txt"

# Check if the file exists
if (-Not (Test-Path $repoFile)) {
    Write-Host "The file $repoFile does not exist. Please check the file path." -ForegroundColor Red
    exit
}

# Read the repository URLs from the file
$repos = Get-Content $repoFile

# Loop through each repository URL and clone it
foreach ($repo in $repos) {
    Write-Host "Cloning repository: $repo"
    git clone $repo
}
