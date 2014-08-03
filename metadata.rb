depends 'aws'

maintainer       "ThachChau"
maintainer_email "rog.kane@gmail.com"
license          "MIT"
description      "Cookbook for MingleAPI"

name   'mingle-chef'
recipe 'mingle-chef::deploy',  'Copying application credentials'
