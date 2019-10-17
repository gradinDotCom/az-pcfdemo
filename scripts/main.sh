#!/bin/bash
# Pre-reqs
# uaac
# om
# bosh
# az
# jq
# texplate
# terraform
#################################
# Required Environment variables
# ARM_ACCESS_KEY
# ARM_CLIENT_ID
# ARM_CLIENT_SECRET
# TF_VAR_client_id
# TF_VAR_client_secret
# ARM_SUBSCRIPTION_ID
# ARM_TENANT_ID
# TF_VAR_subscription_id
# TF_VAR_tenant_id
# pivnet_token
#################################
# These templates are configured for Availability Sets
# They will need to be changed for Availability Zones

##############################
# VARS
##############################
    system_domain="sys.turtleisland.net"
    director_name="director.turtleisland.net"
    opsman_url="https://opsman.turtleisland.net"
    password='P@ssw0rd'
    decrypt_password="DecryPtM3!"
    # Add as env var
    # pivnet_token="xyz"
    #PKS
    pks_automation_acct="automated-client"
    pks_automation_pass="Aut0M4t3M3!"
    pks_api="api.pks.turtleisland.net"
    ##LDAP
    ldap_host="myldap.turtleisland.net"
    ldap_group_search_base_dn="OU=Groups,DC=turtleisland,DC=net"
    ldap_user_search_base_dn="OU=Users,DC=turtleisland,DC=net"
    ldap_user_username="splinter@turtleisland.net"
    ldap_user_password='I!mN0tR3al'
    ldap_admin_group_dn="CN=bale,DC=turtleisland,DC=net"
    ldap_bind_dn="CN=splinter,DC=turtleisland,DC=net"

    #PRODUCT NAMES
    azure_sb_product_slug="azure-service-broker"
    pks_product_slug="pivotal-container-service"
    spring_product_slug="p-spring-cloud-services"
    harbor_product_slug="harbor-container-registry"
    pas_product_slug="cf"
    pasw_product_slug="pas-windows"
    sso_product_slug="Pivotal_Single_Sign-On_Service"
    mysql_product_slug="pivotal-mysql"
    splunk_product_slug="splunk-nozzle"
    credhub_sb_product_slug="credhub-service-broker"
    concourse_product_slug="p-concourse"
    healthwatch_product_slug="p-healthwatch"
    rabbitmq_product_slug="p-rabbitmq"
    redis_product_slug="p-redis"
    metrics_product_slug="apm"

    #PRODUCT VERSIONS
    harbor_version_regex=^1\.8\..*$
    credhub_sb_version_regex=^1\.4\..*$
    mysql_version_regex=^2\.7\..*$
    spring_version_regex=^3\.0\..*$
    redis_version_regex=^2\.2\..*$
    pks_version_regex=^1\.5\..*$
    pas_version_regex=^2\.5\..*$
    pasw_version_regex=^2\.5\..*$
    sso_version_regex=^1\.9\..*$
    splunk_version_regex=^1\.1\..*$
    metrics_version_regex=^1\.6\..*$
    rabbitmq_version_regex=^1\.17\..*$
    azure_sb_version_regex=^1\.11\..*$
    concourse_version_regex=^5\..\..*$
    concourse_stemcell_regex=^315\..*$
    gogs_stemcell="250.79"
    healthwatch_version_regex=^1\.6\..*$

    #CREDHUB
    credhub_version="2.4.0"
    mysql_version="36.19.0"
    uaa_version="73.4.0"
    credhub_static_ips="10.44.44.100"
    credhub_mySQL_proxy_ip="10.44.44.101"
    os_conf_version="21.0.0"
    bbr_sdk_version="1.15.1"
    prometheus_version="25.0.0"
    postgres_version="38"
    bpm_version="1.0.4"
    routing_version="0.188.0"

    # Formatting colors
    RED='\033[0;31m'
    NC='\033[0m'
    BLACK='\033[0;30m'
    GREEN='\033[0;32m'
    BLUE='\033[0;34m'
    WHITE='\033[1;37m'
    WoB='\033[37;44m' #White On Blue
    BoW='\033[30;43m' #Black on White

    TMP="/mnt/demo/tmp"
    TEMP="/mnt/demo/tmp"
    TMPDIR="/mnt/demo/tmp"
    export TMPDIR TMP TEMP
    #OM Config
    export OM_TARGET=$opsman_url
    export OM_USERNAME="admin"
    export OM_PASSWORD="${password}"
    export AZURE_STORAGE_ACCOUNT="azpcf295a"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# START OF MENU SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    main_menu() {
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~"
        echo " M A I N - M E N U"
        echo "~~~~~~~~~~~~~~~~~~~~~"
        echo "1. Sound Check"
        echo "2. Dance your little dance"
        echo "3. Run FULL DEMO"
        echo "4. Destroy the DEMO"
        echo "x. Exit"
    }
    read_options(){
        local choice
        read -p "Enter choice [ 1 - x] " choice
        case $choice in
            1) set_the_stage ;;
            2) dance ;;
            3) run_demo ;;
            4) destroy_demo ;;
            x) exit 0;;
            *) echo -e "${RED}Error...${STD}" && sleep 2
        esac
    }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# END OF MENU SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEMO SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    destroy_demo() {
        cd ../terraforming-pas_only/
        terraform destroy -auto-approve
        cd ../terraforming-pks/
        terraform destroy -auto-approve
        cd ../terraforming-harbor/
        terraform destroy -auto-approve
        pause
        main_menu
    }
    set_the_stage(){
        terraform_opsman
        fresh_opsman
        download_pas
        download_pasw
        download_rabbitmq
        download_healthwatch
        download_harbor
        download_spring
        download_metrics
        download_splunk
        download_sso
        download_azure_sb
        download_mysql
        download_credhub_sb
        download_redis
        download_pks
        pause
    }
    dance(){
        terraform_opsman
        terraform_pas
        terraform_pasw
        terraform_healthwatch
        terraform_harbor
        terraform_azure_sb
        terraform_splunk
        terraform_redis
        terraform_mysql
        terraform_pks
        
        fresh_opsman
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~CONFIGURING DIRECTOR~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        install_director
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING PAS~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_pas
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING PASW~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_pasw
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING RABBIT MQ~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_rabbitmq
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING HEALTHWATCH~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_healthwatch
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING HARBOR~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_harbor
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING METRICS~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_metrics
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING SSO~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_sso
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING SPLUNK~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_splunk
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING AZURE SERVICE BROKER~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_azure_sb
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING CREDHUB SERVICE BROKER~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_credhub_sb
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING MYSQL~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_mysql
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING REDIS~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_redis
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING SPRING SERVICES~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_spring
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING PKS~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_pks
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~EVERYTHING HAS COMPLETED~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        pause

    }
    run_demo(){
        clear
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~IT'S DEMO TIME~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"

        terraform_opsman
        fresh_opsman
        install_director
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING PAS~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform_pas
        download_pas
        config_pas
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING PASW~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform_pasw
        download_pasw
        config_pasw
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING RABBIT MQ~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        download_rabbitmq
        config_rabbitmq
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING HEALTHWATCH~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform_healthwatch
        download_healthwatch
        config_healthwatch
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING HARBOR~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform_harbor
        download_harbor
        config_harbor
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING METRICS~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        download_metrics
        config_metrics
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING SPLUNK~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        download_splunk
        config_splunk
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING SSO~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        download_sso
        config_sso
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING AZURE SERVICE BROKER~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform_azure_sb
        download_azure_sb
        config_azure_sb
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING CREDHUB SERVICE BROKER~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        download_credhub_sb
        config_credhub_sb
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING MYSQL~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        download_mysql
        terraform_mysql
        config_mysql
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING REDIS~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        download_redis
        terraform_redis
        config_redis
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING SPRING SERVICES~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        download_spring
        config_spring
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING PKS~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform_pks
        download_pks
        config_pks
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~EVERYTHING HAS COMPLETED~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        pause
        pause
    }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# END OF DEMO SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# START OF TERRAFORM SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    terraform_concourse(){
        cd ../terraforming-concourse
        terraform init
        terraform apply
        pause
        cd ../scripts
    }
    terraform_opsman(){
        cd ../terraforming-opsman_only
        echo -e  "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${BoW}~~~~~Terraforming OpsMan~~~~~${NC}"
        echo -e  "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform init
        terraform apply -auto-approve

        cd ../scripts
    }
    terraform_harbor(){
        cd ../terraforming-harbor
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e "${BoW}~~~~~Terraforming Harbor~~~~~${NC}"
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform init
        terraform apply -auto-approve
        cd ../scripts
    }
    terraform_mysql(){
        cd ../terraforming-splunk
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e "${BoW}~~~~~Terraforming MySQL~~~~~${NC}"
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform init
        terraform apply -auto-approve
        cd ../scripts
    }
    terraform_redis(){
        cd ../terraforming-redis
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e "${BoW}~~~~~Terraforming Redis~~~~~${NC}"
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform init
        terraform apply -auto-approve
        cd ../scripts
    }
    terraform_splunk(){
        cd ../terraforming-splunk
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e "${BoW}~~~~~Terraforming Splunk~~~~~${NC}"
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform init
        terraform apply -auto-approve
        cd ../scripts
    }
    terraform_pks(){
        cd ../terraforming-pks
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e "${BoW}~~~~~Terraforming PKS~~~~~${NC}"
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform init
        terraform apply  -auto-approve
        cd ../scripts
    }
    terraform_pas(){
        cd ../terraforming-pas_only
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e "${BoW}~~~~~Terraforming PAS~~~~~${NC}"
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform init
        terraform apply  -auto-approve
        cd ../scripts
    }
    terraform_pasw(){
        cd ../terraforming-pasw
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e "${BoW}~~~~~Terraforming PASW~~~~~${NC}"
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform init
        terraform apply  -auto-approve
        cd ../scripts
    }
    terraform_healthwatch(){
        cd ../terraforming-healthwatch
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e "${BoW}~~~~~Terraforming Healthwatch~~~~~${NC}"
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform init
        terraform apply  -auto-approve
        cd ../scripts
    }
    terraform_azure_sb(){
        cd ../terraforming-azure-sb
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e "${BoW}~~~~~Terraforming Azure Service Broker~~~~~${NC}"
        echo -e "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform init
        terraform apply  -auto-approve
        cd ../scripts
    }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# END OF TERRAFORM SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    fresh_opsman (){
        
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~Configuring OpsMan~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "Downloading state"
        az storage blob download -c terraform -f ../opsman.tfstate -n demo-uscentral-pcf/opsman.tfstate

        ##############################
        # Configure OpsMan Auth
        ##############################
        #NON-SAML
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~Setting OpsMan Auth~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        om -k configure-authentication --decryption-passphrase "${decrypt_password}" -u admin -p "${password}"
        #Setting new SSL
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~Adding Certificate~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        om -k update-ssl-certificate --private-key-pem "$(jq -e --raw-output '.modules[0].outputs.ssl_private_key.value' ../opsman.tfstate)" --certificate-pem "$(jq -e --raw-output '.modules[0].outputs.ssl_cert.value' ../opsman.tfstate)"
    }

    install_director (){ 
        echo -e  "${WoB}~~~~~~~~Downloading state~~~~~~~~${NC}"
        az storage blob download -c terraform -f ../opsman.tfstate -n demo-uscentral-pcf/opsman.tfstate
        om -k configure-director --config <(texplate execute ../ci/assets/template/director-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../opsman.tfstate) -o yaml) || true
    }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# All the downloads
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    download_pas(){
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
    }

    download_pasw(){
        mkdir downloads
        echo "Downloading PASW from Pivnet"
        om -k download-product --output-directory ./downloads --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $pasw_product_slug --product-version-regex $pasw_version_regex --stemcell-iaas azure
        om -k download-product --output-directory ./downloads --pivnet-api-token $pivnet_token --pivnet-file-glob "winfs-*.zip" --pivnet-product-slug $pasw_product_slug --product-version-regex $pasw_version_regex
        
        unzip -o ./downloads//winfs-*.zip -d ./downloads/
        chmod +x ./downloads/winfs-injector-linux
        echo "Injecting Tile"
        ./downloads/winfs-injector-linux --input-tile ./downloads/*.pivotal --output-tile ./downloads/pasw-injected.pivotal
        
        echo "Uploading PASW to OpsMan"
        om -k upload-product -p ./downloads/pasw-injected.pivotal
        echo "Uploading PASW Stemcell to OpsMan"
        om -k upload-stemcell -s ./downloads/*.tgz
        echo "Staging PASW"
        om -k stage-product --product-name "$pasw_product_slug" --product-version $(om tile-metadata --product-path ./downloads/pasw-injected.pivotal --product-version true)
        echo "Deleting PASW files"
        rm -rf ./downloads
    }

    download_rabbitmq(){
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
    }
    
    download_healthwatch(){
        echo "Downloading healthwatch from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $healthwatch_product_slug --product-version-regex $healthwatch_version_regex --stemcell-iaas azure
        echo "Uploading healthwatch Stemcell to OpsMan"
        om -k upload-stemcell -s *.tgz
        echo "Uploading healthwatch Tile to OpsMan"
        om -k upload-product -p *health*.pivotal
        echo "Staging healthwatch Tile"
        om -k stage-product --product-name $healthwatch_product_slug --product-version $(om tile-metadata --product-path *health*.pivotal --product-version true)
        echo "Deleting downloaded healthwatch files"
        rm *.pivotal
        rm *.tgz
    }

    download_harbor(){
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
    }

    download_metrics(){

        echo "Downloading Metrics from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $metrics_product_slug --product-version-regex $metrics_version_regex --stemcell-iaas azure
        echo "Uploading Metrics to OpsMan"
        om -k upload-product -p "$metrics_product_slug"*.pivotal
        echo "Uploading Metrics Stemcell to OpsMan"
        om -k upload-stemcell -s *.tgz
        echo "Staging Metrics"
        om -k stage-product --product-name apmPostgres --product-version $(om tile-metadata --product-path "$metrics_product_slug"*.pivotal --product-version true)
        echo "Deleting Metrics files"
        rm "$metrics_product_slug"*.pivotal
        rm *.tgz
    }

    download_splunk(){
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
    }

    download_sso(){
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
    }

    download_azure_sb(){
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
    }

    download_credhub_sb(){
        echo "Downloading CredHub SB from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $credhub_sb_product_slug --product-version-regex $credhub_sb_version_regex --stemcell-iaas azure
        echo "Uploading CredHub SB to OpsMan"
        om -k upload-product -p "$credhub_sb_product_slug"-*.pivotal
        echo "Uploading CredHub SB Stemcell to OpsMan"
        om -k upload-stemcell -s *.tgz
        echo "Staging CredHub SB"
        om -k stage-product --product-name "$credhub_sb_product_slug" --product-version $(om tile-metadata --product-path "$credhub_sb_product_slug"-*.pivotal --product-version true)
        echo "Deleting CredHubfiles"
        rm "$credhub_sb_product_slug"-*.pivotal
        rm *.tgz
    }

    download_mysql(){
        echo "Downloading Azure SB from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $mysql_product_slug --product-version-regex $mysql_version_regex --stemcell-iaas azure
        echo "Uploading MySQL to OpsMan"
        om -k upload-product -p "$mysql_product_slug"-*.pivotal
        echo "Uploading MySQL Stemcell to OpsMan"
        om -k upload-stemcell -s *.tgz
        echo "Staging MySQL"
        om -k stage-product --product-name "$mysql_product_slug" --product-version $(om tile-metadata --product-path "$mysql_product_slug"-*.pivotal --product-version true)
        echo "Deleting MySQL files"
        rm "$mysql_product_slug"-*.pivotal
        rm *.tgz
    }

    download_spring(){
        echo "Downloading Spring Cloud Services from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token "${pivnet_token}" --pivnet-file-glob "*.pivotal" --pivnet-product-slug $spring_product_slug --product-version-regex $spring_version_regex --stemcell-iaas azure
        echo "Uploading Spring Cloud Services SB to OpsMan"
        om -k upload-product -p *spring*.pivotal
        echo "Uploading Spring Cloud Services Stemcell to OpsMan"
        om -k upload-stemcell -s *.tgz
        echo "Staging Spring Cloud Services"
        om -k stage-product --product-name $(om tile-metadata --product-path *spring*.pivotal --product-name) --product-version $(om tile-metadata --product-path *spring*.pivotal --product-version true)
        echo "Deleting Spring Cloud Services files"
        rm "$spring_product_slug"-*.pivotal
        rm *.tgz
    }

    download_redis(){
        echo "Downloading Redis from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $redis_product_slug --product-version-regex $redis_version_regex --stemcell-iaas azure
        echo "Uploading Redis to OpsMan"
        om -k upload-product -p "$redis_product_slug"-*.pivotal
        echo "Uploading Redis Stemcell to OpsMan"
        om -k upload-stemcell -s *.tgz
        echo "Staging Redis"
        om -k stage-product --product-name "$redis_product_slug" --product-version $(om tile-metadata --product-path "$redis_product_slug"-*.pivotal --product-version true)
        echo "Deleting Redis files"
        rm "$redis_product_slug"-*.pivotal
        rm *.tgz
    }

    download_pks(){
        echo "Downloading PKS from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $pks_product_slug --product-version-regex $pks_version_regex --stemcell-iaas azure
        echo "Uploading PKS Stemcell to OpsMan"
        om -k upload-stemcell -s *.tgz
        echo "Uploading PKS Tile to OpsMan"
        om -k upload-product -p pivotal-container-service-*.pivotal
        echo "Staging PKS Tile"
        om -k stage-product --product-name pivotal-container-service --product-version $(om tile-metadata --product-path "$pks_product_slug"-*.pivotal --product-version true)
        echo "Deleting downloaded PKS files"
        rm "$pks_product_slug"-*.pivotal
        rm *.tgz
    }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# End of Downloads
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# All the Configs
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    config_pas(){
        echo -e  "${WoB}~~~~~~~~Downloading state~~~~~~~~${NC}"
        az storage blob download -c terraform -f ../pas.tfstate -n demo-uscentral-pcf/pas.tfstate
        om -k configure-product -c <(texplate execute ../ci/assets/template/pas-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../pas.tfstate) -o yaml)
    }

    config_pasw(){
        echo -e  "${WoB}~~~~~~~~Downloading state~~~~~~~~${NC}"
        az storage blob download -c terraform -f ../pasw.tfstate -n demo-uscentral-pcf/pasw.tfstate
        om -k configure-product -c <(texplate execute ../ci/assets/template/pasw-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../pasw.tfstate) -o yaml)
    }

    config_rabbitmq(){
        om -k configure-product -c ../ci/assets/template/rabbitmq-config.yml
    }
    
    config_healthwatch(){
        echo -e  "${WoB}~~~~~~~~Downloading state~~~~~~~~${NC}"
        az storage blob download -c terraform -f ../healthwatch.tfstate -n demo-uscentral-pcf/healthwatch.tfstate
        om -k configure-product -c <(texplate execute ../ci/assets/template/healthwatch-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../healthwatch.tfstate) -o yaml)
    }

    config_credhub_sb(){
        om -k configure-product -c ../ci/assets/template/credhub_sb-config.yml
    }

    config_spring(){
        om -k configure-product -c ../ci/assets/template/spring-config.yml
    }
    config_harbor(){
        echo -e  "${WoB}~~~~~~~~Downloading state~~~~~~~~${NC}"
        az storage blob download -c terraform -f ../harbor.tfstate -n demo-uscentral-pcf/harbor.tfstate
        om -k configure-product -c <(texplate execute ../ci/assets/template/harbor-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../harbor.tfstate) -o yaml)
    }

    config_redis(){
        echo -e  "${WoB}~~~~~~~~Downloading state~~~~~~~~${NC}"
        az storage blob download -c terraform -f ../redis.tfstate -n demo-uscentral-pcf/redis.tfstate
        om -k configure-product -c <(texplate execute ../ci/assets/template/redis-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../redis.tfstate) -o yaml)
    }
    config_mysql(){
        echo -e  "${WoB}~~~~~~~~Downloading state~~~~~~~~${NC}"
        az storage blob download -c terraform -f ../mysql.tfstate -n demo-uscentral-pcf/mysql.tfstate
        om -k configure-product -c <(texplate execute ../ci/assets/template/mysql-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../mysql.tfstate) -o yaml)
    }
    config_splunk(){
        echo -e  "${WoB}~~~~~~~~Downloading state~~~~~~~~${NC}"
        az storage blob download -c terraform -f ../splunk.tfstate -n demo-uscentral-pcf/splunk.tfstate
        om -k configure-product -c <(texplate execute ../ci/assets/template/splunk-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../splunk.tfstate) -o yaml)
    }
    config_metrics(){
        om -k configure-product -c ../ci/assets/template/metrics-config.yml
    }

    config_sso(){
        om -k configure-product -c ../ci/assets/template/sso-config.yml
    }

    config_azure_sb(){
        echo -e  "${WoB}~~~~~~~~Downloading state~~~~~~~~${NC}"
        az storage blob download -c terraform -f ../azure_sb.tfstate -n demo-uscentral-pcf/azure_sb.tfstate
        om -k configure-product -c <(texplate execute ../ci/assets/template/az_sb-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../azure_sb.tfstate) -o yaml)
    }

    config_pks(){
        echo -e  "${WoB}~~~~~~~~Downloading state~~~~~~~~${NC}"
        az storage blob download -c terraform -f ../pks.tfstate -n demo-uscentral-pcf/pks.tfstate
        om -k configure-product -c <(texplate execute ../ci/assets/template/pks-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../pks.tfstate) -o yaml) 
    }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# End Of Configs
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    pause(){
        read -p "Press [Enter] key to continue..." fackEnterKey
    }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# SHOW MENUS SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    show_main_menu() {
        while true
            do
                main_menu
                read_options
            done
    }

    az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
    az account set -s $ARM_SUBSCRIPTION_ID

trap '' SIGINT SIGQUIT SIGTSTP
show_main_menu
