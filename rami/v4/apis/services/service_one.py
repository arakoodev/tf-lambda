import json

def handler_function(event, context):
  message = 'Hello! I\'m service number 1'
  return {
        "statusCode": 200,
        "body": json.dumps({"statusCode": 200,"message": message}),
        "isBase64Encoded": False
    }