#!/bin/bash

# Define the path to your repositories list file
repoFile="repos.txt"

# Check if the file exists
if [ ! -f "$repoFile" ]; then
    echo -e "\e[31mThe file $repoFile does not exist. Please check the file path.\e[0m"
    exit 1
fi

# Read the repository URLs from the file and loop through each repository URL
while IFS= read -r repo; do
    echo "Cloning repository: $repo"
    git clone "$repo"
done < "$repoFile"
