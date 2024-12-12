# sgitsteer

<p align="center">
  <img src="https://github.com/1yc4n0rn0t/sgitsteer/blob/main/steer.png" alt="Image" style="height: 350px; vertical-align: middle; margin-left: 10px;" />
</p>

# Bulk Clone and Bulk Push for GitHub to Gitea

This repository contains a **PowerShell script** that combines both **bulk cloning** GitHub repositories and **pushing** them to your self-hosted Gitea server. It allows you to easily clone multiple repositories from GitHub and push them to your Gitea server, without having to do it manually for each repository.

## Overview

- **Bulk Clone**: Clone multiple GitHub repositories listed in a `repos.txt` file.
- **Bulk Push**: After cloning, push all of the repositories to your Gitea server, either into an existing organization or under your user account.

This tool helps automate the migration or backup of multiple repositories from GitHub to Gitea with ease.

## Prerequisites

Before using this script, you must have the following:

1. A **Gitea** server set up and running (self-hosted or otherwise).
2. **Git** installed on your machine.
3. **PowerShell** installed (comes pre-installed on most Windows systems).
4. A **Personal Access Token** (PAT) for Gitea with repository creation and push permissions.
5. A `repos.txt` file that contains the GitHub repository URLs that you want to clone.

## How to Use

### 1. Bulk Clone and Bulk Push Script

This script will first clone the repositories from GitHub and then push them to your Gitea server.

#### Steps:

1. Ensure you have a `repos.txt` file in your repository folder. This file should contain the URLs of the GitHub repositories you want to clone, one per line.

    Example `repos.txt`:
    ```
    https://github.com/user/repo1
    https://github.com/user/repo2
    https://github.com/user/repo3
    ```

2. Modify the script **bulk_clone_and_push.ps1** with the following details:
    - Replace the `$giteaUrl` with your Gitea server URL (e.g., `http://gitea.homelab:3000`).
    - Replace the `$token` with your Gitea Personal Access Token.
    - Replace the `$user` with your Gitea username or organization name.
    - Ensure `$reposFile` points to the `repos.txt` file you created.
    - Set `$tempClonePath` to the location where you want to clone the repositories temporarily.

3. Run the **bulk_clone_and_push.ps1** script:

    Open PowerShell, navigate to the directory where the script is located, and run:

    ```bash
    .\bulk_clone_and_push.ps1
    ```

   The script will:
   - Clone each repository listed in your `repos.txt` file from GitHub.
   - Push each cloned repository to your Gitea server.

#### Important Notes:
- If a repository already exists on Gitea, the script will skip the creation process and only push the repository content.
- If a repository doesn't exist, it will be created on your Gitea server before pushing the content.

### 2. Troubleshooting

- **Error: "Repository already exists"**: This is expected if the repository already exists on Gitea. The script will still push the content to the repository.
- **Permission Issues**: Make sure your Personal Access Token has the correct permissions to create repositories and push to them on Gitea.
- **Cloning Errors**: Ensure you have access to the GitHub repositories and there are no authentication issues (e.g., private repositories).

## Script Example

Here’s the full PowerShell script that combines both the bulk clone and bulk push functionality:
    
 # Clone the GitHub repository
   Write-Host "Cloning GitHub repo: $repoUrl"
   $clonePath = Join-Path -Path $tempClonePath -ChildPath $repoName
   git clone $repoUrl $clonePath

# Push the repository to Gitea
    Write-Host "Pushing repository $repoName to Gitea..."
    Set-Location -Path $clonePath

# Set the remote origin to point to the Gitea repository
    $giteaRepoUrl = "http://$($user):$($token)@gitea.<domain>.<port>/$($user)/$repoName.git"
    git remote set-url origin $giteaRepoUrl

  # Push the content to the Gitea repository
    git push origin --all
    git push origin --tags

  Write-Host "Repository $repoName pushed to Gitea successfully!"

    

### How to Use:
- Copy and paste the above content into a file named `README.md` in your repository.
- The Markdown will be properly rendered when viewed on GitHub, GitLab, or any platform that supports Markdown files.

Let me know if you need any more adjustments!

