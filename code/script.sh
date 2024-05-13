#!/bin/bash


while read line
do 

docker pull $line
SourceImageId=`docker inspect $line | jq .[].Id | sed 's/"//g'`

echo "Source image URIs: " >> Output
echo -e '\t'$line >> Output
echo "Image present at ECR URIs: " >> Output

aws ecr get-login-password --region $2 | docker login --username AWS --password-stdin $3.dkr.ecr.$2.amazonaws.com
RepositoryNames=`aws ecr describe-repositories | jq .repositories[].repositoryName | sed 's/"//g'`

for RepositoryName in ${RepositoryNames[@]}; do
  
  ImageTags=`aws ecr describe-images --repository-name $RepositoryName | jq .imageDetails[].imageTags[0] | sed 's/"//g'`
  for ImageTag in ${ImageTags[@]}; do

  	docker pull $3.dkr.ecr.$2.amazonaws.com/$RepositoryName:$ImageTag
  	ImageId=`docker inspect $3.dkr.ecr.$2.amazonaws.com/$RepositoryName:$ImageTag | jq .[].Id | sed 's/"//g'`

  	if [[ "$SourceImageId" == "$ImageId" ]]; then
  	  echo -e '\t'$3.dkr.ecr.$2.amazonaws.com/$RepositoryName:$ImageTag >> Output
  	fi
  	docker image rm $3.dkr.ecr.$2.amazonaws.com/$RepositoryName:$ImageTag
  done
done
printf "\n"
done < $1



