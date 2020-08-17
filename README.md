# Oracle’s Cloud Platform: Disaster Recovery

<!-- Comment out table of contents
## Table of Contents
[Introduction](#introduction)
-->

## Introduction

![Alt text](./failover_SS.png?raw=true "Title")

### Objectives
- automate block volume backups to new region
- setup DNS on OCI

### Documentation
- [Traffic Management on OCI](https://www.oracle.com/a/ocom/docs/cloud/traffic-management-100.pdf)

### Lab100: setup the environment
- Use attached TF scripts to provision the environment
- Create Failover DNS Policy such that if healthcheck in one region fails, this will redirect to a load balancer in a different region
  - Open Navigation Menu
  - Under Core Infrastructure, go to Networking and click Traffic Management Steering Policies
  - Click Create Traffic Management Steering Policy.
  - In the Create Traffic Management Steering Policy dialog box, select Failover
  
### Lab200: configure & dr-automation run scripts
- Run scripts to take backups and move them to phoenix from ashburn
- Drop step 3 where it restores the backup in the script

### Lab300: simulate disaster
- Turn off both compute nodes in ashburn, or terminate load balancer
- Restore backup to 1 node in phoenix
- After first backup restored, restore backup to 2nd node
