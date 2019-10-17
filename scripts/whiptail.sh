#!/bin/bash


##############################
# VARS
##############################
    system_domain="sys.REPLACE_ME_DNS"
    ##LDAP
    ldap_host="REPLACE_ME"
    ldap_group_search_base_dn="REPLACE_ME"
    ldap_user_search_base_dn="REPLACE_ME"
    #/certs/wildcard
    ldap_user_username="REPLACE_ME"
    ldap_user_password='REPLACE_ME'
    ldap_group_search_base_dn="REPLACE_ME"
    ldap_admin_group_dn="REPLACE_ME"
    ldap_bind_dn="REPLACE_ME"

    pivnet_token="REPLACE_ME"
    azure_sb_product_slug="azure-service-broker"
    pks_product_slug="pivotal-container-service"
    harbor_product_slug="harbor-container-registry"
    pas_product_slug="cf"
    pasw_product_slug="pas-windows"
    sso_product_slug="Pivotal_Single_Sign-On_Service"
    splunk_product_slug="splunk-nozzle"
    concourse_product_slug="p-concourse"
    healthwatch_product_slug="p-healthwatch"
    rabbitmq_product_slug="p-rabbitmq"
    metrics_product_slug="apm"
    pks_automation_acct="automated-client"
    pks_automation_pass="REPLACE_ME"
    pks_api="api.pks.REPLACE_ME_DNS"
    harbor_version_regex=^1\.8\..*$
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
    credhub_static_ips="REPLACE_ME0"
    credhub_mySQL_proxy_ip="REPLACE_ME1"

    os_conf_version="21.0.0"
    bbr_sdk_version="1.15.1"
    prometheus_version="25.0.0"
    postgres_version="38"
    bpm_version="1.0.4"
    routing_version="0.188.0"
    director_name="director.REPLACE_ME_DNS"
    opsman_url="https://opsman.REPLACE_ME_DNS"
    password='REPLACE_ME'
    decrypt="REPLACE_ME"
    export OM_TARGET=$opsman_url
    export OM_CLIENT_ID="om-admin"
    export OM_CLIENT_SECRET="${password}"
    export AZURE_STORAGE_ACCOUNT="REPLACE_ME"
    az account set -s REPLACE_ME
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# START OF MENU SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    main_menu() {
        clear
        OPTION=$(whiptail --title "M A I N - M E N U" --menu "Choose your fate" 15 78 4 \
        "1" "Terraform Processes" \
        "2" "PCF processes" \
        "3" "BOSH processes" \
        "4" "PKS Menu" \
        "5" "Log into Azure" \
        "6" "Just Do It All" \
        "X" "EXIT" 3>&1 1>&2 2>&3)
        case $OPTION in
            1) show_terrfaorm_menu ;;
            2) show_om_menu ;;
            3) show_bosh_menu ;;
            4) show_pks_menu ;;
            5) azure_login ;;
            6) no_whammys ;;
            X) exit ;;
        esac
    }

    read_options(){
        OPTION=$(main_menu)
        exitstatus=$?
        if [ $exitstatus = 0 ]; then
            case $OPTION in
                1) show_terrfaorm_menu ;;
                2) show_om_menu ;;
                3) show_bosh_menu ;;
                4) show_pks_menu ;;
                5) azure_login ;;
                6) no_whammys ;;
            esac
        fi
    }

    terraform_menu() {
        # clear
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # echo "   T E R R A F O R M - M E N U   "
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # echo "1. OpsMan"
        # echo "2. Harbor"
        # echo "3. PKS"
        # echo "4. PAS"
        # echo "5. PASW"
        # echo "6. Healthwatch"
        # echo "7. Azure Service Broker"
        # echo "x. Main Menu"
    }
    read_terraform_options(){
        local choice
        read -p "Enter choice [ 1 - x] " choice
        case $choice in
            1) terraform_opsman ;;
            2) terraform_harbor ;;
            3) terraform_pks ;;
            4) terraform_pas ;;
            5) terraform_pasw ;;
            6) terraform_healthwatch ;;
            7) terraform_azure_sb ;;
            x) show_main_menu 0;;
            *) echo -e "${RED}Error...${STD}" && sleep 2
        esac
    }
    om_menu() {
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~"
        echo "   P C F - M E N U   "
        echo "~~~~~~~~~~~~~~~~~~~~~"
        echo "1. Fresh opsman install"
        echo "2. Install/Configure Director"
        echo "3. Install/Configure PKS"
        echo "4. Install/Configure Harbor"
        echo "5. Install/Configure PAS"
        echo "6. Install/Configure PASW"
        echo "7. Install/Configure SSO"
        echo "8. Install/Configure Healthwatch"
        echo "9. Install/Configure Azure SB"
        echo "10. Install/Configure RabbitMQ"
        echo "11. Install/Configure Metrics"
        echo "12. Install/Configure Splunk"
        echo "32. Upgrade OpsMan"
        echo "x. Exit"
    }
    read_om_options(){
        local choice
        read -p "Enter choice [ 1 - x] " choice
        case $choice in
            1) fresh_opsman ;;
            2) install_director ;;
            3) install_pks ;;
            4) install_harbor ;;
            5) install_pas ;;
            6) install_pasw ;;
            7) install_sso ;;
            8) install_healthwatch ;;
            9) install_azure_sb ;;
            10) install_rabbitmq ;;
            11) install_metrics ;;
            12) install_splunk ;;
            32) upgrade_opsman ;;
            x) show_main_menu 0;;
            *) echo -e "${RED}Error...${STD}" && sleep 2
        esac
    }
    pks_menu(){	
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~"	
        echo "         PKS         "
        echo "~~~~~~~~~~~~~~~~~~~~~"
        echo "1. New PKS LDAP Cluster Admin"
        echo "2. New PKS UAA Cluster Admin"
        echo "3. Create PKS Automation Account"
        echo "4. Map PAE_PCF to PKS Manage&Admin"
        echo "5. New PKS Cluster"
        echo "x. Return to Main Menu"
    }
    read_pks_options(){
        local choice
        read -p "Enter choice [ 1 - x] " choice
        case $choice in
            1) new_pks_ldap_cluter_admin ;;
            2) new_pks_cluter_admin ;;
            3) new_pks_automation_client ;;
            4) map_pae_pcf ;;
            5) new_pks_cluster ;;
            x) show_om_menu 0 ;;
            *) echo -e "${RED}Error...${STD}" && sleep 2
        esac
    }
    bosh_menu() {
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "        B O S H - M E N U        "
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "1. Terraform Concourse"
        echo "2. Install Concourse"
        echo "3. Terraform Prometheus"
        echo "4. Install Prometheus"
        echo "x. Main Menu"
    }
    read_bosh_options(){
        local choice
        read -p "Enter choice [ 1 - x] " choice
        case $choice in
            1) terraform_concourse ;;
            2) install_concourse ;;
            3) terraform_prometheus ;;
            4) install_prometheus ;;
            x) show_main_menu 0;;
            *) echo -e "${RED}Error...${STD}" && sleep 2
        esac
    }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# END OF MENU SECTION
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
        echo "==================================================================================================================="
        echo "= If this step fails, you may need to add the cert to your trusted store                                          ="
        echo "= url=releases.hashicorp.com                                                                                      ="
        echo "= openssl s_client -showcerts -connect $url:443</dev/null 2>/dev/null | openssl x509 -outform PEM > /tmp/$url.crt ="
        echo "= sudo mv /tmp/$url.crt /usr/local/share/ca-certificates                                                          ="
        echo "= sudo update-ca-certificates --fresh                                                                             ="
        echo "==================================================================================================================="
        cd ../terraforming-opsman_only
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "~~~~~Lets init this thing~~~~~"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        terraform init
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # echo "~~~~~Running Terraform Plan~~~~~"
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # terraform plan
        # read -p "Plan completed. Run terraform apply? (y/n) " terraform_apply

        # if [ "$terraform_apply" == "y" ]; then
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "~~~~~Running Terraform Apply~~~~~"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            terraform apply
            pause
        # fi

        cd ../scripts
    }
    terraform_harbor(){
        cd ../terraforming-harbor
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "~~~~~Lets init this thing~~~~~"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        terraform init
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # echo "~~~~~Running Terraform Plan~~~~~"
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # terraform plan
        # read -p "Plan completed. Run terraform apply? (y/n) " terraform_apply

        # if [ "$terraform_apply" == "y" ]; then
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "~~~~~Running Terraform Apply~~~~~"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            terraform apply  -auto-approve
            pause
        # fi

        cd ../scripts
    }
    terraform_pks(){
        cd ../terraforming-pks
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "~~~~~Lets init this thing~~~~~"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        terraform init
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # echo "~~~~~Running Terraform Plan~~~~~"
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # terraform plan
        # read -p "Plan completed. Run terraform apply? (y/n) " terraform_apply

        # if [ "$terraform_apply" == "y" ]; then
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "~~~~~Running Terraform Apply~~~~~"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            terraform apply  -auto-approve
            pause
        # fi

        cd ../scripts
    }
    terraform_pas(){
        cd ../terraforming-pas_only
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "~~~~~Lets init this thing~~~~~"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        terraform init
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # echo "~~~~~Running Terraform Plan~~~~~"
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # read -p "Plan completed. Run terraform apply? (y/n) " terraform_apply

        # if [ "$terraform_apply" == "y" ]; then
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "~~~~~Running Terraform Apply~~~~~"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            terraform apply  -auto-approve
            pause
        # fi

        cd ../scripts
    }
    terraform_pasw(){
        cd ../terraforming-pasw
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "~~~~~Lets init this thing~~~~~"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        terraform init
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # echo "~~~~~Running Terraform Plan~~~~~"
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # read -p "Plan completed. Run terraform apply? (y/n) " terraform_apply

        # if [ "$terraform_apply" == "y" ]; then
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "~~~~~Running Terraform Apply~~~~~"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            terraform apply  -auto-approve
            pause
        # fi

        cd ../scripts
    }
    terraform_healthwatch(){
        cd ../terraforming-healthwatch
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "~~~~~Lets init this thing~~~~~"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        terraform init
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # echo "~~~~~Running Terraform Plan~~~~~"
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # read -p "Plan completed. Run terraform apply? (y/n) " terraform_apply

        # if [ "$terraform_apply" == "y" ]; then
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "~~~~~Running Terraform Apply~~~~~"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            terraform apply  -auto-approve
            pause
        # fi

        cd ../scripts
    }
    terraform_azure_sb(){
        cd ../terraforming-azure-sb
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "~~~~~Lets init this thing~~~~~"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        terraform init
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # echo "~~~~~Running Terraform Plan~~~~~"
        # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        # read -p "Plan completed. Run terraform apply? (y/n) " terraform_apply

        # if [ "$terraform_apply" == "y" ]; then
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "~~~~~Running Terraform Apply~~~~~"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            terraform apply  -auto-approve
            pause
        # fi

        cd ../scripts
    }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# END OF TERRAFORM SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# START OF INSTALL SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    fresh_opsman (){

        ##############################
        # Download State
        ##############################
        echo "Downloading state"
        az storage blob download -c terraform -f ../opsman.tfstate -n demo-uscentral-pcf/opsman.tfstate

        

        ##############################
        # Configure OpsMan Auth
        ##############################
        echo "Configuring OpsMan for SAML Auth"
        om -k configure-saml-authentication -c <(texplate execute ../ci/assets/template/opsman.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../opsman.tfstate) -o yaml)
        #om -k configure-saml-authentication --decryption-passphrase REPLACE_ME --saml-idp-metadata https://login.microsoftonline.com/REPLACE_ME/federationmetadata/2007-06/federationmetadata.xml?appid=3c01e1d9-fecd-4e47-b85b-d2d895963280 --saml-bosh-idp-metadata \https://login.microsoftonline.com/REPLACE_ME/federationmetadata/2007-06/federationmetadata.xml?appid=3c01e1d9-fecd-4e47-b85b-d2d895963280 --saml-rbac-admin-group REPLACE_ME --saml-rbac-groups-attribute \http://schemas.microsoft.com/ws/2008/06/identity/claims/groups
        pause


        ##############################
        # Create UAA User for om
        # gem install cf-uaac
        ##############################
        echo "Creating local om-admin user"
        uaac target $opsman_url/uaa/ --skip-ssl-validation
        echo "You will need to access https://opsman.REPLACE_ME_DNS/uaa/passcode for your passcode"
        echo "Client ID:  opsman"
        pause
        uaac token sso get
        uaac client add om-admin --authorized_grant_types client_credentials --authorities opsman.admin --secret $password

        #Setting new SSL
        om -k update-ssl-certificate --private-key-pem "$(jq -e --raw-output '.modules[0].outputs.ssl_private_key.value' ../opsman.tfstate)" --certificate-pem "$(jq -e --raw-output '.modules[0].outputs.ssl_cert.value' ../opsman.tfstate)"

        pause
    }
    install_director (){ 
        #microsoft/azure-cli
        ##############################
        # Download State
        ##############################
        echo "Downloading state"
        az storage blob download -c terraform -f ../opsman.tfstate -n demo-uscentral-pcf/opsman.tfstate

        echo "Configuring bosh director"
        om -k configure-director --config <(texplate execute ../ci/assets/template/director-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../opsman.tfstate) -o yaml)

        read -p "Do you want to apply changes? (y/n) " apply_changes
        if [ "$apply_changes" == "y" ]; then
            echo "Applying changes"
            om -k apply-changes
            pause
        fi
    }

    install_harbor(){
        read -p "Do you want to download/upload/stage Harbor? (y/n) " harbor_download

        if [ "$harbor_download" != "n" ]; then
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
        fi

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

        ##############################
        # apply changes
        ##############################
        read -p "Do you want to apply changes? (y/n) " apply_changes

        if [ "$apply_changes" == "y" ]; then
            echo "Applying changes"
            om -k apply-changes
            pause
        fi

    }
    install_pas(){
        read -p "Do you want to download/upload/stage PAS? (y/n) " pas_download

        if [ "$pas_download" != "n" ]; then
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
            pause
            echo "Deleting PAS files"
            rm "$pas_product_slug"-*.pivotal
            rm *.tgz
        fi

        ##############################
        #Download PAS tfstate   
        ##############################    
        echo "downloading tfstate"
        az storage blob download -c terraform -f ../pas.tfstate -n demo-uscentral-pcf/pas.tfstate

        ##############################
        # Configure PAS
        ##############################
        echo "Configuring PAS"
        om -k configure-product -c <(texplate execute ../ci/assets/template/pas-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../pas.tfstate) -o yaml)

        ##############################
        # apply changes
        ##############################
        read -p "Do you want to apply changes? (y/n) " apply_changes

        if [ "$apply_changes" == "y" ]; then
            echo "Applying changes"
            om -k apply-changes
            pause
        fi
    
    }
    install_rabbitmq(){
        read -p "Do you want to download/upload/stage rabbitmq? (y/n) " rabbitmq_download

        if [ "$rabbitmq_download" != "n" ]; then
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
            pause
            echo "Deleting rabbitmq files"
            rm "$rabbitmq_product_slug"*.pivotal
            rm *.tgz
        fi
        ##############################
        # Configure rabbitmq
        ##############################
        echo "Configuring rabbitmq"
        om -k configure-product -c ../ci/assets/template/rabbitmq-config.yml

        ##############################
        # apply changes
        ##############################
        read -p "Do you want to apply changes? (y/n) " apply_changes

        if [ "$apply_changes" == "y" ]; then
            echo "Applying changes"
            om -k apply-changes
            pause
        fi
    }
    install_metrics(){
        read -p "Do you want to download/upload/stage Metrics? (y/n) " metrics_download

        if [ "$metrics_download" != "n" ]; then
            ################################
            # Download/Upload/Stage Metrics
            ################################
            echo "Downloading Metrics from Pivnet"
            om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $metrics_product_slug --product-version-regex $metrics_version_regex --stemcell-iaas azure
            echo "Uploading Metrics to OpsMan"
            om -k upload-product -p "$metrics_product_slug"*.pivotal
            echo "Uploading Metrics Stemcell to OpsMan"
            om -k upload-stemcell -s *.tgz
            echo "Staging Metrics"
            om -k stage-product --product-name "$metrics_product_slug"  --product-version $(om tile-metadata --product-path "$metrics_product_slug"*.pivotal --product-version true)
            pause
            echo "Deleting Metrics files"
            rm "$metrics_product_slug"*.pivotal
            rm *.tgz
        fi
        ##############################
        # Configure metrics
        ##############################
        echo "Configuring Metrics"
        om -k configure-product -c ../ci/assets/template/metrics-config.yml

        ##############################
        # apply changes
        ##############################
        read -p "Do you want to apply changes? (y/n) " apply_changes

        if [ "$apply_changes" == "y" ]; then
            echo "Applying changes"
            om -k apply-changes
            pause
        fi
    }

    install_splunk(){
        read -p "Do you want to download/upload/stage splunk? (y/n) " splunk_download

        if [ "$splunk_download" != "n" ]; then
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
            pause
            echo "Deleting splunk files"
            rm "$splunk_product_slug"*.pivotal
            rm *.tgz
        fi
        ##############################
        # Configure splunk
        ##############################
        echo "Configuring splunk"
        om -k configure-product -c ../ci/assets/template/splunk-config.yml

        ##############################
        # apply changes
        ##############################
        read -p "Do you want to apply changes? (y/n) " apply_changes

        if [ "$apply_changes" == "y" ]; then
            echo "Applying changes"
            om -k apply-changes
            pause
        fi
    }
    install_sso(){
        read -p "Do you want to download/upload/stage SSO? (y/n) " sso_download

        if [ "$sso_download" != "n" ]; then
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
            pause
            echo "Deleting SSO files"
            rm "$sso_product_slug"*.pivotal
            rm *.tgz
        fi
        ##############################
        # Configure SSO
        ##############################
        echo "Configuring SSO"
        om -k configure-product -c ../ci/assets/template/sso-config.yml

        ##############################
        # apply changes
        ##############################
        read -p "Do you want to apply changes? (y/n) " apply_changes

        if [ "$apply_changes" == "y" ]; then
            echo "Applying changes"
            om -k apply-changes
            pause
        fi
    }
    install_pasw(){
        read -p "Do you want to download/upload/stage PASW? (y/n) " pasw_download

        if [ "$pasw_download" != "n" ]; then
            ##############################
            # Download/Upload/Stage PAS
            ##############################    
            mkdir downloads
            echo "Downloading PASW from Pivnet"
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
            pause
            echo "Deleting PASW files"
            rm -rf ./downloads
        fi

        ##############################
        #Download PAS tfstate   
        ##############################    
        echo "downloading tfstate"
        az storage blob download -c terraform -f ../pasw.tfstate -n demo-uscentral-pcf/pasw.tfstate

        ##############################
        # Configure PAS
        ##############################
        echo "Configuring PASW"
        om -k configure-product -c <(texplate execute ../ci/assets/template/pasw-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../pasw.tfstate) -o yaml)

        ##############################
        # apply changes
        ##############################
        read -p "Do you want to apply changes? (y/n) " apply_changes

        if [ "$apply_changes" == "y" ]; then
            echo "Applying changes"
            om -k apply-changes
            pause
        fi
    }
    install_pks(){
        
        echo "**************************************************************************"
        echo "** Add the required identities to Azure                                 **"
        echo "** Follow directions here:                                              **"
        echo "** https://docs.pivotal.io/runtimes/pks/1-4/azure-managed-identities.html*"
        echo "** Proceed with the next download step while you compelte this task     **"
        echo "**************************************************************************"
        pause

        read -p "Do you want to download/upload/stage PKS? (y/n) " pks_download

        if [ "$pks_download" != "n" ]; then
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
            read -p "Do you want to delete the downloaded PKS files? (y/n) " pks_delete
            if [ "$pks_delete" == "y" ]; then
                echo "Deleting downloaded PKS files"
                rm "$pks_product_slug"-*.pivotal
                rm *.tgz
            fi
        fi


        ##############################
        # Download PKS tfstate
        ##############################
        echo "Downloading PKS state"
        az storage blob download -c terraform -f ../pks.tfstate -n demo-uscentral-pcf/pks.tfstate

        ##############################
        # Configure PKS
        ##############################
        echo "Configuring PKS"
        om -k configure-product -c <(texplate execute ../ci/assets/template/pks-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../pks.tfstate) -o yaml)
        
        
        read -p "Do you want to apply changes? (y/n) " apply_changes

        if [ "$apply_changes" == "y" ]; then
            echo "Applying changes"
            om -k apply-changes
            pause
        fi



    }
    install_healthwatch(){
        read -p "Do you want to download/upload/stage healthwatch? (y/n) " healthwatch_download

        if [ "$healthwatch_download" != "n" ]; then
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
            read -p "Do you want to delete the downloaded healthwatch files? (y/n) " healthwatch_delete
            if [ "$healthwatch_delete" == "y" ]; then
                echo "Deleting downloaded healthwatch files"
                rm *.pivotal
                rm *.tgz
            fi
        fi

        echo "Downloading state"
        az storage blob download -c terraform -f ../healthwatch.tfstate -n demo-uscentral-pcf/healthwatch.tfstate
        
        read -p "Create healthwatch uaa client? (y/n) " healthwatch_client
        if [ "$healthwatch_client" == "y" ]; then
            bosh_uaa_login
            healthwatch_uaa_user=$(cat ../healthwatch.tfstate | jq -e --raw-output '.modules[].outputs.healthwatch_uaa_user.value')
            healthwatch_uaa_pass=$(cat ../healthwatch.tfstate | jq -e --raw-output '.modules[].outputs.healthwatch_uaa_password.value')
            uaac client add "${healthwatch_uaa_user}" --authorized_grant_types client_credentials --authorities bosh.read --secret "${healthwatch_uaa_pass}"
            echo "${healthwatch_uaa_user} created"
        fi

        ##############################
        # Configure healthwatch
        ##############################
        echo "Configuring healthwatch"
        om -k configure-product -c <(texplate execute ../ci/assets/template/healthwatch-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../healthwatch.tfstate) -o yaml)
        
        
        read -p "Do you want to apply changes? (y/n) " apply_changes

        if [ "$apply_changes" == "y" ]; then
            echo "Applying changes"
            om -k apply-changes
            pause
        fi



    }
    docker_copy(){

        #### TODO -- Create a default project (pcf-admins) to add images to
        docker pull harbor.pksREPLACE_ME/pcf-admins/clitools
        docker login -u admin -p REPLACE_ME harbor.pks.REPLACE_ME_DNS
        docker tag harbor.pksREPLACE_ME/pcf-admins/clitools harbor.pks.REPLACE_ME_DNS/pcf-admins/clitools
        docker push harbor.pks.REPLACE_ME_DNS/pcf-admins/clitools

    }
    install_gogs(){
        director_login
        wget https://s3.amazonaws.com/gogs-boshrelease/compiled-releases/gogs/gogs-5.5.1-ubuntu-xenial-250.9-20190303-095820-715799658-20190303095823.tgz -O ../gogs.tgz
        bosh upload-release ../gogs.tgz
        om -k download-product --output-directory ../ --pivnet-api-token $pivnet_token --pivnet-file-glob "*azure*.tgz" --pivnet-product-slug stemcells-ubuntu-xenial --product-version $gogs_stemcell
        bosh upload-stemcell ../*azure*.tgz
        bosh -d gogs deploy ../ci/assets/template/gogs/gogs-basic.yml -n \
        -v gogs-uri=gogs.sys.REPLACE_ME_DNS \
        --vars-store gogs-creds.yml

        bosh -d gogs run-errand gogs-admin

        rm ../*azure*.tgz
        gogs_ip=$(bosh -d gogs vms --json | jq -e --raw-output '.Tables[].Rows[] | select(.instance|test("gogs")) | .ips')
        # git remote set-url --add --push origin "https://${gogs_ip}/az-pcf-fog.git"
        git config http.sslVerify false

        git remote add origin https://${gogs_ip}/az-pcf-fog.git
        git config credential.https://10.44.44.18.username gogs
        git config credential.https://10.44.44.18.password REPLACE_ME
        git push 
        git remote set-url --delete --push origin "https://${gogs_ip}/az-pcf-fog.git"

    }
    install_concourse-basic(){
        director_login
        echo "Downloading concourse from Pivnet"
        om -k download-product --output-directory ../ --pivnet-api-token $pivnet_token --pivnet-file-glob "*.tgz" --pivnet-product-slug $concourse_product_slug --product-version-regex $concourse_version_regex
        echo "Downloading stemcell from pivnet"
        om -k download-product --output-directory ../ --pivnet-api-token $pivnet_token --pivnet-file-glob "*azure*.tgz" --pivnet-product-slug stemcells-ubuntu-xenial --product-version-regex $concourse_stemcell_regex
        echo "Downloading Postgres from GitHub"
        wget "https://bosh.io/d/github.com/cloudfoundry/postgres-release?v=${postgres_version}" -O ../postgres.tgz
        echo "Downloading bpm"
        wget "https://bosh.io/d/github.com/cloudfoundry-incubator/bpm-release?v=1.0.4" -O bpm.tgz
        echo "Uploading Postgres release director"
        bosh -e azure upload-release ../postgres.tgz
        echo "Uploading bpm release director"
        bosh -e azure upload-release ../bpm.tgz
        echo "Uploading concourse Stemcell to director"
        bosh -e azure upload-stemcell ../*azure*.tgz
        echo "Uploading concourse release director"
        bosh -e azure upload-release ../*concourse*.tgz
        echo "Deleting downloaded concourse files"
        rm ../*.tgz
        pause
        bosh -d concourse deploy ../ci/assets/template/concourse/concourse-basic.yml -n
        concourse_ip=$(bosh -d concourse vms --json | jq -e --raw-output '.Tables[].Rows[] | select(.instance|test("concourse")) | .ips')
        fly -t main login -c https://"${concourse_ip}" -n main -u concourse -p REPLACE_ME -k
        fly -t main sync
        fly -t main sp -p inital-automation -c ../ci/assets/template/concourse/pipeline.yml -n
        fly -t main up -p inital-automation
        fly -t main tj -j inital-automation/publish -w


        ##############################
        # Download PKS tfstate
        ##############################
        # echo "Downloading PKS state"
        # az storage blob download -c terraform -f ../pks.tfstate -n demo-uscentral-pcf/pks.tfstate

        ##############################
        # Configure PKS
        ##############################
        # echo "Configuring PKS"
        # om -k configure-product -c <(texplate execute ../ci/assets/template/pks-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../pks.tfstate) -o yaml)

    }

    install_azure_sb(){

        read -p "Do you want to download/upload/stage Azure SB? (y/n) " sb_download

        if [ "$sb_download" != "n" ]; then
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
        fi
        ##############################
        #Download Azure SB tfstate
        ##############################    
        echo "downloading Azure SB tfstate"
        az storage blob download -c terraform -f ../harbor.tfstate -n demo-uscentral-pcf/azure_sb.tfstate

        ##############################
        # Configure Azure SB
        ##############################
        echo "Configuring Azure SB"
        om -k configure-product -c <(texplate execute ../ci/assets/template/az_sb-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../azure_sb.tfstate) -o yaml)

        ##############################
        # apply changes
        ##############################
        read -p "Do you want to apply changes? (y/n) " apply_changes

        if [ "$apply_changes" == "y" ]; then
            echo "Applying changes"
            om -k apply-changes
            pause
        fi
    }

    install_credhub(){
        director_login
        echo "Downloading Credhub from bosh.io"
        wget "https://bosh.io/d/github.com/pivotal-cf/credhub-release?v=${credhub_version}" -O ../credhub.tgz --no-check-certificate
        echo "Uploading credhub release director"
        bosh -e azure upload-release ../credhub.tgz
        echo "Downloading cf-mysql from bosh.io"
        wget "https://bosh.io/d/github.com/cloudfoundry/cf-mysql-release?v=${mysql_version}" -O ../cf-mysql.tgz --no-check-certificate
        echo "Uploading cf-mysql release director"
        bosh -e azure upload-release ../cf-mysql.tgz
        echo "Downloading uaa from bosh.io"
        wget "https://bosh.io/d/github.com/cloudfoundry/uaa-release?v=${uaa_version}" -O ../uaa.tgz --no-check-certificate
        echo "Uploading uaa release director"
        bosh -e azure upload-release ../uaa.tgz
        rm ../*.tgz

        echo "Make sure you have entered ${credhub_mySQL_proxy_ip} and ${credhub_static_ips} into cloud-config as static IPs."
        cf_name=$(bosh deployments --json | jq -e --raw-output '.Tables[].Rows[].name | select(.| contains("cf-"))')


        bosh -d credhub deploy ../ci/assets/template/concourse/credhub-config.yml \
        -v credhub_mySQL_proxy_ip="REPLACE_ME1" \
        -v credhub_static_ips="REPLACE_ME0" \
        -o ../ci/assets/template/concourse/credhub-webui-ops.yml \
        -v cf_deployment_name="${cf_name}" --no-redact -n

        bosh -e azure -d credhub-webui deploy ../ci/assets/template/concourse/credhub-ui.yml \
        -v credhub_webui_hostname=credhubui.sys.REPLACE_ME_DNS \
        -v credhub_client_id=credhub_webui \
        -v credhub_client_secret=LPjdnq9ZR46BNkCP \
        -v credhub_server=https://credhub.REPLACE_ME_DNS:8844 --no-redact -n
    }

    install_concourse(){
        director_login
        read -p "Do you want to download/upload concourse? (y/n) " concourse_download

        if [ "$concourse_download" != "n" ]; then
            ##############################
            # Downlaod/Upload/Stage Concourse
            ##############################
            echo "Downloading concourse from Pivnet"
            om -k download-product --output-directory ../ --pivnet-api-token $pivnet_token --pivnet-file-glob "*.tgz" --pivnet-product-slug $concourse_product_slug --product-version-regex $concourse_version_regex
            echo "Downloading stemcell from pivnet"
            om -k download-product --output-directory ../ --pivnet-api-token $pivnet_token --pivnet-file-glob "*azure*.tgz" --pivnet-product-slug stemcells-ubuntu-xenial --product-version-regex $concourse_stemcell_regex
            echo "Downloading UAA from GitHub"
            wget "https://bosh.io/d/github.com/cloudfoundry/uaa-release?v=${uaa_version}" -O ../uaa.tgz
            echo "Downloading Postgres from GitHub"
            wget "https://bosh.io/d/github.com/cloudfoundry/postgres-release?v=${postgres_version}" -O ../postgres.tgz
            echo "Downloafing backup-and-restore-sdk-release from GitHub"
            wget "https://bosh.io/d/github.com/cloudfoundry-incubator/backup-and-restore-sdk-release?v=${bbr_sdk_version}" -O ../bbr.tgz
            echo "Downloaing os-conf from GitHub"
            wget "https://bosh.io/d/github.com/cloudfoundry/os-conf-release?v=${os_conf_version}" -O ../os-conf.tgz --no-check-certificate
            echo "Downloading bpm"
            wget "https://bosh.io/d/github.com/cloudfoundry-incubator/bpm-release?v=1.0.0" -O bpm.tgz
            echo "Uploading concourse Stemcell to director"
            bosh -e azure upload-stemcell ../*azure*.tgz
            om -k upload-stemcell -s ../*azure*.tgz
            echo "Uploading concourse release director"
            bosh -e azure upload-release ../*concourse*.tgz
            echo "Uploading uaa release director"
            bosh -e azure upload-release ../uaa.tgz
            echo "Uploading backup-and-restore-sdk-release release director"
            bosh -e azure upload-release ../bbr.tgz
            echo "Uploading Postgres release director"
            bosh -e azure upload-release ../postgres.tgz
            echo "Uploading os-conf release director"
            bosh -e azure upload-release ../os-conf.tgz
            echo "Uploading bpm release director"
            bosh -e azure upload-release ../bpm.tgz
            read -p "Do you want to delete the downloaded concourse files? (y/n) " concourse_delete
            if [ "$concourse_delete" == "y" ]; then
                echo "Deleting downloaded concourse files"
                rm ../*.tgz
            fi
        fi
        pause
        
        credhub login
        credhub_write
        bosh -d concourse deploy ../ci/assets/template/concourse/concourse.yml


        ##############################
        # Download PKS tfstate
        ##############################
        # echo "Downloading PKS state"
        # az storage blob download -c terraform -f ../pks.tfstate -n demo-uscentral-pcf/pks.tfstate

        ##############################
        # Configure PKS
        ##############################
        # echo "Configuring PKS"
        # om -k configure-product -c <(texplate execute ../ci/assets/template/pks-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../pks.tfstate) -o yaml)

    }
    install_prometheus(){
        
        read -p "Do you want to download/upload prometheus? (y/n) " prometheus_download

        if [ "$prometheus_download" != "n" ]; then
            ##############################
            # Downlaod/Upload/Stage Concourse
            ##############################
            echo "Downloading prometheus from GitHub"
            wget "https://github.com/bosh-prometheus/prometheus-boshrelease/releases/download/v${prometheus_version}/prometheus-${prometheus_version}.tgz" -O ../promtheus.tgz
            echo "Downloading postgres from GitHub"
            wget "https://bosh.io/d/github.com/cloudfoundry/postgres-release?v=${postgres_version}" -O ../postgres.tgz
            echo "Downloading bpm from GitHub"
            wget "https://bosh.io/d/github.com/cloudfoundry-incubator/bpm-release?v=${bpm_version}" -O ../bpm.tgz
            echo "Downloading bpm from GitHub"
            wget "https://bosh.io/d/github.com/cloudfoundry-incubator/bpm-release?v=${bpm_version}" -O ../bpm.tgz
            echo "Downloading routing from GitHub"
            wget "https://bosh.io/d/github.com/cloudfoundry-incubator/cf-routing-release?v=${routing_version}" -O ../routing.tgz
            echo "Downloading Node Exporter from GitHub"
            wget "https://github.com/bosh-prometheus/node-exporter-boshrelease/releases/download/v4.1.0/node-exporter-4.1.0.tgz" -O ../node-exporter.tgz
            director_login
            echo "Uploading prometheus release director"
            bosh -e azure upload-release ../promtheus.tgz
            echo "Uploading Node Exporter release director"
            bosh -e azure upload-release ../node-exporter.tgz
            echo "Uploading postgres release director"
            bosh -e azure upload-release ../postgres.tgz
            echo "Uploading bpm release director"
            bosh -e azure upload-release ../bpm.tgz
            echo "Uploading routing release director"
            bosh -e azure upload-release ../routing.tgz
            read -p "Do you want to delete the downloaded prometheus files? (y/n) " prometheus_delete
            if [ "$prometheus_delete" == "y" ]; then
                echo "Deleting downloaded prometheus files"
                rm *.tgz
            fi
            pause
        fi

        read -p  "Do you need to know how to prep? (y/n)" prometheus_prep
        
        if [ "$prometheus_prep" != "n" ]; then
            printf "
                ### Create clients for firehose_exporter and cf_exporter
                    #bosh -d "${cf_name}" manifest > /tmp/azure-cf.yml
                    #bosh -d "${cf_name}" deploy /tmp/azure-cf.yml -o ../ci/assets/template/prometheus/ops/cf/add-grafana-uaa-clients.yml  -o ../ci/assets/template/prometheus/ops/cf/add-prometheus-uaa-clients.yml --no-redact

                ######################
                ### Create MySQL user
                ######################
                    # cf_name=$(bosh deployments --json | jq -e --raw-output '.Tables[].Rows[].name | select(.| contains("cf-"))')
                    # mysql_password=$(credhub get -n /p-bosh/"${cf_name}"/mysql-admin-credentials -j | jq -e --raw-output '.value.password')
                    # bosh -d "${cf_name}" ssh mysql/0

                    ####mysql_password Var does not pass over####
                    
                    # mysql -h 127.0.0.1 -u root -p "${mysql_password}"
                    # CREATE USER 'exporter' IDENTIFIED BY 'UyuWBF2g678SBS2x';
                    # GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter' WITH MAX_USER_CONNECTIONS 3;
                    # exit
                    # exit

                    # credhub set -t user -n /p-bosh/prometheus/mysql_exporter -z exporter -w UyuWBF2g678SBS2x

                ####################################
                ### Create client for bosh_exporter
                ####################################
                    # uaa_admin_client_credentials=$(credhub get -n /opsmgr/"${cf_name}"/uaa/admin_client_credentials -j | jq -e --raw-output '.value.password')
                    # uaac target director.REPLACE_ME_DNS:8443 --skip-ssl-validation
                    # uaac token client get admin -s "${uaa_admin_client_credentials}"
                    # uaac client add bosh_exporter --authorized_grant_types client_credentials,refresh_token --authorities bosh.read --scope bosh.read --secret dL92yrTa48ca2xxK
                    # credhub set -n /uaa_bosh_exporter_client_secret -t password -w dL92yrTa48ca2xxK
            "
        fi

        

        echo "Add Node Exporter to Runtime config?" runtime_config
        if [ "$runtime_config" != "n" ]; then
            director_login
            echo 'releases:
  - name: node-exporter
    version: 4.1.0

addons:
  - name: node_exporter
    jobs:
      - name: node_exporter
        release: node-exporter
    include:
      stemcell:
        - os: ubuntu-trusty
        - os: ubuntu-xenial
    properties: {}' > ../runtime-config.yml
            bosh update-runtime-config ../runtime-config.yml
        fi

        ####INSTALL

        # cf_name=$(bosh deployments --json | jq -e --raw-output '.Tables[].Rows[].name | select(.| contains("cf-"))')
        # mysql_password=$(credhub get -n /p-bosh/"${cf_name}"/mysql-admin-credentials -j | jq -e --raw-output '.value.password')
        # bosh -d "${cf_name}" ssh mysql/0
        #Var does not pass over
        # mysql -h 127.0.0.1 -u root -p "${mysql_password}"
        # CREATE USER 'exporter' IDENTIFIED BY 'UyuWBF2g678SBS2x';
        # GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter' WITH MAX_USER_CONNECTIONS 3;
        # exit
        # exit
        # credhub set -t user -n /p-bosh/prometheus/mysql_exporter -z exporter -w UyuWBF2g678SBS2x


        #UAA - bosh_exporter
        # uaac target director.REPLACE_ME_DNS:8443 --skip-ssl-validation
        # https://opsman.REPLACE_ME_DNS/api/v0/deployed/director/manifest
        # "uaa":{"admin":{"client_secret":"YuMRDoqi4r4z-p2dR8BtuhlTikIxXKhA"}
        # uaac token client get admin -s YuMRDoqi4r4z-p2dR8BtuhlTikIxXKhA
        # uaac client add bosh_exporter --authorized_grant_types client_credentials,refresh_token --authorities bosh.read --scope bosh.read --secret dL92yrTa48ca2xxK
        # credhub set -n /uaa_bosh_exporter_client_secret -t password -w dL92yrTa48ca2xxK

        # UAA bosh_exporter on cf
        # credhub get -n /opsmgr/"${cf_name}"/uaa/admin_client_credentials -j | jq -e --raw-output '.value.password'
        # uaac target director.REPLACE_ME_DNS:8443 --skip-ssl-validation

        ###INSTALL
        director_login
        cf_name=$(bosh deployments --json | jq -e --raw-output '.Tables[].Rows[].name | select(.| contains("cf-"))')

        bosh -d prometheus deploy ../ci/assets/template/prometheus/prometheus-config.yml \
        -o ../ci/assets/template/prometheus/ops/enable-cf-route-registrar.yml \
        -o ../ci/assets/template/prometheus/ops/ldap.yml \
        -o ../ci/assets/template/prometheus/ops/monitor-node.yml \
        -o ../ci/assets/template/prometheus/ops/monitor-concourse.yml \
        -o ../ci/assets/template/prometheus/ops/monitor-bosh.yml \
        -o ../ci/assets/template/prometheus/ops/monitor-cf.yml \
        -o ../ci/assets/template/prometheus/ops/monitor-mysql.yml \
        -o ../ci/assets/template/prometheus/ops/enable-cf-loggregator-v2.yml \
        -o ../ci/assets/template/prometheus/ops/alertmanager-group-by-alertname.yml \
        -o ../ci/assets/template/prometheus/ops/monitor-http-probe.yml \
        -o ../ci/assets/template/prometheus/ops/enable-cf-api-v3.yml \
        -o ../ci/assets/template/prometheus/ops/enable-grafana-uaa.yml \
        -o ../ci/assets/template/prometheus/ops/enable-service-discovery.yml \
        -o ../ci/assets/template/prometheus/ops/enable-anon.yml \
        --var-file bosh_ca_cert=../ci/assets/template/certificates/director-ca.cer \
        -v BOSH_CLIENT="bosh_exporter" \
        -v probe_endpoints=[https://opsman.REPLACE_ME_DNS] \
        -v BOSH_CLIENT_SECRET="${BOSH_CLIENT_SECRET}" \
        -v PCF_DIRECTOR="director.REPLACE_ME_DNS" \
        -v PCF_ENV="AzureCloud" \
        -v cf_deployment_name="${cf_name}" --no-redact -n

        grafana_pass=$(credhub get -n /p-bosh/prometheus/grafana_password)
        echo "Your Grafana admin password is ${grafana_pass}"
        
    }
	upload_product(){
        om -k upload-product -p *.pivotal
		echo "Uploading Stemcells to OpsMan"
        om -k upload-stemcell -s *.tgz
        echo "Removing downloaded file(s)"
		rm *.pivotal
		rm *.tgz
	}

    no_whammys(){
        ####
        # Terraform
        ####
        terraform_all

        om -k update-ssl-certificate --private-key-pem "$(jq -e --raw-output '.modules[0].outputs.ssl_private_key.value' ../opsman.tfstate)" --certificate-pem "$(jq -e --raw-output '.modules[0].outputs.ssl_cert.value' ../opsman.tfstate)"

        #######################
        # Download/Upload
        #######################
        echo "Downloading PAS from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "cf*.pivotal" --pivnet-product-slug $pas_product_slug --product-version-regex $pas_version_regex --stemcell-iaas azure
        echo "Uploading PAS to OpsMan"
        upload_product
                
        echo "Downloading Harbor from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $harbor_product_slug --product-version-regex $harbor_version_regex --stemcell-iaas azure
        echo "Uploading Harbor to OpsMan"
        upload_product
        
        echo "Downloading PKS from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $pks_product_slug --product-version-regex $pks_version_regex --stemcell-iaas azure
        echo "Uploading PKS Tile to OpsMan"
        upload_product
        
        echo "Downloading PASW from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $pasw_product_slug --product-version-regex $pasw_version_regex --stemcell-iaas azure
        echo "Uploading PASW to OpsMan"
        upload_product
        
        echo "Downloading healthwatch from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $healthwatch_product_slug --product-version-regex $healthwatch_version_regex --stemcell-iaas azure
        echo "Uploading healthwatch Tile to OpsMan"
        upload_product

        echo "Downloading SSO from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $sso_product_slug --product-version-regex $sso_version_regex --stemcell-iaas azure
        echo "Uploading SSO to OpsMan"
        upload_product

        echo "Downloading RabbitMQ from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $rabbitmq_product_slug --product-version-regex $sso_version_regex --stemcell-iaas azure
        echo "Uploading RabbitMQ to OpsMan"
        upload_product
        
        echo "Downloading Splunk from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $splunk_product_slug --product-version-regex $splunk_version_regex --stemcell-iaas azure
        echo "Uploading Splunk to OpsMan"
        upload_product
        
        echo "Downloading Metrics from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $metrics_product_slug --product-version-regex $metrics_version_regex --stemcell-iaas azure
        echo "Uploading Metrics to OpsMan"
        upload_product
        
        echo "Downloading Azure Service Broker from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $azure_sb_product_slug --product-version-regex $azure_sb_version_regex --stemcell-iaas azure
        echo "Uploading Azure Service Broker to OpsMan"
        upload_product

        echo "Staging PAS"
        om -k stage-product --product-name cf --product-version $(om tile-metadata --product-path "$pas_product_slug"-*.pivotal --product-version true)
        echo "Staging Harbor"
        om -k stage-product --product-name harbor-container-registry --product-version $(om tile-metadata --product-path "$harbor_product_slug"-*.pivotal --product-version true)
        echo "Staging PKS"
        om -k stage-product --product-name pivotal-container-service --product-version $(om tile-metadata --product-path "$pks_product_slug"-*.pivotal --product-version true)
        echo "Staging PAS Windows"
        om -k stage-product --product-name "$pasw_product_slug" --product-version $(om tile-metadata --product-path "$pasw_product_slug"-*.pivotal --product-version true)
        echo "Staging healthwatch"
        om -k stage-product --product-name $healthwatch_product_slug --product-version $(om tile-metadata --product-path *health*.pivotal --product-version true)
        echo "Staging SSO"
        om -k stage-product --product-name "$sso_product_slug"  --product-version $(om tile-metadata --product-path "$sso_product_slug"*.pivotal --product-version true)
        echo "Staging RabbitMQ"
        om -k stage-product --product-name "$rabbitmq_product_slug"  --product-version $(om tile-metadata --product-path "$rabbitmq_product_slug"*.pivotal --product-version true)
        echo "Staging Splunk"
        om -k stage-product --product-name "$splunk_product_slug"  --product-version $(om tile-metadata --product-path "$splunk_product_slug"*.pivotal --product-version true)
        echo "Staging Metrics"
        om -k stage-product --product-name "$metrics_product_slug"  --product-version $(om tile-metadata --product-path "$metrics_product_slug"*.pivotal --product-version true)
        echo "Staging Azure Service Broker"
        om -k stage-product --product-name "$azure_sb_product_slug"  --product-version $(om tile-metadata --product-path "$azure_sb_product_slug"*.pivotal --product-version true)

        ##########Install
        #opsman  
        echo "Downloading opsman state"
        az storage blob download -c terraform -f ../opsman.tfstate -n demo-uscentral-pcf/opsman.tfstate
        echo "Configuring bosh director"
        om -k configure-director --config <(texplate execute ../ci/assets/template/director-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../opsman.tfstate) -o yaml)
        #PAS      
        echo "downloading PAS tfstate"
        az storage blob download -c terraform -f ../pas.tfstate -n demo-uscentral-pcf/pas.tfstate
        echo "Configuring PAS"
        om -k configure-product -c <(texplate execute ../ci/assets/template/pas-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../pas.tfstate) -o yaml)
        #Harbor
        echo "downloading harbor tfstate"
        az storage blob download -c terraform -f ../harbor.tfstate -n demo-uscentral-pcf/harbor.tfstate
        echo "Configuring Harbor"
        om -k configure-product -c <(texplate execute ../ci/assets/template/harbor-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../harbor.tfstate) -o yaml)
        #PKS
        echo "Downloading PKS state"
        az storage blob download -c terraform -f ../pks.tfstate -n demo-uscentral-pcf/pks.tfstate
        echo "Configuring PKS"
        om -k configure-product -c <(texplate execute ../ci/assets/template/pks-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../pks.tfstate) -o yaml)
        #PASW 
        echo "downloading PASW tfstate"
        az storage blob download -c terraform -f ../pasw.tfstate -n demo-uscentral-pcf/pasw.tfstate
        echo "Configuring PASW"
        om -k configure-product -c <(texplate execute ../ci/assets/template/pasw-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../pasw.tfstate) -o yaml)
        #Healthwatch
        echo "Downloading Healthwatch state"
        az storage blob download -c terraform -f ../healthwatch.tfstate -n demo-uscentral-pcf/healthwatch.tfstate
        # echo "Downloading Healthwatch state"
        # bosh_uaa_login
        # healthwatch_uaa_user=$(cat ../healthwatch.tfstate | jq -e --raw-output '.modules[].outputs.healthwatch_uaa_user.value')
        # healthwatch_uaa_pass=$(cat ../healthwatch.tfstate | jq -e --raw-output '.modules[].outputs.healthwatch_uaa_password.value')
        # uaac client add "${healthwatch_uaa_user}" --authorized_grant_types client_credentials --authorities bosh.read --secret "${healthwatch_uaa_pass}"
        # echo "${healthwatch_uaa_user} created"
        echo "Configuring healthwatch"
        om -k configure-product -c <(texplate execute ../ci/assets/template/healthwatch-config.yml -f <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' ../healthwatch.tfstate) -o yaml)
        #SSO
        echo "Configuring SSO"
        om -k configure-product -c ../ci/assets/template/sso-config.yml
        #RabbitMQ
        echo "Configuring RabbitMQ"
        om -k configure-product -c ../ci/assets/template/rabbitmq-config.yml
        #Splunk
        echo "Configuring Splunk"
        om -k configure-product -c ../ci/assets/template/splunk-config.yml
        #Metrics
        echo "Configuring Metrics"
        om -k configure-product -c ../ci/assets/template/metrics-config.yml
        #Azure Service Broker
        echo "Configuring Azure Service Broker"
        om -k configure-product -c ../ci/assets/template/az_sb-config.yml
    }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# END OF INSTALL SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# START OF UPGRADE SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    upgrade_opsman(){
        echo "hey there"
            pause
        ########################################
        # Export OpsMan installation
        ########################################
        #om -k export-installation --installation /tmp/installation.zip

        ########################################
        # Import install after terraform process
        ########################################
        # om -k -d $decrypt import-installation --installation /tmp/installation.zip

    }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# END OF UPGRADE SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# START OF PKS SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    new_pks_automation_client(){
        pks_uaa_login
        #automated client
        uaac client add automated-client -s REPLACE_ME --authorized_grant_types client_credentials --authorities pks.clusters.admin,pks.clusters.manage
        pause
    }
    map_pae_pcf(){
        pks_uaa_pass=$(om -k credentials -p pivotal-container-service --credential-reference .properties.pks_uaa_management_admin_client -f secret)
        uaac target "${pks_api}":8443 --skip-ssl-validation
        # Pks Uaa Management Admin Client
        uaac token client get admin -s "${pks_uaa_pass}"
        uaac group map --name pks.clusters.manage REPLACE_ME
        uaac group map --name pks.clusters.admin REPLACE_ME
        echo "COMPLETED"
        pause
    }
    new_pks_ldap_cluter_admin(){
        pks_uaa_login
        read -p "Enter User Name (IE 10073093@cloud.fiserv.net) " pks_admin_user
        uaac user add "${pks_admin_user}" --emails "${pks_admin_user}" --origin ldap
        pause
    } 
    new_pks_cluter_admin(){
        pks_uaa_login
        read -p "Enter User Name " pks_admin_user
        read -p "Enter Password " pks_admin_password
        uaac user add "${pks_admin_user}" --emails "${pks_admin_user}"@fiserv.net -p "${pks_admin_password}"
        uaac member add pks.clusters.admin "${pks_admin_user}"
        pause
        #uaac user add 10073093@cloud.fiserv.net --given_name Brian --emails 10073093@cloud.fiserv.net --origin ldap
        #uaac member add pks.clusters.admin 10073093@cloud.fiserv.net



        # uaac user add cstare --emails cstare@fiserv.net -p REPLACE_ME
        # uaac user add hug --emails hug@fiserv.net -p REPLACE_ME
        # uaac user add mei --emails mei@fiserv.net -p REPLACE_ME
        # uaac user add tony --emails tony@fiserv.net -p REPLACE_ME
        # uaac user add mahadev --emails mahdev@fiserv.net -p REPLACE_ME
        # uaac user add brismith --emails brismith@fiserv.net

        # uaac member add pks.clusters.admin mahadev
        # uaac member add pks.clusters.admin tony
        # uaac member add pks.clusters.admin hug 
        # uaac member add pks.clusters.admin cstare
        # uaac member add pks.clusters.admin mei
        # uaac member add pks.clusters.admin brismith
    }

    pks_login(){
        pks login -a "${pks_api}" --client-name "${pks_automation_acct}" --client-secret "${pks_automation_pass}" --skip-ssl-validation
    }

    pks_storage_class(){
        kubectl create -f storage-class-azure.yml
        kubectl create -f storage-class-azure-file.yml
        kubectl create -f persistent-volume-claim.yml
        helm install storage-release --set persistence.storageClass=ci-storage stable/wordpress --set mariadb.master.persistence.storageClass=ci-storage
        #To see your new storage
        kubectl get pv
    }

    new_pks_cluster(){
        # echo "${pks_api}"
        # echo "${pks_automation_acct}"
        # echo "${pks_automation_pass}"
        # echo "pks login -a "${pks_api}" --client-name "${pks_automation_acct}" --client-secret "${pks_automation_pass}" --skip-ssl-validation"
        # pause
        #log in
        echo "logging into PKS"
        pks login -a "${pks_api}" --client-name "${pks_automation_acct}" --client-secret "${pks_automation_pass}" --skip-ssl-validation

        read -p "Enter your cluster name (IE MyFreshyFreshCluster) " cluster_name
        read -p "Number of Nodes:: " pks_nodes

        pks create-cluster "${cluster_name}" -e "${cluster_name}".pks.REPLACE_ME_DNS --plan small --num-nodes "${pks_nodes}" --wait
        echo "getting PKS Credentials"
        pks get-credentials "${cluster_name}"
        echo "Follow the additonal steps to create a Load Balancer Found here::https://docs.pivotal.io/runtimes/pks/1-4/azure-cluster-load-balancer.html"
        echo "Now you need to register DNS to the master Node IP(s) to "${cluster_name}".pks.REPLACE_ME_DNS"
        pause

    }

    pks_deploy_simple_app(){
        pks login -a "${pks_api}" --client-name "${pks_automation_acct}" --client-secret "${pks_automation_pass}" --skip-ssl-validation

    }

    no_proxy_iprange(){
        printf -v no_proxy '%s,' 10.44.36.{1..100};
        export no_proxy="${no_proxy%,}";
    }

    pks_deploy_Prometheus(){
        kubectl create namespace prometheus
        kubectl create secret tls prometheus-server-tls --key azure_private.key --cert azure_cert.crt --namespace prometheus
        cd prometheus
        helm install -f values.yaml stable/prometheus --name prometheus --namespace prometheus
        #####################################
        # Deploy Grafana
        cd ../grafana
        kubectl create namespace grafana
        kubectl create secret tls grafana-server-tls --key ../azure_private.key --cert ../azure_cert.crt --namespace grafana
        helm install -f values.yaml stable/grafana --name grafana --namespace grafana
        #####################################
        # Deploy Ingress Controllers
        cd ..
        kubectl create -f nginx-ingress-grafana-rc.yaml --namespace grafana
        kubectl expose rc nginx-ingress-grafana-rc --port="80,443" --type="LoadBalancer" --namespace grafana
        # Deploy prometheus
        kubectl create -f nginx-ingress-prom-rc.yaml --namespace prometheus
        kubectl create -f nginx-ingress-prom-svc.yaml --namespace prometheus
        ####################################
        # TEST
        kubectl get pods,svc,rc,ingress,secrets -n prometheus
        kubectl get pods,svc,rc,ingress,secrets -n grafana

        #After compelte, grab public IPs and register DNS

        #############################################
        # dry run lets you see the rendered yaml
        #helm install --debug --dry-run -f values.yaml stable/prometheus --name prometheus --namespace prometheus > rendered.yaml

        ##############################
        # Delete everything
        kubectl delete pods,svc,rc,ingress,secrets -n grafana --all
        kubectl delete namespace grafana
        helm del --purge grafana
    }

    install_helm(){
        git clone https://github.com/kubernetes/charts.git
        cd charts
        helm init
        helm repo add gitlab https://charts.gitlab.io/
        #https://gitlab.com/gitlab-org/charts/auto-deploy-app
        #helm install auto-deploy-app gitlab/auto-deploy-app --version 0.2.9
    }

    docker_helloworld(){
        echo "Set "
        echo "server: https://etg.pks.REPLACE_ME_DNS:8443"
        echo "insecure-skip-tls-verify: true"
        echo "then run pks get-crednetials again"
        echo "Did you set the identities???"
        docker build -t hello-world .
        docker --insecure-registry=harbor.sys.REPLACE_ME_DNS login https://harbor.sys.REPLACE_ME_DNS
        docker login harbor.sys.REPLACE_ME_DNS
        docker tag hello-world harbor.sys.REPLACE_ME_DNS/public/hello-world
        docker push harbor.sys.REPLACE_ME_DNS/public/hello-world
        helm create helloworld-chart
        helm package helloworld-chart -f helloworld-values.yml --debug
        helm install helloworld helloworld-chart-0.1.0.tgz
        kubectl describe svc helloworld-helloworld-chart
        kubectl describe deployment helloworld-helloworld-chart
    }

    pks_jenkins(){
        helm install jenkins stable/jenkins -f jenkins-values.yml --debug
        jenkins_pass=$(kubectl get secret --namespace default jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode)
        echo "Your Jenkins username is: admin"
        echo "Your Jenkins password is: ${jenkins_pass}"
        kubectl get svc --namespace default -w jenkins

        #Add to ingress-resource and upgrade
        kubectl upgrade -f ingress-resource.yml

        #SmCoDJZX72
        export SERVICE_IP=$(kubectl get svc --namespace default jenkins --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
        echo http://$SERVICE_IP:8080/login

    }

    pks_simple_app(){
        kubectl run bootcamp --image=docker.io/jocatalin/kubernetes-bootcamp:v1 --port=8080

    }

    pks_base(){
        kubectl create -f wildcard-cert.yml
    }

    helm_nginx(){
        ###########
        # It works
        ###########
        #Install default Certificate
        kubectl create -f wildcard-cert.yml
        #install nginx ingress controller
        #https://github.com/helm/charts/tree/master/stable/nginx-ingress
        helm install nginx-ingress stable/nginx-ingress -f ingress-controller.yml
        #Install nginx ingress resource
        kubectl create -f ingress-resource.yml
        #Check it
        kubectl get ingress
        kubectl describe ingress etg-ingress

    }
    helm_nginx_try2(){
        #Install default Certificate
        kubectl create -f wildcard-cert.yml
        #new namespace
        kubectl create namespace ingress-basic
        #####This works, but assigns public IP
        helm install etg-nginx stable/nginx-ingress     --namespace ingress-basic --set controller.service.annotations."service.beta.kubernetes.io/azure-load-balancer-internal"=true
        ###############
        #####Crash loop
        helm install etg-nginx stable/nginx-ingress     --namespace ingress-basic -f ingress-controller.yml
        ###############
        #install nginx ingress controller
        helm install nginx-ingress stable/nginx-ingress \
        --namespace ingress-basic \
        --set imageRegistry=harbor.sys.REPLACE_ME_DNS/public/nginx-ingress-controller \
        --set controller.service.annotations."service.beta.kubernetes.io/azure-load-balancer-internal"=true \
        -f ingress-controller.yml
        #Install nginx ingress resource
        kubectl create -f ingress-resource.yml
        #Check it
        kubectl get ingress
        kubectl describe ingress etg-ingress

    }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# END OF PKS SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# OTHERS
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    director_login(){
        eval "$(om -k bosh-env)"
        bosh -e director.REPLACE_ME_DNS alias-env azure
        bosh -e azure login
    }

    pks_uaa_login(){
        pks_uaa_pass=$(om -k credentials -p pivotal-container-service --credential-reference .properties.pks_uaa_management_admin_client -f secret)
        uaac target "${pks_api}":8443 --skip-ssl-validation
        uaac token client get admin -s "${pks_uaa_pass}"
    }

    bosh_uaa_login(){
        eval "$(om -k bosh-env)"
        echo "Logging into bosh uaa"
        uaac target "${BOSH_ENVIRONMENT}":8443

        uaa_admin_pass=$(om -k curl -p /api/v0/deployed/director/manifest -s | jq -e --raw-output '.instance_groups[].properties.uaa.admin.client_secret')
        uaac token client get admin -s "${uaa_admin_pass}"
    }

    cf_uaa_login(){
        eval "$(om -k bosh-env)"
        cf_uaa_user=$(om -k credentials -p cf -c .uaa.admin_client_credentials -t json | jq  -e --raw-output '.identity')
        cf_uaa_password=$(om -k credentials -p cf -c .uaa.admin_client_credentials -t json | jq  -e --raw-output '.password')
        echo "Logging into cf uaa"
        uaac target uaa.sys.REPLACE_ME_DNS --skip-ssl-validation
        uaac token client get "${cf_uaa_user}" -s "${cf_uaa_password}"
    }

    healthwatch_pcf_group(){
        cf_uaa_login
        uaac group map --name healthwatch.admin "REPLACE_ME"
    }

    cf_pcf_group(){
        cf_uaa_login
        uaac group map --name healthwatch.admin "REPLACE_ME"
    }

    bosh_pcf_group(){
        cf_uaa_login
        uaac group map --name healthwatch.admin "REPLACE_ME"
    }

    azure_login(){
        echo "Logging into Azure"
        az login
        pause
    }

    ssh_opsman(){
        ssh -i ~/.ssh/opsman.priv ubuntu@opsman.REPLACE_ME_DNS
    }

    cf_stuff(){
        cf login -a api.sys.REPLACE_ME_DNS --sso --skip-ssl-validation

    }

    # credhub(){
    #     ########################
    #     # Assign permissions
    #     ########################
    #     uaac target "${director_name}":8443
    #     #uaac target director.REPLACE_ME_DNS:8443 --skip-ssl-validation
    #     uaac token owner get login -s 
    #     credhub login -s "${director_name}":8844 --skip-tls-validation


    # }

    cf_create_user(){
        cf_login
        cf create-user 10073093@cloud.fiserv.net --origin azure
        cf set-org-role 10009555@cloud.fiserv.net ce-org OrgManager
    }

    credhub_write(){
        director_login
        credhub login
        credhub set -n /pcf-services -t value -v "services"
        credhub set -n /ldap_group_search_base_dn -t value -v "${ldap_group_search_base_dn}"
        credhub set -n /ldap_user_search_base_dn -t value -v "${ldap_user_search_base_dn}"
        credhub set -n /certs/default_ca -t certificate -c "$(cat ../opsman.tfstate | jq -e '.modules[0].outputs.ssl_cert.value')" -p "$(cat ../opsman.tfstate | jq -e '.modules[0].outputs.ssl_private_key.value')"
        credhub set -n /ldap_user -t user -z "${ldap_user_username}" -w "${ldap_user_password}"
        credhub set -n /ldap_host -t value -v "${ldap_host}"
        credhub set -n /system_domain -t value -v "${system_domain}"
        credhub set -n /ldap_admin_group_dn -t value -v "${ldap_admin_group_dn}"
        credhub set -n /ldap_bind_dn -t value -v "${ldap_bind_dn}"
        credhub set -n /certs/wildcard -t certificate -r ../ci/assets/template/certificates/REPLACE_ME_DNS-CA.cer -c ../ci/assets/template/certificates/REPLACE_ME_DNS.cer -p ../ci/assets/template/REPLACE_ME_DNS_nopass.key
    }

    info(){
        echo "Get BOSH creds from https://opsman.REPLACE_ME_DNS/api/v0/deployed/director/credentials/bosh_commandline_credentials"
        echo "Get UAA Creds from https://opsmanREPLACE_ME/api/v0/deployed/director/credentials/uaa_login_client_credentials"
        echo "Get Director Creds from https://opsman.REPLACE_ME_DNS/api/v0/deployed/director/credentials/director_credentials"
        echo "Get bosh Root CA on OpsMan from /var/tempest/workspaces/default/root_ca_certificate"
        echo "Take that cert, move to /usr/local/share/ca-certificates, and run sudo update-ca-certificates --fresh"
    }

    pause(){
        read -p "Press [Enter] key to continue..." fackEnterKey
    }

    download_all(){
        echo "Downloading PAS from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "cf*.pivotal" --pivnet-product-slug $pas_product_slug --product-version-regex $pas_version_regex --stemcell-iaas azure
        echo "Downloading Harbor from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $harbor_product_slug --product-version-regex $harbor_version_regex --stemcell-iaas azure
        echo "Downloading PKS from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $pks_product_slug --product-version-regex $pks_version_regex --stemcell-iaas azure
        echo "Downloading PASW from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $pasw_product_slug --product-version-regex $pasw_version_regex --stemcell-iaas azure
        echo "Downloading healthwatch from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $healthwatch_product_slug --product-version-regex $healthwatch_version_regex --stemcell-iaas azure
        echo "Downloading SSO from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $sso_product_slug --product-version-regex $sso_version_regex --stemcell-iaas azure
        echo "Downloading RabbitMQ from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $rabbitmq_product_slug --product-version-regex $sso_version_regex --stemcell-iaas azure
        echo "Downloading Splunk from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $splunk_product_slug --product-version-regex $splunk_version_regex --stemcell-iaas azure
        echo "Downloading Metrics from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $metrics_product_slug --product-version-regex $metrics_version_regex --stemcell-iaas azure
        echo "Downloading Azure Service Broker from Pivnet"
        om -k download-product --output-directory . --pivnet-api-token $pivnet_token --pivnet-file-glob "*.pivotal" --pivnet-product-slug $azure_sb_product_slug --product-version-regex $azure_sb_version_regex --stemcell-iaas azure
 
    }
    # upload_all(){
    #     echo "Uploading PAS to OpsMan"
    #     om -k upload-product -p "$pas_product_slug"-*.pivotal
    #     echo "Uploading Harbor to OpsMan"
    #     om -k upload-product -p "$harbor_product_slug"-*.pivotal
    #     echo "Uploading PKS Tile to OpsMan"
    #     om -k upload-product -p pivotal-container-service-*.pivotal
    #     echo "Uploading PASW to OpsMan"
    #     om -k upload-product -p "$pasw_product_slug"-*.pivotal
    #     echo "Uploading healthwatch Tile to OpsMan"
    #     om -k upload-product -p *health*.pivotal
    #     echo "Uploading SSO to OpsMan"
    #     om -k upload-product -p "$sso_product_slug"*.pivotal

    #     echo "Uploading Stemcells to OpsMan"
    #     om -k upload-stemcell -s *.tgz
    #     rm *.pivotal
    #     rm *.tgz
    # }
    stage_all(){
        echo "Staging PAS"
        om -k stage-product --product-name cf --product-version $(om tile-metadata --product-path "$pas_product_slug"-*.pivotal --product-version true)
        echo "Staging Harbor"
        om -k stage-product --product-name harbor-container-registry --product-version $(om tile-metadata --product-path "$harbor_product_slug"-*.pivotal --product-version true)
        echo "Staging PKS Tile"
        om -k stage-product --product-name pivotal-container-service --product-version $(om tile-metadata --product-path "$pks_product_slug"-*.pivotal --product-version true)
        echo "Staging PASW"
        om -k stage-product --product-name "$pasw_product_slug" --product-version $(om tile-metadata --product-path "$pasw_product_slug"-*.pivotal --product-version true)
        echo "Staging healthwatch Tile"
        om -k stage-product --product-name $healthwatch_product_slug --product-version $(om tile-metadata --product-path *health*.pivotal --product-version true)
        echo "Staging SSO"
        om -k stage-product --product-name "$sso_product_slug"  --product-version $(om tile-metadata --product-path "$sso_product_slug"*.pivotal --product-version true)
    }

    terraform_all(){
        echo "#########################"
        echo "## Terraforming OpsMan ##"
        echo "#########################"
        cd ../terraforming-opsman_only
        terraform init
        terraform apply -auto-approve
        echo "#########################"
        echo "## Terraforming Harbor ##"
        echo "#########################"
        cd ../terraforming-harbor
        terraform init
        terraform apply -auto-approve
        echo "######################"
        echo "## Terraforming PKS ##"
        echo "######################"
        cd ../terraforming-pks
        terraform init
        terraform apply -auto-approve
        echo "######################"
        echo "## Terraforming PAS ##"
        echo "######################"
        cd ../terraforming-pas_only
        terraform init
        terraform apply -auto-approve
        echo "##############################"
        echo "## Terraforming PAS-Windows ##"
        echo "##############################"
        cd ../terraforming-pasw
        terraform init
        terraform apply -auto-approve
        echo "##############################"
        echo "## Terraforming HealthWatch ##"
        echo "##############################"
        cd ../terraforming-healthwatch
        terraform init
        terraform apply -auto-approve
        echo "############################"
        echo "## Terraforming Concourse ##"
        echo "############################"
        cd ../terraforming-concourse
        terraform init
        terraform apply -auto-approve
        cd ../scripts
    }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# SHOW MENUS SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    show_pks_menu(){
        while true
        do
            pks_menu
            read_pks_options
        done
    }
    show_terrfaorm_menu() {
        while true
            do
                terraform_menu
                read_terraform_options
            done
    }
    show_om_menu() {
        while true
            do
                om_menu
                read_om_options
            done
    }
    show_bosh_menu() {
        while true
            do
                bosh_menu
                read_bosh_options
            done
    }
    show_main_menu() {
        while true
            do
                main_menu
                # read_options
            done
    }

trap '' SIGINT SIGQUIT SIGTSTP
show_main_menu
