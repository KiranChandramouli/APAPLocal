SUBROUTINE REDO.V.VAL.LOAN.ACC
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.CUST.CREDIT
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is the input routine to validate the credit and debit accounts
*
*
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2010-08-0031   Initial Creation
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_System
    GOSUB INIT
RETURN
*---
INIT:
*---
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    Y.VAR.ACC.NO = R.NEW(FT.CREDIT.ACCT.NO)
    CALL F.READ(FN.ACCOUNT,Y.VAR.ACC.NO,R.ACCOUNT,F.ACCOUNT,ERR)

    GOSUB CHECK.CUSTOMER


RETURN
*--------------
CHECK.CUSTOMER:
*--------------
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.CUSTOMER =System.getVariable('EXT.SMS.CUSTOMERS')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            Y.CUSTOMER = ""
        END
        IF Y.CUSTOMER NE R.ACCOUNT<AC.CUSTOMER> AND R.ACCOUNT<AC.ARRANGEMENT.ID> EQ '' THEN
            ETEXT ='EB-INVALID.ACCT'
            CALL STORE.END.ERROR
        END
    END
RETURN
END
*---------------------------------------------*END OF SUBROUTINE*-------------------------------------------
