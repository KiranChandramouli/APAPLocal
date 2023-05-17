*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.V.AUTH.DEAL.PRINT
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2009-10-0547
* This is the authorisation routine to choose which deal slip to be triggered

* Revision History:
*------------------------------------------------------------------------------------------
* Date who Reference Description
* 28-Dec-2009 SHANKAR RAJU Initial Creation
*------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.DEAL.SLIP.FORMAT
$INSERT I_GTS.COMMON

GOSUB INIT
GOSUB PROCESS
RETURN

*************
INIT:
*************
CUST.ID=ID.NEW
FN.CUSTOMER='F.CUSTOMER'
F.CUSTOMER=''
LREF.FLD="L.CU.TIPO.CL"

CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN

*********
PROCESS:
*********



CALL GET.LOC.REF('CUSTOMER',LREF.FLD,TIPO.POS)

OFS$DEAL.SLIP.PRINTING = 1
V$FUNCTION = "A"
SAVE.APPLICATION = APPLICATION
APPLICATION = "CUSTOMER"


IF R.NEW(EB.CUS.LOCAL.REF)<1,TIPO.POS> EQ 'PERSONA FISICA' THEN

CALL PRODUCE.DEAL.SLIP("CUS.KYC.FORM.1")

END
IF R.NEW(EB.CUS.LOCAL.REF)<1,TIPO.POS> EQ 'PERSONA JURIDICA' THEN

CALL PRODUCE.DEAL.SLIP("CUS.KYC.FORM.2")

END


RETURN
**************
END
