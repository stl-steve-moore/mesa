#!/usr/local/bin/perl -w

# Self test script for Modality 201 test.

use Env;
use lib "scripts";
require mod;

sub self_test_1591 {
  mod::store_images_secure("T1591", "", "MESA_MODALITY",
		    "MESA_IMG_MGR", "localhost", "2350",
		    "randoms.dat", "test_sys_1.key.pem", "test_sys_1.cert.pem", "mesa_list.cert", "NULL-SHA");

  mod::send_mpps_secure("T1591", "MESA_MODALITY", "MESA_IMG_MGR", "localhost", "2350",
		    "randoms.dat", "test_sys_1.key.pem", "test_sys_1.cert.pem", "mesa_list.cert", "NULL-SHA");

  mod::send_storage_commit_secure("T1591", "MESA", "localhost", "2350", "2400",
		    "randoms.dat", "test_sys_1.key.pem", "test_sys_1.cert.pem", "mesa_list.cert", "NULL-SHA");
}

`perl scripts/reset_servers_secure.pl`;

self_test_1591;
