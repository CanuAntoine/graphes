TOKEN=$(<~/token.gh)

curl \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/CanuAntoine/graphes/actions/artifacts > gh-artifacts.json

jq -r '.artifacts[].id' gh-artifacts.json > liste-id.txt

for id_json in $(cat liste-id.txt); do

    mkdir -p "$id_json"

    # L'option -L pour suivre les redirections autiomatiques    
    curl -L \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/repos/CanuAntoine/graphes/actions/artifacts/$id_json/zip \
        --output $id_json/artifact.zip

    # L'option -d permet d'indiquer le repo de dest / -o permet l'écrasement auto des fichier
    unzip -o -d $id_json $id_json/artifact.zip 

done