#!/usr/local/bin/perl -w

# General evaluation package for MESA scripts.

use Env;

package mesa_evaluate;

require "mesa_get.pm";
require "mesa_dicom_eval.pm";
require "mesa_dicom_eval_support.pm";
require "mesa_xml_eval.pm";
require "mesa_eval_output.pm";

1;

