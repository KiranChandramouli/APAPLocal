$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.STO.REVERSE.VER
*--------------------------------------------------------------------------
* DESCRIPTION: This routine is used to populate the reverse versions
*-----------------------------------------------------------------------------
* Modification History
* DATE         NAME          Reference        REASON
* 10-02-2012   SUDHARSANAN   PACS00178947     Initial creation
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
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

    CALL F.READ(FN.AI.REDO.PRINT.TXN.PARAM,O.DATA,R.AI.REDO.PRINT.TXN.PARAM,F.AI.REDO.PRINT.TXN.PARAM,PARAM.ERR)
    Y.STO.REV.COS = R.AI.REDO.PRINT.TXN.PARAM<AI.PRI.STO.REVE.VERSION>
    O.DATA = 'COS ':Y.STO.REV.COS
RETURN
*-------------------------------------------------------------------------------------------------------------------
END
