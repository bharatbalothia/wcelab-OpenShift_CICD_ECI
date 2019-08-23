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

### Pre-Requisites
1. Images
   1. Foundation - latest OOTB version
   2. App - latest OOTB version
   3. Agent - latest OOTB version
   4. DB2 for Config schema
   5. DB2 for schemas other than Config
   6. MQ Image
2. Git Team Branch
   1. Latest CDT which Group has defined
   2. Group's latest DB extensions for non-config schemas

### Deliverables
1. Images
   1. Team's latest App image 
   2. Team's latest Agent image
2. Updated Git Group Branch
   1. Updated DB extensions
3. Updated Git Team Branch   
   1. Team's latest CDT
   2. Team's customization artifacts
      1. Code, resources, properties
   3. Updated Team's helm charts 

### Dev-Ops Process
1. Prepare OCP project **Individual Team Environment**
   1. Same steps as "Prepare OCP Project for **Group Environment**"

2. Initialize **Individual Team Environment**
   1. Same steps as "Initialize **Group Environment**"

3. Regression test in **Team Environment** after each task completion

4. Regresion/Functional test in **Team Environment** prior to Team's sprint completion
   1. Check out and merge **Group Environment** DB extensions with **Team Environment** DB extensions

5. Promote to Team's completed Sprint to **Group Environment**
   1. Check in the merged DB extensions to Group's Git branch
   2. Check in Team's helm charts to be used in **Group Environment**
   2. Push Team's App and Agent images to Group's Image repository
   3. Update Group's MQ server with Team's Connection factories and Queues, generate new .bindings  
   4. Checkin the MQ .bindings to Git Team Branch
   3. Run Team's containers in **Group Environment** (Group environment has one namespace/project shared by multiple Teams) 
      1. Change Configuration
         1. Apply latest CDT to Team's Config schema in **Group Environment** (Each Team has its own Config schema in Group's namespace)   
      2. Build and Deploy
         1. Check out the Team's latest helm charts to the Group's build/deploy location
         2. Use Foundation container to apply DB extensions to the **Group Environment** transactional schema with Team's changes (entity deployer/DDL)
         3. Deploy the app and agent containers to **Group Environment** using Team's latest helm charts



3. Update **Individual Team Environment** for Team Testing. *Triggers by Team branch commit/merge or manually*
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
   4. Team's MQ artifacts (Scripts for new Connection factories, Queues, Channels.)
   
### Deliverables
1. Images
   1. Team's app image updated with Task's customizations in Image Repository
   2. Team's agent image updated with Task's customizations in Image Repository
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
   3. Update helm charts with new environment specific changes, task changes/customizations and check-in to Task branch
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
      1. Build App and Agent image for the team with latest code from team branch
      2. Push the App and Agent images to the Image repository
      3. Check out the Team's latest helm charts to the Team's build/deploy location
      4. Deploy the app and agent containers to **Team Environment** using the latest helm charts
  5. Team testing in **Team Environment**    
   
