import boto3
import os

def lambda_handler(event, context):
    ses = boto3.client('ses')
    sender_email = os.environ['rahmaashraf053@gmail.com']
    recipient_email = os.environ['rahmaashraf053@gmail.com']
    
    subject = "State File Change Detected"
    body = "A change has been detected in the state file of your Terraform workspace."
    
    response = ses.send_email(
        Source=sender_email,
        Destination={
            'ToAddresses': [recipient_email]
        },
        Message={
            'Subject': {'Data': subject},
            'Body': {'Text': {'Data': body}}
        }
    )

    return {
        'statusCode': 200,
        'body': response
    }
