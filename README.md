Lab Documentation on Creating a Kubernetes Cluster using Kubeadm

Objective
The purpose of this lab was to set up a Kubernetes cluster using Kubeadm on AWS EC2 instances. This involved configuring master and worker nodes, deploying a sample application, and verifying its deployment and service exposure.

Why I Did This
I performed this task to gain hands-on experience in creating and managing Kubernetes clusters. This setup demonstrates real-world scenarios of deploying containerized applications with scalability and high availability.

Steps and Actions Taken
1. Provisioning the Infrastructure
I began by using Terraform scripts to provision the required infrastructure on AWS. This included creating EC2 instances that would serve as the master and worker nodes for the Kubernetes cluster.
After successfully deploying the infrastructure, I verified the resources on AWS to ensure everything was in place.

3. Configuring the Master Node
I SSH-ed into the master node instance using the command:
ssh -i kube-key.pem ubuntu@35.179.163.112

I initialized the Kubernetes cluster on the master node using the kubeadm init command. This setup the master node and generated a token for joining worker nodes.
I used the following command to check the status of nodes:
kubectl get nodes

3. Adding Worker Nodes to the Cluster
I SSH-ed into each worker node individually. For example:
ssh -i kube-key.pem ubuntu@13.40.173.93

I switched to root user with:
sudo su

Then, I used the kubeadm join command to add the worker node to the cluster:

kubeadm join 172.31.24.101:6443 --token ubk1gl.vy4iswhliolodkqo \
--discovery-token-ca-cert-hash sha256:3f2014e41a40eda3eecb09de68eeaf9c9a38fe28e21f58010d21c2c275d37f12

4. Verifying the Cluster Setup
After adding the worker nodes, I ran the following command to confirm that all nodes were successfully connected to the cluster:
kubectl get nodes

5. Deploying an Application
I created a deployment configuration file named deployment.yml and applied it using:
kubectl apply -f deployment.yml

I checked the deployment status with:

kubectl get deployments
I also used the following command to list all pods and their IPs in a wide format:
kubectl get pods -o wide

6. Exposing the Application
To expose the deployed application, I created a service configuration file named service.yml.
I applied the service file with:

kubectl apply -f service.yml
I verified the created service by running:

kubectl get svc
7. Additional Verification
I checked the running pods again to ensure proper functionality:

kubectl get pods
I also verified the Docker version installed on the system:
docker --version

What I Achieved
Cluster Setup: I successfully created a Kubernetes cluster using Kubeadm, with a master node and multiple worker nodes.
Application Deployment: I deployed a sample application in the cluster and verified its pods, deployment, and service.
Service Exposure: I exposed the application to external traffic using a Kubernetes service.
Infrastructure Automation: I utilized Terraform to provision the required AWS infrastructure, streamlining the deployment process.
