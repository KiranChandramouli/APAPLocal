SUBROUTINE REDO.FC.S.PROD.COLL.TYPE.CG(ENQ.DATA)
*-----------------------------------------------------------------------------
* Developer    : Jorge Valarezo (jvalarezoulloa@temenos.com)
* Date         : 03.12.2012
* Description  : NOFILE Enquiry Routine para Clase de Garantia en Template FC
* Attached to  : Enquiry REDO.FC.PROD.COLL.TYPE attached in MANUAL.CG version
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date            Who               Reference      Description
*
*-----------------------------------------------------------------------------
* Input/Output: NA/ENQ.DATA (Enquiry Data Result)
* Dependencies: NA
*-----------------------------------------------------------------------------

* <region name="INCLUDES">
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON

    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COLLATERAL.TYPE

    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.PROD.COLL.POLICY
    $INSERT I_System
* </region>


    GOSUB INIT
    GOSUB PROCESS

RETURN

* <region name="GOSUBS">
*************
INIT:
* Initialize
*************
    Y.PRODUCT = System.getVariable("CURRENT.PRODUCT")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.PRODUCT = ""
    END

    LOCATE '@ID' IN D.FIELDS SETTING Y.POS THEN
        Y.COLL.CODE = D.RANGE.AND.VALUE<Y.POS>
    END

    Y.INFO <1> = Y.PRODUCT
    Y.INFO <2> = Y.COLL.CODE
RETURN


***************
PROCESS:
* Main Process
***************


    CALL REDO.FC.S.GET.COLL.TYPE.CG(Y.INFO,ENQ.DATA)
RETURN


RETURN
* </region>

END
