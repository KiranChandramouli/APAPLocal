* @ValidationCode : MjotMjEyNTQ1MDE5OTpDcDEyNTI6MTY4NDgzNjAzMjM2NTpJVFNTOi0xOi0xOjY4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 68
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE APAP.USER.PASSWORD.CHANGE (Y.REQUEST, Y.RESPONSE)
* ====================================================================================
*
*    - This routine recieve ofs message and process it to change password for eb.external user
*
*
* ====================================================================================
*
* Subroutine Type : OFS MESSAGE ROUTINE
* Attached to     : OFS.SOURCE
* Attached as     : IN.MSG.RTN
* Primary Purpose : Change Password for Eb.external.user
*
*
* Incoming:
* ---------
* Y.REQUEST- ALL PARAMETERS TO CREATE OFS MESSAGE
*
*
* Outgoing:
* ---------
* Y.RESPONSE- RESPONSE
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : Jorge Valarezo
* Date            : 15 Jul 2011
* Modification Date : 28 Sept 2011            Create OFS to update EB.EXTERNAL.USER
*                                             record to set END.DATE
*
* Modification Date : 28 Mar 2012 - Fix for PACS00180440.
*                                   Key for PIN encription updated.
*                                   Unmask function for PWD/PIN added.
*                                   Roberto  Mondragon.
* Modification Date : 31 May 2012 - Fix for PACS00180440.
*                                   Unmask function for PWD/PIN.

*
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , ++ to +=
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*24-08=2023       AJITH KUMAR S               MANUAL R22 CODE CONVERSION ENCRYPT WILL BE CHANGE
*----------------------------------------------------------------------------------------

*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.DATES
    $INSERT I_F.DE.I.MSG.55X
    $INSERT I_F.DE.MESSAGE
    $INSERT I_F.COMPANY
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.OFS.SOURCE
    $INSERT I_GTS.COMMON
    $INSERT JBC.h

*************************************************************************
    GOSUB INITIALISE
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN

***********
INITIALISE:
***********

    LOOP.CNT        =  0
    MAX.LOOPS       =  0
    PROCESS.GOAHEAD =  1
    ID.USER         =  ''
    PWD             =  ''
    CHANNEL         =  ''
    Y.FECHA.INICIO  =  ''
    Y.HORA.INICIO   =  ''
    Y.USER          =  ''
    Y.PWD           =  ''
    OFS.REC         =  ''
    OFS.MSG.ID      =  ''
    OFS.SOURCE.ID   =  ''
    OPTIONS         =  ''

RETURN

************************
CHECK.PRELIM.CONDITIONS:
************************

    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
        END CASE
        LOOP.CNT +=1
    REPEAT

RETURN

********
PROCESS:
********

    CHANGE "," TO @FM IN Y.REQUEST
    ID.USER        = Y.REQUEST<1>
    PWD            = Y.REQUEST<2>
    CHANNEL        = Y.REQUEST<3>
    Y.FECHA.INICIO = Y.REQUEST<4>
    Y.HORA.INICIO  = Y.REQUEST<5>
    Y.USER         = Y.REQUEST<6>
    Y.PWD          = Y.REQUEST<7>

    GOSUB GET.PWD

* Insert the password for ARCIB user
    IF CHANNEL EQ "INTERNET" THEN
        OFS.REC = 'BROWSER.XML,,,,,,'
        OFS.REC := '<<?xml version="1.0" encoding="UTF-8"?>'
        OFS.REC := '<ofsSessionRequest xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" schemaLocation="\WEB-INF\xml\schema\ofsSessionRequest.xsd">'
        OFS.REC := '<requestType>UTILITY.ROUTINE</requestType>'
        OFS.REC := '<requestArguments>'
        OFS.REC := '<routineName>OS.PASSWORD</routineName>'
        OFS.REC := '<routineArgs>PROCESS.REPEAT:' : ID.USER
        OFS.REC := ':': PWD :':'
        OFS.REC := PWD : '</routineArgs>'
        OFS.REC := '</requestArguments>'
        OFS.REC := '</ofsSessionRequest>'
        OFS.MSG.ID = ''
        OFS.SOURCE.ID = 'ARCIB'
        OPTIONS = ''

        CALL OFS.POST.MESSAGE(OFS.REC, OFS.MSG.ID, OFS.SOURCE.ID, OPTIONS)

        Y.RESPONSE="OFS CAMBIO DE PASSWORD"
    END

*Insert the PIN number for IVR user
    IF CHANNEL EQ "IVR" THEN
*OLD - START
*KEYUSED = "7"
*PWD = ENCRYPT(PWD,KEYUSED,2)
*OLD - END
*NEW-START
        KEYUSED="12345678" ;*R22-MANUAL CONVERSION
        PIN = ENCRYPT(PIN,KEYUSED,JBASE_CRYPT_DES_BASE64)
*NEW - END
        
        OFS.REC  = "REDO.CH.PINADM,/I/PROCESS/1/0,":Y.USER:"/":Y.PWD:",": ID.USER :","
        OFS.REC  := "PIN:1:1=": PWD :","
        OFS.REC := "START.DATE:1:1=": Y.FECHA.INICIO :","
        OFS.REC := "START.TIME:1:1=": Y.HORA.INICIO :","
        OFS.REC := "TYPE:1:1=DEFINITIVO,"
        OFS.MSG.ID = ''
        OFS.SOURCE.ID = 'GCS'
        OPTIONS = ''

        CALL OFS.POST.MESSAGE(OFS.REC, OFS.MSG.ID, OFS.SOURCE.ID, OPTIONS)

        Y.RESPONSE="OFS CAMBIO DE PIN"
    END

    CALL JOURNAL.UPDATE(OFS.MSG.ID)

RETURN

********
GET.PWD:
********

    Y.PWD.LEN = DCOUNT(PWD,'-')
    Y.CNT = 1
    Y.ARR.PWD = ''
    LOOP
    WHILE Y.CNT LE Y.PWD.LEN
        Y.PWD.CHAR = FIELD(PWD,'-',Y.CNT)
        Y.ARR.PWD := Y.PWD.CHAR : @AM
        Y.CNT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT

    Y.PWD.TO.UNM = CHARS(Y.ARR.PWD)

    PWD = ''
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.PWD.LEN
        PWD := Y.PWD.TO.UNM<Y.CNT>
        Y.CNT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT

RETURN

END
