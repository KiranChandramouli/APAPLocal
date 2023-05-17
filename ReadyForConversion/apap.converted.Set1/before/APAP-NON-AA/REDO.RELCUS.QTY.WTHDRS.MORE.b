*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.RELCUS.QTY.WTHDRS.MORE(CUST.ID,WTHDRS.CNTR)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
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
WTHDRS.CNTR=''
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
IF R.ACCOUNT<AC.LOCAL.REF><1,QTY.WTHDR.POS> EQ '51-MORE' THEN

WTHDRS.CNTR + = 1

END
END ELSE
WTHDRS.CNTR=''
END

REPEAT
RETURN
***********
END
