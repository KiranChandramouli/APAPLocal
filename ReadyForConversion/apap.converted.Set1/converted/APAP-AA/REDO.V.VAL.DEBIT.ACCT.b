SUBROUTINE REDO.V.VAL.DEBIT.ACCT
*------------------------------------------------------------------------------
*Company Name: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program Name: REDO.V.VAL.DEBIT.ACCT
*----------------------------------------------------------------------------------------------------------------------------
* DESCRIPTION:
*----------------------------------------------------------------------------------------------------------------------------
*           This is a validation routine, when user selected payment method as direct debit
* the system should allow to input debit account number which should be a loan customer account and
*continue the transaction.If the payment method is not direct debit then user cannot input data in debit account
*----------------------------------------------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*----------------------------------------------------------------------------------------------------------------------------
*  DATE             WHO         REFERENCE            DESCRIPTION
* 21-06-2010      PREETHI.MD   ODR-2009-10-0326 N.3  INITIAL CREATION
*
*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.CUSTOMER.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS1
    GOSUB PROCESS2
    GOSUB PROCESS3
RETURN

*------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------
* INITIALISE THE VARIABLES

    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT=''
    R.CUSTOMER.ACCOUNT=''

    ARR.ID=c_aalocArrId
    EFF.DATE=TODAY
    PROP.CLASS='CUSTOMER'
    PROPERTY=''
    R.CONDITION=''
    ERR.MSG=''
    Y.ACCT.FLAG='N'

    APPL.ARRAY="AA.PRD.DES.PAYMENT.SCHEDULE"
    FLD.ARRAY='L.AA.PAY.METHD':@VM:'L.AA.DEBT.AC'
    FLD.POS=''

RETURN
*------------------------------------------------------------------------------
PROCESS1:
*------------------------------------------------------------------------------

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    Y.PAYMETHD.POS=FLD.POS<1,1>
    Y.DEBITAC.POS=FLD.POS<1,2>

    IF V$FUNCTION EQ 'I' THEN
        IF R.NEW(AA.PS.LOCAL.REF)<1,Y.PAYMETHD.POS> NE "Direct Debit" THEN

            IF R.NEW(AA.PS.LOCAL.REF)<1,Y.DEBITAC.POS> NE "" THEN
                AF=AA.PS.LOCAL.REF
                AV=Y.DEBITAC.POS
                ETEXT="AA-DEBIT.AC"
                CALL STORE.END.ERROR
            END
        END
    END
RETURN
*--------------------------------------------------------------------------------------
PROCESS2:
*--------------------------------------------------------------------------------------------
    IF V$FUNCTION EQ 'I' THEN
        IF R.NEW(AA.PS.LOCAL.REF)<1,Y.PAYMETHD.POS> EQ "Direct Debit" THEN

            IF R.NEW(AA.PS.LOCAL.REF)<1,Y.DEBITAC.POS> EQ "" THEN
                AF=AA.PS.LOCAL.REF
                AV=Y.DEBITAC.POS
                ETEXT="AA-DEBIT.AC.MAND"
                CALL STORE.END.ERROR
            END

        END
    END
RETURN
*---------------------------------------------------------------------------------------------------------------
PROCESS3:
*---------------------------------------------------------------------------------------------------------------
*TUS change IF condition
    IF R.NEW(AA.PS.LOCAL.REF)<1,Y.DEBITAC.POS> NE '' AND NOT(ETEXT) THEN
        CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
        Y.CUS.ID=DCOUNT(R.CONDITION<AA.CUS.OWNER>,@VM)

        FOR Y.INITIAL=1 TO Y.CUS.ID


            CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
            CALL F.READ(FN.CUSTOMER.ACCOUNT,R.CONDITION<AA.CUS.OWNER><Y.INITIAL>,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,Y.ERR)
            Y.ACCT.LIST=R.CUSTOMER.ACCOUNT

            LOOP
                REMOVE Y.ACCT.ID FROM Y.ACCT.LIST SETTING POS1
            WHILE Y.ACCT.ID:POS1 DO
                IF R.NEW(AA.PS.LOCAL.REF)<1,Y.DEBITAC.POS> EQ Y.ACCT.ID THEN
                    Y.ACCT.FLAG='Y'
                END
            REPEAT

        NEXT Y.INITIAL

        IF V$FUNCTION EQ 'I' THEN
            IF Y.ACCT.FLAG EQ 'N' THEN
                TEXT = "AA.PAY.DEBIT.ACCT"
                CURR.NO = DCOUNT(R.NEW(AA.PS.OVERRIDE),@VM)
                CALL STORE.OVERRIDE(CURR.NO+1)
            END
        END
    END
RETURN

END
