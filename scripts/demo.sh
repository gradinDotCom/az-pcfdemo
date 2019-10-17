
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
        om -k configure-saml-authentication --decryption-passphrase "${decrypt_password}" --saml-idp-metadata https://login.microsoftonline.com/REPLACE_ME/federationmetadata/2007-06/federationmetadata.xml?appid=3c01e1d9-fecd-4e47-b85b-d2d895963280 --saml-bosh-idp-metadata \https://login.microsoftonline.com/REPLACE_ME/federationmetadata/2007-06/federationmetadata.xml?appid=3c01e1d9-fecd-4e47-b85b-d2d895963280 --saml-rbac-admin-group REPLACE_ME --saml-rbac-groups-attribute \http://schemas.microsoft.com/ws/2008/06/identity/claims/groups

        ##############################
        # Create UAA User for om
        # gem install cf-uaac
        ##############################
        echo "Creating local om-admin user"
        uaac target $opsman_url/uaa/ --skip-ssl-validation
        echo "You will need to access https://opsman.turtleisland.net/uaa/passcode for your passcode"
        echo "Client ID:  opsman"
        pause
        uaac token sso get
        uaac client add om-admin --authorized_grant_types client_credentials --authorities opsman.admin --secret $password

        #Setting new SSL
        om -k update-ssl-certificate --private-key-pem "$(jq -e --raw-output '.modules[0].outputs.ssl_private_key.value' ../opsman.tfstate)" --certificate-pem "$(jq -e --raw-output '.modules[0].outputs.ssl_cert.value' ../opsman.tfstate)"

        pause
    }

    download_harbor(){
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
    }

    config_harbor(){
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
    download_rabbitmq(){
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
    }

    config_rabbitmq(){
        ##############################
        # Configure rabbitmq
        ##############################
        echo "Configuring rabbitmq"
        om -k configure-product -c ../ci/assets/template/rabbitmq-config.yml
    }

    download_metrics(){
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
    }

    config_metrics(){
        ##############################
        # Configure metrics
        ##############################
        echo "Configuring Metrics"
        om -k configure-product -c ../ci/assets/template/metrics-config.yml
    }

    download_splunk(){
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
    }
    config_splunk(){
        ##############################
        # Configure splunk
        ##############################
        echo "Configuring splunk"
        om -k configure-product -c ../ci/assets/template/splunk-config.yml

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