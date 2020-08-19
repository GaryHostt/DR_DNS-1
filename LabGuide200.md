# Lab 200: Disaster Recovery - Part 2: Automation & Traffic Steering

<!-- Comment out table of contents
## Table of Contents
[Introduction](#introduction)
-->

## Introduction

This lab walks your through how to automate your block and boot volumes backups to a new region. Should disaster strike your home region, it is critical to have the backups elsewhere. Then you will configure the Traffic Management policy where if your servers in your home region are down, your DNS entry will re-route visitors to your site to your standby region.

[Lab 200 Walkthrough Video]()

### Objectives
- Configure DNS failover to standby region in traffic management
- Run attached Python scripts to take backups and move them from primary to standby region
- Restore a backup from the Primary region to compute in the standby region

### Required Artifacts
-   Attached Python scripts
    - block-volume-migration.py
    - boot-volume-migration.py
-   Configure OCI SDK
-   Relevant IAM permissions in your tenancy

### Extra Resources


## Part 2. Running the Python scripts

### **STEP 0**: What do the scripts do

1.   Boot Volume script (boot-volume-migration.py) takes all volume from one region for a given compartment and restores this volume across any given region thru volume backups

usage: boot-volume-migration.py [-h] 
            --compartment-id COMPARTMENT_ID

            --destination-region DESTINATION_REGION

            --availability-domain AVAILABILITY_DOMAIN

2. Block Volume script (block-volume-migration.py) takes all volume from one region for a given compartment and restores this volume across any given region thru volume backups

usage: block-volume-migration.py [-h] 
             --compartment-id COMPARTMENT_ID

             --destination-region DESTINATION_REGION

             --availability-domain AVAILABILITY_DOMAIN

Steps in the automation scripts:
1. create_volume_backups in source region
2. copy_volume_backups across destination region
3. restore_volume in destination region

### **STEP 1**: Configure the scripts for your tenancy

-   Once at the [homepage](https://demo.oracle.com/apex/f?p=DEMOWEB:HOME::::::), navigate to the "Demos" section. 

![](./screenshots/Lab200/source.png " ")

![](./screenshots/Lab200/destination.png " ")

-   Click the **Register a Demo**.




## Summary

-   In this lab, you XXXXX

-   **You are ready to move on to the next lab!**

[Back to top](#introduction)

