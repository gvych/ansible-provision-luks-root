#!/bin/bash
echo 123456
exit

. encrypted-passwords.txt
for PASS in ${ENC_PASSWORDS[@]}
do
  ssh-keygen -lf ~/.ssh/id_rsa.pub | awk 'NR==1{print $2}'
  echo $PASS | base64 -d  | openssl rsautl -decrypt -oaep -inkey ~/.ssh/id_rsa |
  if [[ "$?" -eq 0 ]]; then exit; fi
done

