#!/bin/bash
apt-get update
apt-get -y upgrade
apt install -y python3-pip python3.8-venv nginx awscli
ufw allow 8080
systemctl start nginx
systemctl enable nginx
echo "export GITHUB_TOKEN=$(aws --region ap-south-1 ssm get-parameters --names github_token --with-decryption --query Parameters[0].Value | tr -d '"')" >> ~/.profile
git clone https://kartikay1506:${GITHUB_TOKEN}@github.com/kartikay1506/one2n-assignment.git
cd one2n-assignment
python3 -m venv venv && source venv/bin/activate
pip install flask gunicorn boto3
sed -i '1s/^/upstream list-bucket-content {server 127.0.0.1:8080;}\n/' /etc/nginx/sites-available/default
systemctl restart nginx
echo "export AWS_ACCESS_KEY=$(aws --region ap-south-1 ssm get-parameters --names access_key_id --with-decryption --query Parameters[0].Value | tr -d '"')" >> ~/.profile
echo "export AWS_SECRET_ACCESS_KEY=$(aws --region ap-south-1 ssm get-parameters --names secret_access_key --with-decryption --query Parameters[0].Value | tr -d '"')" >> ~/.profile
gunicorn -b :8080 app:app --daemon