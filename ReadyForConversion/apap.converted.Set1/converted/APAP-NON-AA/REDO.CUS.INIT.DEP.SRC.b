SUBROUTINE REDO.CUS.INIT.DEP.SRC(CUST.ID,DEPOSIT.SOURCE)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* This is field format routine for the pdf form CUS.KYC.FORM
* Input/Output:
*--------------
* IN :CUSTOMER.ID
* OUT : DEPOSIT.SOURCE1
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------------------------------------------------------------------------------
* Date who Reference Description
* 28-DEC-2009 B Renugadevi ODR-2010-04-0425 Initial Creation
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER.ACCOUNT
    GOSUB INIT
    GOSUB PROCESS
RETURN
*
******
INIT:
******
    CNT = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    DEPOSIT.SOURCE = ''
    DEPOSIT.CODE = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL GET.LOC.REF('ACCOUNT','L.AC.SRCINITDEP',L.DEP.POS)


    CUS.ID = CUST.ID
RETURN
********
PROCESS:
********
*
    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUS.ID,R.CUST,F.CUSTOMER.ACCOUNT,CUST.ERR)
    CNT = DCOUNT(R.CUST,@FM)
    INC = 1
    LOOP
    WHILE INC LE CNT
        ACC.ID = R.CUST<INC>
        GOSUB READ.VALUES
        INC +=1
    REPEAT
RETURN
************
READ.VALUES:
************
    CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT THEN
        DEP.CODE = R.ACCOUNT<AC.LOCAL.REF,L.DEP.POS>
        ACCT.CODE = ACC.ID
        DEPOSIT.SOURCE<-1> = ACCT.CODE:":":DEP.CODE:"@"
    END
RETURN
END
