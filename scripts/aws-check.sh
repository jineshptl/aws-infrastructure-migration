#!/bin/bash
# Lists anything in AWS that costs money, in every region. Prints ALL CLEAR if nothing.
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_CREDENTIAL_EXPIRATION
if ! aws sts get-caller-identity >/dev/null 2>&1; then
  echo "CAN'T CHECK: not logged in. Run 'aws login' and try again."
  exit 1
fi
echo "Checking all regions (about 1 minute)..."
found=0
for r in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text); do
  printf "%s " "$r"
  i=$(aws ec2 describe-instances --region $r --filters Name=instance-state-name,Values=pending,running,stopping,stopped --query "Reservations[].Instances[].InstanceId" --output text)
  v=$(aws ec2 describe-volumes --region $r --query "Volumes[].VolumeId" --output text)
  e=$(aws ec2 describe-addresses --region $r --query "Addresses[].PublicIp" --output text)
  n=$(aws ec2 describe-nat-gateways --region $r --filter Name=state,Values=pending,available --query "NatGateways[].NatGatewayId" --output text)
  l=$(aws elbv2 describe-load-balancers --region $r --query "LoadBalancers[].LoadBalancerName" --output text 2>/dev/null)
  d=$(aws rds describe-db-instances --region $r --query "DBInstances[].DBInstanceIdentifier" --output text 2>/dev/null)
  for x in "servers:$i" "disks:$v" "elastic-ips:$e" "nat-gateways:$n" "load-balancers:$l" "databases:$d"; do
    if [ -n "${x#*:}" ]; then echo; echo "COSTS MONEY -> $r ${x%%:*}: ${x#*:}"; found=1; fi
  done
done
echo
b=$(aws s3 ls 2>/dev/null)
if [ -n "$b" ]; then echo "S3 buckets (small storage cost):"; echo "$b"; found=1; fi
[ $found -eq 0 ] && echo "ALL CLEAR: nothing running that costs money"
