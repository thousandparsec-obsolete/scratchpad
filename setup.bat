
python ez_setup.py

cd ..

rem Update everything
IF NOT EXIST libtpproto-py GOTO SKIP_UPDATE_TPPROTO
cd libtpproto-py
darcs pull -a
cd ..
:SKIP_UPDATE_TPPROTO

IF NOT EXIST libtpclient-py GOTO SKIP_UPDATE_TPCLIENT
cd libtpclient-py
darcs pull -a
cd ..
:SKIP_UPDATE_TPCLIENT

rem Setup the Python Server for inplace operation
IF NOT EXIST tpserver-py GOTO SKIP_SERVER
cd tpserver-py
darcs pull -a
cd ..
:SKIP_SERVER

rem Setup the tpclient-pywx for inplace operation
cd tpclient-pywx
darcs pull -a

IF NOT EXIST tp GOTO SKIP_DELETE
DEL /S /Q /F tp
:SKIP_DELETE

mkdir tp
cd tp
echo # > __init__.py
IF NOT EXIST ..\..\libtpproto-py GOTO ERROR
mkdir netlib
xcopy /S ..\..\libtpproto-py\tp\netlib netlib

IF NOT EXIST ..\..\libtpclient-py GOTO ERROR
mkdir client
xcopy /S ..\..\libtpclient-py\tp\client client
cd ..
cd ..

rem Update everything
IF NOT EXIST libtpclient-py-dev GOTO SKIP_UPDATE_TPCLIENT_DEV
cd libtpclient-py-dev
darcs pull -a
cd ..
:SKIP_UPDATE_TPCLIENT_DEV

rem Setup the tpclient-pywx for inplace operation
cd tpclient-pywx-dev
darcs pull -a

IF NOT EXIST tp GOTO SKIP_DELETE
DEL /S /Q /F tp
:SKIP_DELETE

mkdir tp
cd tp
echo # > __init__.py
IF NOT EXIST ..\..\libtpproto-py GOTO ERROR
mkdir netlib
xcopy /S ..\..\libtpproto-py\tp\netlib netlib

IF NOT EXIST ..\..\libtpclient-py-dev GOTO ERROR
mkdir client
xcopy /S ..\..\libtpclient-py-dev\tp\client client
cd ..
cd ..

exit

:ERROR
echo "Could not find the correct files."
pause
