Domains-Lookup-Tool
====================

A domain expiry checker and data analytics based on 
 [whois](https://lookup.icann.org/) lookup.

 panel developed using php56.*, bootstrap4 and bash scripts on redhat Linux OS (fedora27 in local and centos 7.5 on server) 

####Install whois:

```
# yum install whois		#RHEL/CentOS
# dnf install whois		#Fedora 22+
$ sudo apt install whois	#Debian/Ubuntu
```

####Set cronJob
```
crontab -e
Add cronjob for 
scripts/bash/start.sh 

```

####Config smtp server
To send email notification add config files to scripts/certs


app/ directory and public/config.php generated to use sqlite database in future


- About whois [https://whois.icann.org/en](https://whois.icann.org/en/basics-whois) 
- Any question? feel free to mail 
 [Amirhosein_Morteza@yahoo.com](https://Amirhosein_Morteza@yahoo.com) 
