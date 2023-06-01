* @ValidationCode : MjotMTA0NDQ5Nzk4NzpDcDEyNTI6MTY4NDg1MTk2OTA4NTpJVFNTOi0xOi0xOjI3NDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 19:56:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 274
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BUILD.CCARD.COMMON.VAR(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.E.BUILD.CHECK.COMMON.VAR
*----------------------------------------------------------

* Description   : Used to get current Account

* Linked with   : Enquiry
* In Parameter  : None
* Out Parameter : None
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
*
* 13-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, IF Condition added
* 17-APR-2023      Harishvikram C   Manual R22 conversion CALL method format changed
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_System
    $INSERT I_F.CUSTOMER.ACCOUNT
    $USING APAP.REDOCHNLS

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----
INIT:
*-----
    F.CUSTOMER.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR=''
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

    Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion- start
        Y.USR.VAR = ""
    END					;*R22 Auto conversion - end
    Y.USR.VAR = Y.USR.VAR:"-":"CURRENT.CARD.LIST.CUS"

RETURN
*-------
PROCESS:
*-------
    Y.CURRENT.CARD.ID = System.getVariable("CURRENT.CARD.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion- start
        Y.CURRENT.CARD.ID = ""
    END					;*R22 Auto conversion - end
    Y.CURRENT.CARD.LIST = System.getVariable("CURRENT.CARD.LIST")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion- start
        Y.CURRENT.CARD.LIST = ""
    END					;*R22 Auto conversion - end

*READ CARD.DATA FROM F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR THEN ;*Tus Start
    CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,CARD.DATA,F.REDO.EB.USER.PRINT.VAR,CARD.DATA.ERR)
    IF CARD.DATA THEN  ;* Tus End
        CHANGE '*' TO @FM IN CARD.DATA
        IF NUM(Y.CURRENT.CARD.ID) THEN
            LOCATE Y.CURRENT.CARD.ID IN CARD.DATA SETTING CUS.ACCT.POS THEN

            END ELSE
                ENQ.ERROR = 'OF-SECURITY.VIOLATION'
                CALL APAP.REDOCHNLS.aiRedoKillSession();* R22 Manual conversion
            END
        END

        IF NUM(Y.CURRENT.CARD.LIST) THEN
            LOCATE Y.CURRENT.CARD.LIST IN CARD.DATA SETTING CUS.ACCT.POS THEN
            END ELSE
                ENQ.ERROR = 'OF-SECURITY.VIOLATION'
                CALL APAP.REDOCHNLS.aiRedoKillSession() ;* R22 Manual conversion
            END
        END

    END ELSE
        ENQ.ERROR = 'OF-SECURITY.VIOLATION'
        CALL APAP.REDOCHNLS.aiRedoKillSession();* R22 Manual conversion
    END
RETURN
END
