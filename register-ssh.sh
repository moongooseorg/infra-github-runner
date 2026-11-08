#!/usr/bin/env bash
set -e

if [ ! -f ~/.ssh/runner ]; then
  ssh-keygen -t ed25519 -f ~/.ssh/runner -N ""
fi

KEYS=$(cat ~/.ssh/runner.pub)
if [ -f ~/.ssh/deploy_key.pub ]; then
  KEYS="$KEYS
$(cat ~/.ssh/deploy_key.pub)"
fi

for ip in "$@"; do
  TMP=$(ssh "pi@$ip" 'f=$(mktemp) && cat > "$f" && echo "$f"' <<< "$KEYS")
  ssh -t "pi@$ip" "
    sudo install -d -m 700 -o runner -g runner /home/runner/.ssh &&
    sudo install -m 600 -o runner -g runner '$TMP' /home/runner/.ssh/authorized_keys;
    rc=\$?; rm -f '$TMP'; exit \$rc
  "
  grep -qs "^Host $ip\$" ~/.ssh/config || printf '\nHost %s\n  User runner\n  IdentityFile ~/.ssh/runner\n' "$ip" >> ~/.ssh/config
  ssh-keyscan -H "$ip" >> ~/.ssh/known_hosts
  docker context inspect "$ip" >/dev/null 2>&1 || docker context create "$ip" --docker "host=ssh://$ip"
done
