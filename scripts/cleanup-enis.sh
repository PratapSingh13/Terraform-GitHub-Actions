#!/bin/bash
# cleanup-enis.sh
# Purpose: Clean up orphaned ENIs left by EKS VPC CNI during destroy

VPC_ID=$1
REGION=$2
CLUSTER_NAME=$3

echo "Starting cleanup of orphaned ENIs for VPC: $VPC_ID and Cluster: $CLUSTER_NAME in $REGION..."

# 1. Get all 'available' ENIs in the specified VPC
ENI_IDS=$(aws ec2 describe-network-interfaces \
    --region "$REGION" \
    --filters "Name=vpc-id,Values=$VPC_ID" "Name=status,Values=available" \
    --query 'NetworkInterfaces[?contains(Description, `'"$CLUSTER_NAME"'`) || contains(Description, `aws-K8S`)].NetworkInterfaceId' \
    --output text)

if [ -n "$ENI_IDS" ] && [ "$ENI_IDS" != "None" ]; then
    echo "Found ENIs to delete: $ENI_IDS"
    for ENI in $ENI_IDS; do
        echo "Deleting ENI: $ENI"
        aws ec2 delete-network-interface --network-interface-id "$ENI" --region "$REGION" || echo "Failed to delete $ENI"
    done
fi

# 2. Get all EKS-related Security Groups in the VPC
SG_IDS=$(aws ec2 describe-security-groups \
    --region "$REGION" \
    --filters "Name=vpc-id,Values=$VPC_ID" \
    --query 'SecurityGroups[?GroupName!=`default` && (contains(GroupName, `'"$CLUSTER_NAME"'`) || contains(Description, `'"$CLUSTER_NAME"'`))].GroupId' \
    --output text)

if [ -n "$SG_IDS" ] && [ "$SG_IDS" != "None" ]; then
    echo "Found Security Groups to delete: $SG_IDS"
    for SG in $SG_IDS; do
        echo "Deleting Security Group: $SG"
        aws ec2 delete-security-group --group-id "$SG" --region "$REGION" || echo "Failed to delete $SG (might have dependencies)"
    done
fi

echo "Cleanup complete."
