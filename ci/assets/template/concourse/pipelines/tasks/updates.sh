#!/bin/bash

#set -xe

##############################
# VARS
##############################
#OPSMAN/DIRECTOR
    director_name="director.REPLACE_ME_DNS"
    opsman_url="https://opsman.REPLACE_ME_DNS"
    password='REPLACE_ME'
    decrypt="REPLACE_ME"

    #HARBOR
    harbor_product_slug="harbor-container-registry"
    harbor_version_regex=^1\.8\..*$

    #CONCOURSE
    concourse_product_slug="p-concourse"
    concourse_version_regex=^5\..\..*$
    concourse_stemcell_regex=^315\..*$
    
    #PAS
    pas_product_slug="cf"
    pas_version_regex=^2\.5\..*$
    system_domain="sys.REPLACE_ME_DNS"

    #PKS
    pks_product_slug="pivotal-container-service"
    pks_version_regex=^1\.4\..*$
    pks_automation_acct="automated-client"
    pks_automation_pass="REPLACE_ME"
    pks_api="api.pks.REPLACE_ME_DNS"

    #SSO
    sso_version_regex=^1\.11\..*$
    sso_product_slug="Pivotal_Single_Sign-On_Service"

    #PASW
    pasw_product_slug="pas-windows"
    pasw_version_regex=^2\.5\..*$

    #AZURE SERVICE BROKER
    azure_sb_product_slug="azure-service-broker"
    azure_sb_version_regex=^1\.11\..*$

    #HEALTHWATCH
    healthwatch_product_slug="p-healthwatch"
    healthwatch_version_regex=^1\.6\..*$

    #PROMETHEUS
    prometheus_version="25.0.0"

    #SPLUNK
    splunk_version_regex=^1\.1\..*$
    splunk_product_slug="splunk-nozzle"

    #RABBIT
    rabbitmq_product_slug="p-rabbitmq"
    rabbitmq_version_regex=^1\.17\..*$

    #METRICS
    metrics_product_slug="apm"
    metrics_version_regex=^1\.6\..*$



    gogs_stemcell="250.79"
    credhub_version="2.4.0"
    uaa_version="73.4.0"
    os_conf_version="21.0.0"
    bbr_sdk_version="1.15.1"
    postgres_version="38"
    bpm_version="1.0.4"
    routing_version="0.188.0"

    
    #COMMON
    pivnet_token="REPLACE_ME"
    export OM_TARGET=$opsman_url
    export OM_CLIENT_ID="om-admin"
    export OM_CLIENT_SECRET="${password}"
    export AZURE_STORAGE_ACCOUNT="REPLACE_ME"

##############################
# HARBOR
##############################
install_harbor(){
    ##############################
    # Download/Upload/Stage Harbor
    ##############################
    echo "Downloading Harbor from Pivnet"
    om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $harbor_product_slug --product-version-regex $harbor_version_regex --stemcell-iaas azure
    echo "Uploading Harbor to OpsMan"
    om -k upload-product -p "$harbor_product_slug"-*.pivotal
    echo "Uploading Harbor Stemcell to OpsMan"
    om -k upload-stemcell -s *.tgz
    echo "Staging Harbor"
    om -k stage-product --product-name harbor-container-registry --product-version $(om tile-metadata --product-path "$harbor_product_slug"-*.pivotal --product-version true)
    echo "Deleting Harbor files"
    rm "$harbor_product_slug"-*.pivotal
    rm *.tgz
    ##############################
    #Download harbor tfstate
    ##############################    
    echo "downloading tfstate"
    az storage blob download -c terraform -f ../harbor.tfstate -n demo-uscentral-pcf/harbor.tfstate
    ##############################
    # Configure harbor
    ##############################
    echo "Configuring Harbor"
    om -k configure-product -c <(texplate execute ../ci/assets/template/harbor-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../harbor.tfstate) -o yaml)
}

info(){
    echo "Get BOSH creds from https://opsman.REPLACE_ME_DNS/api/v0/deployed/director/credentials/bosh_commandline_credentials"
    echo "Get UAA Creds from https://opsmanREPLACE_ME/api/v0/deployed/director/credentials/uaa_login_client_credentials"
    echo "Get Director Creds from https://opsman.REPLACE_ME_DNS/api/v0/deployed/director/credentials/director_credentials"
    echo "Get bosh Root CA on OpsMan from /var/tempest/workspaces/default/root_ca_certificate"
    echo "Take that cert, move to /usr/local/share/ca-certificates, and run sudo update-ca-certificates --fresh"
}

install_rabbitmq(){
    ################################
    # Download/Upload/Stage rabbitmq
    ################################
    echo "Downloading rabbitmq from Pivnet"
    om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $rabbitmq_product_slug --product-version-regex $rabbitmq_version_regex --stemcell-iaas azure
    echo "Uploading rabbitmq to OpsMan"
    om -k upload-product -p "$rabbitmq_product_slug"*.pivotal
    echo "Uploading rabbitmq Stemcell to OpsMan"
    om -k upload-stemcell -s *.tgz
    echo "Staging rabbitmq"
    om -k stage-product --product-name "$rabbitmq_product_slug"  --product-version $(om tile-metadata --product-path "$rabbitmq_product_slug"*.pivotal --product-version true)
    echo "Deleting rabbitmq files"
    rm "$rabbitmq_product_slug"*.pivotal
    rm *.tgz
    ##############################
    # Configure rabbitmq
    ##############################
    # echo "Configuring rabbitmq"
    # om -k configure-product -c ../ci/assets/template/rabbitmq-config.yml
}
install_metrics(){

    ################################
    # Download/Upload/Stage Metrics
    ################################
    echo "Downloading Metrics from Pivnet"
    om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $metrics_product_slug --product-version-regex $metrics_version_regex --stemcell-iaas azure
    echo "Uploading Metrics to OpsMan"
    om -k upload-product -p *.pivotal
    echo "Uploading Metrics Stemcell to OpsMan"
    om -k upload-stemcell -s *.tgz
    echo "Staging Metrics"
    om -k stage-product --product-name apmPostgres --product-version $(om tile-metadata --product-path "$metrics_product_slug"*.pivotal --product-version true)
    echo "Deleting Metrics files"
    rm *.pivotal
    rm *.tgz
    ##############################
    # Configure metrics
    ##############################
    # echo "Configuring Metrics"
    # om -k configure-product -c ../ci/assets/template/metrics-config.yml

}

install_splunk(){
    ##############################
    # Download/Upload/Stage splunk
    ##############################
    echo "Downloading splunk from Pivnet"
    om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $splunk_product_slug --product-version-regex $splunk_version_regex --stemcell-iaas azure
    echo "Uploading splunk to OpsMan"
    om -k upload-product -p "$splunk_product_slug"*.pivotal
    echo "Uploading splunk Stemcell to OpsMan"
    om -k upload-stemcell -s *.tgz
    echo "Staging splunk"
    om -k stage-product --product-name "$splunk_product_slug"  --product-version $(om tile-metadata --product-path "$splunk_product_slug"*.pivotal --product-version true)
    echo "Deleting splunk files"
    rm "$splunk_product_slug"*.pivotal
    rm *.tgz
    ##############################
    # Configure splunk
    ##############################
    # echo "Configuring splunk"
    # om -k configure-product -c ../ci/assets/template/splunk-config.yml
}
install_sso(){
    ##############################
    # Download/Upload/Stage SSO
    ##############################
    echo "Downloading SSO from Pivnet"
    om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $sso_product_slug --product-version-regex $sso_version_regex --stemcell-iaas azure
    echo "Uploading SSO to OpsMan"
    om -k upload-product -p "$sso_product_slug"*.pivotal
    echo "Uploading SSO Stemcell to OpsMan"
    om -k upload-stemcell -s *.tgz
    echo "Staging SSO"
    om -k stage-product --product-name "$sso_product_slug"  --product-version $(om tile-metadata --product-path "$sso_product_slug"*.pivotal --product-version true)
    echo "Deleting SSO files"
    rm "$sso_product_slug"*.pivotal
    rm *.tgz
    ##############################
    # Configure SSO
    ##############################
    echo "Configuring SSO"
    om -k configure-product -c ../ci/assets/template/sso-config.yml
}

    install_pasw(){
        ##############################
        # Download/Upload/Stage PAS
        ##############################    
        mkdir downloads
        om -k download-product --output-directory ./downloads --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $pasw_product_slug --product-version-regex $pasw_version_regex --stemcell-iaas azure
        om -k download-product --output-directory ./downloads --pivnet-api-token $pivnet_token --pivnet-file-glob "winfs-*.zip" --pivnet-product-slug $pasw_product_slug --product-version-regex $pasw_version_regex
        
        unzip -o ./downloads//winfs-*.zip -d ./downloads/
        chmod +x ./downloads/winfs-injector-linux
        #inject
        ./downloads/winfs-injector-linux --input-tile ./downloads/*.pivotal --output-tile ./downloads/pasw-injected.pivotal
        
        echo "Uploading PASW to OpsMan"
        om -k upload-product -p ./downloads/pasw-injected.pivotal
        echo "Uploading PASW Stemcell to OpsMan"
        om -k upload-stemcell -s ./downloads/*.tgz
        echo "Staging PASW"
        om -k stage-product --product-name "$pasw_product_slug" --product-version $(om tile-metadata --product-path ./downloads/pasw-injected.pivotal --product-version true)
        echo "Deleting PASW files"
        rm -rf ./downloads

        ##############################
        #Download PAS tfstate   
        ##############################    
        #echo "downloading tfstate"
        #az storage blob download -c terraform -f ../pasw.tfstate -n demo-uscentral-pcf/pasw.tfstate

        ##############################
        # Configure PAS
        ##############################
        #echo "Configuring PASW"
        #om -k configure-product -c <(texplate execute ../ci/assets/template/pasw-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../pasw.tfstate) -o yaml)
    }
    install_pks(){
        ##############################
        # Downlaod/Upload/Stage PKS
        ##############################
        echo "Downloading PKS from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $pks_product_slug --product-version-regex $pks_version_regex --stemcell-iaas azure
        echo "Uploading PKS Stemcell to OpsMan"
        om -k upload-stemcell -s *.tgz
        echo "Uploading PKS Tile to OpsMan"
        om -k upload-product -p pivotal-container-service-*.pivotal
        echo "Staging PKS Tile"
        om -k stage-product --product-name pivotal-container-service --product-version $(om tile-metadata --product-path "$pks_product_slug"-*.pivotal --product-version true)

        ##############################
        # Download PKS tfstate
        ##############################
        #echo "Downloading PKS state"
        #az storage blob download -c terraform -f ../pks.tfstate -n demo-uscentral-pcf/pks.tfstate

        ##############################
        # Configure PKS
        ##############################
        #echo "Configuring PKS"
        #om -k configure-product -c <(texplate execute ../ci/assets/template/pks-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../pks.tfstate) -o yaml)
    }
    install_healthwatch(){
        ##############################
        # Downlaod/Upload/Stage PKS
        ##############################
        echo "Downloading healthwatch from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $healthwatch_product_slug --product-version-regex $healthwatch_version_regex --stemcell-iaas azure
        echo "Uploading healthwatch Stemcell to OpsMan"
        om -k upload-stemcell -s *.tgz
        echo "Uploading healthwatch Tile to OpsMan"
        om -k upload-product -p *health*.pivotal
        echo "Staging healthwatch Tile"
        om -k stage-product --product-name $healthwatch_product_slug --product-version $(om tile-metadata --product-path *health*.pivotal --product-version true)
        #echo "Downloading state"
        #az storage blob download -c terraform -f ../healthwatch.tfstate -n demo-uscentral-pcf/healthwatch.tfstate

        ##############################
        # Configure healthwatch
        ##############################
        #echo "Configuring healthwatch"
        #om -k configure-product -c <(texplate execute ../ci/assets/template/healthwatch-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../healthwatch.tfstate) -o yaml)
   }

    install_pas(){
        ##############################
        # Download/Upload/Stage PAS
        ##############################
        echo "Downloading PAS from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "cf*.pivotal" --pivnet-product-slug $pas_product_slug --product-version-regex $pas_version_regex --stemcell-iaas azure
        echo "Uploading PAS to OpsMan"
        om -k upload-product -p "$pas_product_slug"-*.pivotal
        echo "Uploading PAS Stemcell to OpsMan"
        om -k upload-stemcell -s *.tgz
        echo "Staging PAS"
        om -k stage-product --product-name cf --product-version $(om tile-metadata --product-path "$pas_product_slug"-*.pivotal --product-version true)
        echo "Deleting PAS files"
        rm "$pas_product_slug"-*.pivotal
        rm *.tgz

        ##############################
        #Download PAS tfstate   
        ##############################    
        # echo "downloading tfstate"
        # az storage blob download -c terraform -f ../pas.tfstate -n demo-uscentral-pcf/pas.tfstate

        ##############################
        # Configure PAS
        ##############################
        # echo "Configuring PAS"
        # om -k configure-product -c <(texplate execute ../ci/assets/template/pas-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../pas.tfstate) -o yaml)
    }
    install_azure_sb(){
            ##############################
            # Download/Upload/Stage Azure SB
            ##############################
            echo "Downloading Azure SB from Pivnet"
            om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $azure_sb_product_slug --product-version-regex $azure_sb_version_regex --stemcell-iaas azure
            echo "Uploading Azure SB to OpsMan"
            om -k upload-product -p "$azure_sb_product_slug"-*.pivotal
            echo "Uploading Azure SB Stemcell to OpsMan"
            om -k upload-stemcell -s *.tgz
            echo "Staging Azure SB"
            om -k stage-product --product-name azure-service-broker --product-version $(om tile-metadata --product-path "$azure_sb_product_slug"-*.pivotal --product-version true)
            echo "Deleting Azure SB files"
            rm "$azure_sb_product_slug"-*.pivotal
            rm *.tgz
        ##############################
        #Download Azure SB tfstate
        ##############################    
        # echo "downloading Azure SB tfstate"
        # az storage blob download -c terraform -f ../harbor.tfstate -n demo-uscentral-pcf/azure_sb.tfstate

        ##############################
        # Configure Azure SB
        ##############################
        # echo "Configuring Azure SB"
        # om -k configure-product -c <(texplate execute ../ci/assets/template/az_sb-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../azure_sb.tfstate) -o yaml)
    }

check_product(){
    pivnet login --api-token REPLACE_ME
    om -k staged-products -f json > out.json

    for name in $(jq -e --raw-output '.[] | .name' < out.json)
    do
        version=$(jq -r --arg name "$name" '.[] | select(.name == $name) | .version' < out.json)
        echo $name
        echo "installed version::"$version
        pivnet_ver=$(pivnet releases -p $name --format json | jq  -e --arg version "$" '.[].version')
        echo "pivnet version::"$pivnet_ver
    done
}

check_specific_product(){
    pivnet login --api-token REPLACE_ME
    
    current_ver=$(om -k staged-products -f json | jq -r --arg name "$name" '.[] | select(.name == $name) | .version')

#There must be a better way
    if [[ $current_ver == *"build"* ]] ; then
        current_ver=$(echo $current_ver | cut -d '-' -f 1)
    fi

    minor=$(echo $current_ver | cut -d '.' -f 1-2)   
    echo "Current Version is " $current_ver
    echo "Looking for minor version " $minor
    pivnet_ver=$(pivnet releases -p $name --format json | jq --arg minor $minor '.[] | select(.version|test($minor)).version' | head -n 1 | cut -d '"' -f 2)
    echo "Latest Pivnet Version is " $pivnet_ver

#There must be a better way
    if [[ $current_ver == *"build"* ]] ; then
        if [ $(echo $pivnet_ver | cut -d '.' -f 3) -gt $(echo $current_ver | cut -d '-' -f 1 | cut -d '.' -f 3) ] ; then
            echo "you need to upgrade"
            install_${PRODUCT}
        fi
    else
        if [ $(echo $pivnet_ver | cut -d '.' -f 3) -gt $(echo $current_ver | cut -d '.' -f 3) ] ; then
            echo "you need to upgrade"
            install_${PRODUCT}
        fi
    fi
}

if [ "$PRODUCT" == "harbor" ] ; then
    name=$harbor_product_slug
    check_specific_product
elif [ "$PRODUCT" == "info" ] ; then
    info
elif [ "$PRODUCT" == "metrics" ] ; then
    name="apm" #$metrics_product_slug
    check_specific_product
elif [ "$PRODUCT" == "rabbitmq" ] ; then
    name=$rabbitmq_product_slug
    check_specific_product
elif [ "$PRODUCT" == "splunk" ] ; then
    name=$splunk_product_slug
    check_specific_product
elif [ "$PRODUCT" == "sso" ] ; then
    name=$sso_product_slug
    check_specific_product
elif [ "$PRODUCT" == "healthwatch" ] ; then
    name=$healthwatch_product_slug
    check_specific_product
elif [ "$PRODUCT" == "pas" ] ; then
    name=$pas_product_slug
    check_specific_product
elif [ "$PRODUCT" == "pasw" ] ; then
    name=$pasw_product_slug
    check_specific_product
elif [ "$PRODUCT" == "azure_sb" ] ; then
    name=$azure_sb_product_slug
    check_specific_product
fi