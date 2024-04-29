#!/bin/bash

# Function to clone PHP application from GitHub repository
clone_application() {
    echo "Cloning PHP application from GitHub repository..."
    git clone https://github.com/laravel/laravel /var/www/html/laravel
}

# Function to install LAMP stack
install_lamp_stack() {
    echo "Installing Apache, MySQL, PHP, Composer, and other required packages..."
    sudo apt-get update
    sudo apt-get install -y apache2 mysql-server composer
    sudo add-apt-repository ppa:ondrej/php --yes
    sudo apt update -y
    sudo apt install php8.2 php8.2-curl php8.2-dom php8.2-mbstring php8.2-xml php8.2-mysql zip unzip -y || handle_error "Failed to install PHP and extensions."
}

# Function to configure Apache to serve the PHP application
configure_apache() {
    echo "Configuring Apache to serve the PHP application..."
    sudo cp /var/www/html/laravel/.env.example /var/www/html/laravel/.env
    sudo chown -R www-data:www-data /var/www/html/laravel/storage
    sudo chmod -R 775 /var/www/html/laravel/storage
    sudo systemctl restart apache2
}

# Function to configure MySQL
configure_mysql() {
    echo "Configuring MySQL..."
    # Create MySQL database
    sudo mysql -uroot -e "CREATE DATABASE laravel_db;"
    # Create MySQL user
    sudo mysql -uroot -e "CREATE USER 'laravel_user'@'localhost' IDENTIFIED BY 'Wetindeyhappen';"
    # Grant necessary privileges to the new user
    sudo mysql -uroot -e "GRANT ALL PRIVILEGES ON laravel_db.* TO 'laravel_user'@'localhost';"
    # Flush privileges to apply changes
    sudo mysql -uroot -e "FLUSH PRIVILEGES;"
}

# Function to update .env file for Laravel configuration
update_env_file() {
    echo "Updating .env file for Laravel configuration..."
    sed -i 's/DB_CONNECTION=sqlite/DB_CONNECTION=mysql/' /var/www/html/laravel/.env
    sed -i 's/# DB_HOST=127.0.0.1/DB_HOSTS=127.0.0.1/' /var/www/html/laravel/.env
    sed -i 's/# DB_PORT=3306/DB_PORT=3306/' /var/www/html/laravel/.env
    sed -i 's/# DB_DATABASE=laravel/DB_DATABASE=laravel_db/' /var/www/html/laravel/.env
    sed -i 's/# DB_USERNAME=root/DB_USERNAME=laravel_user/' /var/www/html/laravel/.env
    sed -i 's/# DB_PASSWORD=/DB_PASSWORD=Wetindeyhappen/' /var/www/html/laravel/.env
}

# Function to migrate database schema
migrate_database() {
    echo "Migrating database schema..."
    cd /var/www/html/laravel
    php artisan migrate
}

# Main function to execute deployment steps
main() {
    clone_application
    install_lamp_stack
    configure_apache
    configure_mysql
    update_env_file
    migrate_database
    echo "Deployment of LAMP stack completed."
}

# Execute main function
main