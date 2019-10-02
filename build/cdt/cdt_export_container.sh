#!/bin/sh
INSTALL_DIR=/opt/ssfs/runtime
export INSTALL_DIR
.  ${INSTALL_DIR}/bin/tmp.sh

#remove existing cdt xml files
#if [ $IMPORT != "true" ]; then
#    rm /oms/CDT/*
#fi
export PATH=$PATH:/oms/build/cdt

cp /opt/ssfs/sources/workspace/custom/generic/resources/ydkresources/ydkprefs.xml ${INSTALL_DIR}/resources/ydkresources/
cp /opt/ssfs/sources/workspace/custom/generic/properties/system_overrides.template ${INSTALL_DIR}/properties/


#mkdir -p ${INSTALL_DIR}/extensions/global/entities/
#cp /oms/workspace/custom/generic/extensions/global/entities/GMC_Extensions.xml ${INSTALL_DIR}/extensions/global/entities/

export SOURCE_DB=$SOURCEDB
export TARGET_DB=$TARGETDB

echo Source DB = $SOURCE_DB , Target DB = $TARGET_DB

DBUSERID=$SOURCEDB_USERID
DBPASSWORD=$SOURCEDB_PASSWORD
export SOURCE_PASSWORD=$DBPASSWORD
DBURL=$SOURCEDB_URL
DBNAME=$SOURCEDB_CATALOG
sed -i "s/<DBUSERID>/${DBUSERID}/g" ${INSTALL_DIR}/properties/system_overrides.template
sed -i "s/<DBNAME>/${DBNAME}/g" ${INSTALL_DIR}/properties/system_overrides.template
sed -i "s/<DBPASSWORD>/${DBPASSWORD}/g" ${INSTALL_DIR}/properties/system_overrides.template
sed -i "s#<DBURL>#${DBURL}#g" ${INSTALL_DIR}/properties/system_overrides.template
#envsubst  < ${INSTALL_DIR}/properties/system_overrides.template >  ${INSTALL_DIR}/properties/system_overrides.properties

cp ${INSTALL_DIR}/properties/system_overrides.template ${INSTALL_DIR}/properties/system_overrides.properties
cat  ${INSTALL_DIR}/properties/system_overrides.properties

#Now copy all the files to /oms/CDT folder to be included in the om-cdt image.  This is needed so that cdt import can work of the image
#instead of the source code repository being mounted
#cp /oms/workspace/custom/generic/resources/ydkresources/ydkprefs.xml /oms/CDT/ydkprefs.template
#The below line is causing issues since it' getting copied to CDT
#cp /oms/workspace/custom/generic/extensions/global/entities/GMC_Extensions.xml /oms/CDT/GMC_Extensions.template
#cp /oms/workspace/custom/generic/extensions/global/entities/GM_SHIPMENT_TRACKING.xml /oms/CDT/GM_SHIPMENT_TRACKING.xml.template
#cp /oms/workspace/custom/generic/extensions/global/entities/GM_ORDER_COMMPLAN.xml /oms/CDT/GM_ORDER_COMMPLAN.xml.template
#cp /oms/workspace/custom/generic/extensions/global/entities/GM_ORDER_LINE_COMMPLAN.xml /oms/CDT/GM_ORDER_LINE_COMMPLAN.xml.template
#cp /oms/workspace/custom/generic/properties/system_overrides.template /oms/CDT/
#cp /oms/build/cdt/* /oms/CDT/

#Set the YFS_HOME directory below to point to your installation directory
YFS_HOME=${INSTALL_DIR}
export YFS_HOME

#If you have extended application tables, specify the full path name to the jar file
#containing the generated database classes below
DB_EXTN_JAR=${INSTALL_DIR}/repository/entities.jar
export DB_EXTN_JAR

#Set the name of the source database that you have defined
#in ${INSTALL_DIR}/resources/ydkprefs.xml
#SOURCE_DB=MC_XML
#SOURCE_DB=MC_DB
#export SOURCE_DB

#Specify the password required for the source database. This parameter is not
#required to be set if the source is an XML folder, unless that XML folder
#contains encrypted resources.
#SOURCE_PASSWORD=STart_123_Start_123_Start_1234
#export SOURCE_PASSWORD

#Set the name of the target database that you have defined
#in ${INSTALL_DIR}/resources/ydkprefs.xml
#TARGET_DB=MC_XML
#TARGET_DB=QA_DB
#TARGET_DB=DEV_DB
#export TARGET_DB

#Specify the password required for the target database. This parameter is not
#required to be set if the target is an XML folder, unless that XML folder
#contains encrypted resources.
#TARGET_PASSWORD=
#export TARGET_PASSWORD

#Specify the password required to refresh the cache of the target database. This
#parameter is not required if there is no target cache to refresh.
TARGET_HTTP_PASSWORD=
export TARGET_HTTP_PASSWORD

# Other options available to the ConfigDeployMain class:
# Set these options by modifying the script below. They cannot be passed as
# command line parameters.
#
# -MODE <mode>
#    The MODE may be one of several options to affect the type of operation.
#    Each mode has its own set of options.

# ----------------------------------------------
# -MODE Deploy [this is default]
#    Deploy changes from source to target database.
#    There are several optional options available:
# -ExportDir <directory>
#    The given directory will be created, and the results of the comparison
#    will be written to it.
# -ExportPassphrase <password>
#    The given password is used to encrypt supported Import/Export data when
#    exporting results. This is only applicable when ExportDir is given.
# -ImportDir <directory>
#    The given directory should contain an export. Rather than compare the
#    source and target databases, this export will be loaded. When this
#    argument is present, the Source database properties are not used.
# -ImportPassphrase <password>
#    The given password is used to decrypt data from the import files as
#    needed, and should match the password given to create the export.
# -DoNotSynchronize <Y|N>
#    If passed as Y, only the comparison will take place; nothing will be
#    deployed. By default, results are automatically deployed.
# -ColonyId <ColonyId>
#    ColonyId to filter data with when in a multi-schema environment. By
#    default, all data in the affected tables will be processed.
# -Compare<Type> <CompareValue>
#    Filter results by the given CompareValue, as defined in the config-db.xml.
#    If the option is not given, the corresponding filter will not be used.
#    Consult the product documentation for all supported options.
# -AppendOnly <Y|N>
#    Pass Y to treat all tables as if they were configured to be Append-Only
#    within the CDT preferences.
# -IgnoreMissingTables <Y|N>
#    Pass Y to ignore tables that are missing in the source or target databases.
# -LabelId <LabelId>
#    The given value will be used to create labels BEGIN_<LabelId> and
#    END_<LabelId> before and after the deployment, respectively. If the option
#    is not given, no labels will be created.

# ----------------------------------------------
# -MODE LABELDEPLOY
#    Deploy audit changes between two version labels.
#    There are two available options:
# -FromLabel <LabelID to start from>
# -ToLabel <LabelID to end with>

set -x

dstamp=`date '+%Y%m%d%H%M%S'`

${JAVA} ${HEAP_FLAGS} -classpath ${INSTALL_DIR}/jar/bootstrapper.jar:${INSTALL_DIR}/resources/ydkresources -Dvendor=shell -DvendorFile=${INSTALL_DIR}/properties/servers.properties -DUseEntitiesFromClasspath=Y -DDISABLE_DS_EXTENSIONS=Y -DDISABLE_EXTENSIONS=Y -DYFS_HOME=${INSTALL_DIR} com.sterlingcommerce.woodstock.noapp.NoAppLoader -class com.yantra.tools.ydk.config.ConfigDeployMain -p ${INSTALL_DIR}/resources/ydkresources -f ${INSTALL_DIR}/properties/dynamicclasspath.cfg -invokeargs -Source ${SOURCE_DB} -Target ${TARGET_DB} -SourcePassword ${SOURCE_PASSWORD} -TargetPassword ${TARGET_PASSWORD} -TargetHTTPPassword ${TARGET_HTTP_PASSWORD} "$@" 2>&1 | tee ${INSTALL_DIR}/logs/cdtshell.${dstamp}.log
if [ $IMPORT == "true" ]; then
    ${INSTALL_DIR}/bin/deployer.sh -t entitydeployer
fi
