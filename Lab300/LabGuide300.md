# Lab 300: simulate disaster
<!-- Comment out table of contents
## Table of Contents
[Introduction](#introduction)
-->

![](./images/intro.png " ")

## Introduction

*In addition to the workshop*, feel free to watch the walk-through companion video by clicking on the following link:
[Lab 300A Walkthrough Video](https://otube.oracle.com/media/PaaS+for+SaaS+-+Lab+300AA+OIC/0_u9vafbok)

In this lab, you will use Oracle Integration to make a connection to your Cloud ERP instance. From there, you will build a basic application integration that creates an Order. After that, you will create a Process that allows for human approval. You will create a process form that allows you to enter order information. The process allows you to define workflow approval and call an integration to create an Order within ERP.

![](./images/Notionalarch.png " ")

### Objectives
- Drain connections in Primary load balancer
- Show DNS failover to standby region
- Scale up compute node in standby region

### Extra Resources
-   To learn more about Load Balancer, feel free to explore the capabilities by clicking on this link: [Load Balancer Documentation](https://docs.cloud.oracle.com/en-us/iaas/Content/Balance/Concepts/balanceoverview.htm)
-   To learn more about , how the OCI API scales up the compute node, here is the relevant [documentation](https://docs.cloud.oracle.com/en-us/iaas/api/#/en/iaas/20160918/datatypes/UpdateInstanceDetails).

## Part 1. The disaster

### **STEP 1**: Drain connections from Primary Load Balancer

Navigate from the upper left hamburger menu to networking -> Load balancers. Find the Load Balancer in your primary region.

Navigate to backend sets, click the 3 dots on the right, and then drain the connections. 

If you navigate to health/check traffic steering - you can see the health for the Primary region load balancer is now critical. If you visit the IP address of this load balancer, you will get 502 bad gateway. 

Now, enter your DNS url in your web browswer, you should see the HTML indicating you are now seeing traffic steered to your standby region. 

### **

## Part 2. Scaling disaster compute

### **STEP 1**: Configure SDK



## Summary

-   In this lab, you learned how to build an end to end integration with Oracle Cloud ERP and the Autonomous Data Warehouse using the Oracle integration platforms low-code development platform.

-   **You are ready to move on to the next lab!**

[Back to top](#introduction)

