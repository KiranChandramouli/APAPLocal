SUBROUTINE REDO.B.STATUS1.UPD.SELECT

*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.B.STATUS1.UPD.SELECT
*------------------------------------------------------------------
* Description : This is the update rotuine which will select all the customer
* accounts for processing
**********************************************************************
*08-08-2011                JEEVAT             EB.LOOKUP select has been removed
*------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.ACCOUNT.PARAMETER
    $INSERT I_REDO.B.STATUS1.UPD.COMMON



    GOSUB ACCOUNT.SELECT
RETURN
*-----------------------------------------------------
ACCOUNT.SELECT:
*-----------------------------------------------------

    Y.SYSTEM = 'SYSTEM'
    CALL CACHE.READ(FN.ACCOUNT.PARAMETER,Y.SYSTEM,R.ACCT.PARAMETER,Y.ERR)
    Y.PARA.CATG.STR = R.ACCT.PARAMETER<AC.PAR.ACCT.CATEG.STR>
    Y.PARA.CATG.END = R.ACCT.PARAMETER<AC.PAR.ACCT.CATEG.END>
    Y.FINAL.SEL.FORM = ''
    Y.CNT = 1

    LOOP
    WHILE Y.CNT LE DCOUNT(Y.PARA.CATG.STR,@VM)
        Y.SEL.CMD.FORM = ' WITH ( CATEGORY GE ':Y.PARA.CATG.STR<1,Y.CNT>:' AND WITH CATEGORY LE ':Y.PARA.CATG.END<1,Y.CNT>:' ) '
        IF NOT(Y.FINAL.SEL.FORM) THEN
            Y.FINAL.SEL.FORM = Y.SEL.CMD.FORM
        END ELSE
            Y.FINAL.SEL.FORM := ' OR  ':Y.SEL.CMD.FORM
        END
        Y.CNT += 1
    REPEAT

*SEL.CMD = "SELECT ":FN.ACCOUNT

    SEL.CMD  = "SELECT ":FN.ACCOUNT:Y.FINAL.SEL.FORM

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
