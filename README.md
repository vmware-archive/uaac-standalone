# uaac-standalone
Ruby Traveler Scripts For Creating a Standalone UAA CLI 3.1.0

You should only need to run these scripts if you want to recreate the package

The package is hosted here:

https://s3.amazonaws.com/ruby-traveler-packages/20150517-2.2.2/uaac-standalone-3.1.0-linux-x86_64.tar.gz

Simply run `rake package` to create the linux 64 packages

In the future if UAAC has a new gem with native extensions you will need to update 
the bundle-native-extensions, Rakefile scripts and upload the appropriate files to the S3 bucket
