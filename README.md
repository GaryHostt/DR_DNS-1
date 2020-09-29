# Oracle’s Cloud Platform: Pilot Light - App & DB

<!-- Comment out table of contents
## Table of Contents
[Introduction](#introduction)
-->

## Introduction

![Alt text](./pic.png?raw=true "Title")

### Objectives
- Enable application & database DR across regions on OCI
  - Automate block volume backups to new region
  - Setup DNS on OCI
  - Simulate disaster and subsequent recovery

### Documentation
- [Traffic Management on OCI](https://www.oracle.com/a/ocom/docs/cloud/traffic-management-100.pdf)
- [Block Volume Backups](https://docs.cloud.oracle.com/en-us/iaas/Content/Block/Concepts/blockvolumebackups.htm)
- [Using Resource Manager](https://docs.cloud.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/resourcemanager.htm)

### [Lab100: Setup your Environment](https://github.com/arshyasharifian/DR_DNS/blob/master/LabGuide100.md)
- Use attached Terraform scripts to provision the environment
- Complete standby region load balancer setup in OCI console
- Configure DNS for primary region
  
### [Lab200: Configure Failover & Recovery Backups](https://github.com/arshyasharifian/DR_DNS/blob/master/LabGuide200.md)
- Configure DNS failover to DR region in traffic management
- Manually run attached Python scripts to take backups and move the backups from primary to DR region
  - Ability to run as cron job for production
- Restore a backup from the Primary region to compute in the DR region
- See how terraform will configure your backup automation, rsync, and Active Data Guard
  - Database DR is setup with data guard in the terraform scripts, but the [subsequent lab](INSERT) will show the manual configuration of dataguard

### [Lab300: Simulate Disaster](https://github.com/arshyasharifian/DR_DNS/blob/master/LabGuide300.md)
- Drain connections in Primary load balancer
- Perform DNS failover to DR region
- Scale up compute node in DR region
