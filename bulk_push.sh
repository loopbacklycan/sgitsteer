#!/bin/bash
# Your Gitea server details
giteaUrl="http://your-gitea.address"  # Replace with your Gitea URL
token="your-gitea-token"  # Replace with your Personal Access Token
user="USERNAME"  # Replace with your Gitea username
reposFile="repos.txt"  # File containing GitHub repos

# Path where you want to store the cloned repos temporarily
tempClonePath="$HOME/repos"  # Change this path as needed

# Read the repository URLs from the file
while IFS= read -r repoUrl; do
    # Extract the repository name from the URL
    repoName=$(basename "$repoUrl" .git)
    echo "Processing repository: $repoName"

    # Check if the repository already exists on Gitea
    url="$giteaUrl/api/v1/repos/$user/$repoName"
    response=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $token" "$url")

    if [ "$response" -eq 200 ]; then
        echo "Repository $repoName already exists on Gitea. Skipping creation."
    else
        echo "Repository $repoName does not exist. Creating repository on Gitea..."

        # Create the repository on Gitea (user account)
        url="$giteaUrl/api/v1/user/repos"  # Use user repos endpoint
        body=$(jq -n --arg name "$repoName" --argjson private true '{name: $name, private: $private}')

        response=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Authorization: token $token" -H "Content-Type: application/json" -d "$body" "$url")

        if [ "$response" -eq 201 ]; then
            echo "Repository $repoName created successfully on Gitea!"
        else
            echo "Failed to create $repoName on Gitea." >&2
            continue
        fi
    fi

    # Clone the GitHub repository
    clonePath="$tempClonePath/$repoName"
    if [ -d $clonePath ]; then
        echo "Pulling latest changes"
        cd $clonePath
        git pull
    else
        echo "Cloning GitHub repo: $repoUrl"
        git clone "$repoUrl" "$clonePath"
    fi

    # Push the repository to Gitea
    echo "Pushing repository $repoName to Gitea..."
    cd "$clonePath" || exit

    # Set the remote origin to point to the Gitea repository
    dynamic_gitea_url=$(echo $giteaUrl | sed 's|http://||g')
    giteaRepoUrl="http://$user:$token@$dynamic_gitea_url/$user/$repoName.git"
    git remote set-url origin "$giteaRepoUrl"

    # Push the content to the Gitea repository
    git push origin --all
    git push origin --tags

    echo "Repository $repoName pushed to Gitea successfully!"
done < "$reposFile"
