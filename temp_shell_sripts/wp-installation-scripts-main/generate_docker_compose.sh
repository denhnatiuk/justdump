DB_HOST=$(aws ssm get-parameter --name "/myapp/DB_HOST" --query "Parameter.Value" --output text)
DB_NAME=$(aws ssm get-parameter --name "/myapp/DB_NAME" --query "Parameter.Value" --output text)
DB_NEWUSER=$(aws ssm get-parameter --name "/myapp/DB_NEWUSER" --with-decryption --query "Parameter.Value" --output text)
DB_NEWPASSWORD=$(aws ssm get-parameter --name "/myapp/DB_NEWPASSWORD" --with-decryption --query "Parameter.Value" --output text)
DOMAIN=$(aws ssm get-parameter --name "/myapp/DOMAIN" --with-decryption --query "Parameter.Value" --output text)

cp docker-compose.yml ~/docker-compose.yml

cp -r php-fpm ~/php-fpm

# Replace the variables in the docker-compose.yml file
sed -i "s/\$acc_name/$DB_NAME/g" ~/docker-compose.yml
sed -i "s/\$dbhost/$DB_HOST/g" ~/docker-compose.yml
sed -i "s/\$dbuser/$DB_NEWUSER/g" ~/docker-compose.yml
sed -i "s/\$dbpassword/$DB_NEWPASSWORD/g" ~/docker-compose.yml
sed -i "s/\$dbname/$DB_NAME/g" ~/docker-compose.yml
sed -i "s/\$domain/$DOMAIN/g" ~/docker-compose.yml