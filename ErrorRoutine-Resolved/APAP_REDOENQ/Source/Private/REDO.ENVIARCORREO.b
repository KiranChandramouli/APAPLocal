* @ValidationCode : MjotMTc0NzA5NTQ1NjpDcDEyNTI6MTY4NDQ5NDU0MTg1MDpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 16:39:01
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
SUBROUTINE REDO.ENVIARCORREO

******************************************************************

* Send a random temporary password to the external user s email

* HISTORY
*       AUTHOR.1 - EDGAR GABRIEL RESENDES GONZALEZ
*
*       CLIENT:    APAP

*       DATE:      29/JUL/2010

******************************************************************
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
* DATE                WHO              REFERENCE
* 19-05-2023    Conversion Tool     R22 Auto Conversion - X TO X.VAR AND = TO EQ AND CHAR TO CHARX AND CONVERT TO CHANGE AND <> TO NE AND VM TO @VM
* 19-05-2023    ANIL KUMAR B        R22 Manual Conversion - RANDOMIZE (TIME()) TO RND (TIME()) AND�ADDED "EMAIL.TO = R.EMAIL<LOC.CE.MAILTO>"
*------------------------------------------------------------------------


    $INSERT I_COMMON

    $INSERT I_EQUATE

    $INSERT I_F.EB.EXTERNAL.USER

    $INSERT I_F.CUSTOMER

    $INSERT I_F.REDO.CONFIG.EMAIL.AI

*****************

    GOSUB ABRE_TABLAS

    GOSUB INITIALIZE

RETURN
*****************


INITIALIZE:


    classNamePwd = 'REDOEnvioCorreo'

    methodName = '$EnviarCorreo'



*******************************************

* GETS VALUES FROM EXTERNAL USER *

*******************************************

    OPENPATH 'C:\' TO MYPATH ELSE NULL

    ID.USER = ID.NEW

    ID.CUS = R.NEW(EB.XU.CUSTOMER)

    CHANNEL = R.NEW(EB.XU.CHANNEL)

    USER.STATUS = R.NEW(EB.XU.STATUS)

    PWD.RVW = R.NEW(EB.XU.PASSWORD.REVIEW)

    IF USER.STATUS EQ 'ACTIVE' OR CHANNEL EQ 'INTERNET' THEN

*******************

* BUILDS TEMPORARY PASSWORDS OF 8 LENGTH *

*******************

        PWD = ""
        RND (TIME())   ;*R22 MANUAL
*RANDOMIZE (TIME())
        FOR x.VAR = 1 TO 8
            CharType = RND(3)       ;* Determines whether an uppercase, lowercase or number will be generated next
            BEGIN CASE
                CASE CharType EQ 0; PWD:= CHARX(RND(26) + 65) ;* Uppercase char
                CASE CharType EQ 1; PWD:= CHARX(RND(26) + 97) ;* Lowercase char
                CASE CharType EQ 2; PWD:= RND(10)
            END CASE
        NEXT x.VAR


*WRITE PWD TO MYPATH,'PWDTEST.txt' ON ERROR NULL

********************************************

* CHANGE THE USER PASSWORD *

********************************************

        OFS.REC = 'BROWSER.XML,,,,,,'

        OFS.REC := '<<?xml version="1.0" encoding="UTF-8"?>'

        OFS.REC := '<ofsSessionRequest xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" schemaLocation="\WEB-INF\xml\schema\ofsSessionRequest.xsd">'

        SEL.CMD = "SELECT ":FN.EMAIL

        CALL EB.READLIST(SEL.CMD,NO.OF.REC,'',CNT.REC,REC.ERR)

        IF NO.OF.REC NE "" THEN

            CALL F.READ(FN.EMAIL,NO.OF.REC,R.EMAIL,F.REDO.CONFIG.EMAIL.AI,F.ERR)
            EMAIL.SUBJECT = R.EMAIL<LOC.CE.SUBJECT>
            EMAIL.BODY.1 = R.EMAIL<LOC.CE.BODY>
            EMAIL.TO = R.EMAIL<LOC.CE.MAILTO>  ;*R22 MANUAL

            IF EMAIL.BODY.1 NE "" THEN
                CRLF = CHARX(13):CHARX(10)
                EMAIL.BODY = CHANGE(EMAIL.BODY.1,"%%",PWD,1)
                CHANGE @VM TO CRLF IN EMAIL.BODY
*EMAIL.BODY = CHANGE(EMAIL.BODY,"CHAR(10)",CRLF)
            END
            EMAIL.FROM = R.EMAIL<LOC.CE.MAILFROM>

        END


*PWD = PWD:" ":USER.STATUS:" ":CHANNEL:" ":EMAIL.TO:" ":EMAIL.SUBJECT:" ":EMAIL.BODY:" ":EMAIL.FROM
*WRITE PWD TO MYPATH,'PWDTEST.txt' ON ERROR NULL
*WRITE OFS.REC TO MYPATH,'OFS.txt' ON ERROR NULL

***********************************************

* INVOKES CALLJ TO SEND EMAIL *

***********************************************
        
        param = EMAIL.FROM

        param = param : "," : EMAIL.SUBJECT

        param = param : "," : EMAIL.BODY

        param = param : "," : EMAIL.TO    ;*R22 Manual

        IF EMAIL.FROM NE "" AND EMAIL.SUBJECT NE "" AND EMAIL.BODY NE "" AND EMAIL.TO NE "" THEN

            CALLJ classNamePwd, methodName, param SETTING ret ON ERROR GOTO errHandler

        END


    END



RETURN



***********

errHandler:

***********

    err = SYSTEM(0)

    BEGIN CASE

        CASE err EQ 1

            ETEXT = "Fatal error creating Thread!"

            CALL STORE.END.ERROR

            RETURN

        CASE err EQ 2

            ETEXT = "Cannot find the JVM.dll!"

            CALL STORE.END.ERROR

            RETURN

        CASE err EQ 3

            ETEXT = "Class ": classNamePwd : " doesn't exist!"

            CALL STORE.END.ERROR

            RETURN

        CASE err EQ 4

            ETEXT = "UNICODE conversion error!"

            CALL STORE.END.ERROR

            RETURN

        CASE err EQ 5

            ETEXT = "Method " : methodName : " doesn't exist!"

            CALL STORE.END.ERROR

            RETURN

        CASE err EQ 6

            ETEXT = "Cannot find object Constructor1"

            CALL STORE.END.ERROR

            RETURN

        CASE err EQ 7

            ETEXT = "Cannot instantiate object!"

            CALL STORE.END.ERROR

            RETURN

        CASE @TRUE

            ETEXT = "Unknown error!"

            CALL STORE.END.ERROR

            RETURN

    END CASE

RETURN

************
ABRE_TABLAS:
************

*FN.EB.EXT.USER = 'F.EB.EXTERNAL.USER'
*FV.EB.EXT.USER = ''
*CALL OPF(FN.EB.EXT.USER, FV.EB.EXT.USER)
    OPEN '','F.EB.EXTERNAL.USER' TO F.EB.EXTERNAL.USER ELSE

*PRINT 'NO SE PUDO ABRIR F.EB.EXTERNAL.USER'
        RETURN
    END

    FN.CUST = 'F.CUSTOMER'
    FV.CUST = ''
    CALL OPF(FN.CUST, FV.CUST)

    FN.EMAIL = 'F.REDO.CONFIG.EMAIL.AI'
    FV.EMAIL = ''
    CALL OPF(FN.EMAIL, FV.EMAIL)
RETURN



***************
WRITE.IN.FILE:
***************

    YFECHA    = TODAY

    YDAY.TYPE = ''
    CALL AWD('',YFECHA,YDAY.TYPE)
    IF YDAY.TYPE EQ "H" THEN
        CALL CDT('',YFECHA,"-1W")
    END
    ELSE
        CALL CDT('',YFECHA,"-1C")
    END

    YFECHA     = YFECHA[1,4] : "" : YFECHA[5,2] : "" : YFECHA[7,2] :"M02":YFECHA[7,2]

*CALL F.READ(FN.EB.EXT.USER,ID.USER,REC.EB.EXT.USER,FV.EB.EXT.USER,F.ERR)
*REC.EB.EXT.USER<EB.XU.PASSWORD.REVIEW> = YFECHA
*CALL F.WRITE(FN.EB.EXT.USER,ID.USER,REC.EB.EXT.USER)


    Y.REC = ""
    READ Y.REC FROM F.EB.EXTERNAL.USER,ID.USER THEN

        Y.REC<EB.XU.PASSWORD.REVIEW> = YFECHA
        WRITE Y.REC TO F.EB.EXTERNAL.USER,ID.USER

    END

    WRITE YFECHA TO MYPATH,'PFECHA.txt' ON ERROR NULL

    CALL REBUILD.SCREEN

RETURN


END
