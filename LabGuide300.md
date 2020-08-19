# Lab 300: Simulate Disaster
<!-- Comment out table of contents
## Table of Contents
[Introduction](#introduction)
-->

![](./screenshots/300screenshots/Scaling-Finished.PNG)

## Introduction

*In addition to the workshop*, feel free to watch the walk-through companion video by clicking on the following link:
[Lab 300A Walkthrough Video]()

In this lab, you will use 

![](./images/Notionalarch.png " ")

### Objectives
- Drain connections in Primary load balancer
- Show DNS failover to standby region
- Scale up compute node in standby region

### Extra Resources
-   To learn more about Load Balancer, feel free to explore the capabilities by clicking on this link: [Load Balancer Documentation](https://docs.cloud.oracle.com/en-us/iaas/Content/Balance/Concepts/balanceoverview.htm)
-   To learn more about , how the OCI API scales up the compute node, here is the relevant [documentation](https://docs.cloud.oracle.com/en-us/iaas/api/#/en/iaas/20160918/datatypes/UpdateInstanceDetails).

## Part 1. The Disaster

### **STEP 1**: Drain connections from Primary Region Load Balancer


![](./screenshots/300screenshots/1.png)


Navigate from the upper left hamburger menu to networking -> Load balancers. Find the Load Balancer in your primary region.

![](./screenshots/300screenshots/2.png)

Go to your backend set. 
![](./screenshots/300screenshots/3.png)

Check mark your backends. Then press actions.

![](./screenshots/300screenshots/4.png)

Set the drain state to True. This will stop all current connections and simulate the disaster. 

![](./screenshots/300screenshots/5.png)

Your health check on your primary region is now failing, and traffic hitting your DNS should now be routed to your standby region. 
![](./screenshots/300screenshots/300a.png)
![](./screenshots/300screenshots/300b.png)
![](./screenshots/300screenshots/300c.png)


If you navigate to health/check traffic steering - you can see the health for the Primary region load balancer is now critical. If you visit the IP address of this load balancer, you will get 502 bad gateway. 

Now, enter your DNS url in your web browswer, you should see the HTML indicating you are now seeing traffic steered to your standby region. 

### **

## Part 2. Scaling the standby region compute node

### **STEP 1**: Configure SDK

Please follow steps in [lab200] to configure the SDK for your python scripts to call resources in your tenancy.

### **STEP 2**: Run Python scripts

The following link will help you setup the rest api key that python needs to run scaling script.
*https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#Required_Keys_and_OCIDs*

*The script will not continue unitl the scaling is complete. Check the OCI console work request to see when the instance will be available again.*
![](./screenshots/300screenshots/python-scaling.PNG)

*The instance will be shutdown while the update takes place.*
![](./screenshots/300screenshots/Scaling-Start.PNG)

*You can now log into the instance again*
![](./screenshots/300screenshots/Scaling-Finished.PNG)

## Summary

-   In this lab, you learned how to build an end to end integration with Oracle Cloud ERP and the Autonomous Data Warehouse using the Oracle integration platforms low-code development platform.

-   **You are ready to move on to the next lab!**

[Back to top](#introduction)

