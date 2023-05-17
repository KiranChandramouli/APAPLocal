SUBROUTINE REDO.ROU.CONTEXT.AZ.METHOD(Y.FIN.ARR)
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: NOFILE ROUTINE
*------------
*DESCRIPTION:
*------------
* This nofile routine will be attached to the enquiry REDO.ROU.CONTEXT.AZ.METHOD.ENQ.
*
*---------------------------------------------------------------------------
* Input / Output
*----------------
*
* Input / Output
* IN     : -na-
* OUT    : Y.FIN.ARR
*
*------------------------------------------------------------------------------------------------------------
* Revision History
* Date           Who                Reference              Description
* 09-SEP-2011   Marimuthu S        PACS00121111
*------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.MTS.DISBURSE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AZ.ACCOUNT


MAIN:

    GOSUB PROCESS
    GOSUB PGM.END

PROCESS:


    FN.REDO.MTS.DISBURSE = 'F.REDO.MTS.DISBURSE'
    F.REDO.MTS.DISBURSE = ''
    CALL OPF(FN.REDO.MTS.DISBURSE,F.REDO.MTS.DISBURSE)

    APPLN = 'AZ.ACCOUNT'
    FLD = 'L.AZ.METHOD.PAY'
    CALL MULTI.GET.LOC.REF(APPLN,FLD,POSS)
    Y.PAY.POS = POSS<1,1>


    Y.CUS.ID = R.NEW(AZ.CUSTOMER)
    Y.PRINC.AMT = R.NEW(AZ.PRINCIPAL)
    Y.MET.PAY = R.NEW(AZ.LOCAL.REF)<1,Y.PAY.POS>

    IF Y.MET.PAY EQ 'FROM.DISBURSEMENT' THEN
        SEL.CMD = 'SELECT ':FN.REDO.MTS.DISBURSE:' WITH CUSTOMER.NO EQ ':Y.CUS.ID:' AND AMOUNT EQ ':Y.PRINC.AMT:' AND AZ.ACCT.STATUS EQ AUTHORISED AND BRANCH.ID EQ ':ID.COMPANY
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

        LOOP
            REMOVE Y.ID FROM SEL.LIST SETTING POS.SS
        WHILE Y.ID:POS.SS
            CALL F.READ(FN.REDO.MTS.DISBURSE,Y.ID,R.REDO.MTS.DISBURSE,F.REDO.MTS.DISBURSE,MTS.ERR)
            Y.FIN.ARR<-1> = R.REDO.MTS.DISBURSE<MT.ARRANGEMENT.ID>:'*':R.REDO.MTS.DISBURSE<MT.CUSTOMER.NO>:'*':R.REDO.MTS.DISBURSE<MT.AMOUNT>:'*':R.REDO.MTS.DISBURSE<MT.CURRENCY>
        REPEAT
    END

RETURN

PGM.END:


END
