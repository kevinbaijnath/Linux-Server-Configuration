# Linux-Server-Configuration

This project enables deployment and setup of an application on a Linux VM.  

## Accessing application
* [Website](http://ec2-52-37-248-241.us-west-2.compute.amazonaws.com/)
* IP Address: 52.37.248.241
* SSH Port: 2200

## Key Features
* Automated configuration and deployment of application and security settings using a [deployment script](deployment.sh)
* [Item-Catalog](https://github.com/kevinbaijnath/Item-Catalog/tree/linuxserver) served by Apache
* Postgres has been setup and configured for the Item-Catalog site

## Summary Of Configuration Applied
1. Update package sources and upgrade installed packages
2. Install required packages
  * Apache - Serves the application
  * mod_wsgi - Enables apache to serve python applications
  * Postgresql - Database used by application
  * Git - Used to obtain the application files
  * libpam-cracklib - Changes password requirements for users to be more secure
3. Create and configure a user named grader
  * Create new user named grader
  * Copy public key to new users' authorized_keys file
  * Force user to change password on first time login
  * Give grader user sudo permissions
4. Change the time zone to UTC
5. Configure SSH
  * Change SSH port from 22 to 2200
  * Disable password authentication via SSH
  * Disable login as root via SSH
6. Configure firewall (ufw)
  * Block all inbound requests from all ports except 2200, 80 and 123
  * Allow all outgoing requests
7. Obtain application
  * Download application from git
  * Install all python packages required by the application
8. Configure Postgres
  * Create a new user in postgres named catalog
  * Create a new db named itemcatalog and give permissions to the catalog user
9. Configure application
  * Populate db with default information
  * Move all of the application files to the apache folder
10. Configure apache
  * Enable apache to serve the python application
11. Enable all of the settings
  * Restart apache service
  * Restart SSH service
  * Enable UFW

## Technologies used
* [Ubuntu](https://www.ubuntu.com/)
* [Apache](https://httpd.apache.org/)
* [Python](https://www.python.org/)
* [Postgres](https://www.postgresql.org/)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details

## Acknowledgments

* The team at Udacity
* The Udacity Forums
* Stack Overflow
* Some Specific questions referenced
  * [Adding a user noninteractively](https://askubuntu.com/questions/94060/run-adduser-non-interactively)
  * [Changing timezone in linux](https://unix.stackexchange.com/questions/110522/timezone-setting-in-linux)
  * [Configure Postgres](https://help.ubuntu.com/community/PostgreSQL)
  * [Using sed](https://stackoverflow.com/questions/11694980/using-sed-insert-a-line-below-or-above-the-pattern)
