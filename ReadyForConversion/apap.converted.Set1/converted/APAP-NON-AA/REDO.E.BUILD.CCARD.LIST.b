SUBROUTINE REDO.E.BUILD.CCARD.LIST(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.E.BUILD.CCARD.LIST
*----------------------------------------------------------

* Description   : This subroutine is used to set selection for REDO.CCARD.LIST

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
    Y.VAR.EXT.CUSTOMER= System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.VAR.EXT.CUSTOMER = ""
    END

RETURN
*-------
PROCESS:
*-------
    IF ENQ.DATA<1,1> EQ 'AI.REDO.CCARD.LIST' THEN
        ENQ.DATA<2,-1>='CLIENT.ID'
        ENQ.DATA<3,-1>='EQ'
        ENQ.DATA<4,-1>=Y.VAR.EXT.CUSTOMER
    END ELSE
        ENQ.DATA<2,-1>='@ID'
        ENQ.DATA<3,-1>='EQ'
        ENQ.DATA<4,-1>=Y.VAR.EXT.CUSTOMER
    END
RETURN
END
