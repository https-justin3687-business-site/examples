#!/bin/bash

# Source library
. ../utils/helper.sh
  
# Source demo-specific configurations
source config/demo.cfg

# Setup Azure container
export AZBLOB_ACCOUNT_KEY=$(az storage account keys list --account-name $AZBLOB_STORAGE_ACCOUNT | jq -r '.[0].value')
az storage container show --name $AZBLOB_CONTAINER --account-name $AZBLOB_STORAGE_ACCOUNT --account-key $AZBLOB_ACCOUNT_KEY 2>/dev/null
if [[ $? != 0 ]]; then
  echo "az storage container create --name $AZBLOB_CONTAINER --account-name $AZBLOB_STORAGE_ACCOUNT --account-key $AZBLOB_ACCOUNT_KEY"
  az storage container create --name $AZBLOB_CONTAINER --account-name $AZBLOB_STORAGE_ACCOUNT --account-key $AZBLOB_ACCOUNT_KEY
fi

create_connector_cloud connectors/az_no_avro.json || exit 1
wait_for_connector_up connectors/az_no_avro.json 240 || exit 1

# While Azure Blob Sink is in Preview, limit is only one connector of this type
# So these lines are to remain commented out until then
#create_connector_cloud connectors/az_avro.json || exit 1
#wait_for_connector_up connectors/az_avro.json 240 || exit 1

exit 0
