#!/bin/bash
SUBSCRIPTION_ID=$1
JOB_RESOURCE_GROUP="rg-glb-uks-ghrunners"
JOB_NAME_LIST=("aca-glb-uks-devops" "aca-glb-uks-nomad-app" "aca-glb-uks-nomad-backend" "aca-glb-uks-nomad-infra")

for CONTAINER_JOB in "${JOB_NAME_LIST[@]}"; do
    echo "Scaling container app job $CONTAINER_JOB to 0 replicas"
    az rest -m PATCH --header "Accept=application/json" -u "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$JOB_RESOURCE_GROUP/providers/Microsoft.App/jobs/$CONTAINER_JOB?api-version=2024-03-01" --body "{'properties': {'configuration': {'eventTriggerConfig': {'scale': {'minExecutions': 0}}}}}"
    echo "Stopping all executions of container app job $CONTAINER_JOB"
    az rest -m POST --header "Accept=application/json" -u "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$JOB_RESOURCE_GROUP/providers/Microsoft.App/jobs/$CONTAINER_JOB/stop?api-version=2024-03-01"
done