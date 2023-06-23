#!/bin/sh

/opt/halyard/bin/halyard &

echo "waiting now"
sleep 20;
CONTEXT=$(aws eks update-kubeconfig --region ${REGION} --name ${CLUSTER_NAME})
echo "done waiting"
hal config provider kubernetes enable;
sleep 2;
hal config provider kubernetes account add eks-spinnaker --context $(kubectl config current-context);
sleep 2;
hal config features edit --artifacts true;
sleep 2;
hal config deploy edit --type distributed --account-name eks-spinnaker ;
sleep 2;
echo "bucket name"
echo $S3_BUCKET
hal config storage s3 edit --access-key-id $AWS_ACCESS_KEY_ID \
   --secret-access-key $AWS_SECRET_ACCESS_KEY --region $REGION --bucket $S3_BUCKET;
sleep 2;
hal config storage edit --type s3;
sleep 2;
hal config version edit --version 1.30.2


# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?