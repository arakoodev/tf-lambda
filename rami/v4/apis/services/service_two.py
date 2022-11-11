import json

def handler_function(event, context):
  message = 'Hello! I\'m service number 2'
  return {
        "statusCode": 200,
        "body": json.dumps({"statusCode": 200,"message": message}),
        "isBase64Encoded": False
    }