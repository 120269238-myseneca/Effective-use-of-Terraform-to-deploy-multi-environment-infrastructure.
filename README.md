Made by Sudeep Saurabh
---

# Effective use of Terraform to deploy multi-environment infrastructure.

Welcome to AWS Terraform Deployment Guide! Follow the instructions below to set up and deploy your AWS infrastructure using Terraform.  

The Architecture:
<div align="center">
<img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture15.png" width="500" alt="Alt text">
</div>


## Warning: Image Guidance

The images provided in this document are meant to serve as a visual guide to help you understand what the output should look like after running the code. Please take note of the following:

- The images are illustrative and meant for guidance only.
- The white highlighted or redacted parts in the images are intentionally placed to hide sensitive information such as API keys, IP addresses, and other confidential data.
- Ensure to replace any placeholders or redacted information with your own valid credentials and data.


Please follow the instructions carefully, and use the images as a reference to verify that you are on the right track.


## Prerequisites

Before we start, make sure you have the following:

1. **AWS S3 Bucket**: Create an S3 bucket named `acs730-assignment-ssaurabh3` to store the Terraform state files.
2. **AWS Cloud9 Environment**: Create a Cloud9 environment named "Assignment". After creation, open Cloud9 and upload the project folder. To do this:
   - Click on "File" > "Upload Local Files".
   - Select and upload the unzipped project folder.
3. **SSH Keys**: Generate two SSH keys for authentication.
   - In terminal run to create SSH Key for the staging-vpc:
     ```
     cd Final/staging/webservers
     ssh-keygen -t rsa -f assignment-staging
     ```
    - Press "Enter" until the process is complete.


<div align="center">
<img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture1.png" width="500" alt="Alt text">
</div>


       
   - Create new SSH keys for prod-vpc, by run the code:
     ```
     cd ../../prod/webservers
     ssh-keygen -t rsa -f assignment-prod
     ```
     Press "Enter" until the process is complete.

     
<div align="center">
<img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture2.png" width="500" alt="Alt text">
</div>



## Deployment Steps  
Reminder come back to "Final" Folder: 
   ```
     cd ..//..
   ```

1. **Deploy the STAGING VPC Network**:
   ```sh
   cd staging/network
   terraform init
   terraform validate
   terraform plan 
   terraform apply -auto-approve
   ```

   
<div align="center">
<img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture3.png" width="500" alt="Alt text">
</div>


2. **Deploy the PROD VPC Network**:
   ```sh
   cd ../../prod/network
   terraform init
   terraform validate
   terraform plan
   terraform apply -auto-approve
   ```


<div align="center">
<img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture4.png" width="500" alt="Alt text">
</div> 
IMPORANT: Only when the Staging and Prod VPC is deploy , then run next code


3. **Set up VPC Peering**:
   ```sh
   cd ../../vpc_perring
   terraform init
   terraform validate
   terraform plan
   terraform apply -auto-approve
   ```

4. **Deploy the STAGING Web Servers**:
   ```sh
   cd ../staging/webservers
   terraform init
   terraform validate
   terraform plan
   terraform apply -auto-approve
   ```

   
<div align="center">
<img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture5.png" width="500" alt="Alt text">
</div>


5. **Deploy the PROD Web Servers**:
   ```sh
   cd ../../prod/webservers
   terraform init
   terraform validate
   terraform plan
   terraform apply -auto-approve
   ```
<div align="center">
<img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture6.png" width="500" alt="Alt text">
</div>


## Accessing VMs via Bastion Host
Reminder come back to "Final/staging/webservers" Folder by running below code after deploy of Prod Web Servers

   ```
     cd ../../staging/webservers
   ```

1. **Transfer SSH Keys to Bastion Host**:
   Replace `BASTION_HOST_PUBLIC_IP` with the actual public IP of your Bastion host. The public IP can be found either from when you deploy staging Web Servers, or go EC2 instance and find assignment-staging-bastion instance. Click on instance, and see the public IPv4 address.

<div align="center">
<img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture7.png" width="500" alt="Alt text">
</div>



(Also after running first script, they will ask Are you sure you want to continue connecting (yes/no)?  
Enter: Yes)

   ```sh
   scp -i assignment-staging assignment-staging ec2-user@BASTION_HOST_PUBLIC_IP:/home/ec2-user/
   scp -i assignment-staging ../../prod/webservers/assignment-prod ec2-user@BASTION_HOST_PUBLIC_IP:/home/ec2-user/
   ```

<div align="center">
<img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture8.png" width="500" alt="Alt text">
</div>


3. **SSH into Bastion Host**:
   ```sh
   ssh -i assignment-staging ec2-user@BASTION_HOST_PUBLIC_IP
   ```


<div align="center">
<img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture10.png" width="500" alt="Alt text">
</div>


4. **Connect to VMs**:
   - Replace `VM2_PRIVATE_IP` with the actual private IP of VM2 .Connecting to VM2. 


     ```sh
     chmod 400 assignment-staging
     ssh -i assignment-staging ec2-user@VM2_PRIVATE_IP
     ```


- After running last given script, it will say "Are you sure you want to continue connecting (yes/no)?" Enter Yes


<div align="center">
<img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture11.png" width="500" alt="Alt text">
</div>


 - After connecting to run website:
     ```sh 
     exit
     curl http://VM2_PRIVATE_IP
      ```


<div align="center">
<img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture12.png" width="500" alt="Alt text">
</div>


   - For VM3
   Replace `VM3_PRIVATE_IP` with the actual private IP of VM3 :
     ```sh
     chmod 400 /home/ec2-user/assignment-prod
     ssh -i /home/ec2-user/assignment-prod ec2-user@VM3_PRIVATE_IP
     ```
   - After running last given script, it will say "Are you sure you want to continue connecting (yes/no)?" Enter Yes
   - Once sucessful connect, exit by writing `exit` in terminal 


   <div align="center">
<img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture13.png" width="500" alt="Alt text">
</div>


      Replace `VM4_PRIVATE_IP` with the actual private IP of VM4:
     ```sh
     ssh -i /home/ec2-user/assignment-prod ec2-user@VM4_PRIVATE_IP
     ```
   - After running last given script, it will say "Are you sure you want to continue connecting (yes/no)?" Enter Yes

<div align="center">
<img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture14.png" width="500" alt="Alt text">
</div>

   - Once sucessful connect, exit by writing `exit` in terminal. Then you will exit the VM3. Now write   `exit` again to exit the Bastion Host.
## Cleanup

To avoid incurring additional costs, destroy the resources:

1. **Destroy PROD Web Servers**:
   ```sh
   cd ../../prod/webservers
   terraform destroy -auto-approve
   ```

2. **Destroy STAGING Web Servers**:
   ```sh
   cd ../../staging/webservers
   terraform destroy -auto-approve
   ```

3. **Destroy VPC Peering**:
   ```sh
   cd ../../vpc_perring
   terraform destroy -auto-approve
   ```

4. **Destroy PROD VPC Network**:
   ```sh
   cd ../prod/network
   terraform destroy -auto-approve
   ```

5. **Destroy STAGING VPC Network**:
   ```sh
   cd ../../staging/network
   terraform destroy -auto-approve
   ```

## Conclusion
 You will successfully run and cleaned up the project. If you want to edit the code, please remeber to edit the code, then do the deployment step. The clean up is impornat as the more the aws resourse is on, it will cost you alot of money. So remember to shut down your Cloud9 environment. 

---
