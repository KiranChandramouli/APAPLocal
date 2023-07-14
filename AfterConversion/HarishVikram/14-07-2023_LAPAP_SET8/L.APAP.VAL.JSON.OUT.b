* @ValidationCode : MjotMjg4Mzg5ODM3OkNwMTI1MjoxNjg5MzEzNDE3NDY2OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 14 Jul 2023 11:13:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
