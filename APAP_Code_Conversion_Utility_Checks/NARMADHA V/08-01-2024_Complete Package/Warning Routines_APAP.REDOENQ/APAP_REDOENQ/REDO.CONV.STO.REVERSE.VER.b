* @ValidationCode : MjotMTI1MDczNTEzMjpVVEYtODoxNzAzMjM5MDA2Mzg5OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 22 Dec 2023 15:26:46
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.STO.REVERSE.VER
*--------------------------------------------------------------------------
* DESCRIPTION: This routine is used to populate the reverse versions
*-----------------------------------------------------------------------------
* Modification History
* DATE         NAME          Reference        REASON
* 10-02-2012   SUDHARSANAN   PACS00178947     Initial creation
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion   - No changes
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 22-12-2023         Narmadha V            Manual R22 Conversion   F.READ to CACHE.READ
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.AI.REDO.PRINT.TXN.PARAM

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

***********
OPEN.FILES:
***********

    FN.AI.REDO.PRINT.TXN.PARAM = 'F.AI.REDO.PRINT.TXN.PARAM'
    F.AI.REDO.PRINT.TXN.PARAM = ''
    CALL OPF(FN.AI.REDO.PRINT.TXN.PARAM,F.AI.REDO.PRINT.TXN.PARAM)

RETURN
**********
PROCESS:
*********

*CALL F.READ(FN.AI.REDO.PRINT.TXN.PARAM,O.DATA,R.AI.REDO.PRINT.TXN.PARAM,F.AI.REDO.PRINT.TXN.PARAM,PARAM.ERR)
    CALL CACHE.READ(FN.AI.REDO.PRINT.TXN.PARAM,O.DATA,R.AI.REDO.PRINT.TXN.PARAM,PARAM.ERR) ;*Manual R22 Conversion - F.READ to CACHE.READ
    Y.STO.REV.COS = R.AI.REDO.PRINT.TXN.PARAM<AI.PRI.STO.REVE.VERSION>
    O.DATA = 'COS ':Y.STO.REV.COS
RETURN
*-------------------------------------------------------------------------------------------------------------------
END
