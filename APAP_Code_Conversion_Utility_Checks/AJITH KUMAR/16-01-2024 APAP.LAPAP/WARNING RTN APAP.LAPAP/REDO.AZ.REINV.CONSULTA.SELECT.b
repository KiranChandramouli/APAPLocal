$PACKAGE APAP.LAPAP
SUBROUTINE REDO.AZ.REINV.CONSULTA.SELECT
*----------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-07-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED,FM TO @FM
*13-07-2023       Samaran T               R22 Manual Code Conversion       No Changes
*---------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON  ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_REDO.AZ.REINV.CONSULTA.COMMON  ;*R22 AUTO CODE CONVERSION.END
   $USING EB.Service

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    SEL.ACCT = ''; SEL.REC = ''; SEL.LIST = ''; SEL.ERR = ''; Y.AZ.CATEGORY = ''
    SEL.ACCTCL = ''; SEL.RECCL = ''; SEL.LISTCL = ''; SEL.ERRCL = ''
RETURN

PROCESS:
********
*    CALL EB.CLEAR.FILE(FN.DR.OPER.AZCONSL.WORKFILE, F.DR.OPER.AZCONSL.WORKFILE)
EB.Service.ClearFile(FN.DR.OPER.AZCONSL.WORKFILE, F.DR.OPER.AZCONSL.WORKFILE);* R22 UTILITY AUTO CONVERSION
    SEL.ACCT = "SELECT ":FN.AZ.ACCOUNT
    CALL EB.READLIST(SEL.ACCT,SEL.REC,'',SEL.LIST,SEL.ERR)
    SEL.ACCTCL = "SELECT ":FN.AZ.ACCT.BAL.HIST
    CALL EB.READLIST(SEL.ACCTCL,SEL.RECCL,'',SEL.LISTCL,SEL.ERRCL)
    Y.FINAL.LIST = SEL.REC:@FM:SEL.RECCL  ;*R22 AUTO CODE CONVERSION
*    CALL BATCH.BUILD.LIST("",Y.FINAL.LIST)
EB.Service.BatchBuildList("",Y.FINAL.LIST);* R22 UTILITY AUTO CONVERSION
RETURN
END
