*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.OVERDRAFT.ACCT.RTN.SELECT
*********************************************************************************************************
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Dev By       : V.P.Ashokkumar
*
*********************************************************************************************************

    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_ENQUIRY.COMMON
    $INCLUDE T24.BP I_F.ACCOUNT
    $INCLUDE T24.BP I_F.ACCOUNT.CLASS
    $INCLUDE LAPAP.BP I_REDO.B.OVERDRAFT.ACCT.RTN.COMMON

    GOSUB INIT
    GOSUB PROCESS
    RETURN

INIT:
*****
    CALL EB.CLEAR.FILE(FN.DR.OPER.OVERDRAF.WORKFILE, F.DR.OPER.OVERDRAF.WORKFILE)
    R.ACCT.CLASS = ''; ACCT.CLASS.ERR = ''; Y.SAVINGS.CATEG = ''
    SEL.CMD.ACC = ''; SEL.LIST = ''; NO.OF.REC = ''; RET.CODE = ''
    Y.ACC.CLASS.ID = 'SAVINGS'
    CALL F.READ(FN.ACCOUNT.CLASS,Y.ACC.CLASS.ID,R.ACCT.CLASS,F.ACCOUNT.CLASS,ACCT.CLASS.ERR)
    Y.SAVINGS.CATEG = R.ACCT.CLASS<AC.CLS.CATEGORY>
    CHANGE VM TO ' ' IN Y.SAVINGS.CATEG
    RETURN

PROCESS:
********
    SEL.CMD.ACC = "SELECT ":FN.ACCOUNT:" WITH CATEGORY EQ ":Y.SAVINGS.CATEG
    CALL EB.READLIST(SEL.CMD.ACC,SEL.LIST,'',NO.OF.REC,RET.CODE)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
    RETURN

END
