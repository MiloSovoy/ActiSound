# For setting up after cloning from GitHub (getting theos links good)
rm ./theos
ln -s $THEOS ./theos
SUBPROJECTS=`cat Makefile | grep 'SUBPROJECTS' | sed -e 's/.*SUBPROJECTS += //'`
rm ./$SUBPROJECTS/theos
ln -s $THEOS ./$SUBPROJECTS/theos
