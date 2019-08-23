# CICD Process

## Group process

0. Prepare OCP Cluster
   1. Install ICP Common services (helm, tiller etc)
   2. Download OMS helm charts
   3. Update helm charts with cluster specific information
   3. Create Persisten Storage
   4. Create ConfigMap
   5. Create Kube Secrets
   6. Create Ingress/Routes for app server load balancer
1. Initialize Group environment
   1. Prepare DB2 transaction schema with OOTB OMS schema and factory data (use helm charts prepared in step 0.3)
   2. Prepare MQ Server
   3. Load Image registry with OOTB OMS images (foundation, app and agent)
   4. Create OCP project (similar to namespace in kubernetes cluster) with appropriate group name
   5. Deploy ootb app and agent image into the new ocp project
2. Prepare Team's environment for Team Testing
   1. Complete pull requests with code and configuration changes for all tasks to Team's sprint release branch
   2. Build OMS app and agent images with latest code from sprint release branch
   3. Push tagged app and agent images to Image registry
   4. Update Team's DB2 config schema with latest Configuration Data (apply CDT)
   5. Prepare DB2 transaction schema with Team's latest db extensions (entity deployer)
   6. Update MQ server with Connection factories and Queues, generate bindings
   7. Create OCP project for Team testing
   8. Prepare pre-requisites for helm deploy
      1. Persistent Volume Claim
      2. Update Secrets with DB credentials
      3. Update Config Map with MQ bindings, DB connection properties and customer overrides properites, SSL certificates
      4. Update ingress/routes configurations if any
      5. Update values.yaml (new image tags, new agent/integration servers, db and mq connection details, ingress details) 
   9. Deploy latest app and agent images to the newly created project (Using helm charts prepared above)
3. Update Group environment with Team's new sprint
   1. Update DB2 transaction with data definition changes (perform entity deployer)
   2. Prepare DB2 config schema with Team's new sprint configuration data (Check out CDT xmls from git and import CDT)
   3. 
