*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.AZ.REINV.CONSULTA.SELECT
*
*
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_F.ACCOUNT
    $INCLUDE T24.BP I_F.AZ.ACCOUNT
    $INCLUDE LAPAP.BP I_REDO.AZ.REINV.CONSULTA.COMMON

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
    CALL EB.CLEAR.FILE(FN.DR.OPER.AZCONSL.WORKFILE, F.DR.OPER.AZCONSL.WORKFILE)
    SEL.ACCT = "SELECT ":FN.AZ.ACCOUNT
    CALL EB.READLIST(SEL.ACCT,SEL.REC,'',SEL.LIST,SEL.ERR)
    SEL.ACCTCL = "SELECT ":FN.AZ.ACCT.BAL.HIST
    CALL EB.READLIST(SEL.ACCTCL,SEL.RECCL,'',SEL.LISTCL,SEL.ERRCL)
    Y.FINAL.LIST = SEL.REC:FM:SEL.RECCL
    CALL BATCH.BUILD.LIST("",Y.FINAL.LIST)
    RETURN
END