import json
import boto3
import os
import string
import random

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("url-shortener")

def lambda_handler(event, context):
    path = event.get("rawPath", "")
    method = event.get("requestContext", {}).get("http", {}).get("method", "")
    
    # Handle root path GET /
    if method == "GET" and path == "/":
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"message": "URL Shortener API is running!"})
        }

    # Shorten URL
    if method == "POST" and path == "/shorten":
        body = json.loads(event.get("body", "{}"))
        long_url = body.get("url")
        
        if not long_url:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing 'url' in request"})
            }

        code = ''.join(random.choices(string.ascii_letters + string.digits, k=6))
        table.put_item(Item={"code": code, "url": long_url})

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"code": code})
        }

    # Redirect using code
    if method == "GET" and path.startswith("/"):
        code = path.lstrip("/")
        response = table.get_item(Key={"code": code})
        item = response.get("Item")

        if item:
            return {
                "statusCode": 302,
                "headers": {
                    "Location": item["url"]
                },
                "body": ""
            }
        else:
            return {
                "statusCode": 404,
                "body": json.dumps({"error": "Code not found"})
            }

    # Unknown route
    return {
        "statusCode": 404,
        "body": json.dumps({"error": "Route not found"})
    }
