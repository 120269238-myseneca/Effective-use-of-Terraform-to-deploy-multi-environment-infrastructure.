
**Made by**: Sudeep Saurabh

---

# Effective Use of Terraform to Deploy Multi-Environment Infrastructure

Welcome to the AWS Terraform Deployment Guide! In this guide, we will walk through the process of setting up and deploying a multi-environment infrastructure on AWS using Terraform. This project aims to simplify the process of Infrastructure as Code (IaC) deployment, making it accessible even for those who are new to Terraform and AWS. Follow along with the instructions and images provided to ensure a successful deployment.

---

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Deployment Steps](#deployment-steps)
4. [Accessing VMs via Bastion Host](#accessing-vms-via-bastion-host)
5. [Cleanup](#cleanup)
6. [Conclusion](#conclusion)
7. [Contact and Support](#contact-and-support)

---

## Introduction

The Architecture:
<div align="center">
  <img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture15.png" width="500" alt="Architecture Diagram">
</div>

---

## Warning: Image Guidance

The images provided in this document are meant to serve as a visual guide to help you understand what the output should look like after running the code. Please take note of the following:

- The images are illustrative and meant for guidance only.
- The white highlighted or redacted parts in the images are intentionally placed to hide sensitive information such as API keys, IP addresses, and other confidential data.
- Ensure to replace any placeholders or redacted information with your own valid credentials and data.

Please follow the instructions carefully, and use the images as a reference to verify that you are on the right track.

---

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
  <img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture1.png" width="500" alt="SSH Key Generation for Staging VPC">
</div>

- Create new SSH keys for prod-vpc, by running the following commands:
  ```
  cd ../../prod/webservers
  ssh-keygen -t rsa -f assignment-prod
  ```
  Press "Enter" until the process is complete.

<div align="center">
  <img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture2.png" width="500" alt="SSH Key Generation for Prod VPC">
</div>

---

## Deployment Steps
Reminder: Come back to the "Final" folder by running:
```
cd ../../..
```

1. **Deploy the STAGING VPC Network**:
   - Navigate to the staging network directory and deploy the infrastructure:
     ```sh
     cd staging/network
     terraform init
     terraform validate
     terraform plan 
     terraform apply -auto-approve
     ```

<div align="center">
  <img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture3.png" width="500" alt="Deploying STAGING VPC Network">
</div>

2. **Deploy the PROD VPC Network**:
   - Navigate to the prod network directory and deploy the infrastructure:
     ```sh
     cd ../../prod/network
     terraform init
     terraform validate
     terraform plan
     terraform apply -auto-approve
     ```

<div align="center">
  <img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture4.png" width="500" alt="Deploying PROD VPC Network">
</div>
Important: Only proceed to the next steps once the Staging and Prod VPCs are deployed.

3. **Set up VPC Peering**:
   - Navigate to the VPC peering directory and set up the VPC peering:
     ```sh
     cd ../../vpc_perring
     terraform init
     terraform validate
     terraform plan
     terraform apply -auto-approve
     ```

4. **Deploy the STAGING Web Servers**:
   - Navigate to the staging web servers directory and deploy the web servers:
     ```sh
     cd ../staging/webservers
     terraform init
     terraform validate
     terraform plan
     terraform apply -auto-approve
     ```

<div align="center">
  <img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture5.png" width="500" alt="Deploying STAGING Web Servers">
</div>

5. **Deploy the PROD Web Servers**:
   - Navigate to the prod web servers directory and deploy the web servers:
     ```sh
     cd ../../prod/webservers
     terraform init
     terraform validate
     terraform plan
     terraform apply -auto-approve
     ```

<div align="center">
  <img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture6.png" width="500" alt="Deploying PROD Web Servers">
</div>

---

## Accessing VMs via Bastion Host
Reminder: Navigate back to "Final/staging/webservers" folder by running:
```
cd ../../staging/webservers
```

1. **Transfer SSH Keys to Bastion Host**:
   - Replace `BASTION_HOST_PUBLIC_IP` with the actual public IP of your Bastion host. The public IP can be found either from when you deployed the staging Web Servers, or by going to the EC2 instance section on AWS and finding the `assignment-staging-bastion` instance. Click on the instance, and note the public IPv4 address.

<div align="center">
  <img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture7.png" width="500" alt="Finding Bastion Host Public IP">
</div>

- Transfer the SSH keys:
  ```sh
  scp -i assignment-staging assignment-staging ec2-user@BASTION_HOST_PUBLIC_IP:/home/ec2-user/
  scp -i assignment-staging ../../prod/webservers/assignment-prod ec2-user@BASTION_HOST_PUBLIC_IP:/home/ec2-user/
  ```

(Also after running the first script, it will ask "Are you sure you want to continue connecting (yes/no)?" Enter: Yes)

<div align="center">
  <img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture8.png" width="500" alt="Transferring SSH Keys">
</div>

3. **SSH into Bastion Host**:
   - Connect to the Bastion Host:
     ```sh
     ssh -i assignment-staging ec2-user@BASTION_HOST_PUBLIC_IP
     ```

<div align="center">
  <img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture10.png" width="500" alt="SSH into Bastion Host">
</div>

4. **Connect to VMs**:
   - Replace `VM2_PRIVATE_IP`, `VM3_PRIVATE_IP`, and `VM4_PRIVATE_IP` with the actual private IPs of VM2, VM3, and VM4 respectively:
   - Connecting to VM2:
     ```sh
     chmod 400 assignment-staging
     ssh -i assignment-staging ec2-user@VM2_PRIVATE_IP
     ```

- After running the last script, it will ask "Are you sure you want to continue connecting (yes/no)?" Enter Yes

<div align="center">
  <img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture11.png" width="500" alt="Connecting to VM2">
</div>

- To run the website on VM2:
  ```sh 
  exit
  curl http://VM2_PRIVATE_IP
  ```

<div align="center">
  <img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture12.png" width="500" alt="Running Website on VM2">
</div>

- For VM3 and VM4:
  - Connecting to VM3:
    ```sh
    chmod 400 /home/ec2-user/assignment-prod
    ssh -i /home/ec2-user/assignment-prod ec2-user@VM3_PRIVATE_IP
    ```

  - After running the last script, it will ask "Are you sure you want to continue connecting (yes/no)?" Enter Yes

  - Once connected successfully, exit by typing `exit` in the terminal.

<div align="center">
  <img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture13.png" width="500" alt="Connecting to VM3">
</div>

- Connecting to VM4:
  ```sh
  ssh -i /home/ec2-user/assignment-prod ec2-user@VM4_PRIVATE_IP
  ```

- After running the last script, it will ask "Are you sure you want to continue connecting (yes/no)?" Enter Yes

<div align="center">
  <img src="https://github.com/SuTiger6/Effective-use-of-Terraform-to-deploy-multi-environment-infrastructure./blob/main/image/Picture14.png" width="500" alt="Connecting to VM4">
</div>

- Once connected successfully, exit by typing `exit` in the terminal. Now you will exit VM4. Type `exit` again to exit VM3, and then type `exit` once more to exit the Bastion Host.

---

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

---

## Conclusion
Congratulations! You have successfully run and cleaned up the project. If you wish to make any modifications to the code, please remember to go through the deployment steps again after making your changes. Clean-up is crucial as AWS resources can incur significant costs if left running. Remember to shut down your Cloud9 environment to avoid additional charges.

---

## Contact and Support
If you have any questions or need further assistance, feel free to reach out. Your feedback is appreciated, and it helps in improving the documentation and the project itself.

---

Feel free to adjust any parts as you see fit. This revision aims to enhance clarity, consistency, and user guidance throughout your documentation.
