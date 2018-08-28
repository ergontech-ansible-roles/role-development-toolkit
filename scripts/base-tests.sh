#!/bin/bash
set -e

# A script to run a set of basic tests with ansible
# ------
# Tests
#
# 1. Syntax check
# 2. Playbook runs
# 3. Playbook is idempotent

# Args
container_id=
playbook="test.yml"
path_to_playbook="/etc/ansible/roles/test-role/tests"

usage()
{
    printf "usage:
     --container-id   -id    docker container id
     --playbook       -b     playbook to run (default: test.yml)
     --path           -p     path-to-playbook (default: /etc/ansible/roles/test-role/tests) \n"
}

while [ "$1" != "" ]; do
    case $1 in
        -id | --container-id )  shift
                                container_id=$1
                                ;;
        -b | --playbook )       shift
                                playbook=$1
                                ;;
        -p | --path )           shift
                                path_to_playbook=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done



## Constants
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

# Install requirements if `requirements.yml` is present.
printf ${green}"Checking for dependencies."${neutral}
depFile=${path_to_playbook}/requirements.yml
echo ${path_to_playbook}
ls -la ${path_to_playbook}
if [ -f $depFile ]; then
  printf ${green}"Requirements file detected; installing dependencies."${neutral}"\n"
  docker exec --tty $container_id env TERM=xterm ansible-galaxy install -r $depFile
fi

# Test Ansible syntax.
printf ${green}"Checking Ansible playbook syntax."${neutral}
docker exec --tty $container_id ansible-playbook ${path_to_playbook}/${playbook} --syntax-check

printf "\n"

# Run Ansible playbook.
printf ${green}"Running command: docker exec $container_id ansible-playbook ${path_to_playbook}/${playbook}"${neutral}
docker exec $container_id env ANSIBLE_FORCE_COLOR=1 ansible-playbook ${path_to_playbook}/${playbook}

# Run Ansible playbook again (idempotence test).
printf ${green}"Running playbook again: idempotence test"${neutral}
idempotence=$(mktemp)
docker exec $container_id ansible-playbook ${path_to_playbook}/${playbook}|  tee -a $idempotence
tail $idempotence \
    | grep -q 'changed=0.*failed=0' \
    && (printf ${green}'Idempotence test: pass'${neutral}"\n") \
    || (printf ${red}'Idempotence test: fail'${neutral}"\n" && exit 1)
