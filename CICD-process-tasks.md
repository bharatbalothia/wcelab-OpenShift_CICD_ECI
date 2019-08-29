# CICD Process

## OMS Group process

### Pre-Requisites
1. Images
   1. Foundation - latest OOTB version
   2. App - latest OOTB version
   3. Agent - latest OOTB version
   4. DB2 for Config schema
   5. DB2 for schemas other than Config
   6. MQ Image
2. Git Group Branch

### Deliverables
1. Images
   1. Group's latest App image (if it is a standard one accross service teams)
   2. Service's latest Agent image (if it is a standard one accross service teams)
2. Updated Git OMS Group Branch
   1. Base CDT for services
   
## DevOp Process

1. Prepare OCP Cluster [Epic 19](/../../issues/19)
   1. Install ICP Common services (helm, tiller etc) [User Story 21](/../../issues/21)
   1. Update OMS helm charts for the OpenShift cluster [User Story 30](/../../issues/30)
      1. Download OOB OMS helm charts [Part of User Story #30](/../../issues/30)
      1. Update helm charts with cluster specific information [Part of User Story #30](/../../issues/30)

1. Initialize **Group environment** [Epic 15](/../../issues/15)
   
   1. Prepare OCP project for **Group Environment** [User Story 22](/../../issues/22)

      1. Create Persistent Storage
      1. Create ConfigMap
      1. Create Kube Secrets
      1. Create Ingress/Routes for app server load balancer
   
   1. Load starter containers for a team [User Story 31](/../../issues/31)
      1. Prepare DB2 transaction schema with OOTB OMS schema and factory data
      2. Prepare MQ Server
      3. Load Image registry with OOTB OMS images (foundation, app and agent)
      4. Update OpenShift project (similar to namespace in kubernetes cluster) with appropriate group name
      5. Deploy OOTB app and agent image into the new OpenShift project

1. Create and Save OOTB or BDA Configuratin CDT as Group's Base CDT [User Story 14](/../../issues/14)

## Service Team Process

Service team is a team that is responsible for the development, unit testing, and group testing of the service. 

### Pre-Requisites
1. Images
   1. Foundation - latest OOTB version
   2. App - latest OOTB version
   3. Agent - latest OOTB version
   4. DB2 for Config schema
   5. DB2 for schemas other than Config
   6. MQ Image
2. Git Service Branch
   1. Latest CDT which Group has defined
   2. Group's latest DB extensions for non-config schemas

### Deliverables
1. Images
   1. Service's latest App image 
   2. Service's latest Agent image
2. Updated Git OMS Group Branch
   1. Updated DB extensions
3. Updated Git Service Branch   
   1. Service's latest CDT
   2. Service's customization artifacts
      1. Code, resources, properties
   3. Updated Service's helm charts 

### Dev-Ops Process

1. Initialize Individual **Service Environment** [Epic 15](/../../issues/15)
   1. Same steps as "Initialize **Group Environment**"

3. Regression test in **Service Environment** after each task completion

4. Regresion/Functional test in **Service Environment** prior to Service Team's sprint completion [Epic 27](/../../issues/27)
   1. Independently deploy our service's configuration and code base to Group Environment
   1. Merge our service's DB extension with Group's DB extension
   1. Test our service's functionality in the Group Environment with other OMS services

5. Deploy Service Team's Sprint Deliverables to **Group Environment** and perform Group level testing [Epic 27](/../../issues/27)
   1. Stage the service's independent configuration and code base for the Group Environment
      1. Check in Service's helm charts to be used in **Group Environment**
      2. Push Service's App and Agent images to registry
      3. Update Service's CDT if required for the **Group Environment**
   2. Merge the service dependent configuration with Group's configuration
      1. Merge our service's DB extension with Group's DB extension
      3. Update Group's MQ server with Service's Connection factories and Queues, generate new .bindings. Checkin the MQ .bindings to Git Service Branch **[NZ should this be in Service or Group branch or both?]**

   1. Deploy or update Service in the **Group Environment**
      1. Apply latest CDT to Service's Config schema in **Group Environment** (Each Service has its own Config schema in Group's namespace)   
      2. Build and Deploy
         1. Check out the Service's latest helm charts to the Group's build/deploy location
         2. Use Foundation container to apply DB extensions to the **Group Environment** transactional schema with Service's changes (entity deployer/DDL)
         3. Deploy the Service's app and agent containers to **Group Environment** using Service's latest helm charts
   1. Test the service's functionality in the Group Environment with other Services


3. Update individual **Service Environment** for Service Testing. *Triggers by Service branch commit/merge or manually*
   1. Complete any pending pull requests code and configuration changes **[NZ I think this should be Task Team's responsibility]**
   2. Build OMS app and agent images with latest code from Service branch
   3. Push tagged app and agent images to Image registry
   4. Update Service's DB2 config schema with latest Configuration Data (apply CDT)
   5. Prepare DB2 transaction schema with Service's latest db extensions (entity deployer)
   6. Update MQ server with Connection factories and Queues, generate bindings   
   8. Prepare pre-requisites for helm deploy **[NZ we need to put some steps in "Initialization" step. We also need to make this automatical instead of a manual process]**
      1. Persistent Volume Claim
      2. Update Secrets with DB credentials
      3. Update Config Map with MQ bindings, DB connection properties and customer overrides properites, SSL certificates
      4. Update ingress/routes configurations if any
      5. Update values.yaml (new image tags, new agent/integration servers, db and mq connection details, ingress details) 
   9. Deploy latest app and agent images to the newly created project (Using helm charts prepared above) **[NZ I think this step is no moved to Prepare OS project step]**
   

1. Update Group environment with Service's new Sprint **[NZ I think it is a duplicate step of "Deploy Service Team's Sprint Deliverables to Group Environment and perform Group level testing"]**
   1. Update DB2 transaction with data definition changes (perform entity deployer)
   2. Prepare DB2 config schema with Service's new sprint configuration data (Check out CDT xmls from git and perfrom import CDT)
   3. Prepare helm charts to deploy Service's new Sprint changes to Group environment
   4. Deploy Service's app and agent images to the Group's project using the updated helm charts
   
## Task Team Process

### Pre-Requisites
1. Images
   1. Foundation
   2. App
   3. Agent
   4. DB2 for config schema
2. Running Containers
   1. DB2 container with schemas except Config schema
   2. Service's MQ container
3. Git Team Branch
   1. Service's Helm Charts in Git
   2. Service's latest CDT
   3. Service's Code base
   4. Service's MQ artifacts (Scripts for new Connection factories, Queues, Channels.)
   
### Deliverables
1. Images
   1. Service's app image updated with Task's customizations in Image Repository
   2. Service's agent image updated with Task's customizations in Image Repository
2. Updated Git Service branch
   1. Updated CDT
   2. Task's customization artifacts
      1. Code, resources, properties, db extensions etc
   3. Updated Service's helm charts
   
### Dev-Ops Process

The DevOp process is reflected in [Epic 32](/../../issues/32)

1. Initialize **Task Environment** [User story 33](/../../issues/33)
   1. Prepare DB2 Configuration schema
   2. Prepare helm charts with new Config schema, app and agent image tags (Team's latest image)
   3. Initialize foundation container connecting to DB2 config schema, check out the latest CDT from the Service's branch and apply CDT
   4. Deploy Task's app server and agent containers using the prepared helm charts
   5. Create new Task branch from the Service's branch in Git
2. Develop and test Task feature in **Task Environment** [User story 34](/../../issues/34)
   1. Change Configuration
      1. Manual configuration changes through OMS Application in the **Task Environment**
   2. Change Code Base (Code, DB extensions, resources, properties etc)
      1. Check in Code changes to the Task branch
      2. Build/Update the app and agent containers with the new Code changes (hot deployment)
      3. Optional: Use Foundation container to apply DB extensions to the **Service Environment** transactional schema (entity deployer/DDL)
   3. Update helm charts with new environment specific changes, task changes/customizations and check-in to Task branch
   3. Test customizations in **Task Environment**
3. Pull Request for Task to Git Service branch [User story 35](/../../issues/35)
   1. Extract Task Configuration   
      1. Export CDT from **Task Environment**
      2. Check in the CDT xmls to Task branch in Git
   2. Pull Request from Task Branch to Service Branch
4. Update **Service Environment** with Task deliverables [User story 36](/../../issues/36)
   1. Change Configuration
      1. Apply latest CDT to **Service Environment** Config schema
   2. Build and Deploy
      1. Build App and Agent image for the Service with latest code from Service branch
      2. Push the App and Agent images to the Image repository
      3. Check out the Service's latest helm charts to the Service's build/deploy location
      4. Deploy the app and agent containers to **Service Environment** using the latest helm charts
5. New feature and regression test in **Service Environment** [User story 37](/../../issues/37)


## Operation Team Process

Operations team is a team that is responsible for the deployment of releases to production and non-production testing environments. Also provide support and maintenance. 

### Pre-Requisites
1.Production and Pre-Production environments have more secured artifactory which holds the released and verified docker images corresponding to Foundation, App and Agent
1. Images
   1. Foundation - latest OOTB version
   2. App - release version for each Group
   3. Agent - release version for each Group 
   4. DB2 for Config schema for each
   5. DB2 for schemas other than Config
   6. MQ with Queues, Channels and Connection factories configured
2. Git Release Branch
   1. Release version of the CDT for each Group
   2. Group's release version of DB extension for non-config schemas 

### Operations Responsibilities
1. Avail the number of instances of App and different Agent and Integration server containers based on performance testing results from the testing team
2. Sizing information in terms of CPU, Memory and HDD capacity
3. Update the helm charts with the number of instances for each container
4. Prepare helm charts on need basis to deploy specific Sterling API/Service/Functionality. 
5. Prepare the corresponding configuration schema required for the specific Sterling API/Service/Functionality.
6. Validate network and MQ connectivities and configurations
7. Auto discovery using Openshift Service configurations for set of replicated pods. 
8. Autoscaling - Openshift ClusterAutoscaler?
9. OpenShift provides self-healing mechanisms through liveness probe and readiness proble
10. Continous deployment - Blue-Green and A/B deployment strategies - multiple options in OpenShift. (https://docs.openshift.com/container-platform/3.3/dev_guide/deployments/advanced_deployment_strategies.html)

### Deliverables
1. Deployed Containers
   1. Deploy Group's release version of App, Agent containers
2. DB Changes applied
   1. DB2 Config Schema corresponding to Group's release version of CDT applied
   2. DB2 Non-Config Schema for Group with the release version of DB extensions applied
3. MQ changed applied
   1. Apply release changes including new Queues, Container factories etc with 
   2. Generated .bindings file after applying release changes
4. Helm Charts - Release version
   1. Each Group's updated ConfigMap corresponding to the release 
   2. Updated values.yaml file with release changes



