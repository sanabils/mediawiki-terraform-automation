# mediawiki-tf-module

`mediawiki-tf-module` is a Terraform module to create EC2 instance on AWS and install and configure [MediaWiki](https://www.mediawiki.org/wiki/Manual:Running_MediaWiki_on_Red_Hat_Linux) on it in fully automated fashion.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= v1.4.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.0 |

### Terraform installation 

Please follow [this link](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) to install Terraform 

### Set AWS Access keys and Secret

Just export `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables and allow the AWS SDK to handle it using the AWS provider.

```
export AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxx/xxxx
```

### Run terraform as below

### init

```
terraform init
```

The `terraform init` command initializes a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control.


### apply

Make sure to provide DB username and password as parameters to `terraform apply` command
```
terraform apply -var "db_username=xxxx" -var "db_password=xxxx" -auto-approve
```

The terraform apply command is used to apply all changes to the project infrastructure specified in the terraform plan.

### Validation 

* Wait for couple of minutes(be patient) before mediawiki is being installed and configured. 
* Once `terraform appy` command is executed successfully then, connect to created ec2 instance through ssh and monitor `user_data.sh` logs at this location /var/log/cloud-init-output.log
* Again be patient and trail the log /var/log/cloud-init-output.log until you get the message `[INFO] Mediawiki installation has been completed.`
* Now get `Public IP` of EC2 instance and hit it in browser. The mediawiki will be accessible on port 80 through url http://\<public ip\> or http://\<public ip\>:80
  

### Destroy created resources

```
terraform destroy -var "db_username=xxxx" -var "db_password=xxxx" -auto-approve
```

The terraform destroy command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.

### Links

[MediaWiki Installation](https://www.mediawiki.org/wiki/Manual:Running_MediaWiki_on_Red_Hat_Linux)
