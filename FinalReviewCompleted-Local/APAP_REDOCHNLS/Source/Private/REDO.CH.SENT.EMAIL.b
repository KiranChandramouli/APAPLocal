* @ValidationCode : MjotMTY0OTU0NjQyNjpDcDEyNTI6MTY4MjY3MDAwNDI4MDpJVFNTOi0xOi0xOjY1MzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Apr 2023 13:50:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 653
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS
SUBROUTINE REDO.CH.SENT.EMAIL
**
* Subroutine Type : VERSION
* Attached to     : PASSWORD.RESET,REDO.CH.RESUSRPWD
* Attached as     : AUTH.RTN
* Primary Purpose : Send the new temporal password to Internet User by email
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 1/11/10 - First Version
*           ODR Reference: ODR-2010-06-0155
*           Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP)
*           Martin Macias
*           mmacias@temenos.com
* 07/11/11 - Fix for PACS00146411
*            Roberto Mondragon - TAM Latin America
*            rmondragon@temenos.com
* 05/04/13 - Update
*            Roberto Mondragon - TAM Latin America
*            rmondragon@temenos.com
*-----------------------------------------------------------------------------
* Modification Details:
* =====================
* Date         Who                  Reference      Description
* ------       -----                ------------   -------------
* 12-05-2015   Vignesh Kumaar M R   PACS00457115   ARC-IB PIN ERROR
* 12-APR-2023     Conversion tool   R22 Auto conversion   CHAR to CHARX, = to EQ, <> to NE, VM to @VM
* 12-APR-2023     Harishvikram C   Manual R22 conversion  GOTO changed to GOSUB
*------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.PASSWORD.RESET
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_F.CUSTOMER

    $INSERT I_F.REDO.SOLICITUD.CANAL
    $INSERT I_F.REDO.CONFIG.EMAIL.AI
*    $INCLUDE TAM.BP I_REDO.CH.NEWPWD.COMMON

    GOSUB INIT
    GOSUB PROCESS

RETURN

********
PROCESS:
********

    PWD = System.getVariable("CURRENT.ARC.PASS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - START
        PWD = ""
    END					;*R22 Auto conversion - END

    R.NEW(EB.PWR.USER.PASSWORD) = PWD
    ID.USER = R.NEW(EB.PWR.USER.RESET)

    R.EXT.USER = ''; EXUSER.ERR = ''
    CALL CACHE.READ(FN.EXT.USER, ID.USER, R.EXT.USER, EXUSER.ERR) ;*R22 Auto conversion
    IF R.EXT.USER THEN
        ID.CUS = R.EXT.USER<EB.XU.CUSTOMER>
        Y.PROD = R.EXT.USER<EB.XU.LOCAL.REF><1,PROD.USED.POS>
        Y.EMAIL.REG = R.EXT.USER<EB.XU.LOCAL.REF><1,L.CORP.EMAIL.POS>
    END

    IF Y.PROD EQ 'PERSONAL' THEN
        R.CUSTOMER = ''; CUS.ERR = ''
        CALL F.READ(FN.CUST,ID.CUS,R.CUSTOMER,FV.CUST,CUS.ERR)
        IF R.CUSTOMER NE '' THEN
            EMAIL.TO = ''
            EMAIL.TO = R.CUSTOMER<EB.CUS.EMAIL.1,1>
        END

    END ELSE
        EMAIL.TO = Y.EMAIL.REG
    END

    IF EMAIL.TO EQ '' THEN
        GOSUB GET.EMAIL.FROM.REQ
        RETURN
    END

    GOSUB GET.EMAIL.DETAILS
    GOSUB SEND.MAIL

RETURN

******************
GET.EMAIL.DETAILS:
******************

    Y.REC.MSG = '2'
    CALL F.READ(FN.EMAIL, Y.REC.MSG, R.EMAIL, FV.EMAIL, F.ERR)
    IF R.EMAIL THEN
        EMAIL.SUBJECT = R.EMAIL<LOC.CE.SUBJECT>
        EMAIL.BODY.1 = R.EMAIL<LOC.CE.BODY>
        EMAIL.FROM = R.EMAIL<LOC.CE.MAILFROM>
    END
    IF EMAIL.BODY.1 NE "" THEN
        CRLF = CHARX(13):CHARX(10) ;*R22 Auto conversion
        EMAIL.BODY = CHANGE(EMAIL.BODY.1,"%%",PWD,1)
        CHANGE @VM TO CRLF IN EMAIL.BODY
    END

RETURN

**********
SEND.MAIL:
**********

    param = EMAIL.FROM
    param = param : "NEXTPARAM" : EMAIL.SUBJECT
    param = param : "NEXTPARAM" : EMAIL.BODY
    param = param : "NEXTPARAM" : EMAIL.TO

    IF EMAIL.FROM NE "" AND EMAIL.SUBJECT NE "" AND EMAIL.BODY NE "" AND EMAIL.TO NE "" THEN
        CALLJ classNamePwd, methodName, param SETTING ret ON ERROR GOSUB errHandler ;* Manual R22 conversion - GOTO changed to GOSUB
    END

RETURN

***********
errHandler:
***********

    err = SYSTEM(0)
    BEGIN CASE
        CASE err EQ 1
            E = "EB-REDO.CALLJ.ERROR.1"
            RETURN
        CASE err EQ 2
            E = "EB-REDO.CALLJ.ERROR.2"
            RETURN
        CASE err EQ 3
            E = "EB-REDO.CALLJ.ERROR.3"
            RETURN
        CASE err EQ 4
            E = "EB-REDO.CALLJ.ERROR.4"
            RETURN
        CASE err EQ 5
            E = "EB-REDO.CALLJ.ERROR.5"
            RETURN
        CASE err EQ 6
            E = "EB-REDO.CALLJ.ERROR.6"
            RETURN
        CASE err EQ 7
            E = "EB-REDO.CALLJ.ERROR.7"
            RETURN
        CASE @TRUE
            E = "EB-REDO.CALLJ.ERROR.8"
            RETURN
    END CASE

RETURN

*******************
GET.EMAIL.FROM.REQ:
*******************

    SEL.CMD = ''; NO.OF.REC = ''; CNT.REC= ''; RET.CD = ''
    SEL.CMD = "SELECT ":FN.REDO.SOLICITUD.CANAL:" WITH ID.USUARIO LIKE ":ID.USER
    CALL EB.READLIST(SEL.CMD,NO.OF.REC,'',CNT.REC,RET.CD)

    IF CNT.REC EQ '1' THEN
        Y.REQUEST = NO.OF.REC<CNT.REC>
        R.REQUEST = ''; REQ.ERR = ''
        CALL F.READ(FN.REDO.SOLICITUD.CANAL,Y.REQUEST,R.REQUEST,FV.REDO.SOLICITUD.CANAL,REQ.ERR)
        IF R.REQUEST THEN
            EMAIL.TO = R.REQUEST<RD.SC.EMAIL>
        END
    END ELSE
        E = "EB-REDO.NOT.MAIL"
        CALL STORE.END.ERROR
    END

RETURN

*****
INIT:
*****

    FN.CUST = 'F.CUSTOMER'
    FV.CUST = ''
    CALL OPF(FN.CUST, FV.CUST)

    FN.EXT.USER = 'F.EB.EXTERNAL.USER'
    FV.EXT.USER = ''
    CALL OPF(FN.EXT.USER, FV.EXT.USER)

    FN.EMAIL = 'F.REDO.CONFIG.EMAIL.AI'
    FV.EMAIL = ''
    CALL OPF(FN.EMAIL, FV.EMAIL)

    FN.REDO.SOLICITUD.CANAL = 'F.REDO.SOLICITUD.CANAL'
    FV.REDO.SOLICITUD.CANAL = ''
    CALL OPF(FN.REDO.SOLICITUD.CANAL,FV.REDO.SOLICITUD.CANAL)

    classNamePwd = 'REDOEnvioCorreo'
    methodName = '$EnviarCorreo'

    LREF.APP = 'EB.EXTERNAL.USER'
    LREF.FIELDS = 'PROD.USED':@VM:'L.CORP.EMAIL'
    LREF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    PROD.USED.POS = LREF.POS<1,1>
    L.CORP.EMAIL.POS = LREF.POS<1,2>

RETURN

END
