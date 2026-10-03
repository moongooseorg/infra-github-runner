# infra-github-runner

### Install the runner
To setup the github runner, run this from your development machine

```bash
./install-runner.sh <runner-ip>
```

### registering each host
Each pi will need to allow the runner to deploy docker images.  Perform this on the development machine

```bash
./register-ssh.sh <target-ip> <target-ip> ...
```