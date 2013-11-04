#!/usr/local/bin/perl -w

# Self test script for Modality 1xx tests.

use Env;
use lib "scripts";
require mod;

sub self_test_106 {
  mod::store_images("T106", "", "MESA_MODALITY",
		    "MESA_IMG_MGR", "localhost", "2350");
  mod::send_mpps("T106", "MESA_MODALITY", "MESA_IMG_MGR", "localhost","2350");

  mod::store_images("T106_gsps_x6", "", "MESA_MODALITY",
		    "MESA_IMG_MGR", "localhost", "2350");
  mod::send_mpps("T106_gsps_x6", "MESA_MODALITY", "MESA_IMG_MGR", "localhost","2350");

  mod::store_images("T106_gsps_x7", "", "MESA_MODALITY",
		    "MESA_IMG_MGR", "localhost", "2350");
  mod::send_mpps("T106_gsps_x7", "MESA_MODALITY", "MESA_IMG_MGR", "localhost","2350");
}


`perl scripts/reset_servers.pl`;

self_test_106;

