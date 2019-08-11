#!/bin/bash

shared_password=$( echo 123456 )


echo $shared_password
exit


generate-new-password() {
 
  INTERMEDIARYKEY=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo )
  rm vault.key.enc
  #echo $INTERMEDIARYKEY | ./sshcrypt agent-encrypt > vault.key.enc #reinit database with everybodies signatures

  mkdir -p engineers_encrypted_passwords/
  while read -r ; do  #encrypt new randomkey for each engineer with his public SSH key, so he can access it 
    fingerprint=$(ssh-keygen -E md5 -lf <(echo $REPLY) | tr ' ()' '___')
    echo $INTERMEDIARYKEY | openssl rsautl -encrypt -oaep -pubin -inkey <(ssh-keygen -e -f <(echo $REPLY) -m PKCS8) | base64 > engineers_encrypted_passwords/$fingerprint
  done < engineers_ssh_keys
  unset INTERMEDIARYKEY

  add-yourself-into-signatures
}

add-yourself-into-signatures() {
  fingerprint=$(ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub | tr ' ()' '___')
  KEY=$(< engineers_encrypted_passwords/$fingerprint openssl rsautl -decrypt -oaep -inkey ~/.ssh/id_rsa )
  echo $KEY | ./sshcrypt agent-encrypt >> vault.key.enc 
}


try-to-open-with-your-signature() {
 sshcrypt agent-decrypt < vault.key.enc || add-yourself-into-signatures
}

main func:
1. check if sshcrypt agent can work
2. if cant access - get your personal enc by ssh-key
3. enc personal key using sshcrypt agent
4. append common list of sshcrypt encs with your

gen new keys:
1.   gen random passphrase
1.1. save random passphrase encrypted with agent-encrypt
1.2. decrypt random passphrase into variable
2.   for each SSH pub key generate personal enc by ssh-keys
3.   store in common store of ssh-keys encs 
4.   go to main func for yourself



#declare -A encrypted_password
#shared_password=$(<
while read -r ; do
  echo "$enc_pass" > engineers_encrypted_passwords/$fingerprint
  #fingerprint=$(ssh-keygen -lf $REPLY | awk 'NR==1{print $2}')
  #encrypted_password["test"]=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo)
  #encrypted_password["$fingeprint"]=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo)
< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo | ./sshcrypt agent-encrypt > vault.key.enc

#generate first use with ssh-add password entering for adding youself into vault.key.env
function add_myself_into_vault.key.enc_using_my_private_key()
   base64 -d < vault.key.orig | openssl rsautl -decrypt -oaep -inkey ~/.ssh/id_rsa |

. encrypted-passwords.txt
for PASS in ${ENC_PASSWORDS[@]}
do
  ssh-keygen -lf ~/.ssh/id_rsa.pub | awk 'NR==1{print $2}'
  echo $PASS | base64 -d  | openssl rsautl -decrypt -oaep -inkey ~/.ssh/id_rsa |
  if [[ "$?" -eq 0 ]]; then exit; fi
done
