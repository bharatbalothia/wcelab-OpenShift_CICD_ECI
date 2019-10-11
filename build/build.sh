#!/bin/bash
#sh ./build_custom.sh
#cd /opt/ssfs/runtime/docker-samples/imagebuild
#./generateImages.sh --MODE=app --WAR_FILES=smcfs --EXPORT=true
#echo PUSH_DOCKERCFG_PATH $PUSH_DOCKERCFG_PATH
#echo "Content of the file $(cat $PUSH_DOCKERCFG_PATH/.dockercfg)"
#(echo "{ \"auths\": " ; sudo cat $PUSH_DOCKERCFG_PATH/.dockercfg ; echo "}") > /tmp/.dockercfg
#buildah tag om-app:10.0 ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}
#buildah push --tls-verify=false --authfile=/tmp/.dockercfg ${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}

sh ./cdt/cdt_export_container.sh
cd /opt/ssfs/sources/CDT
ls
echo "CDT export success"
git config user.email "mreyas@us.ibm.com"
git config user.name "Moideen Parampil Mohamed Reyas"
git add -v .
echo "git add success"
git commit -m "Committing latest CDT xmls"
echo "git commit success"
cd /opt/ssfs
eval $(ssh-agent -s)
ssh-add ssh-privatekey
echo "ssh private key add success"
cd /opt/ssfs/sources/CDT
git push origin master
echo "git push success"