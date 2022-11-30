#!/bin/bash
sudo yum update -y 
sudo yum install -y ${application} 


echo "<html>" > ${file}
echo "<body>" > ${file}
echo "<h1><center> My public IP address is : </center></h1>" > ${file}
echo "<h2 style=\"background-color:blue\">" > ${file}
echo "<center>" > ${file}
echo {{ passed_in_hosts }} > ${file}   
echo "</center> </h2>" > ${file}
echo "</body></html>" > ${file}

systemctl start ${application}.service
systemctl enable ${application}.service