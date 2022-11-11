Note: We are saving the Terraform states in Amazon S3, so you need to create a new bucket for it before deploying anything. Also, remember to save it name at the Makefile vars

Deployment Steps
1| Go to the foundations/ directory and run in the command line:
    $ make deploy
    
    You can verify in AWS that the following resources where created:
    - AWS S3 Object (storing Terraform State). => ${bucket name}/${bucket path}/foundations/state
    - AWS Route 53 Hosted Zone. => lambda.${domain}.com
    - AWS Route 53 Record in domain zone that points to new hosted zone.
    - AWS generic ACM Certificate (with wildcard). => *.lambda.${domain}.com
    - AWS Route 53 Record in new HZ that validates the new certificate.
    - AWS API Gateway. => backend-services
    - AWS API Gateway Stage. => main
    - AWS API Gateway CDN. => backend.lambda.${domain}.com
    - AWS Route 53 Record in new HZ that points to API Gateway CDN. => backend.lambda.${domain}.com
    - AWS IAM Role for Lambda Functions (shared between all of them).

    Note: You have to set the values for the $bucket_name and $bucket_path at the Makefile!
    
2| Go to the apis/ directory and run in the command line:
    $ make deploy
    
    You can verify in AWS that the following resources where created:
    - AWS S3 Object (storing Terraform State). => ${bucket name}/${bucket path}/${function name}/state
    - AWS API Gateway resource and method. => ex: GET /service01
    - AWS Lambda Function. => service01
    - AWS CloudWatch Log Group for Lambda Function. => /aws/lambda/service_one

    Note: You need to have the compressed code for the Lambda Function done beforehand.

3| In order to deploy another function you need to go to:
    apis/Makefile         => Update the value of the FUNCTION_NAME variable
    apis/terraform.tfvars => Update tha value of these vars: APIGW_PATH, FUNCTION_NAME, ZIP_FILE_PATH, and FUNCTION_HANDLER

4| In order to test it go to the terminal and run:
    $ curl -X ${method} "https://{CDN}/${function_name}"
    ex: 
    $ curl -X GET "https://backend.lambda.${domain}/myservice"
    $ curl -X GET "https://backend.lambda.${domain}/anotherservice"
    $ curl -X GET "https://backend.lambda.${domain}/otherservice"

    $ curl -X GET "https://backend.lambda.ramirocuenca.com/service01"

5| In order to destroy the resources it's important that you destroy them sequentially:
    Note: If you have many Lambdas deployed, you need to destroy all of them before destroying the foundations!
    1st go to apis/ directory and run $ make destroy
    2nd go to foundations/ directory and run $ make destroy