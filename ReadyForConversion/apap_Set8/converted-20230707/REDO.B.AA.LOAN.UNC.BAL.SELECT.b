SUBROUTINE REDO.B.AA.LOAN.UNC.BAL.SELECT

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_REDO.B.AA.LOAN.UNC.BAL.COMMON


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
