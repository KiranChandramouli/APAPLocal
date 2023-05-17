SUBROUTINE REDO.CUS.OTH.FININS.FOUR(CUST.ID,OTH.FIN4)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* This is field format routine for the deal slip to return forth multivalue field
* of OTH.FIN.INST
* Input/Output:
*--------------
* IN :CUSTOMER.ID
* OUT : OTH.FIN
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 28-DEC-2009       SHANKAR RAJU    ODR-2010-04-0425      Initial Creation
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    GOSUB INIT
    GOSUB PROCESS
RETURN
*************
INIT:
*************
    CUS.ID = CUST.ID

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''

    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN
****************
****************
PROCESS:
***************

    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)

    IF R.CUSTOMER THEN

        IF R.CUSTOMER<EB.CUS.OTHER.FIN.INST,4> NE '' THEN

            OTH.FIN4=R.CUSTOMER<EB.CUS.OTHER.FIN.INST,4>

        END ELSE
            OTH.FIN4=''
        END
    END

RETURN
END
