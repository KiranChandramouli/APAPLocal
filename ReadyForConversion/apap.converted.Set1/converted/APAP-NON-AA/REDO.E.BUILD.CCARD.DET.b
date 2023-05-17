SUBROUTINE REDO.E.BUILD.CCARD.DET(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.E.BUILD.CCARD.LIST
*----------------------------------------------------------

* Description   : This subroutine is used to set selection for CREDIT CARD DETAILS

* Linked with   : REDO.CCARD.LIST
* In Parameter  : ENQ.DATA
* Out Parameter : ENQ.DATA
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
    Y.CARD.NO= System.getVariable('CURRENT.CARD.ID')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CARD.NO = ""
    END
    Y.COMAPNY.CODE= System.getVariable('CURRENT.COMP.CODE')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.COMAPNY.CODE = ""
    END

RETURN
*-------
PROCESS:
*-------
    Y.FIELD.COUNT=DCOUNT(ENQ.DATA<2>,@VM)
    ENQ.DATA<2,Y.FIELD.COUNT+1>= 'CARD.NO'
    ENQ.DATA<3,Y.FIELD.COUNT+1>= 'EQ'
    ENQ.DATA<4,Y.FIELD.COUNT+1> = Y.CARD.NO
    ENQ.DATA<2,Y.FIELD.COUNT+2>= 'COMPANY.CODE'
    ENQ.DATA<3,Y.FIELD.COUNT+2>= 'EQ'
    ENQ.DATA<4,Y.FIELD.COUNT+2> = Y.COMAPNY.CODE
RETURN
END
