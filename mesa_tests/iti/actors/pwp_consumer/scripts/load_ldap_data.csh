#!/bin/csh

ldapadd -a -D "cn=Manager,dc=ihe,dc=net" -f ../pwp_directory/data/PWPRecords.ldif -W -x

