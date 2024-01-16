$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.AA.ZBAL.NEG.VAL.SELECT
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*
*                       Ashokkumar.V.P                  07/09/2015    .
*--------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-07-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*13-07-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------------
    $INSERT I_COMMON  ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_REDO.B.AA.ZBAL.NEG.VAL.COMMON  ;*R22 AUTO CODE CONVERSION.END
   $USING EB.Service

    GOSUB MAIN.PROCESS
RETURN

MAIN.PROCESS:
*************
*    CALL EB.CLEAR.FILE(FN.DR.REG.AA.PROB.WORKFILE, F.DR.REG.AA.PROB.WORKFILE)
EB.Service.ClearFile(FN.DR.REG.AA.PROB.WORKFILE, F.DR.REG.AA.PROB.WORKFILE);* R22 UTILITY AUTO CONVERSION
    SEL.CMD = ''; SEL.LIST = ''; SEL.CNT = ''; ERR.SEL = ''
    SEL.CMD = "SSELECT ":FN.AA.ARR:" WITH PRODUCT.LINE EQ 'LENDING'"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.CNT,ERR.SEL)
*    CALL BATCH.BUILD.LIST("",SEL.LIST)
EB.Service.BatchBuildList("",SEL.LIST);* R22 UTILITY AUTO CONVERSION
RETURN
END
