*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.RELCUS.QTY.DEPS.FIFTY(CUST.ID,FIFTY.CNTR)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* This is field format routine for the deal slip to return count of deposit under a range
* Input/Output:
*--------------
* IN :CUSTOMER.ID
* OUT : FIFTY.CNTR
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
******
INIT:
******
CUS.ID = CUST.ID
FN.ACCOUNT = 'F.ACCOUNT'
F.ACCOUNT = ''
FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
F.CUSTOMER.ACCOUNT = ''

CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
CALL OPF(FN.ACCOUNT,F.ACCOUNT)

CALL GET.LOC.REF('ACCOUNT','L.AC.QTY.DEPOS',QTY.DEP.POS)
FIFTY.CNTR = ''
RETURN
*********
PROCESS:
*********
SEL.CMD = "SELECT ":FN.CUSTOMER.ACCOUNT:" WITH CUSTOMER.CODE EQ ":CUS.ID
CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)
LOOP
REMOVE ACC.ID FROM SEL.LIST SETTING POS
WHILE ACC.ID:POS
CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
IF R.ACCOUNT THEN
IF R.ACCOUNT<AC.LOCAL.REF><1,QTY.DEP.POS> EQ '26-50' THEN
FIFTY.CNTR + = 1
END
END ELSE
FIFTY.CNTR = ''
END
REPEAT
RETURN
END
