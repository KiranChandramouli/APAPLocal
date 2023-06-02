* @ValidationCode : MjotMTc0OTE0NTI1NDpDcDEyNTI6MTY4NDQ5NDM0MDc2MTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 16:35:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.ENVIAR.CORREO
**
* Subroutine Type : VERSION
* Attached to : EB.EXTERNAL.USER,REDO.PERS.NEWINT
* EB.EXTERNAL.USER,REDO.CORP.NEWINTADM
* EB.EXTERNAL.USER,REDO.CORP.NEWINTAUTH
* EB.EXTERNAL.USER,REDO.CORP.NEWINTINP
* Attached as : AUTH.ROUTINE
* Primary Purpose : Create a temporal password for the Interner User and send
* it by email
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 5/07/10 - First Version
* ODR Reference: ODR-2010-06-0075
* Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP)
* Gonzalo Cordova - TAM Latin America
* gcordova@temenos.com
* 4/07/11 - Update an EB.ERROR record if you are creating a new error code
* Gonzalo Cordova - TAM Latin America
* gcordova@temenos.com
* 19/10/11 - Update to T24 coding standards and fix for PACS00146411
* Roberto Mondragon - TAM Latin America
* rmondragon@temenos.com
* 20/12/11 - Update for field separator used to send information to java class
* Roberto Mondragon - TAM Latin America
* rmondragon@temenos.com
* DATE             WHO                 REFERENCE
* 19-05-2023  Conversion Tool    R22 Auto Conversion - X TO X.VAR AND CHAR TO CHARX AND = TO EQ AND <> TO NE AND VM TO @VM
* 19-05-2023  ANIL KUMAR B       R22 Manual Conversion - RANDOMIZE (TIME()) TO RND(TIME())
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.CONFIG.EMAIL.AI
    $INSERT I_F.REDO.SOLICITUD.CANAL
    $INSERT I_REDO.CH.V.EMAIL.COMMON

    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN

********
PROCESS:
********

    ID.USER = ID.NEW
    ID.CUS = R.NEW(EB.XU.CUSTOMER)
    USER.STATUS = R.NEW(EB.XU.STATUS)
    PWD.RVW = R.NEW(EB.XU.PASSWORD.REVIEW)

    GOSUB GET.AND.VAL.EMAIL
    GOSUB CREATE.PWD
    GOSUB INSERT.PWD
    GOSUB GET.EMAIL.DETAILS
    GOSUB SEND.MAIL

RETURN

***********
CREATE.PWD:
***********

    PWD = ""
*   RANDOMIZE (TIME())
    RND(TIME())    ;*R22 MANUAL CONVERSION
    FOR x.VAR = 1 TO 8
        CharType = RND(3) ;* Determines whether an uppercase, lowercase or number will be generated next
        BEGIN CASE
            CASE CharType EQ 0; PWD:= CHARX(RND(26) + 65) ;* Uppercase char
            CASE CharType EQ 1; PWD:= CHARX(RND(26) + 97) ;* Lowercase char
            CASE CharType EQ 2; PWD:= RND(10)
        END CASE
    NEXT x.VAR

RETURN

***********
INSERT.PWD:
***********

    OFS.SRC = 'CHADMONPROC4'

    OFS.HEADER = 'PASSWORD.RESET,/I/PROCESS/1/0,/,': ID.USER :','
    OFS.BODY := 'USER.RESET:1:1=': ID.USER :','
    OFS.BODY := 'USER.PASSWORD:1:1=': PWD :','
    OFS.BODY := 'USER.TYPE:1:1=EXT,'

    OFS.MSG = OFS.HEADER : OFS.BODY

    CALL OFS.POST.MESSAGE(OFS.MSG,RESP.OFS.MSG,OFS.SRC,"0")

RETURN

**********
SEND.MAIL:
**********

    param = EMAIL.FROM
    param = param : "NEXTPARAM" : EMAIL.SUBJECT
    param = param : "NEXTPARAM" : EMAIL.BODY
    param = param : "NEXTPARAM" : EMAIL.TO

    IF EMAIL.FROM NE "" AND EMAIL.SUBJECT NE "" AND EMAIL.BODY NE "" AND EMAIL.TO NE "" THEN
        CALLJ classNamePwd, methodName, param SETTING ret ON ERROR GOTO errHandler
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

***********
INITIALIZE:
***********

    FN.CUST = 'F.CUSTOMER'
    FV.CUST = ''
    CALL OPF(FN.CUST, FV.CUST)

    FN.EMAIL = 'F.REDO.CONFIG.EMAIL.AI'
    FV.EMAIL = ''
    CALL OPF(FN.EMAIL, FV.EMAIL)

    FN.REDO.SOLICITUD.CANAL = 'F.REDO.SOLICITUD.CANAL'
    FV.REDO.SOLICITUD.CANAL = ''
    CALL OPF(FN.REDO.SOLICITUD.CANAL, FV.REDO.SOLICITUD.CANAL)

    classNamePwd = 'REDOEnvioCorreo'
    methodName = '$EnviarCorreo'

    LREF.APP = 'EB.EXTERNAL.USER'
    LREF.FIELDS = 'L.CORP.EMAIL'
    LREF.POS = ''
    CALL GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)

    L.CORP.EMAIL.POS = LREF.POS<1,1>

RETURN

******************
GET.AND.VAL.EMAIL:
******************

    IF PGM.VERSION NE ',REDO.PERS.NEWINT' THEN
        EMAIL.TO = R.NEW(EB.XU.LOCAL.REF)<1,L.CORP.EMAIL.POS>
        RETURN
    END

    R.CUSTOMER = ""; CUS.ERR = ""
    CALL F.READ(FN.CUST,ID.CUS,R.CUSTOMER,FV.CUST,CUS.ERR)
    IF R.CUSTOMER EQ "" THEN
        E = "EB-CUSTOMER.NOT.EXIST"
        RETURN
    END

    EMAIL.TO = R.CUSTOMER<EB.CUS.EMAIL.1>
    Y.EMAIL.ACCTS = DCOUNT(EMAIL.TO,@VM)

    IF Y.EMAIL.ACCTS GE 2 THEN
        EMAIL.TO = FIELD(EMAIL.TO,@VM,1)
    END

    IF EMAIL.TO EQ "" THEN
        GOSUB GET.EMAIL.FROM.REQ
    END

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

******************
GET.EMAIL.DETAILS:
******************

    Y.REC.MSG = '3'
    CALL F.READ(FN.EMAIL, Y.REC.MSG, R.EMAIL, FV.EMAIL, F.ERR)
    IF R.EMAIL THEN
        EMAIL.SUBJECT = R.EMAIL<LOC.CE.SUBJECT>
        EMAIL.BODY.1 = R.EMAIL<LOC.CE.BODY>
        EMAIL.FROM = R.EMAIL<LOC.CE.MAILFROM>
    END

    IF EMAIL.BODY.1 NE "" THEN
        CRLF = '' ;*CHAR(13):CHAR(10)
        EMAIL.BODY = CHANGE(EMAIL.BODY.1,"%%",PWD,1)
        CHANGE @VM TO CRLF IN EMAIL.BODY
    END

RETURN

END
