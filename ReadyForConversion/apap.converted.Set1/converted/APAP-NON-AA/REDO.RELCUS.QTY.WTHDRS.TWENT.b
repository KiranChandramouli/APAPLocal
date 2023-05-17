SUBROUTINE REDO.RELCUS.QTY.WTHDRS.TWENT(CUST.ID,WTHDRS.CNTR2)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* This is field format routine for the deal slip to return counter of withdrawal under a range
* Input/Output:
*--------------
* IN :CUSTOMER.ID
* OUT : WTHDRS.CNTR
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
*************
INIT:
*************
    CUS.ID = CUST.ID

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    CALL GET.LOC.REF('ACCOUNT','L.AC.QTY.WITHDR',QTY.WTHDR.POS)
    WTHDRS.CNTR2 =''
RETURN
*********
PROCESS:
*********
*
    SEL.CMD = "SELECT ":FN.CUSTOMER.ACCOUNT:" WITH CUSTOMER.CODE EQ ":CUS.ID
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)
    LOOP
        REMOVE ACC.ID FROM SEL.LIST SETTING POS
    WHILE ACC.ID:POS
        CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        IF R.ACCOUNT THEN
            IF R.ACCOUNT<AC.LOCAL.REF><1,QTY.WTHDR.POS> EQ '11-25' THEN

                WTHDRS.CNTR2 + = 1

            END
        END ELSE
            WTHDRS.CNTR2 =''
        END

    REPEAT
RETURN
***********
END
