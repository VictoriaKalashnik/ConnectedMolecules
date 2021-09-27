The files included in this archive:

- AmazonRootCA1.pem - AWS root certificate
- certificate.pem - Certificate needed to connect to aws mqtt procol 
- private.key - Certificates Private key file
- public.key - Certificates Public key file
- thing.json - Configurations about the `thing` we created for you 
- thing-example-js - An example project to send and receive mqtt messages 
- instructions.md - This file
- openapi.yml - API Specifications

***Please check the files, contact with como if necessary***

# Challenge

We designed a very small cloud IoT application for you. It consists 2 parts. AWS IoT and an API.

```uml
+-------+          +---------+        +-------------+     +-----+           +-------------+
| Thing |          | AWS_IoT |        | Persistence |     | API |           | API_Client  |
+-------+          +---------+        +-------------+     +-----+           +-------------+
    |                   |                    |               |                     |
    | Send event        |                    |               |                     |
    |------------------>|                    |               |                     |
    |                   |                    |               |                     |
    |                   | Store event        |               |                     |
    |                   |------------------->|               |                     |
    |                   |                    |               |                     |
    |                   |                    |               |          Get Events |
    |                   |                    |               |<--------------------|
    |                   |                    |               |                     |
    |                   |                    |    Get Events |                     |
    |                   |                    |<--------------|                     |
    |                   |                    |               |                     |
    |                   |                    |               | Events List         |
    |                   |                    |               |-------------------->|
    |                   |                    |               |                     |
    |                   |                    |               |        Send command |
    |                   |                    |               |<--------------------|
    |                   |                    |               |                     |
    |                   |                    |  Send command |                     |
    |                   |<-----------------------------------|                     |
    |                   |                    |               |                     |
    |      Send Command |                    |               |                     |
    |<------------------|                    |               |                     |
    |                   |                    |               |                     |
```

***Your task is to do whatever you'll do that a QA / SDET engineer would do when facing this system.***

Please put any resulting files to a git repository and share with us.
