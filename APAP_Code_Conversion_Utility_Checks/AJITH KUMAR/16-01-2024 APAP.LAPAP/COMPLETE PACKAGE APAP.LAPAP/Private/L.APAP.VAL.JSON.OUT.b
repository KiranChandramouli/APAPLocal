* @ValidationCode : MjotMjg4Mzg5ODM3OkNwMTI1MjoxNjkwMTY3NTM3Nzc2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.VAL.JSON.OUT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.L.APAP.JSON.TO.OFS

    GOSUB PROCESS
RETURN

PROCESS:
*----------

    IF R.NEW(ST.JSON.OPERATION.TYPE) EQ "OUT" AND  R.NEW(ST.JSON.OBJECT) NE "NONE" THEN
        TEXT="L.APAP.OUT.JSON"
        CURR.NO=1
        CALL STORE.OVERRIDE(CURR.NO)
        RETURN
    END
RETURN
END
