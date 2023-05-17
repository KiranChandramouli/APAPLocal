SUBROUTINE APAP.B.CREATE.LN.SERVICE.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : APAP.B.CREATE.LN.SERVICE
*-----------------------------------------------------------------------------
* Description:
*------------
*
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_APAP.B.CREATE.LN.SERVICE.COMMON

    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
*
    SEL.CMD = "SELECT ":FN.APAP.LN.OFS.CONCAT
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
    CALL BATCH.BUILD.LIST('',BUILD.LIST)
*
RETURN

************************FINAL END**********************************************************
END
