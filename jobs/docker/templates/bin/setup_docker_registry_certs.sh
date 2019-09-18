#!/bin/bash -e

# Multiple certs in 'docker_registry_certs' are separated with this delimiter
delimiter=*#*#*#*#*#*#*#*#*#*#*#*#*#*#

trim() {
     echo "$(echo -e "$1" | sed '/^[[:space:]]*$/d')"
}

process_cert() {
    domain_name="$(echo "$1" | sed -n '1p')"
    certificate="$(echo "$1" | sed -n '1!p')"

    dir_path="/etc/docker/certs.d/${domain_name}"
    mkdir -p "${dir_path}" && touch "${dir_path}/ca.crt"
    echo "$certificate" > "${dir_path}/ca.crt"
}

CERTS_PATH=/var/vcap/jobs/docker/config/docker_registry_certs
certs=$(<${CERTS_PATH})

certs_arr=()
while [[ $certs ]]; do
    cert="${certs%%"$delimiter"*}"
    certs="${certs#*"$delimiter"}"

    cert="$(trim "${cert}")"
    process_cert "${cert}"
done

