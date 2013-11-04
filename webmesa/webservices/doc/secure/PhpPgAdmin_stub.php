<?php 
    include "../common_functions.inc";
    logDbAdmin();

    // redirect to the given URL.
    // Be sure that the alias is set up in apache.conf which resolves this URL
    header("Location: ./ris_mall/phppgadmin");
    exit;
?>
