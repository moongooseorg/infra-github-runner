# infra-github-runner

### Install the runner
To setup the github runner, run this from your development machine

```bash
./install-runner.sh <runner-ip>
```
You will need to go to your org or repo and add a runner there to fetch the details needed.


### registering each host
Each pi will need to allow the runner to deploy docker images.  Perform this on the development machine

```bash
./register-ssh.sh <target-ip> <target-ip> ...
```