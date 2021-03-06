#!/bin/bash


project_name="wordpress" 
user_name="wordpress"
pass_word="wordpress"  
email="your-email@example.com"
website_title="My Blog"
website_url="https://www.example.com"
phmyadmin_url="sql.example.com"
env_file=".env"
compose_file="docker-compose.yml"



echo ---SETTING PRODUCTION ENVIRONMENT VARIABLES----
echo $env_file and $compose_file backups \(before update\) are available in _trash folder


mkdir -p _trash
cp $env_file _trash/$env_file
cp $compose_file  _trash/$compose_file

rm -rf $compose_file $env_file
curl -s https://raw.githubusercontent.com/kassambara/wordpress-docker-compose/master/docker-compose-onlinehost.yml > $compose_file
curl -s https://raw.githubusercontent.com/kassambara/wordpress-docker-compose/master/.env > $env_file



sed -i -e "/COMPOSE_PROJECT_NAME/s/wordpress/$project_name/" $env_file


sed -i -e "/DATABASE_PASSWORD/s/password/$pass_word/" $env_file
sed -i -e "/DATABASE_USER/s/root/$user_name/" $env_file
sed -i -e "/WORDPRESS_ADMIN_PASSWORD/s/wordpress/$pass_word/" $env_file
sed -i -e "/WORDPRESS_ADMIN_USER/s/wordpress/$user_name/" $env_file
sed -i -e "s/your-email@example.com/$email/" $env_file


url=$website_url
url=$(echo $url | sed 's/http:/https:/g') 

url_without_http=${url/https:\/\//}             
url_without_www=${url_without_http/www./}
url=$(echo $url | sed 's;/;\\/;g') # Escape / in url
sed -i -e "s/sql.example.com/$phmyadmin_url/" $env_file
sed -i -e "s/My Blog/$website_title/" $env_file
sed -i -e "s/http:\/\/localhost/$url/" $env_file
sed -i -e "s/localhost/$url_without_http/" $env_file
sed -i -e "s/example.com/$url_without_www/" $env_file

# Update automatically docker-compose.yml file
# --------------------------------------------------------------------------
sed -i -e "s/https:\/\/www.change-me-with-your-domain.com/$url/" $compose_file

echo -----------------DONE-----------------
echo Inspect now the $env_file and the $compose_file files to check if settings are OK


