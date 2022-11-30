#!/bin/bash
sudo yum update -y 
sudo yum install -y ${application} 


echo "<html>" > ${file}
echo "<body>" >> ${file}
echo "<h1><center> My public IP address is : </center></h1>" >> ${file}
echo "<h2 style=\"background-color:blue\">" >> ${file}
echo "<center>" >> ${file}
echo {{ passed_in_hosts }} >> ${file}   
echo "</center> </h2>" >> ${file}
echo "</body></html>" >> ${file}

systemctl start ${application}.service
systemctl enable ${application}.service


sudo yum install -y ruby 
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install 
chmod a+x ./install 
sudo ./install auto -v releases/codedeploy-agent-1.4.1-2244.noarch.rpm
