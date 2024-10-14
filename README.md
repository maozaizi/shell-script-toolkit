# shell-script-toolkit

## About This Repo

This code repository serves as a storage space for various shell scripts I've developed while tinkering around. It includes scripts for setting up environments, installing MariaDB, installing Nginx, and backing up WordPress sites, among other operations. As a beginner, I aim to document my tinkering experiences here.

## setup01_Addsrc.sh

Automated Script for Installing Nginx, PHP, and MariaDB on Ubuntu

This Bash script is designed to automate the installation and configuration of a LEMP stack (Linux, Nginx, MariaDB, PHP) on an Ubuntu system. The script ensures that the necessary repositories and GPG keys are added for Nginx, MariaDB, and PHP, and handles the installation and configuration of each service.
Key Features:

    Root Privileges Check: Ensures the script is run with root permissions for proper installation.
    Nginx Installation:
        Adds the official Nginx signing key and repository for the mainline version.
        Configures package priority to prefer Nginx packages from the official repository.
    PHP Setup:
        Adds Ondřej Surý’s PPA for the latest PHP versions, ensuring compatibility with modern web applications.
    MariaDB Installation:
        Adds the MariaDB GPG key and repository, and installs MariaDB 10.6 for secure and reliable database management.
    Error Handling: The script is set to terminate immediately if any command fails, preventing incomplete installations.
    System Update: Ensures that the package lists are updated and the ubuntu-keyring is installed to support signed packages.

Usage:

    Clone the repository to your local machine.
    Run the script with root privileges (sudo ./script.sh).
    The script will automatically set up the Nginx, MariaDB, and PHP environment on your Ubuntu system.

This script simplifies the process of setting up a LEMP stack by automating the installation steps, making it ideal for new server setups or automated deployments.