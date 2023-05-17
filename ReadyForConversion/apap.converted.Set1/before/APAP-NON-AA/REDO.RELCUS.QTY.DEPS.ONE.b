*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.RELCUS.QTY.DEPS.ONE(CUST.ID,DEP.CNTR,TWENT.CNTR,FIFTY.CNTR,MORE.CNTR)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* Input/Output:
*--------------
* IN :CUSTOMER.ID
* OUT : DEP.CNTR
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
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
CNT = ''
FN.ACCOUNT = 'F.ACCOUNT'
F.ACCOUNT = ''
FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
F.CUSTOMER.ACCOUNT = ''

CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
CALL OPF(FN.ACCOUNT,F.ACCOUNT)

CALL GET.LOC.REF('ACCOUNT','L.AC.QTY.DEPOS',QTY.DEP.POS)
DEP.CNTR = ''
RETURN
*********
PROCESS:
*********
CUS.ID = CUST.ID
CALL F.READ(FN.CUSTOMER.ACCOUNT,CUS.ID,R.CUST,F.CUSTOMER.ACCOUNT,CUST.ERR)
CNT = DCOUNT(R.CUST,FM)
INC = 1
LOOP
WHILE INC LE CNT
ACC.ID = R.CUST<INC>
CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
IF R.ACCOUNT THEN
IF R.ACCOUNT<AC.LOCAL.REF><1,QTY.DEP.POS> EQ '0-10' THEN
DEP.CNTR + = 1
END
IF R.ACC<AC.LOCAL.REF><1,QTY.DEP.POS> EQ '11-25' THEN
TWENT.CNTR + = 1
END

IF R.ACCOUNT<AC.LOCAL.REF><1,QTY.DEP.POS> EQ '26-50' THEN
FIFTY.CNTR + = 1
END
IF R.ACCOUNT<AC.LOCAL.REF><1,QTY.DEP.POS> EQ '51- MORE' THEN
MORE.CNTR + = 1
END
END
INC +=1
REPEAT
RETURN
END
