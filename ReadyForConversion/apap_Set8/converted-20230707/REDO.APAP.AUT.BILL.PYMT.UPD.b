SUBROUTINE REDO.APAP.AUT.BILL.PYMT.UPD
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.AUT.BILL.PYMT.UPD
*--------------------------------------------------------------------------------------------------------
*Description       : This is an AUTHORISATION routine, the routine checks if the transaction type is
*                    BILL PAYMENTS then updates the table REDO.THIRDPRTY.PAYMENT with amount,
*                    contract no/bill number, company name, Bill type and Bill condition
*Linked With       : Version T24.FUND.SERVICES,REDO.MULTI.TXN
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : T24.FUND.SERVICES                   As          I       Mode
*                    CATEG.INT.ACCT                      As          I       Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
* Date            Who                   Reference                 Description
* ----            ---                   ---------                 ------------
* 19 July 2010    Shiva Prasad Y        ODR-2009-10-0318 B.126    Initial Creation
* 12 JULY 2013    Vignesh Kumaar M R    PACS00307024              SELECTION TO BE BASED ON THE COMPANY
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LOCKING
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.REDO.THIRDPRTY.PAYMENT
    $INSERT I_System

*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
    FN.LOCKING = 'F.LOCKING'
    F.LOCKING  = ''
    CALL OPF(FN.LOCKING,F.LOCKING)

    FN.REDO.THIRDPRTY.PAYMENT = 'F.REDO.THIRDPRTY.PAYMENT'
    F.REDO.THIRDPRTY.PAYMENT  = ''
    CALL OPF(FN.REDO.THIRDPRTY.PAYMENT,F.REDO.THIRDPRTY.PAYMENT)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    GOSUB FIND.MULTI.LOCAL.REF

    Y.TXN.CODES = R.NEW(TFS.TRANSACTION)
    CHANGE @VM TO @FM IN Y.TXN.CODES

    LOCATE 'BILLPAYMENTCASH' IN Y.TXN.CODES<1> SETTING Y.TXN.POS ELSE
        LOCATE 'BILLPAYMENTCHQ'  IN Y.TXN.CODES<1> SETTING Y.TXN.POS ELSE
            RETURN
        END
    END

    IF NOT(R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.CMPNY.ID.POS>) THEN
        RETURN
    END

    GOSUB CREATE.RTP.ID
    GOSUB UPDATE.RTP

RETURN
*--------------------------------------------------------------------------------------------------------
**************
CREATE.RTP.ID:
**************
* In this para of the code, LOCKING is read and a new RTP ID is created/Generated
    LOCKING.ID = 'F.REDO.THIRDPRTY.PAYMENT'
    GOSUB READ.LOCKING

    IF R.LOCKING THEN
        GOSUB GEN.NEW.ID
    END ELSE
        GOSUB CREATE.NEW.ID
    END

RETURN
*--------------------------------------------------------------------------------------------------------
***********
GEN.NEW.ID:
***********
* In this para of the code, we are generating a new ID for parameter fiel RTP
    Y.REMARK = R.LOCKING<EB.LOK.REMARK>

    IF NOT(R.LOCKING<EB.LOK.REMARK>) THEN
        R.LOCKING<EB.LOK.REMARK>  = TODAY
        GOSUB WRITE.LOCKING
        RETURN
    END

    IF TODAY GT R.LOCKING<EB.LOK.REMARK> THEN
        R.LOCKING<EB.LOK.REMARK>  = TODAY
        R.LOCKING<EB.LOK.CONTENT> = '0000'
        Y.MID.ID = '0000'
        GOSUB WRITE.LOCKING
        RETURN
    END

    IF TODAY EQ R.LOCKING<EB.LOK.REMARK> THEN
        R.LOCKING<EB.LOK.REMARK> = TODAY
        R.LOCKING<EB.LOK.CONTENT> = R.LOCKING<EB.LOK.CONTENT> + 1
        Y.MID.ID = R.LOCKING<EB.LOK.CONTENT>
        GOSUB WRITE.LOCKING
    END

RETURN
*--------------------------------------------------------------------------------------------------------
**************
CREATE.NEW.ID:
**************
* In this para of the code, we are creating a new ID for parameter fiel RTP
    R.LOCKING<EB.LOK.REMARK> = TODAY
    R.LOCKING<EB.LOK.CONTENT> = '0000'
    Y.MID.ID = '0000'
    GOSUB WRITE.LOCKING

RETURN
*--------------------------------------------------------------------------------------------------------
***********
UPDATE.RTP:
***********
* In this para of the code, the core fields are being populated
    REDO.THIRDPRTY.PAYMENT.ID = TODAY:FMT(Y.MID.ID,'R%4')
    GOSUB READ.REDO.THIRDPRTY.PAYMENT

    IF R.REDO.THIRDPRTY.PAYMENT THEN
        RETURN
    END

    R.REDO.THIRDPRTY.PAYMENT<TPT.BRANCH>      = R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.CMPNY.ID.POS>
    R.REDO.THIRDPRTY.PAYMENT<TPT.COMP.NAME>   = R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.CMPNY.NAME.POS>
    R.REDO.THIRDPRTY.PAYMENT<TPT.BILL.TYPE>   = R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.BILL.TYPE.POS>
    R.REDO.THIRDPRTY.PAYMENT<TPT.BILL.COND>   = R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.BILL.COND.POS>
    R.REDO.THIRDPRTY.PAYMENT<TPT.BILL.NUMBER> = R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.BILL.NUM.POS>
    IF R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.TXN.AMT.POS> THEN
        R.REDO.THIRDPRTY.PAYMENT<TPT.AMOUNT>      = R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.TXN.AMT.POS>
    END ELSE
        R.REDO.THIRDPRTY.PAYMENT<TPT.AMOUNT> = R.NEW(TFS.AMOUNT)<1,Y.TXN.POS>
    END

    R.NEW(TFS.OUR.REFERENCE) = REDO.THIRDPRTY.PAYMENT.ID

    GOSUB WRITE.REDO.THIRDPRTY.PAYMENT

RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.LOCKING:
*************
* In this para of the code, file LOCKING is read
    R.LOCKING  = ''
    LOCKING.ER = ''
    LOCKING.RT = ''
    CALL F.READU(FN.LOCKING,LOCKING.ID,R.LOCKING,F.LOCKING,LOCKING.ER,LOCKING.RT)

RETURN
*--------------------------------------------------------------------------------------------------------
****************************
READ.REDO.THIRDPRTY.PAYMENT:
****************************
* In this para of the code, file REDO.THIRDPRTY.PAYMENT is read
    R.REDO.THIRDPRTY.PAYMENT  = ''
    REDO.THIRDPRTY.PAYMENT.ER = ''
    CALL F.READ(FN.REDO.THIRDPRTY.PAYMENT,REDO.THIRDPRTY.PAYMENT.ID,R.REDO.THIRDPRTY.PAYMENT,F.REDO.THIRDPRTY.PAYMENT,REDO.THIRDPRTY.PAYMENT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
**************
WRITE.LOCKING:
**************
* In this para of the code, values are written to file LOCKING
    CALL F.WRITE(FN.LOCKING,LOCKING.ID,R.LOCKING)

RETURN
*--------------------------------------------------------------------------------------------------------
*****************************
WRITE.REDO.THIRDPRTY.PAYMENT:
*****************************
* In this para of the code, values are written to file REDO.THIRDPRTY.PAYMENT

* Fix for PACS00307024 [SELECTION TO BE BASED ON THE COMPANY]

    E.BACK = E
    GET.COMP.ID = System.getVariable("CURRENT.USER.BRANCH")


    IF GET.COMP.ID EQ "CURRENT.USER.BRANCH" THEN
        LOCATE 'EB-UNKNOWN.VARIABLE' IN E<1,1> SETTING POS THEN
            E = E.BACK
        END
        GET.COMP.ID = ID.COMPANY
    END

    R.RTP<TPT.PAY.COMPANY> = GET.COMP.ID

* End of Fix

    CALL F.WRITE(FN.REDO.THIRDPRTY.PAYMENT,REDO.THIRDPRTY.PAYMENT.ID,R.REDO.THIRDPRTY.PAYMENT)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'T24.FUND.SERVICES'
    FLD.ARRAY = 'L.TT.CMPNY.ID':@VM:'L.TT.CMPNY.NAME':@VM:'L.TT.BILL.TYPE':@VM:'L.TT.BILL.COND':@VM:'L.TT.BILL.NUM':@VM:'L.TFS.TXN.AMT'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.CMPNY.ID.POS    =  FLD.POS<1,1>
    LOC.L.TT.CMPNY.NAME.POS  =  FLD.POS<1,2>
    LOC.L.TT.BILL.TYPE.POS   =  FLD.POS<1,3>
    LOC.L.TT.BILL.COND.POS   = FLD.POS<1,4>
    LOC.L.TT.BILL.NUM.POS    = FLD.POS<1,5>
    LOC.L.TFS.TXN.AMT.POS    = FLD.POS<1,6>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of PRogram
