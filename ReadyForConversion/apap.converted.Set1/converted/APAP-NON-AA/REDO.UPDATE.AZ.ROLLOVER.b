SUBROUTINE REDO.UPDATE.AZ.ROLLOVER
*----------------------------------------------------
*Description: This routine is to update a concat table REDO.AZ.ROLLOVER
* which is used to update the Pool rate in Loan, for which this deposit is
* a Collateral.
*----------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES


    GOSUB OPEN.FILES
    GOSUB PROCESS.SELECT
    GOSUB PROCESS
RETURN
*----------------------------------------------------
OPEN.FILES:
*----------------------------------------------------

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT  = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.REDO.AZ.CONCAT.ROLLOVER = 'F.REDO.AZ.CONCAT.ROLLOVER'
    F.REDO.AZ.CONCAT.ROLLOVER  = ''
    CALL OPF(FN.REDO.AZ.CONCAT.ROLLOVER,F.REDO.AZ.CONCAT.ROLLOVER)

RETURN
*----------------------------------------------------
PROCESS.SELECT:
*----------------------------------------------------
    Y.LAST.WORKING.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    SEL.CMD = 'SELECT ':FN.AZ.ACCOUNT:' WITH MATURITY.DATE GT ':Y.LAST.WORKING.DATE:' AND MATURITY.DATE LE ':TODAY
    CALL EB.READLIST(SEL.CMD,SEL.AZ,'',NO.OF.REC,RET.CODE)

RETURN
*----------------------------------------------------
PROCESS:
*----------------------------------------------------
    IF NO.OF.REC THEN
        CALL OCOMO("No. of AZ Records selected - ":NO.OF.REC:" records")
    END ELSE
        CALL OCOMO("No Records selected")
        RETURN
    END
    R.REDO.AZ.CONCAT.ROLLOVER = SEL.AZ
    CALL F.WRITE(FN.REDO.AZ.CONCAT.ROLLOVER,TODAY,R.REDO.AZ.CONCAT.ROLLOVER)
RETURN
END
