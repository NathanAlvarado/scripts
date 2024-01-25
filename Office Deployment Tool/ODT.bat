ECHO OFF
MODE CON: cols=90 lines=20
CLS

:: File Checks
IF EXIST .\setup.exe GOTO MAINMENU
ECHO Please download the Office Deployment Tool and extract the contents to this folder.
ECHO Opening Webpage...
START "" https://www.microsoft.com/en-us/download/details.aspx?id=49117
PAUSE >NUL
GOTO EOF

:: MAIN Menu
:MAINMENU
SET "MAINMENU-SELECTION=666"
CLS
ECHO.
ECHO              ..................................................
ECHO                           Office Deployment Tool
ECHO              ..................................................
ECHO.
ECHO                        Step 1 - Create XML File
ECHO                        Step 2 - Download
ECHO                        Step 3 - Install
ECHO                             0 - EXIT
ECHO.

SET /P MAINMENU-SELECTION=Select an option then press ENTER:
IF %MAINMENU-SELECTION%==1 GOTO STEP1
IF %MAINMENU-SELECTION%==2 GOTO STEP2
IF %MAINMENU-SELECTION%==3 GOTO STEP3
IF %MAINMENU-SELECTION%==0 GOTO EOF
GOTO MAINMENU

:: 32bit or 64bit
:STEP1
SET "STEP1-SELECTION=666"
CLS
ECHO.
ECHO              ..................................................
ECHO                     Select 32 bit or 64 bit install
ECHO              ..................................................
ECHO.
ECHO                        1 - 32 bit
ECHO                        2 - 64 bit
ECHO                        0 - EXIT
ECHO.

SET /P STEP1-SELECTION=Select an option then press ENTER:
IF %STEP1-SELECTION%==1 GOTO 32BIT
IF %STEP1-SELECTION%==2 GOTO 64BIT
GOTO STEP1

:32BIT
SET OFFICE-INSTALL-BIT=32
GOTO PRODUCTMENU

:64BIT
SET OFFICE-INSTALL-BIT=64
GOTO PRODUCTMENU

::Product Menu
:PRODUCTMENU
SET "PRODUCTMENU-SELECTION=666"
CLS
ECHO.
ECHO              ..................................................
ECHO                              Select Version
ECHO              ..................................................
ECHO.
ECHO                        1 - Office 365 Business (Standard)
ECHO                        2 - Office 365 ProPlus (E3, E5, Premium)
ECHO                        3 - Office 2021 Standard (Volume)
ECHO                        4 - Office 2021 Standard (Home and Business)
ECHO                        5 - Office 2021 ProPlus (Volume)
ECHO                        6 - Office 2021 ProPlus (Retail)
ECHO                        7 - Project 2021 Standard (Volume)
ECHO                        8 - Visio 2021 Standard (Volume)
ECHO                        9 - Manual Entry
ECHO                        0 - EXIT
ECHO.

SET /P PRODUCTMENU-SELECTION=Select an option then press ENTER:
IF %PRODUCTMENU-SELECTION%==1 GOTO O365BusinessRetail
IF %PRODUCTMENU-SELECTION%==2 GOTO O365ProPlusRetail
IF %PRODUCTMENU-SELECTION%==3 GOTO Standard2021Volume
IF %PRODUCTMENU-SELECTION%==4 GOTO HomeBusiness2021Retail
IF %PRODUCTMENU-SELECTION%==5 GOTO ProPlus2021Volume
IF %PRODUCTMENU-SELECTION%==6 GOTO ProPlus2021Retail
IF %PRODUCTMENU-SELECTION%==7 GOTO ProjectStd2021Volume
IF %PRODUCTMENU-SELECTION%==8 GOTO VisioStd2021Volume
IF %PRODUCTMENU-SELECTION%==9 GOTO ManualEntry
IF %PRODUCTMENU-SELECTION%==0 GOTO EOF
GOTO PRODUCTMENU

:O365BusinessRetail
SET OFFICE-INSTALL-VERSION=O365BusinessRetail
GOTO BUILDXML
:O365ProPlusRetail
SET OFFICE-INSTALL-VERSION=O365ProPlusRetail
GOTO BUILDXML
:Standard2021Volume
SET OFFICE-INSTALL-VERSION=Standard2021Volume
GOTO BUILDXML
:HomeBusiness2021Retail
SET OFFICE-INSTALL-VERSION=HomeBusiness2021Retail
GOTO BUILDXML
:ProPlus2021Volume
SET OFFICE-INSTALL-VERSION=ProPlus2021Volume
GOTO BUILDXML
:ProPlus2021Retail
SET OFFICE-INSTALL-VERSION=ProPlus2021Retail
GOTO BUILDXML
:ProjectStd2021Volume
SET OFFICE-INSTALL-VERSION=ProjectStd2021Volume
GOTO BUILDXML
:VisioStd2021Volume
SET OFFICE-INSTALL-VERSION=VisioStd2021Volume
GOTO BUILDXML
:ManualEntry
ECHO .........................................................................................
ECHO                                 Supported Products
ECHO .........................................................................................
ECHO O365BusinessRetail      O365ProPlusRetail       O365ProPlusEEANoTeamsRetail  O365BusinessEEANoTeamsRetail
ECHO AccessRetail            Access2019Retail        Access2021Retail             Access2019Volume
ECHO Access2021Volume        ExcelRetail             Excel2019Retail              Excel2021Retail
ECHO Excel2019Volume         Excel2021Volume         HomeBusinessRetail           HomeBusiness2019Retail
ECHO HomeBusiness2021Retail  HomeStudentRetail       HomeStudent2019Retail        HomeStudent2021Retail
ECHO O365HomePremRetail      OneNoteFreeRetail       OneNoteRetail                OneNote2021Volume
ECHO OutlookRetail           Outlook2019Retail       Outlook2021Retail            Outlook2019Volume
ECHO Outlook2021Volume       Personal2019Retail      Personal2021Retail           PowerPointRetail
ECHO PowerPoint2019Retail    PowerPoint2021Retail    PowerPoint2019Volume         PowerPoint2021Volume
ECHO ProfessionalRetail      Professional2019Retail  Professional2021Retail       ProjectProXVolume
ECHO ProjectPro2019Retail    ProjectPro2021Retail    ProjectPro2019Volume         ProjectPro2021Volume
ECHO ProjectStdRetail        ProjectStdXVolume       ProjectStd2019Retail         ProjectStd2021Retail
ECHO ProjectStd2019Volume    ProjectStd2021Volume    ProPlus2019Volume            ProPlus2021Volume
ECHO ProPlusSPLA2021Volume   ProPlus2019Retail       ProPlus2021Retail            PublisherRetail
ECHO Publisher2019Retail     Publisher2021Retail     Publisher2019Volume          Publisher2021Volume
ECHO Standard2019Volume      Standard2021Volume      StandardSPLA2021Volume       VisioProXVolume
ECHO VisioPro2019Retail      VisioPro2021Retail      VisioPro2019Volume           VisioPro2021Volume
ECHO VisioStdRetail          VisioStdXVolume         VisioStd2019Retail           VisioStd2021Retail
ECHO VisioStd2019Volume      VisioStd2021Volume      WordRetail                   Word2019Retail
ECHO Word2021Retail          Word2019Volume          Word2021Volume
ECHO.



SET /p OFFICE-INSTALL-VERSION="Type a listed product: "
GOTO BUILDXML

:: Build XML File
:BUILDXML
IF EXIST .\config.xml DEL .\config.xml
CLS
SET \t=   
(
ECHO.^<Configuration^>
ECHO.%\t%^<Add OfficeClientEdition="%OFFICE-INSTALL-BIT%"^>
ECHO.%\t%%\t%^<Product ID="%OFFICE-INSTALL-VERSION%"^>
ECHO.%\t%%\t%%\t%^<Language ID="en-us" /^>
ECHO.%\t%%\t%^</Product^>
ECHO.%\t%^</Add^>
ECHO.^</Configuration^>
)>>.\config.xml

:BUILDXMLMENU
SET "XML-SELECTION=666"
CLS
ECHO %OFFICE-INSTALL-BIT%bit %OFFICE-INSTALL-VERSION% XML Created, ready to download/install
ECHO.
ECHO                        1 - Download
ECHO                        2 - Main Menu
ECHO                        0 - EXIT
ECHO.
SET /P XML-SELECTION=Select an option then press ENTER:
IF %XML-SELECTION%==1 GOTO STEP2
IF %XML-SELECTION%==2 GOTO MAINMENU
IF %XML-SELECTION%==0 GOTO EOF
GOTO BUILDXMLMENU

:STEP2
SET "STEP2-SELECTION=666"
CLS
ECHO Downloading %OFFICE-INSTALL-VERSION% %OFFICE-INSTALL-BIT%bit please wait...
.\setup.exe /download config.xml
ECHO Download complete!
ECHO.
ECHO                        1 - Install
ECHO                        2 - Main Menu
ECHO                        0 - EXIT
ECHO.
SET /P STEP2-SELECTION=Select an option then press ENTER:
IF %STEP2-SELECTION%==1 GOTO STEP3
IF %STEP2-SELECTION%==2 GOTO MAINMENU
IF %STEP2-SELECTION%==0 GOTO EOF
GOTO STEP2


:STEP3
CLS
ECHO Installing %OFFICE-INSTALL-VERSION% %OFFICE-INSTALL-BIT%bit please wait...
.\setup.exe /configure config.xml
ECHO Install complete! Press any key to exit
PAUSE >NUL
GOTO EOF

:EOF
