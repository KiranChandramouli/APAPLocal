SUBROUTINE REDO.FI.RECORD.TXN.DETAILS(R.PARAMS,IN.RESULT,IN.REF,OUT.ARRAY)
*************************************************************************************
*    Save records in REDO.FI.CONTROL
*    Parameters:
*        O.ERR.MSG:  Output parameter to send the ERROR message get in the process
*
* ===================================================================================
*
*    First Release :R9
*    Developed for :APAP
*    Developed by  :Ana Noriega
*    Date          :2010/Oct/25
*
*====================================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_REDO.FI.VARIABLES.COMMON
    $INSERT I_F.REDO.FI.CONTROL
    $INSERT I_F.FUNDS.TRANSFER
*
*=====================================================================================
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* ======
PROCESS:
* ======

    IF R.PARAMS<12> EQ 'ORANGE' THEN
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.ACCOUNT.NUMBER,-1>  = R.PARAMS<6>
        Y.ACCT.ID = R.PARAMS<6>
    END ELSE
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.ACCOUNT.NUMBER,-1>  = R.PARAMS<11>
        Y.ACCT.ID = R.PARAMS<11>
    END

    CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    IF R.ACCOUNT THEN
        Y.CUS.ID =  R.ACCOUNT<AC.CUSTOMER>
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.CUSTOMER.NUMBER,-1> = Y.CUS.ID
    END ELSE
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.CUSTOMER.NUMBER,-1> = ' '
    END

    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    IF R.CUSTOMER THEN
        Y.CUSTOMER.NAME = R.CUSTOMER<EB.CUS.NAME.1>
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.CUSTOMER.NAME,-1> = Y.CUSTOMER.NAME
    END ELSE
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.CUSTOMER.NAME,-1> = ' '
    END


    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TXN.AMOUNT,-1> = R.PARAMS<7>
    Y.TXN.REF = FIELD(IN.RESULT,'/',1)[1,2]
    IF Y.TXN.REF EQ 'FT' THEN
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.TXN.STATUS,-1>  = '01'
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.DESCRIPTION,-1> = 'OK'
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.FT.REFERENCE,-1>=IN.REF
    END ELSE
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.DESCRIPTION,-1>  = FIELD(IN.RESULT,@FM,1,1)
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.TXN.STATUS,-1>   = '04'
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.FT.REFERENCE,-1> = ' '
    END

*    OUT.ARRAY<-1> = Y.TXN.SEQUENCE.NO:'##':Y.ACCOUNT.NUMBER:'##':Y.CUSTOMER.NUMBER:'##':Y.CUSTOMER.NAME:'##':Y.TXN.AMOUNT:'##':Y.TXN.STATUS:'##':Y.DESCRIPTION:'##':Y.FT.REFERENCE

RETURN
* ---------
INITIALISE:
* ---------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    R.ACCOUNT  = ''

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    R.CUSTOMER = ''


RETURN
*
*
* ---------
OPEN.FILES:
* ---------
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN
*
END
