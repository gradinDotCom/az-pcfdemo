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
        echo "3. Destroy the DEMO"
        echo "x. Exit"
    }
    read_options(){
        local choice
        read -p "Enter choice [ 1 - x] " choice
        case $choice in
            1) set_the_stage ;;
            2) dance ;;
            3) destroy_demo ;;
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
        download_product rabbitmq $rabbitmq_product_slug $rabbitmq_version_regex
        download_product healthwatch $healthwatch_product_slug $healthwatch_version_regex
        download_product harbor $harbor_product_slug $harbor_version_regex
        download_product spring $spring_product_slug $spring_version_regex
        download_product metrics $metrics_product_slug $metrics_version_regex
        download_product splunk $splunk_product_slug $splunk_version_regex
        download_product sso $sso_product_slug $sso_version_regex
        download_product azure_sb $azure_sb_product_slug $azure_sb_version_regex
        download_product mysql $mysql_product_slug $mysql_version_regex
        download_product credhub_sb $credhub_sb_product_slug $credhub_sb_version_regex
        download_product redis $redis_product_slug $redis_version_regex
        download_product cloudcache $cloudcache_product_slug $cloudcache_version_regex
        download_product pks $pks_product_slug $pks_version_regex
        pause
    }
    dance(){
        terraform_opsman
        terraform_product pas
        terraform_product pasw
        terraform_product healthwatch
        terraform_product harbor
        terraform_product azure_sb
        terraform_product splunk
        terraform_product redis
        terraform_product mysql
        terraform_product pks
        terraform_product cloudcache
        
        fresh_opsman
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~CONFIGURING DIRECTOR~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        install_director
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING PAS~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_product pas
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING PASW~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_product pasw
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING RABBIT MQ~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_product rabbitmq
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING HEALTHWATCH~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_product healthwatch
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING HARBOR~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_product harbor
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
        config_product splunk
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING AZURE SERVICE BROKER~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_product azure_sb
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING CREDHUB SERVICE BROKER~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_credhub_sb
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING MYSQL~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_product mysql
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING REDIS~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_product redis
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING SPRING SERVICES~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_spring
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING PIVOTAL CLOUD CACHE~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_product cloudcache
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~STARTING PKS~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        config_product pks
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~EVERYTHING HAS COMPLETED~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        pause

    }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# END OF DEMO SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# START OF TERRAFORM SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    terraform_opsman(){
        echo "==================================================================================================================="
        echo "= If this step fails, you may need to add the cert to your trusted store                                          ="
        echo "= url=releases.hashicorp.com                                                                                      ="
        echo "= openssl s_client -showcerts -connect $url:443</dev/null 2>/dev/null | openssl x509 -outform PEM > /tmp/$url.crt ="
        echo "= sudo mv /tmp/$url.crt /usr/local/share/ca-certificates                                                          ="
        echo "= sudo update-ca-certificates --fresh                                                                             ="
        echo "==================================================================================================================="
        cd ../terraforming-opsman_only
        echo -e  "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${BoW}~~~~~Terraforming OpsMan~~~~~${NC}"
        echo -e  "${BoW}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        terraform init
        terraform apply -auto-approve

        cd ../scripts
    }
    terraform_product(){
        cd ../terraforming-${1}
        echo -e "${BoW}~~~~~Terraforming ${1}~~~~~${NC}"
        terraform init
        terraform apply -auto-approve
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
    download_product(){
        # download_product product product_slug version_regex
        product=$1
        product_slug=$2
        version_regex=$3
        echo "Downloading ${product} from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $product_slug --product-version-regex $version_regex --stemcell-iaas azure
        echo "Uploading ${product} to OpsMan"
        om -k upload-product -p "$product_slug"*.pivotal
        echo "Uploading ${product} Stemcell to OpsMan"
        om -k upload-stemcell -s *.tgz
        echo "Staging ${product}"
        om -k stage-product --product-name "$product_slug"  --product-version $(om tile-metadata --product-path "$product_slug"*.pivotal --product-version true)
        echo "Deleting ${product} files"
        rm "$product_slug"*.pivotal
        rm *.tgz
    }
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
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# End of Downloads
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# All the Configs
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    config_product(){
        echo -e  "${WoB}~~~~~~~~Downloading ${1} state~~~~~~~~~${NC}"
        az storage blob download -c terraform -f ../${1}.tfstate -n etg-uscentral-lower-pcf/${1}.tfstate
        om -k configure-product -c <(texplate execute ../ci/assets/template/${1}-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../${1}.tfstate) -o yaml)
    }
    fresh_opsman (){
        
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~Configuring OpsMan~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "Downloading state"
        az storage blob download -c terraform -f ../opsman.tfstate -n etg-uscentral-lower-pcf/opsman.tfstate

        ##############################
        # Configure OpsMan Auth
        ##############################
        #NON-SAML
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~Setting OpsMan Auth~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        om -k configure-authentication --decryption-passphrase "${OPSMAN_DECRYPTION_PASSPHRASE}" -u admin -p "${password}"
        #Setting new SSL
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~Adding Certificate~~~~~~~~${NC}"
        echo -e  "${WoB}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
        om -k update-ssl-certificate --private-key-pem "$(jq -e --raw-output '.modules[0].outputs.ssl_private_key.value' ../opsman.tfstate)" --certificate-pem "$(jq -e --raw-output '.modules[0].outputs.ssl_cert.value' ../opsman.tfstate)"
    }
    install_director (){ 
        echo -e  "${WoB}~~~~~~~~Downloading state~~~~~~~~${NC}"
        az storage blob download -c terraform -f ../opsman.tfstate -n etg-uscentral-lower-pcf/opsman.tfstate
        om -k configure-director --config <(texplate execute ../ci/assets/template/director-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../opsman.tfstate) -o yaml) || true
    }
    #Need to add terraform process to these.  Only network name needs set.
    config_credhub_sb(){
        om -k configure-product -c ../ci/assets/template/credhub_sb-config.yml
    }
    config_spring(){
        om -k configure-product -c ../ci/assets/template/spring-config.yml
    }
    config_metrics(){
        om -k configure-product -c ../ci/assets/template/metrics-config.yml
    }
    config_sso(){
        om -k configure-product -c ../ci/assets/template/sso-config.yml
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
