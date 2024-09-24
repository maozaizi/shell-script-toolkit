# shell-script-toolkit

## About This Repo

This code repository serves as a storage space for various shell scripts I've developed while tinkering around. It includes scripts for setting up environments, installing MariaDB, installing Nginx, and backing up WordPress sites, among other operations. As a beginner, I aim to document my tinkering experiences here.

## setup01_Addsrc.sh

Script for Installing and Configuring Nginx, PHP, and MariaDB on Ubuntu

This Bash script automates the setup of essential web server components on Ubuntu, including Nginx, MariaDB, and PHP. It ensures the system is up to date and installs necessary GPG keys, software repositories, and package priorities. Key features of the script:

    Nginx: Adds the official Nginx repository and installs it with a high priority pinning to the mainline version.
    PHP: Adds Ondřej Surý's PPA for the latest PHP versions.
    MariaDB: Adds the official MariaDB repository and installs version 10.6 with proper key signing.
    System Setup: Ensures ubuntu-keyring is installed, and the system's package lists are updated accordingly.

This script is designed to streamline the process of setting up a LEMP (Linux, Nginx, MariaDB, PHP) stack on Ubuntu.