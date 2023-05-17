SUBROUTINE REDO.V.INP.ACCT.REST.CHK
****************************************************************
*-------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : BHARATH C
* Program Name : REDO.V.INP.ACCT.REST.CHK
* ODR NUMBER : ODR-2009-10-0522
*-------------------------------------------------------------------------

* Description :This routine is triggered while creating a new product.It
*checks the customer related to account is a restricted customer or not
*If the customer is a restricted customer then will raise an error times

*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
*   $INSERT I_F.CUSTOMER

    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN
**********************************
INIT:
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''

    CUSTOMER.ERROR=''
    CUSTOMER.ID=''
    L.CU.LISTA.REST.POS=''
    L.CU.LISTA.REST.VAL=''

RETURN
**********************************
OPENFILE:
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL GET.LOC.REF('CUSTOMER','L.CU.LISTA.REST',L.CU.LISTA.REST.POS)

RETURN
*********************************
PROCESS:


    IF APPLICATION EQ 'ACCOUNT' THEN

        CUSTOMER.ID=R.NEW(AC.CUSTOMER)
        Y.JOINT.HOLDER = R.NEW(AC.JOINT.HOLDER)
        AF=AC.CUSTOMER
        IF R.NEW(AC.ARRANGEMENT.ID) THEN
            RETURN ;* We dont need to throw error for arrangement account. since error blocks the scheduled activities in COB.
        END
    END

    IF APPLICATION EQ 'AZ.ACCOUNT' THEN

        CUSTOMER.ID=R.NEW(AZ.CUSTOMER)
        AF=AZ.CUSTOMER
    END

    IF APPLICATION EQ 'AA.ARRANGEMENT.ACTIVITY' THEN

        CUSTOMER.ID=R.NEW(AA.ARR.ACT.CUSTOMER)
        AF=AA.ARR.ACT.CUSTOMER
    END

    R.CUSTOMER=''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERROR)
    L.CU.LISTA.REST.VAL=R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.LISTA.REST.POS>

    Y.TOT.JNT.HOLDER = DCOUNT(Y.JOINT.HOLDER,@VM)
    CHANGE @VM TO @FM IN Y.JOINT.HOLDER
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.TOT.JNT.HOLDER
        Y.STATUS = ''
        Y.JNT.CUS.ID =Y.JOINT.HOLDER<Y.CNT>
        CALL F.READ(FN.CUSTOMER,Y.JNT.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERROR)
        Y.STATUS = R.CUSTOMER<EB.CUS.CUSTOMER.STATUS>

        IF Y.STATUS EQ '3' THEN
            AF = AC.JOINT.HOLDER
            AV = Y.CNT
            ETEXT = 'EB-REDO.AC.DECESED'
            CALL STORE.END.ERROR

        END
        IF Y.STATUS EQ '4' THEN
            AF = AC.JOINT.HOLDER
            AV = Y.CNT
            ETEXT = 'EB-REDO.AC.CLOSED'
            CALL STORE.END.ERROR
        END

        Y.CNT += 1
    REPEAT

    IF L.CU.LISTA.REST.VAL EQ 'SI' THEN
        ETEXT='AA-REDO.CUST.RESTR'
        CALL STORE.END.ERROR
    END

RETURN
*********************
END
