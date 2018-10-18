.DEFAULT_GOAL := plan

PROJECT=hero
REGION=us-east-1
AWS_PROFILE=default

# setup terraform bucket for aws
one-time:
	aws s3api create-bucket --bucket "tf-${PROJECT}-${REGION}" \
	--acl private --profile ${AWS_PROFILE} --region ${REGION}

init:
	terraform init && terraform get -update

apply: init
	terraform apply -auto-approve --var-file="terraform.tfvars"

plan: init
	terraform plan --var-file="terraform.tfvars"

destroy: init
	terraform destroy --force --auto-approve --var-file="terraform.tfvars"

refresh: init
	terraform refresh --var-file="terraform.tfvars"



