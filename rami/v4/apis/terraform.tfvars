/* Route 53 variables */
DOMAIN_NAME = "" # Domain name

/* API Gateway variables */
API_GATEWAY_NAME = "backend-services" # API Gateway name
APIGW_METHOD     = "GET"              # API Gateway method
APIGW_PATH       = "service01"        # API Gateway path

/* Lambda variables */
FUNCTION_NAME    = "service_one"                  # Lambda Function name
ZIP_FILE_PATH    = "dist/service_one.zip"         # Path to the ZIP file (Lambda)
FUNCTION_HANDLER = "service_one.handler_function" # filename.func_name (Python)
FUNCTION_RUNTIME = "python3.8"                    # Language and version bein used