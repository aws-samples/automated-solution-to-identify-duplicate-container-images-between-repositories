## Automated Solution to Identify Duplicate Container Images between Repositories

For this walkthrough, following prerequisites are required to be completed:

a) AWS Account
b) ECR public registry
c) Understanding of following AWS services:
  1) AWS CodeCommit
  2) AWS CodePipeline
  3) AWS CodeBuild
  4) AWS IAM
  5) Amazon S3

d) CodeCommit credentials configuration
e) Clone this Gitlab repository to your local machine.

Please find the architcture diagram for reference:
![image](https://github.com/aws-samples/automated-solution-to-identify-duplicate-container-images-between-repositories/assets/113442298/581e890b-d13d-4bec-891b-c3172f075772)


## Setup CI/CD pipeline
The AWS CodePipeline will be setup with two stages to identify images that are already present in ECR repository. The pipeline will be configured with following resources:

AWS CodePipeline for orchestration of deployment pipeline.
AWS CodeCommit repository to store bash script and input file
AWS CodeBuild project to invoke the bash script to identify images that are already present in ECR repository.
Necessary IAM roles to allow access.
Amazon S3 bucket to store the output file that image URIs.
Another Amazon S3 bucket to store AWS CodePipeline artifacts.
Set the “SourceImageFile” parameter to “input.txt”

Refer the following steps to configure pipeline with all the necessary components:

Navigate to the root directory.
Create the CloudFormation stack using pipeline.yaml file with all the required parameters.

#Populate CodeCommit Repository
To populate the CodeCommit repository, perform following steps:

Open the CodeCommit console and navigate to the respective AWS region where CloudFormation stack was created.
Find the repository (provisioned using AWS CloudFormation script) from the list, select the Clone URL and copy the HTTPS URL protocol to connect to the repository.
Open a command prompt and run the git clone command with the HTTPS URL which was copied in previous step.
Navigate to the root directory. Create a file named input.txt and populate this file with ECR public image registry URIs that you would like to search in ECR repository.
Copy these files (script.sh, buildspec.yml and input.txt) to cloned repository.

Finally, upload the files to CodeCommit using commands below:

    git add .
    git commit -m “added input files”
    git push


## CodePipeline status
The pipeline will be released automatically and the pipeline status will be transitioned to in-progress. After a while when the bash script in CodeBuild stage has executed successfully, the pipeline will be transitioned to Succeeded state. You can download the output file from Output S3 bucket. This output file will have the list of all the ECR public image registry URI along with all the occurrences of image in ECR (list of ECR image URIs). The Output file will look like as mentioned below:
Source image URIs:
public.ecr.aws/<image-name>
Image present at ECR URIs:

    <account-id>.dkr.ecr.<region>.amazonaws.com/image1:   
    <account-id>.dkr.ecr.<region>.amazonaws.com/image2:latest


Note: This solution also applies to other public registries, like Docker Hub, Quay, etc

## Cleaning up
To avoid incurring future charges, delete the resources by following steps:

Navigate to CodePipeline artifact S3 bucket and empty the bucket.
Navigate to Output S3 bucket and empty the bucket.
Navigate to CloudFormation console and delete the stack created during the setup.

## Conclusion
The pattern explained an automated solution to identify the list of container images that are already present in Elastic Container Registry to help de-duplication of container images when migrating images from other container repositories like DockerHub.

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

