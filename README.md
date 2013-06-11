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

### Default EC2 security group

You'll want to make sure that your default security group has SSH turned on.

## Usage

To kick things off, run:

    $ bin/bootstrap

This will launch and bootstrap a server for you and then spit out the ssh
command to run that'll attach you to that configured server.

### Watching the progress

If you're interested in more than just dots, try tailing the bootlog:

    $ tail -f bootlog.log

### Using the existing image

If you just want to use an exisiting image, run this:

    $ bin/pairup
