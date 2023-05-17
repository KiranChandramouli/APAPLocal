SUBROUTINE REDO.E.BUILD.CCARD.LTST.TXN(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.E.BUILD.CCARD.LIST
*----------------------------------------------------------

* Description   : This subroutine is used to set selection for Latest Transaction

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
    Y.COMPANY.CODE= System.getVariable('CURRENT.COMP.CODE')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.COMPANY.CODE = ""
    END
    Y.CARD.NO=System.getVariable('CURRENT.CARD.ID')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CARD.NO = ""
    END
    Y.FROM.DATE=System.getVariable('CURRENT.ST.DATE')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.FROM.DATE = ""
    END
    Y.TO.DATE=TODAY
RETURN
*-------
PROCESS:
*-------
    Y.FIELD.COUNT=DCOUNT(ENQ.DATA<2>,@VM)
    ENQ.DATA<2,Y.FIELD.COUNT+1>= 'COMPANY.CODE'
    ENQ.DATA<3,Y.FIELD.COUNT+1>= 'EQ'
    ENQ.DATA<4,Y.FIELD.COUNT+1> = Y.COMPANY.CODE
    ENQ.DATA<2,Y.FIELD.COUNT+2>= 'CARD.NO'
    ENQ.DATA<3,Y.FIELD.COUNT+2>= 'EQ'
    ENQ.DATA<4,Y.FIELD.COUNT+2> = Y.CARD.NO
    ENQ.DATA<2,Y.FIELD.COUNT+1>= 'FROM.DATE'
    ENQ.DATA<3,Y.FIELD.COUNT+1>= 'EQ'
    ENQ.DATA<4,Y.FIELD.COUNT+1> = Y.FROM.DATE
    ENQ.DATA<2,Y.FIELD.COUNT+1>= 'TO.DATE'
    ENQ.DATA<3,Y.FIELD.COUNT+1>= 'EQ'
    ENQ.DATA<4,Y.FIELD.COUNT+1> = Y.TO.DATE
RETURN
END
