#!/bin/bash

# Delete all instances
for id in $(aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --output text)
do
  aws ec2 terminate-instances --instance-ids $id
done

# Wait for all instances to be terminated
aws ec2 wait instance-terminated

# Delete all load balancers
for arn in $(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].LoadBalancerArn' --output text)
do
  aws elbv2 delete-load-balancer --load-balancer-arn $arn
done

# Delete all network interfaces
for id in $(aws ec2 describe-network-interfaces --query 'NetworkInterfaces[*].NetworkInterfaceId' --output text)
do
  aws ec2 delete-network-interface --network-interface-id $id
done

# Detach and delete all internet gateways
for id in $(aws ec2 describe-internet-gateways --query 'InternetGateways[*].InternetGatewayId' --output text)
do
  for vpc in $(aws ec2 describe-internet-gateways --internet-gateway-ids $id --query 'InternetGateways[*].Attachments[*].VpcId' --output text)
  do
    aws ec2 detach-internet-gateway --internet-gateway-id $id --vpc-id $vpc
  done
  aws ec2 delete-internet-gateway --internet-gateway-id $id
done

# Delete all subnets
for id in $(aws ec2 describe-subnets --query 'Subnets[*].SubnetId' --output text)
do
  aws ec2 delete-subnet --subnet-id $id
done

# Delete all VPCs
for id in $(aws ec2 describe-vpcs --query 'Vpcs[*].VpcId' --output text)
do
  aws ec2 delete-vpc --vpc-id $id
done

echo "All specified resources have been deleted."