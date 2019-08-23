# CICD Process

## Group process

1. Prepare OCP Cluster
   1. Install ICP Common services (helm, tiller etc)
   2. Download OMS helm charts
   3. Update helm charts with cluster specific information
  
1. Prepare OCP project for **Group Environment**

   1. Create Persisten Storage
   1. Create ConfigMap
   1. Create Kube Secrets
   1. Create Ingress/Routes for app server load balancer

1. Initialize **Group environment**
   
   1. Prepare DB2 transaction schema with OOTB OMS schema and factory data (use helm charts prepared in step 0.3)
   2. Prepare MQ Server
   3. Load Image registry with OOTB OMS images (foundation, app and agent)
   4. Create OCP project (similar to namespace in kubernetes cluster) with appropriate group name
   5. Deploy ootb app and agent image into the new ocp project

## Team Process

1. Prepare OCP project **Individual Team Environment**
   1. Same steps as "Prepare OCP Project for **Group Environment**"

1. Initialize **Individual Team Environment**

   1. Same steps as "Initialize **Group Environment**"

1. Update **Individual Team Environment** for Team Testing. *Triggers by Team branch commit/merge or manually*
   1. Complete pull requests with code and configuration changes for all tasks to Team's sprint release branch
   2. Build OMS app and agent images with latest code from sprint release branch
   3. Push tagged app and agent images to Image registry
   4. Update Team's DB2 config schema with latest Configuration Data (apply CDT)
   5. Prepare DB2 transaction schema with Team's latest db extensions (entity deployer)
   6. Update MQ server with Connection factories and Queues, generate bindings   
   8. Prepare pre-requisites for helm deploy **[NZ we need to put some steps in "Initialization" step. We also need to make this automatical instead of a manual process]**
      1. Persistent Volume Claim
      2. Update Secrets with DB credentials
      3. Update Config Map with MQ bindings, DB connection properties and customer overrides properites, SSL certificates
      4. Update ingress/routes configurations if any
      5. Update values.yaml (new image tags, new agent/integration servers, db and mq connection details, ingress details) 
   9. Deploy latest app and agent images to the newly created project (Using helm charts prepared above)
   

1. Update Group environment with Team's new Sprint
   1. Update DB2 transaction with data definition changes (perform entity deployer)
   2. Prepare DB2 config schema with Team's new sprint configuration data (Check out CDT xmls from git and perfrom import CDT)
   3. Prepare helm charts to deploy Team's new Sprint changes to Group environment
   4. Deploy Team's app and agent images to the Group's project using the updated helm charts
   
## Task Process

### Pre-Requisites
1. Images
   1. Foundation
   2. App
   3. Agent
   4. DB2 for config schema
2. Running Containers
   1. DB2 container with schemas except Config schema
   2. Team's MQ container
3. Git Team Branch
   1. Team's Helm Charts in Git
   2. Team's latest CDT
   3. Team's Code base
   
### Deliverables
1. Images
   1. Team's app image updated with Task's customizations
   2. Team's agent image updated with Task's customizations
2. Updated Git Team branch
   1. Updated CDT
   2. Task's customization artifacts
      1. Code, resources, properties, db extensions etc
   3. Updated Team's helm charts
   
### Dev-Ops Process
1. Initialize **Task Environment**
   1. Prepare DB2 Configuration schema
   2. Prepare helm charts with new Config schema, app and agent image tags (Team's latest image)
   3. Initialize foundation container connecting to DB2 config schema, check out the latest CDT from the team's branch and apply CDT
   4. Deploy app server and agent containers using the prepared helm charts
   5. Create new Task branch from the Team's branch in Git
2. Apply Customizations to **Task Environment**
   1. Change Configuration
      1. Manual configuration changes through OMS Application in the **Task Environment**
   2. Change Code Base (Code, DB extensions, resources, properties etc)
      1. Check in Code changes to the Task branch
      2. Build/Update the app and agent containers with the new Code changes (hot deployment)
      3. Optional: Use Foundation container to apply DB extensions to the **Team Environment** transactional schema (entity deployer/DDL)
   3. Test customizations in **Task Environment**
3. Pull Request for Task to Team Git branch
   1. Extract Task Configuration   
      1. Export CDT from **Task Environment*
      2. Check in the CDT xmls to Task branch in Git
   2. Pull Request from Task Branch to Team Branch
 4. Apply Customization to **Team Environment**  
   1. Change Configuration
      1. Apply latest CDT to **Team Environment** Config schema
   2. Build and Deploy
      1. Build app and agent image for the team with latest code from team branch
      2. Push images to the repository
      3. Update helm charts with new environment specific changes, task changes/customizations
      4. Deploy the app and agent containers to **Team Environment**
  5. Team testing in **Team Environment**    
   
