# Disaster Recovery

![](./screenshots/200screenshots/intro.png)

Disaster Recovery Network and connectivity setup
=======================================================

This solution provides a Network Architecture deployment to demonstrate Disaster Recovery scenario across 2 regions [examples are geared towards region Ashburn & Phoenix, but any region in OCI can be used].


## Quickstart Deployment

1. Download the terraform files to your computer. The `pilot-light` directory contains the Terraform configurations for a sample topology based on the architecture described earlier.

2. [Install Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html), in this lab we use version 12.

3. Setup tenancy values for terraform variables by updating **env-vars** file with the required information. The file contains definitions of environment variables for your Oracle Cloud Infrastructure tenancy.
    The following example is using London as the primary region. You can visit this [link](https://www.oci-workshop.com/keys/). to create the keys.
    ![](./screenshots/100screenshots/env-vars-example.PNG)
    
   ```
    $ source env-vars
    ```
    
4. Create **terraform.tfvars** from *terraform.tfvars.sample* file with the inputs for the architecture that you want to build. A running sample terraform.tfvars file is available below. The contents of sample file can be copied to create a running terraform.tfvars input file. Update db_admin_password with actual password in terraform.tfvars file.

    ![](./screenshots/100screenshots/terrform_var.PNG)
    
5. Deploy the topology:

-   **Deploy Using Terraform**
    
    ```
    $ terraform init
    $ terraform plan
    $ terraform apply
    ```
    When you’re prompted to confirm the action, enter yes.

    When all components have been created, Terraform displays a completion message. For example: Apply complete! Resources: nn added, 0 changed, 0 destroyed.

6. If you want to delete the infrastructure, run:
    First navigate to OCI Console and terminate the Standby database and once the termination is successfull then run the following command
    ```
    $ terraform destroy
    ```
    When you’re prompted to confirm the action, enter yes.


## Inputs required in the terraform.tfvars file
*The following inputs are required for terraform modules:*

```
Argument
Description

dr_region
standby region in which to operate, example: us-ashburn-1, us-phoenix-1, ap-seoul-1, ap-tokyo-1, ca-toronto-1>

dr_vcn_cidr_block
CIDR block of the VCN (Virtual Cloud Network) to be created in standby region. make sure the VCN CIDR blocks of primary and standby regions do not overlap

vcn_cidr_block
CIDR block of the VCN (Virtual Cloud Network) to be created in primary region. make sure the VCN CIDR blocks of primary and standby regions do not overlap

vcn_dns_label
DNS Label of the VCN (Virtual Cloud Network) to be created.

bucket_display_name
Display name of the object storage bucket, this name will be prefixed with region name to keep unique name across regions

bastion_server_shape
This is compute shape for bastion server. For more information on available shapes, see VM Shapes

app_server_shape
This is compute shape for application servers deployed in primary region for hosting application. For more information on available shapes, see VM Shapes

db_display_name
The user-provided name of the Database Home

db_system_shape
The shape of the DB system. The shape determines resources allocated to the DB system.For virtual machine shapes, the number of CPU cores and memory and for bare metal and Exadata shapes, the number of CPU cores, memory, and storage. To get a list of shapes, use the ListDbSystemShapes operation.

db_admin_password
A strong password for SYS, SYSTEM, PDB Admin and TDE Wallet. The password must be at least nine characters and contain at least two uppercase, two lowercase, two numbers, and two special characters. The special characters must be _, #, or -.

lb_shape
A template that determines the total pre-provisioned bandwidth (ingress plus egress). To get a list of available shapes, use the ListShapes operation. Example: 100Mbps

cron_schedule
Cron schedule of backup/restore of boot/block volumes in Primary region. Example: "0 */12 * * *" this runs every 12 hours. This cron job runs on the bastion server

dr_cron_schedule
Cron schedule of backup/restore of boot/block volumes in Standby region. Example: ""#0 */12 * * *"" this is commented out intentionally as the region is in standby mode. When switchover to this region happens then this should be uncommented

snapshot_frequency
Cron schedule for taking snapshots of file storage system in Primary region, this is taken on primary_app_server_1. Example "@hourly" for taking hourly snapshots

data_sync_frequency
Cron schedule for synchronizing the file storage system between both standby and primary region. The rsync job is run as part of this cron scheduler on the compute "dr_replication_server" in standby region. Example "*/30 * * * *" this runs every 30 minutes
```
## Example of the results terraform will produce.
 *Example: Instances in the Primary Region*

 ![](./screenshots/100screenshots/App-Server(Primary).PNG)
 
 *Example: Database system in the Primary Region*

 ![](./screenshots/100screenshots/DB-System(Primary).PNG)
 
 *Example: Instance in the Secondary Region*

 ![](./screenshots/100screenshots/App-Server(Secondary).png)
 
 *Example: Database system in the Secondary Region*

 ![](./screenshots/100screenshots/DB-System(Secondary).PNG)
 
## Configuring the DNS for failover.

### Create a new DNS zone
1.![](./screenshots/100screenshots/DNS-Zone.png)

2.![](./screenshots/100screenshots/DNS-Zone-Information.png)

### Attach a subdomain to the DNS zone
1.![](./screenshots/100screenshots/DNS-Zone-Subdomain-Step1.png)

2.![](./screenshots/100screenshots/DNS-Zone-Subdomain-Step2.png)

3.Publish to finish attaching.

![](./screenshots/100screenshots/Failover-Policy-Publish.png)

# Adding Html to the compute instances.

You can place these HTML files in your app-tier compute nodes to demonstrate the DR working by displaying different HTML pages depending on which region you are hitting. You can see this information in the IP address as well, but this is additional visual stimulation.

## Primary Instance
*Follow the instructions in the [html file](HTML-Instructions.txt)*

## Secondary Instance
*Follow the instructions in the [html file](HTML-Instructions.txt)*


## Troubleshooting


### End
