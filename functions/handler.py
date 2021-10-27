import boto3
#import json
import logging
import os.path
import time

from botocore.signers import RequestSigner

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

fis = boto3.client('fis')

def hook_init(hook_payload):

    hook_info = {
        'experiment_template_id': os.environ.get('EXPERIMENT_TEMPLATE_ID'),
    }

    logger.info("Processing event with payload %s" % (str(hook_payload)))

    return hook_info

def lambda_handler(event, context):

    logger.info(event)

    # handle aws sns event
    for record in event['Records']:
        hook_info = {}
        hook_info = hook_init({})

        response = fis.start_experiment(
            experimentTemplateId=hook_info['experiment_template_id'],
            tags={
                'BuiltWith': 'terraform'
            }
        )
        logger.info("Processed event with response %s" % (str(response)))
