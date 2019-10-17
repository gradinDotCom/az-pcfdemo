#!/bin/bash

set -eu

POLL_INTERVAL=30

function apply-changes() {
echo "Applying changes on Ops Manager @ ${OPSMAN_DOMAIN_OR_IP_ADDRESS}"
{
om -k \
  apply-changes \
  --ignore-warnings && send_dat_email "COMPLETED"
} || {
  send_dat_email "FAILED"
}

}

function send_dat_email() {
status="${1}"
echo "Status detected ${status}"
TIME=$(date +%T)
cat > email/headers.txt <<EOH
MIME-version: 1.0
Content-Type: text/html; charset="UTF-8"
EOH

#Begin the Email Body
cat > email/body.html <<EOH
<html>
<style>
table, th, td {
    border: 1px solid black;
}
</style>
<body>
<p>
<pre>
EOH

  apply_last_state=$(om -k \
    installations|head -4|tail -1)

echo "Here is the state $apply_last_state"

printf "<h2><font face=Arial>Apply change result:</font></h2>$apply_last_state" \
>> email/body.html

printf "</table></body></html>" >> email/body.html

printf "${ENV} ${status} Last Apply"> email/subject.txt
}
export OM_TARGET="https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}"
export OM_CLIENT_ID="${OPSMAN_CLIENT_ID}"
export OM_CLIENT_SECRET="${OPSMAN_PASSWORD}"
apply-changes