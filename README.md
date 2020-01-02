Drupal Environment Creator (DECr)
=================================


CONTENTS OF THIS FILE
---------------------
   
 * Introduction
 * Requirements
 * Recommended plugins
 * Installation
 * Configuration
 * Troubleshooting
 * FAQ
 * Maintainers


INTRODUCTION
------------

The Drupal Environment Creator (DECr) is project which uses vagrant with virtualbox to create and handle drupal instances for developers. It creates vm with fully configured apache2 webserwer with mariadb.


REQUIREMENTS
------------

This package requires the following programs:

 * Vagrant [recomended 2.2+] (https://www.vagrantup.com/)
 * Virtualbox [recomended 5.6+] (https://www.virtualbox.org/)
 * Virtualbox Guest Additions (https://www.virtualbox.org/)
 
 
RECOMMENDED PLUGINS
-------------------

 * Vagrant Hostupdater [must be 1.1+] (https://github.com/cogitatio/vagrant-hostsupdater):
   When installed DECr also creates aliases to declared ips in configuration using host filed.
   

INSTALLATION
------------
 
 * Install DECr by going to its direcotry from terminal and typing:
   vagrant up
   
 * It may take a while. At the end you will be able to see "DECr Successfully (re)installed".
 
 
CONFIGURATION
-------------
 
 * All of configuration you set by editing config.json file.
 
 * Configure the vm:

   - Memory [memory]

     The amount of RAM the DECr will be able to use.

   - Start IP [start_ip]

     The ip be used to handle DECr standard (help, informations) page.

   - Start Host [start_host]

     The host will be used to handle DECr standard page, if you have HostUpdater installled.
	 
   - Forwarded Ports [forwarded_ports]

     The ports will will be forwarded between host and guest.

 * Configure the Drupal instances:
 
   - Name [name]
   
     The name will be taken as drupal site name.
	 
   - Drupal Version [drup_ver]
   
     The branch of Drupa project will be used when Git cloning.
	 
   - PHP Version [php_ver]
   
     The version of php will be used to handle instances.
	 
   - IP [ip]
   
	 The ip will be used as standard access to webpage.
	 
   - Host [host]
   
     The host will be used as second access to webpage, if you have HostUpdater installled.
	 
   - Path [path]
   
     The path name will be used for creating instance base path on guest and host.
	 
   - Catalog Type [catalog_type]
   
     The type of file system to be used for instance base path.
	 
   - User Login [user >> login]
   
	 The nickname for drupal instance and database (drup-[login]).
	 
   - User Password [user >> login]
   
	 The password for drupal instance and database.
	
	
TROUBLESHOOTING
---------------

 * If the provision causes on error:

   Try turn off your anty-virus software or adding vagrant with virtualbox to exclusions in firewall options
   
 * If Vagrant has internet connection problems:
 
   Try restart DECr using:
   vagrant halt
   vagrant up
   
 * If Hostupdater does not work:
 
   Try changing C:/Windows/system32/drivers/etc/hosts file permissions to allow users group modify action.
   

FAQ
---

Q: Must I fill host fields in configuration, when not use of Hostupdater?

A: Yes, because of adding it to apache2 sites configuration. Skipping it may cause syntax error.

Q: Why instances works so slow?!

A: They slow, bacuse of their type is seted to default. Switching to nfs is good idea, but your system must support it (sorry Windows users :( )

Q: Can I use vagrant provision multiple times?

A: Yes, it's for reinitialize purposes.
   
   
MAINTAINERS
-----------

Current maintainers:
 * Adam Wróbel (adam3278) - https://www.drupal.org/u/adam3278