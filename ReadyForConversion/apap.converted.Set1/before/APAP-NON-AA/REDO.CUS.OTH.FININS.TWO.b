*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CUS.OTH.FININS.TWO(CUST.ID,OTH.FIN2)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* This is field format routine for the pdf generation form of KYC to return second multivalue field
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
*   Date               who               Reference            Description
* 28-DEC-2009          B.Renugadevi     ODR-2010-04-0425     Initial Creation
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
PROCESS:
***************

  CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)

  IF R.CUSTOMER THEN

    IF R.CUSTOMER<EB.CUS.OTHER.FIN.INST,2> NE '' THEN

      OTH.FIN2=R.CUSTOMER<EB.CUS.OTHER.FIN.INST,2>

    END ELSE
      OTH.FIN2=''
    END
  END

  RETURN
END
