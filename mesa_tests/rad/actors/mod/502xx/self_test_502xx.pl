#!/usr/local/bin/perl -w

# Self test script for Modality 201 test.

use Env;
use lib "scripts";
require mod;

sub goodbye {
  die "Exiting modality self test script\n";
}

sub self_test_50202 {
  mesa::store_images("T50202", "", "MESA_MODALITY",
		"MESA_IMG_MGR", "localhost", "2350", 1);

  mod::send_mpps("T50202", "MESA_MODALITY", "MESA_IMG_MGR", "localhost", "2350");

  mod::send_storage_commit("T50202", "MESA", "localhost", "2350", "2400");
}


sub self_test_213 {
  mesa::store_images("T213_8a", "", "MESA_MODALITY",
		    "MESA_IMG_MGR", "localhost", "2350", 1);
  mod::send_mpps("T213_8a", "MESA_MODALITY", "MESA_IMG_MGR", "localhost","2350");

  mesa::store_images("T213_8b", "", "MESA_MODALITY",
		    "MESA_IMG_MGR", "localhost", "2350", 1);
  mod::send_mpps("T213_8b", "MESA_MODALITY", "MESA_IMG_MGR", "localhost","2350");
}

sub self_test_214 {
  mesa::store_images("T214_4a", "", "MESA_MODALITY",
		    "MESA_IMG_MGR", "localhost", "2350", 1);
  mod::send_mpps("T214_4a", "MESA_MODALITY", "MESA_IMG_MGR", "localhost","2350");

  mesa::store_images("T214_4b", "", "MESA_MODALITY",
		    "MESA_IMG_MGR", "localhost", "2350", 1);
  mod::send_mpps("T214_4b", "MESA_MODALITY", "MESA_IMG_MGR", "localhost","2350");
}

sub self_test_50215 {
  mesa::store_images("T50215", "", "MESA_MODALITY",
		    "MESA_IMG_MGR", "localhost", "2350", 1);
  mod::send_mpps("T50215", "MESA_MODALITY", "MESA_IMG_MGR", "localhost","2350");
}

sub self_test_218 {
  mesa::store_images("T218", "", "MESA_MODALITY",
		"MESA_IMG_MGR", "localhost", "2350", 1);

  mod::send_mpps("T218", "MESA_MODALITY", "MESA_IMG_MGR", "localhost", "2350");
}

sub self_test_221 {
  mesa::store_images("T221", "", "MESA_MODALITY",
		    "MESA_IMG_MGR", "localhost", "2350", 1);
  mod::send_mpps("T221", "MESA_MODALITY", "MESA_IMG_MGR", "localhost","2350");
}

sub self_test_222 {
  mesa::store_images("T222", "", "MESA_MODALITY",
		    "MESA_IMG_MGR", "localhost", "2350", 1);
  mod::send_mpps("T222", "MESA_MODALITY", "MESA_IMG_MGR", "localhost","2350");
}

sub self_test_231 {
  mesa::store_images("T231_orig", "", "MESA_MODALITY",
		    "MESA_IMG_MGR", "localhost", "2350", 1);
  mod::send_mpps("T231_orig", "MESA_MODALITY", "MESA_IMG_MGR", "localhost","2350");

  mesa::store_images("T231_append", "", "MESA_MODALITY",
		    "MESA_IMG_MGR", "localhost", "2350", 1);
  mod::send_mpps("T231_append", "MESA_MODALITY", "MESA_IMG_MGR", "localhost","2350");
}

sub self_test_241 {
  mesa::store_images("T241", "", "MESA_MODALITY",
		    "MESA_IMG_MGR", "localhost", "2350", 1);
  mod::send_mpps("T241", "MESA_MODALITY", "MESA_IMG_MGR", "localhost","2350");
}

sub self_test_242 {
  mod::send_mpps("T242", "MESA_MODALITY", "MESA_IMG_MGR", "localhost","2350");
}

`perl scripts/reset_servers.pl`;

if (scalar(@ARGV) == 0) {
 self_test_50202;
# self_test_213;
# self_test_214;
 self_test_50215;
# self_test_218;
# self_test_221;
# self_test_222;
# self_test_231;
# self_test_241;
# self_test_242;
} else {
 self_test_50202 if ($ARGV[0] eq "50202");
# self_test_213 if ($ARGV[0] eq "213");
# self_test_214 if ($ARGV[0] eq "214");
 self_test_50215 if ($ARGV[0] eq "50215");
# self_test_218 if ($ARGV[0] eq "218");
# self_test_221 if ($ARGV[0] eq "221");
# self_test_222 if ($ARGV[0] eq "221");
# self_test_231 if ($ARGV[0] eq "231");
# self_test_241 if ($ARGV[0] eq "241");
# self_test_242 if ($ARGV[0] eq "242");

}
