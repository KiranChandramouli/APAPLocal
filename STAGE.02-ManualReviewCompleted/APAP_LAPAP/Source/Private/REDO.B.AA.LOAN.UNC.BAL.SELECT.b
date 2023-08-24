$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.AA.LOAN.UNC.BAL.SELECT
*------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-07-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*13-07-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------

    $INSERT I_COMMON  ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_REDO.B.AA.LOAN.UNC.BAL.COMMON  ;*R22 AUTO CODE CONVERSION.END


    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    SEL.AACMD = ''; SEL.LIST = ''; NO.OF.REC = ''; SEL.ERR = ''
    CALL EB.CLEAR.FILE(FN.DR.REG.UNC.BAL.WORKFILE,F.DR.REG.UNC.BAL.WORKFILE)
RETURN

PROCESS:
********
    SEL.AACMD = "SELECT ":FN.AA.ARRANGEMENT.ACTIVITY:" WITH ACTIVITY EQ 'LENDING-CREDIT-ARRANGEMENT'"
    CALL EB.READLIST(SEL.AACMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST("",SEL.LIST)
RETURN

END
