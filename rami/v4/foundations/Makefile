BUCKET_NAME   := ""
BUCKET_PATH   := "foundations/state"
AWS_REGION    := "us-east-1"

init:
	echo "Initializing Terraform - Saving state at:" ; \
	echo "AWS Region    => $(AWS_REGION)" ; \
	echo "Bucket name   => $(BUCKET_NAME)" ; \
	echo "Bucket path   => $(BUCKET_PATH)" ; \
	terraform init \
	-backend-config="bucket=$(BUCKET_NAME)" \
	-backend-config="key=$(BUCKET_PATH)" \
	-backend-config="region=$(AWS_REGION)" ;

deploy: init
	terraform apply --auto-approve ;

destroy: init
	terraform destroy --auto-approve ;