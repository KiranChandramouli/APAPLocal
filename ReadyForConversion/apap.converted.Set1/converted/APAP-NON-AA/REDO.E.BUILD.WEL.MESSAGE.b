SUBROUTINE REDO.E.BUILD.WEL.MESSAGE(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name :REDO.E.BUILD.WEL.MESSAGE
*----------------------------------------------------------

* Description   : This subroutine is used to set selection for REDO.CCARD.LIST

* Linked with   : REDO.E.BUILD.WEL.MESSAGE
* In Parameter  : ENQ.DATA
* Out Parameter : ENQ.DATA
*-----------------------------------------------------------------------------
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

    Y.CUSTOMER= System.getVariable('EXT.EXTERNAL.USER')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CUSTOMER = ""
    END
RETURN
*-------
PROCESS:
*-------
    Y.FIELD.COUNT=DCOUNT(ENQ.DATA<2>,@VM)
    ENQ.DATA<2,Y.FIELD.COUNT+1>= '@ID'
    ENQ.DATA<3,Y.FIELD.COUNT+1>= 'EQ'
    ENQ.DATA<4,Y.FIELD.COUNT+1> = Y.CUSTOMER
RETURN
END
