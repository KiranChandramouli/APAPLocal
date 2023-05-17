SUBROUTINE REDO.RELCUS.QTY.WTHDRS.ONE(CUST.ID,WTHDRS.CNTR1,WTHDRS.CNTR2,WTHDRS.CNTR3,WTHDRS.CNTR)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* This is field format routine for the deal slip to return count of withdrawal under a range
* Input/Output:
*--------------
* IN :CUSTOMER.ID
* OUT : WTHDRS.CNTR
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
*************
INIT:
*************
    CUS.ID = CUST.ID
    CNT = ''
    WTHDRS.CNTR1 = '' ; WTHDRS.CNTR2 = '' ; WTHDRS.CNTR3 = '' ; WTHDRS.CNTR = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''

    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL GET.LOC.REF('ACCOUNT','L.AC.QTY.WITHDR',QTY.WTHDR.POS)
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
        CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        IF R.ACCOUNT THEN
            IF R.ACCOUNT<AC.LOCAL.REF><1,QTY.WTHDR.POS> EQ '0-10' THEN
                WTHDRS.CNTR1 + = 1
            END
            IF R.ACCOUNT<AC.LOCAL.REF><1,QTY.WTHDR.POS> EQ '11-25' THEN
                WTHDRS.CNTR2 + = 1
            END
            IF R.ACCOUNT<AC.LOCAL.REF><1,QTY.WTHDR.POS> EQ '26-50' THEN
                WTHDRS.CNTR3 + = 1
            END
            IF R.ACCOUNT<AC.LOCAL.REF><1,QTY.WTHDR.POS> EQ '51-MORE' THEN
                WTHDRS.CNTR + = 1
            END
        END
        INC +=1
    REPEAT
RETURN
END
