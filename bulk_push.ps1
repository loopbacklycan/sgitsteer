# Your Gitea server details
$giteaUrl = "http://your-gitea.address"  # Replace with your Gitea URL
$token = "your-gitea-token"  # Replace with your Personal Access Token
$user = "USERNAME"  # Replace with your Gitea username
$reposFile = "repos.txt"  # File containing GitHub repos

# Path where you want to store the cloned repos temporarily
$tempClonePath = "C:\$USER\Downloads"  # Change this path as needed

# Read the repository URLs from the file
$repos = Get-Content $reposFile

# Loop through each GitHub repository, create the repo on Gitea, and push files
foreach ($repoUrl in $repos) {
    # Extract the repository name from the URL
    $repoName = [System.IO.Path]::GetFileNameWithoutExtension($repoUrl)
    Write-Host "Processing repository: $repoName"

    # Check if the repository already exists on Gitea
    $url = "$giteaUrl/api/v1/repos/$user/$repoName"
    $headers = @{
        "Authorization" = "token $token"
    }
    
    try {
        $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers
        Write-Host "Repository $repoName already exists on Gitea. Skipping creation."
    } catch {
        Write-Host "Repository $repoName does not exist. Creating repository on Gitea..."
        
        # Create the repository on Gitea (user account)
        $url = "$giteaUrl/api/v1/user/repos"  # Use user repos endpoint
        $body = @{
            "name" = $repoName
            "private" = $true  # Change this to $false if you want public repos
        }
        
        try {
            $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body ($body | ConvertTo-Json) -ContentType "application/json"
            
            if ($response) {
                Write-Host "Repository $repoName created successfully on Gitea!"
            } else {
                Write-Host "Failed to create $repoName on Gitea." -ForegroundColor Red
                continue
            }
        } catch {
            Write-Host "Error creating repository $($repoName): $_" -ForegroundColor Red
            continue
        }
    }

    # Clone the GitHub repository
    Write-Host "Cloning GitHub repo: $repoUrl"
    $clonePath = Join-Path -Path $tempClonePath -ChildPath $repoName
    git clone $repoUrl $clonePath

    # Push the repository to Gitea
    Write-Host "Pushing repository $repoName to Gitea..."
    Set-Location -Path $clonePath

    # Set the remote origin to point to the Gitea repository
    $giteaRepoUrl = "http://$($user):$($token)@gitea.<domain>:port/$($user)/$repoName.git"
    git remote set-url origin $giteaRepoUrl

    # Push the content to the Gitea repository
    git push origin --all
    git push origin --tags

    Write-Host "Repository $repoName pushed to Gitea successfully!"
}

