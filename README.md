# ec2boot

## Install

### Clone the repo

    $ git clone git://github.com/jgdavey/ec2boot.git

### Install Gems

    $ bundle

Note: RVM users may need to install a Ruby version.

### EC2 Key Pair

Sign in to the AWS console and create a new Key Pair called `fog_default`, then
download it and move it here:

    ~/.ec2/fog_default.pem

DON'T FORGET: you also have to chmod this file:

    $ chmod 600 ~/.ec2/fog_default.pem

### Fog config

You'll need to setup a ~/.fog credentials file - we're using the default group,
so something like this works:

    :default:
      :aws_access_key_id: [KEY_ID]
      :aws_secret_access_key: [ACCESS_KEY]

## Usage

1. Create a config.yml in the project directory
2. Run the generator

        bin/generate > user-data.sh

3. Use the generated file to launch and ec2 instance

        ec2-run-instances --key $EC2_KEY -t m1.small -f user-data.sh <IMAGE>

4. Once the instance is ready, run the workspace script for the "dev" user (or whatever username you used).

        ssh dev@really-long-ec2-hostname-12-123-123-413.amazonaws.com 'bash -s' < workspace.sh

Before step 4, you can optionally watch progress. It usually takes 5-10
minutes for the instance to boot and the script to complete. The last
line of the file will read "DONE" when the script is complete.

    ssh -i ~/.ec2/$EC2_KEY.pem ubuntu@really-long-ip.amazonaws.com 'tail -f /var/log/bootstrap_out.log'

Note: replace the argument to `-i` with the path to your ec2 pem file.
