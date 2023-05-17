SUBROUTINE REDO.BL.GET.ARRANGEMENT(Y.FINAL.IDS)
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  :
* Program Name  : REDO.BLD.E.REPRINT.TXN
*-------------------------------------------------------------------------
* Description:To get the account id when arrangement id is given as well as the
*    account number is also given
*----------------------------------------------------------
*----------------------------------------------------------
* Linked with   : Enquiry REDO.AA.LOAN.OVERDUE.DET as selection field
* In parameter  : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
***********************************************************************
*DATE                WHO                   REFERENCE         DESCRIPTION
*19-05-2011        S.DHAMU              ODR-2010-01-0081    INITIAL CREATION
*
****************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS

    GOSUB OPEN
    GOSUB PROCESS
RETURN

****
OPEN:
****

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS  = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

RETURN

********
PROCESS:
********


    LOCATE '@ID' IN D.FIELDS SETTING POS1 THEN
        Y.ID = D.RANGE.AND.VALUE<POS1>
    END

    CALL F.READ(FN.AA.ARRANGEMENT,Y.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARRANGE.ERR)
    IF R.AA.ARRANGEMENT THEN
        Y.ARR.ID = Y.ID
    END ELSE
        CALL F.READ(FN.ACCOUNT,Y.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
        Y.ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
    END

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACC.ERR)
    Y.BILL.IDS    = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.BILL.STATUS = R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
    CHANGE @SM TO @FM IN Y.BILL.IDS
    CHANGE @VM TO @FM IN Y.BILL.IDS
    CHANGE @SM TO @FM IN Y.BILL.STATUS
    CHANGE @VM TO @FM IN Y.BILL.STATUS
    Y.BILLS.CNT = DCOUNT(Y.BILL.IDS,@FM)
    Y.FINAL.IDS = ''
    Y.VAR1 = 1
    Y.BILL.CNT = 1
    LOOP
    WHILE Y.VAR1 LE Y.BILLS.CNT
        IF Y.BILL.STATUS<Y.VAR1> EQ 'UNPAID' THEN
            Y.FINAL.IDS<-1> = Y.BILL.CNT:'*':Y.BILL.IDS<Y.VAR1>:'*': Y.ARR.ID
            Y.BILL.CNT += 1
        END
        Y.VAR1 += 1
    REPEAT
RETURN
END
