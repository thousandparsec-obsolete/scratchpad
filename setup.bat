
python ez_setup.py

cd ..

rem Update everything
IF NOT EXIST libtpproto-py GOTO SKIP_UPDATE_TPPROTO
cd libtpproto-py
git pull --verbose origin
python setup.py develop
cd ..
:SKIP_UPDATE_TPPROTO

IF NOT EXIST libtpclient-py GOTO SKIP_UPDATE_TPCLIENT
cd libtpclient-py
git pull origin
python setup.py develop
cd ..
:SKIP_UPDATE_TPCLIENT

rem Setup the Python Server for inplace operation
IF NOT EXIST tpserver-py GOTO SKIP_SERVER
cd tpserver-py
git pull origin
cd ..
:SKIP_SERVER

rem Setup the tpclient-pywx for inplace operation
cd tpclient-pywx
git pull origin

IF NOT EXIST tp GOTO SKIP_DELETE
DEL /S /Q /F tp
:SKIP_DELETE

cd ..


rem We no longer need to do the song and dance as ez_setup finally works properly!

pause

exit

:ERROR
echo "Could not find the correct files."
pause
