SUBROUTINE REDO.E.BUILD.CURRENT.ACC(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.E.BUILD.CURRENT.ACC
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
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_System

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----
INIT:
*-----
    Y.VAR.ACCOUNT = System.getVariable('CURRENT.ACCT.NO')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.VAR.ACCOUNT = ""
    END
RETURN
*-------
PROCESS:
*-------
    Y.FIELD.COUNT=DCOUNT(ENQ.DATA<2>,@VM)
    ENQ.DATA<2,Y.FIELD.COUNT+1>= 'ACCOUNT'
    ENQ.DATA<3,Y.FIELD.COUNT+1>= 'EQ'
    ENQ.DATA<4,Y.FIELD.COUNT+1> = Y.VAR.ACCOUNT
RETURN
END
