SUBROUTINE REDO.IDENTITY.NUMBER(CUST.ID,ID.NUM)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* This is field format routine for the generation of KYC.It will intake the ACCOUNT number
* and sends out the ID.NUM of the customer
* Input/Output:
*--------------
* IN : ACCOUNT.ID
* OUT : -NA-
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
* Revision History:
*------------------
* Date who Reference Description
* 25-Nov-2009 B Renugadevi ODR-2010-04-0425 Initial Creation
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS
RETURN
******
INIT:
******
    CUS.ID = CUST.ID
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL GET.LOC.REF('CUSTOMER','L.CU.CIDENT',CIDENT.POS)

RETURN

********
PROCESS:
********

    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF R.CUSTOMER THEN
        IF R.CUSTOMER<EB.CUS.LOCAL.REF><1,CIDENT.POS> NE '' THEN
            ID.NUM = R.CUSTOMER<EB.CUS.LOCAL.REF><1,CIDENT.POS>
        END ELSE
            ID.NUM = R.CUSTOMER<EB.CUS.LEGAL.ID>
        END
    END
RETURN
END
