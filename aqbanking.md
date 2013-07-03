# AqBanking CLI Setup Steps

Please note that the below steps might be different for you, depending on your financial institute. Also note that this might not work for you due to issues with aqbanking, or with your financial institute.

## Basic Steps

I'm assuming that you're using a Pin/ Tan security mechanism:

First, install aqbanking using homebrew:

    $ brew install aqbanking

Now add your user. This is important because aqbanking uses users to fetch account and transaction informations.

    $ aqhbci-tool4 adduser -t pintan --context=1 -b <blz> -u <userid> -s <server> -N "<Name>" --hbciversion=300

According to the aqbanking readme the userid might be different to your account number. Check with your financial institute to make sure.

If the above command succeeded you should see at least one user account if you execute:

    $ aqhbci-tool4 listusers

Now, fetch all available accounts. You'll be prompted for your pin.

    $ aqhbci-tool4 getaccounts

Last, aqbanking should list your accounts:

    $ aqhbci-tool4 listaccounts

That's it! The basic setup succeeded!