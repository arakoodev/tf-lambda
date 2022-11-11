# Change this value each time you want to deploy a new Lambda Function!
FUNCTION_NAME := "service01"

BUCKET_NAME   := ""
BUCKET_PATH   := "apis/$(FUNCTION_NAME)/state"
AWS_REGION    := "us-east-1"

init:
	echo "Initializing Terraform - Saving state at:" ; \
	echo "AWS Region    => $(AWS_REGION)" ; \
	echo "Bucket name   => $(BUCKET_NAME)" ; \
	echo "Bucket path   => $(BUCKET_PATH)" ; \
	echo "Function name => $(FUNCTION_NAME)" ; \
	rm -rf .terraform/ .terraform.lock.hcl
	terraform init \
	-backend-config="bucket=$(BUCKET_NAME)" \
	-backend-config="key=$(BUCKET_PATH)" \
	-backend-config="region=$(AWS_REGION)" ;

deploy: init
	terraform apply --auto-approve ;

destroy: init
	terraform destroy --auto-approve ;