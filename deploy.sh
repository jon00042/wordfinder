#!/bin/sh -x

cd `dirname $0`
cwd=`/bin/pwd`

cd /usr/local
rm -rf wordfinder
dancer -a wordfinder

cd $cwd
/bin/cp -p ./wordfinder.pm /usr/local/wordfinder/lib/.
/bin/cp -p ./dictionary /usr/local/wordfinder/lib/.

