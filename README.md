# Terraform 

### Guideline. Part 1

- Register AWS free account.
- Create IAM user `Terraform`
- Save credantials
- Attach `AdministratorAccess` policy to this user
- Install Terraform and aws cli
- Configure default aws cli profile:

```
    % aws configure
    AWS Access Key ID : <Access Key>
    AWS Secret Access Key : <Secret Key>
    Default region name []: us-east-1
    Default output format [None]:
```

- Create folder `Part1` and go there
- Initialize terraform in the folder
```
    % terraform init
```
- Create resource S3 bucket and attach policies using Terraform
  
### Requirements

- Use `count` to create 3 buckets
- Get any outputs
- Use the modulare structure


### Guideline. Part 2

Please create and configure the below setup using Terraform.

- Create VPC named `VPC`
- Create three different subnets inside VPC named `public`, `private`, `database`
- Launch free tier EC2 instance named `Bastion` with public IP in public subnet
- Launch free tier EC2 instance named `Public-ec2` with public IP in public subnet
- Launch free tier EC2 instance named `Private-ec2` in private subnet
- Launch free tier EC2 instance named `Database` in database subnet
- Create security groups `SG-Bastion`, `SG-Public`, `SG-Private`, `SG-Database` and configure in the follow way:
  - `SG-Bastion` in public and private subnets by SSH. Include network 82.209.240.102/32 by SSH. 
  - `SG-Public` in private subnet by SSH. Allow HTTP for all.
  - `SG-Private` in public and database subnets by SSH.
  - `SG-Database` in private by SSH.
  - Allow ping for all security group
- Apply SG's to instances:
  - `SG-Bastion` to instance `Bastion`
  - `SG-Public` to instance `Public-ec2`
  - `SG-Private` to instance `Private-ec2`
  - `SG-Database` to instance `Database`
- Make the Internet (all addresses) to be outbound reachable from `Private-ec2` for purposes software update. Use NAT Gateway for this

### Procedure

- Locate IP addresses that have been set on `Bastion`, `Public-ec2`, `Private-ec2`, `Database`.
- Locate SSH key for `Bastion`, `Public-ec2`, `Private-ec2`, `Database`. (Use the same SSH key for all instances)
- Log in to `Bastion` with SSH, get command prompt
- Log in to `Private-ec2` with SSH from `Bastion`, get command prompt
- From `Private-ec2` ping address 1.1.1.1
- Log in to `Database` with SSH from `Private-ec2`, get command prompt
- From `Database` ping address 1.1.1.1
- Log in with viewuser, locate following parts, note meaningful tags:
  - VPC
  - Subnets
  - Route table (check routes)
  - Security Groups
  - NACL
  - EC2 instances
  - NAT Gateway with Elastic IP
  - Internet Gateway

### Desirable

- Use terraform `locals` to pass variables
- Store tfstate in S3 bucket. Create remote backend
- Lock tfstate file. Prevent more than one person from changing the tfstate file at the same time
