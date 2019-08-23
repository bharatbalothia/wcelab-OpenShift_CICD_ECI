# CICD Process

## Group process

1. Initialize group environment
   1. Prepare DB2 transaction schema with OOTB OMS schema and factory data
   2. Prepare MQ Server
   3. Load Image registry with OOTB OMS images (foundation, app and agent)
   4. Create OCP project (similar to namespace in kubernetes cluster) with appropriate group name
   5. Deploy ootb app and agent image into the new ocp project
2. Prepare Team's environment for Team Testing
   1. Complete pull requests with code and configuration changes for all tasks to Team's sprint release branch
   2. Build OMS app and agent images with latest code from sprint release branch
   3. Push tagged app and agent images to Image registry
   4. Update Team's DB2 config schema with latest Configuration Data (apply CDT)
   5. 
3. Update Group environment with Team's new sprint
   1. Update DB2 transaction with data definition changes (perform entity deployer)
   2. Prepare DB2 config schema with Team's new sprint configuration data (Check out CDT xmls from git and import CDT)
   3. 
