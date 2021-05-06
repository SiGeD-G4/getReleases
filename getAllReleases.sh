#!/bin/bash
tag_clients=('v0.1' 'v0.2' 'v0.3' 'v0.3.0' 'v0.3.1' 'v0.3.2' 'V1.0.0' 'V1.0.1' 'V1.1.0' 'V1.1.1')
tag_demands=('v0.1' 'v0.2' 'v0.3' 'v0.4' 'v0.4.0' 'v0.5.0' 'v0.5.1' 'v0.5.2' 'v0.6.0' 'v0.7.0' 'v0.8.0' 'v0.9.0' 'v1.0.0' 'v1.1.0' 'v1.2.0' 'v1.3.0' 'v1.4.0' 'v1.4.1')
tag_frontend=('v0.1' 'v0.2' 'v0.3' 'v0.4' 'v0.5' 'v0.6' 'v0.7' 'v0.8' 'v0.9' 'v0.9.0' 'v0.10.0' 'v0.10.1' 'v0.10.2' 'v0.11.0' 'v0.11.1' 'v0.12.0' 'v0.13.0' 'v0.14.0' 'v0.14.1' 'v1.0.0' 'v1.1.0' 'v1.2.0' 'v1.3.0' 'v1.3.1' 'v1.3.2' 'v1.3.3' 'v1.4.0' 'v1.4.1' 'v1.4.2' 'v1.4.3' 'v1.5.0' 'v1.5.1' 'v1.6.0' 'v1.7.0' 'v1.7.1' 'v1.7.2' 'v1.8.0' 'v1.9.0' 'v1.9.1')
#tag_sectors=('v0.1.0' 'v0.1.1' 'v1.0' 'v1.0.0' 'v1.0.1' 'v1.1.0' 'v1.1.1')
tag_sectors=('v1.1.1')
tag_users=('v0.1' 'v0.2' 'v0.3' 'v0.3.0' 'v0.3.1' 'v0.3.2' 'v1.0.0' 'v1.0.1' 'v1.0.2')

function run_updates {
  repo=$1
  tags=$@
  tags=( "${tags[@]/$repo}" )
  echo "repo: " $repo
  echo "tags: " $tags
  
  unset REPO
  export REPO=$repo

  for key in $tags;
    do
      echo $key;
      git reset $key
      git push -f
      sleep 40
      unset TAG
      export TAG=$key
      #cp /root/getReleases/token.env /root/getReleases/.env
      #echo "TAG="$key >> /root/getReleases/.env
      #echo "REPO="$repo >> /root/getReleases/.env
      node /root/getReleases/release.js
    done
  cd ..
}

# Update Clients
#echo "======= GET RELEASES FOR CLIENTS ======="
#cd 2020-2-SiGeD-Clients/
#run_updates "2020-2-SiGeD-Clients" ${tag_clients[@]}

# Update Demands
#echo "======= GET RELEASES FOR DEMANDS ======="
#cd 2020-2-SiGeD-Demands/
#run_updates  "2020-2-SiGeD-Demands" ${tag_demands[@]} 

# Update Frontend
#echo "======= GET RELEASES FOR FRONTEND ======="
#cd 2020-2-SiGeD-Frontend/
#run_updates  "2020-2-SiGeD-Frontend" ${tag_frontend[@]} 

# Update Sectors
echo "======= GET RELEASES FOR SECTORS ======="
cd 2020-2-SiGeD-Sectors/
run_updates "2020-2-SiGeD-Sectors" ${tag_sectors[@]}

# # Update Users
# echo "======= GET RELEASES FOR USERS ======="
# cd 2020-2-SiGeD-Users/
# run_updates "2020-2-SiGeD-Users" ${tag_users[@]}
