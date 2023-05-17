SUBROUTINE REDO.CUS.PRD.ACCT.NUM(CUST.ID,PRODUCT.CODE)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* Input/Output:
*--------------
* IN :CUSTOMER.ID
* OUT : PROD.ACCT.NO1
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 28-DEC-2009       B Renugadevi     ODR-2010-04-0425     Initial Creation
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER.ACCOUNT
    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****

    PRODUCT.CODE   = ''
    PROD.CODES     = ''
    CNT            = 0
    CUS.ID         = CUST.ID
    NO.OF.ACC      = ''

    FN.ACCOUNT     = 'F.ACCOUNT'
    F.ACCOUNT      = ''
    FN.CUSTOMER.ACCOUNT  = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT   = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.CUSTOMER.ACCOUNT, F.CUSTOMER.ACCOUNT)
RETURN
********
PROCESS:
********
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
    CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACC,F.ACCOUNT,ACC.ERR)
    IF R.ACC THEN
        PROD.CODE = R.ACC<AC.CATEGORY>
        ACCT.CODE = ACC.ID
        PRODUCT.CODE<-1> = PROD.CODE:":":ACCT.CODE:"@"
    END
RETURN
END
