$PACKAGE APAP.AA ;*MANUAL R22 CODE CONVERSION
SUBROUTINE REDO.V.VAL.DD.CATEG
 
*-----------------------------------------------------------------------------------
* Modification History: 
* DATE                 WHO                  REFERENCE                    DESCRIPTION
* 29/03/2023         SURESH      MANUAL R22 CODE CONVERSION        Package Name added APAP.AA
* 29/03/2023         Conversion Tool      AUTO R22 CODE CONVERSION        VM TO @VM,FM TO @FM,CALL F.READ TO  CALL CACHE.READ, CNT ++ TO CNT += 1 
*-----------------------------------------------------------------------------------
* Subroutine Type : ROUTINE
* Attached to     : ACC.TO.DEBIT field
* Attached as     : ROUTINE
* Primary Purpose : Validate if the account chosed belongs to client or it is not.
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  :  Edwin Charles D
* Date            :  23 Nov 2017
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.AA.DD.CATEGORY
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_AA.LOCAL.COMMON

    IF c_aalocActivityStatus MATCHES 'AUTH':@VM:'AUTH-REV' THEN ;*AUTO R22 CODE CONVERSION 
        RETURN
    END

    GOSUB INIT
    GOSUB PROCESS

RETURN          ;* Program RETURN

PROCESS:
*-------
    Y.DEBIT.ACCT.NO = ''
    Y.DEBIT.ACCT.NO = R.NEW(AA.PS.LOCAL.REF)<1,Y.POS.DD.1>

    Y.FROM.CAT.LIST = R.REDO.AA.DD.CATEGORY<DD.CT.FROM.CATEGORY>
    Y.TO.CAT.LIST = R.REDO.AA.DD.CATEGORY<DD.CT.TO.CATEGORY>

    IF NOT(Y.FROM.CAT.LIST) THEN
        ETEXT = 'EB-ACCT.NOT.DD.CATEGORY'
        CALL STORE.END.ERROR
        RETURN
    END

    IF Y.DEBIT.ACCT.NO THEN
        CHANGE @VM TO @FM IN Y.FROM.CAT.LIST ;*AUTO R22 CODE CONVERSION
        CHANGE @VM TO @FM IN Y.TO.CAT.LIST ;*AUTO R22 CODE CONVERSION
        Y.ACCT.CATEG = '' ; R.ACCOUNT = ''; ACC.ERR = '' ; Y.DD.CUSTOMER = '' ; Y.DD.JOINT.HOLDER = '' ; Y.DD.RELATION.CODE = ''
        CALL F.READ(FN.ACCOUNT,Y.DEBIT.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        Y.ACCT.CATEG = R.ACCOUNT<AC.CATEGORY>
        Y.DD.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
        Y.TOT.CAT.CNT = DCOUNT(Y.FROM.CAT.LIST, @FM)
        PROCESS.GOAHEAD = ''
        CNT = 1
        LOOP
        WHILE CNT LE Y.TOT.CAT.CNT
            GOSUB CHECK.CATEGORY.RANGE
            CNT += 1
        REPEAT

        IF NOT(PROCESS.GOAHEAD) THEN
            ETEXT = 'EB-ACCT.NOT.DD.CATEGORY'
            CALL STORE.END.ERROR
            RETURN
        END

        IF Y.LOAN.CUSTOMER NE Y.DD.CUSTOMER THEN
            GOSUB GET.SAVINGS.RELATION
            GOSUB GET.LOAN.CUST.RELATION
            GOSUB RAISE.OVERRIDE
        END
    END

RETURN

CHECK.CATEGORY.RANGE:
*-------------------

    BEGIN CASE

        CASE Y.ACCT.CATEG EQ Y.FROM.CAT.LIST<CNT> OR (Y.TO.CAT.LIST<CNT> AND Y.ACCT.CATEG EQ Y.TO.CAT.LIST<CNT>)
            PROCESS.GOAHEAD = '1'
        CASE Y.ACCT.CATEG GT Y.FROM.CAT.LIST<CNT> AND Y.ACCT.CATEG LT Y.TO.CAT.LIST<CNT>
            PROCESS.GOAHEAD = '1'
        CASE 1

    END CASE

RETURN

GET.SAVINGS.RELATION:
*-------------------

    R.CUSTOMER.ACCOUNT = '' ; Y.DD.JOINT.HOLDER.LIST = '' ; Y.DD.RELATION.CODE.LIST = ''
    CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.DD.CUSTOMER,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,CUS.ACC.ERR)

    Y.DD.JOINT.HOLDER.LIST<1, -1> = Y.DD.CUSTOMER

    IF R.CUSTOMER.ACCOUNT THEN
        TOT.ACCT.CNT = DCOUNT(R.CUSTOMER.ACCOUNT, @FM) ;*AUTO R22 CODE CONVERSION
        CNT = 1
        LOOP
        WHILE CNT LE TOT.ACCT.CNT
            Y.ACCT = R.CUSTOMER.ACCOUNT<CNT>
            CALL F.READ(FN.ACCOUNT,Y.ACCT,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
            Y.DD.JOINT.HOLDER.LIST<1, -1> = R.ACCOUNT<AC.JOINT.HOLDER>
            Y.DD.RELATION.CODE.LIST<1, -1> = R.ACCOUNT<AC.RELATION.CODE>
            CNT += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
    END

RETURN

GET.LOAN.CUST.RELATION:
*----------------------
    RAISE.OVERRIDE = ''
    R.CUSTOMER.ACCOUNT = '' ; Y.LN.JOINT.HOLDER.LIST = '' ; Y.LN.RELATION.CODE.LIST = ''
    CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.LOAN.CUSTOMER,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,CUS.ACC.ERR)

    IF R.CUSTOMER.ACCOUNT THEN
        TOT.ACCT.CNT = DCOUNT(R.CUSTOMER.ACCOUNT, @FM);*AUTO R22 CODE CONVERSION
        CNT = 1
        LOOP
        WHILE CNT LE TOT.ACCT.CNT
            Y.ACCT = R.CUSTOMER.ACCOUNT<CNT>
            CALL F.READ(FN.ACCOUNT,Y.ACCT,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
            Y.LN.JOINT.HOLDER = R.ACCOUNT<AC.JOINT.HOLDER>
            Y.LN.RELATION.CODE = R.ACCOUNT<AC.RELATION.CODE>
            GOSUB VALIDATE.RELATION.CODE
            CNT += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
    END

RETURN

VALIDATE.RELATION.CODE:
*----------------------
    Y.DD.RELATION.CODE = Y.DD.RELATION.CODE.LIST<1,1>
    BEGIN CASE
* NULL / OR condition
        CASE NOT(Y.LN.JOINT.HOLDER) OR (Y.LN.JOINT.HOLDER AND Y.LN.RELATION.CODE EQ '501')
            IF Y.LOAN.CUSTOMER MATCHES Y.DD.JOINT.HOLDER.LIST AND Y.DD.RELATION.CODE EQ '501' THEN
                RAISE.OVERRIDE = '1'
            END ELSE
            END
* AND / AND condition
        CASE Y.LN.RELATION.CODE EQ '500' AND Y.DD.RELATION.CODE EQ '500'
            IF Y.LOAN.CUSTOMER MATCHES Y.DD.JOINT.HOLDER.LIST AND Y.LN.JOINT.HOLDER MATCHES Y.DD.JOINT.HOLDER.LIST THEN
                RAISE.OVERRIDE = '1'
            END ELSE
            END
* AND / OR condition
        CASE Y.LN.RELATION.CODE EQ '500' AND Y.DD.RELATION.CODE EQ '501'
            IF Y.LOAN.CUSTOMER MATCHES Y.DD.JOINT.HOLDER.LIST OR Y.LN.JOINT.HOLDER MATCHES Y.DD.JOINT.HOLDER.LIST THEN
                RAISE.OVERRIDE = '1'
            END ELSE
            END
*   AND / NULL condition
        CASE Y.LN.RELATION.CODE EQ '500' AND NOT(Y.DD.RELATION.CODE)
            IF Y.LOAN.CUSTOMER MATCHES Y.DD.JOINT.HOLDER.LIST OR Y.LN.JOINT.HOLDER MATCHES Y.DD.JOINT.HOLDER.LIST THEN
                RAISE.OVERRIDE = '1'
            END ELSE
            END
* remaining condition
        CASE 1

    END CASE

RETURN

RAISE.OVERRIDE:
*--------------

    IF NOT(RAISE.OVERRIDE) THEN
        CURR.NO = DCOUNT(R.NEW(AA.ARR.ACT.OVERRIDE),@VM) ;*AUTO R22 CODE CONVERSION
        TEXT = 'AA-CUSTOMER.SHOULD.APPROVE.PROCEED'
        CALL STORE.OVERRIDE(CURR.NO+1)
    END

RETURN

INIT:
*-----

    FN.REDO.AA.DD.CATEGORY = 'F.REDO.AA.DD.CATEGORY'
    F.REDO.AA.DD.CATEGORY = ''
    CALL OPF(FN.REDO.AA.DD.CATEGORY, F.REDO.AA.DD.CATEGORY)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT, F.CUSTOMER.ACCOUNT)

    CALL CACHE.READ(FN.REDO.AA.DD.CATEGORY, 'SYSTEM', R.REDO.AA.DD.CATEGORY, DD.CATEG.ERR) ;*AUTO R22 CODE CONVERSION

    Y.POS.DD.1 = ''
    Y.APPL = 'AA.PRD.DES.PAYMENT.SCHEDULE'
    Y.FLD = 'L.AA.DEBT.AC'
    POS.D = ''
    CALL MULTI.GET.LOC.REF(Y.APPL,Y.FLD,POS.D)
    Y.POS.DD.1 = POS.D<1,1>
    Y.LOAN.CUSTOMER = ''
    Y.LOAN.CUSTOMER = c_aalocArrActivityRec<AA.ARR.ACT.CUSTOMER>
RETURN
*------------
PROGRAM.EXIT:

END