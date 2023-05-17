SUBROUTINE REDO.RELCUS.TOT.WITHDR(CUST.ID,TOT.WDR)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* Input/Output:
*--------------
* IN :CUSTOMER.ID
* OUT : TOTAL.WITHDRAWLS
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
* Revision History:
*------------------------------------------------------------------------------------------
* Date who Reference Description
* 25-Nov-2009 B Renugadevi ODR-2010-04-0425 Initial Creation
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS
RETURN
******
INIT:
*******
    CUS.ID = CUST.ID
    CNT = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''

    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL GET.LOC.REF('ACCOUNT','L.AC.TOT.WITHDR',TOT.WDR.POS)
    TOT.WDR = ''
RETURN
*********
PROCESS:
*********
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
        TOT.WDR + = R.ACCOUNT<AC.LOCAL.REF><1,TOT.WDR.POS>
    END
* TOT.WDR = FMT(TOT.WDR,"L2#100")
RETURN
END
