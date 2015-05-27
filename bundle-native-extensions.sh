#!/bin/bash

set -e

RUBY_VERSION=$(cat Gemfile | sed -n 's/ruby "\(.*\)"/\1/p')
TRAVELING_RUBY_VERSION="20150517-$RUBY_VERSION"

DIR_ONLY=1

clean_vendor() {
	# Delete
	rm -rf packaging/vendor/*
}

package_all() {
	package '.*extensions.*eventmachine.*' eventmachine-1.0.6
	package '.*extensions.*http_parser.*' http_parser.rb-0.6.0	
}

package() {
	echo "Packaging $1 $2"
	filter=$1
	extension=$2

	cd packaging/vendor/ruby/
	find . -regex $filter -type f -exec tar -rvf ../../traveling-ruby-$TRAVELING_RUBY_VERSION-linux-x86_64-$extension.tar.gz {} \;
	cd -
}

build_osx () {
	clean_vendor

	rake package:bundle_install KEEP_EXT=1
	package_all

	clean_vendor
}

build_linux() {
	clean_vendor

	docker run \
		-v $(pwd)/packaging/:/root/packaging \
		-w /root/packaging \
		ruby:$RUBY_VERSION \
		bundle install --path /root/packaging/vendor --without development


	package_all

	clean_vendor
}

build_linux