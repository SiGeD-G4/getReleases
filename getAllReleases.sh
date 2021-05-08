#!/bin/bash
tag_clients=(v0.1 v0.2 v0.3 v0.3.0 v0.3.1 v0.3.2 V1.0.0 V1.0.1 V1.1.0 V1.1.1)
tag_demands=(v0.1 v0.2 v0.3 v0.4 v0.4.0 v0.5.0 v0.5.1 v0.5.2 v0.6.0 v0.7.0 v0.8.0 v0.9.0 v1.0.0 v1.1.0 v1.2.0 v1.3.0 v1.4.0 v1.4.1)
tag_frontend=(v0.1 v0.2 v0.3 v0.4 v0.5 v0.6 v0.7 v0.8 v0.9 v0.9.0 v0.10.0 v0.10.1 v0.10.2 v0.11.0 v0.11.1 v0.12.0 v0.13.0 v0.14.0 v0.14.1 v1.0.0 v1.1.0 v1.2.0 v1.3.0 v1.3.1 v1.3.2 v1.3.3 v1.4.0 v1.4.1 v1.4.2 v1.4.3 v1.5.0 v1.5.1 v1.6.0 v1.7.0 v1.7.1 v1.7.2 v1.8.0 v1.9.0 v1.9.1)
tag_sectors=(v0.1.0 v0.1.1 v1.0 v1.0.0 v1.0.1 v1.1.0 v1.1.1)
tag_users=(v0.1 v0.2 v0.3 v0.3.0 v0.3.1 v0.3.2 v1.0.0 v1.0.1 v1.0.2)

function copy_files_to_repo {
  repo=$1
  case $repo in
    2020-2-SiGeD-Clients)
      cp /root/clients-docker-compose.yml /root/2020-2-SiGeD-Clients/docker-compose.yml
      cp /root/clients-package.json /root/2020-2-SiGeD-Clients/package.json
      cp /root/clients.env /root/2020-2-SiGeD-Clients/.env
    ;;
    2020-2-SiGeD-Demands)
      cp /root/demands-docker-compose.yml /root/2020-2-SiGeD-Demands/docker-compose.yml
      cp /root/demands-package.json /root/2020-2-SiGeD-Demands/package.json
      cp /root/demands.env /root/2020-2-SiGeD-Demands/.env
    ;;
    2020-2-SiGeD-Frontend)
      cp /root/frontend-docker-compose.yml /root/2020-2-SiGeD-Frontend/docker-compose.yml
      cp /root/frontend-package.json /root/2020-2-SiGeD-Frontend/package.json
    ;;
    2020-2-SiGeD-Sectors)
      cp /root/sectors-docker-compose.yml /root/2020-2-SiGeD-Sectors/docker-compose.yml
      cp /root/sectors-package.json /root/2020-2-SiGeD-Sectors/package.json
      cp /root/sectors.env /root/2020-2-SiGeD-Sectors/.env
    ;;
    2020-2-SiGeD-Users)
      cp /root/users-docker-compose.yml /root/2020-2-SiGeD-Users/docker-compose.yml
      cp /root/users-package.json /root/2020-2-SiGeD-Users/package.json
      cp /root/users.env /root/2020-2-SiGeD-Users/.env
    ;;
    *)
      echo "REPO NOT FOUND"
    ;;
  esac
}

function run_sonar_on_tags {
  repo=$1
  tags=$@
  tags=( "${tags[@]/$repo}" )
  echo "repo: " $repo
  echo "tags: " $tags
  
  unset REPO
  export REPO=$repo

  for key in $tags;
    do
      echo $(date +'%m/%d/%Y %H:%M')
      echo $key;
      git reset $key
      copy_files_to_repo $repo
      git add sonar-project.properties .github/workflows/sonarCoverage.yml docker-compose.yml package.json .env
      git commit -m "Add sonar properties"
      git push -f
      sleep 5m
      unset TAG
      export TAG=$key
      node /root/getReleases/release.js
    done
  cd ..
}

echo "======= GET RELEASES FOR CLIENTS ======="
cd 2020-2-SiGeD-Clients/
run_sonar_on_tags "2020-2-SiGeD-Clients" ${tag_clients[@]}

echo "======= GET RELEASES FOR DEMANDS ======="
cd 2020-2-SiGeD-Demands/
run_sonar_on_tags  "2020-2-SiGeD-Demands" ${tag_demands[@]} 

echo "======= GET RELEASES FOR FRONTEND ======="
cd 2020-2-SiGeD-Frontend/
run_sonar_on_tags  "2020-2-SiGeD-Frontend" ${tag_frontend[@]} 

echo "======= GET RELEASES FOR SECTORS ======="
cd 2020-2-SiGeD-Sectors/
run_sonar_on_tags "2020-2-SiGeD-Sectors" ${tag_sectors[@]}

echo "======= GET RELEASES FOR USERS ======="
cd 2020-2-SiGeD-Users/
run_sonar_on_tags "2020-2-SiGeD-Users" ${tag_users[@]}

echo "======= FINISHED SCRIPT ======="

