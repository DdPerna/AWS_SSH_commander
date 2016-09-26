# AWS_SSH_commander
A bash script for running bash commands through ssh to AWS EC2 instances. 
Output is displayed on the host box and is seperated by a line of equal signs.
Tested on instances using Amazon linux AMI and Centos 6.

## Getting started

First, clone the repository using git (recommended):

```bash
git clone https://github.com/DdPerna/AWS_SSH_commander.git
```

or download the script manually using this command:

```bash
curl "https://raw.githubusercontent.com/AWS_SSH_commander/ssh_commander.sh" -o ssh_commander.sh
```

Then give the execution permission to the script and run it:

```bash
 $chmod +x ssh_commander.sh
 $./ssh_commander.sh
```

## Credentials

 In order to make API calls to AWS you will need the appropriate authenication credentials.
 
 1. If running the script from an instance in AWS it is recommended to assign an IAM role to that instance at launch.
 2. Or pass the credentials into the ~/.aws/credentials file

### Creating an IAM Role

- Creating an IAM role using the console is simple to start with
  https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html

### Setting up local credentials

- Located in the user's home directory. Create the file `~/.aws/credentials`
```
[default]
aws_access_key_id = ACCESS_KEY_ID
aws_secret_access_key = ACCESS_KEY
```

- Further information is located here  
  https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-config-files

## Setup
 The script is setup to accept a region and two tag values followed by the bash commands, or a flag to indicate a file location.
 This can be customized to your specific needs by customizing the filters section of the aws api call. 
 - For Example: to limit your search to instances with a tag called "Environment" that equals the value of the user's second input
 
 ENVIR=$2
 
 --filters "Name=tag:Environment,Values=$ENVIR"
 
 ### Keys
 The ssh connection is established with the ec2-user account and requires passing the required key for authenication. 
 The script looks at which region is passed in to select the key, but this can be changed to your use case.
 
 ## Considerations
 Sending Bash Commands over ssh can be strict and take some troubleshooting. 
 for example, using cd and executing a script on a remote instance 
 ```
 ./ssh_commander us-east-1 Stage APP 'sudo /bin/sh -c "cd /home/example && ./script.sh"'
 ```
