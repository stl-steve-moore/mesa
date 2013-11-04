#!/bin/csh

date
(time make install) >& install.out
echo install done
(time make install_secure) >& install_secure.out
echo install secure done
cd mesa_tests
(time make install) >& ../install_mesa_tests.out
cd ..
pushd /opt/mesa
strip bin/*
popd
tail -5 install.out
tail -5 install_secure.out
tail -5 install_mesa_tests.out
date
