echo "this is a script to help you wityh key rotation"

read -p "choose a name for the key: " KEY_NAME

read -p "what is the public ip adderess of the ec2 instance?: " EC2_IP

read -p "give us the location of the current key to the ec2: " EC2_CURRENT_KEY



if [ -z $KEY_NAME ]; then
    echo "the key name is not initialized"
fi

if [ -z $EC2_IP ]; then
    echo "the ip of the ec2 is not initialized"
fi

if [ -z $EC2_CURRENT_KEY ]; then
    echo "the current key location is not initialized"
fi

ssh-keygen -t rsa -N "" -f $KEY_NAME

echo "keys created"


scp -i $EC2_CURRENT_KEY "${KEY_NAME}.pub" ec2-user@$EC2_IP:~/"${KEY_NAME}.pub"
echo "key copied"

ssh -i $EC2_CURRENT_KEY ec2-user@$EC2_IP bash -c "'cat ${KEY_NAME}.pub | tee -a  ~/.ssh/authorized_keys'"

echo "key added to authorized_keys"

ssh -i $EC2_CURRENT_KEY ec2-user@$EC2_IP rm "${KEY_NAME}.pub"

echo "key removed from server"

echo "Done"