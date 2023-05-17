*-----------------------------------------------------------------------------
* <Rating>80</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.RE.GET.LOAN.STAT(CUSTOMER.IDENTITY)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached to EB.CONTEXT to get the loan paid percentage.
*-------------------------------------------------------------------------
* HISTORY:
*---------
* Date who Reference Description

* 24-AUG-2011 SHANKAR RAJU ODR-2011-07-0162 Initial Creation
*-------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER.ACCOUNT
$INSERT I_F.AA.OVERDUE

GOSUB OPEN.FILES
GOSUB PROCESS

RETURN

OPEN.FILES:
*----------

FN.ACCOUNT = 'F.ACCOUNT'
F.ACCOUNT = ''
R.ACCOUNT = ''
CALL OPF(FN.ACCOUNT,F.ACCOUNT)

FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
F.CUSTOMER.ACCOUNT = ''
R.CUSTOMER.ACCOUNT = ''
CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

LR.APP = 'AA.PRD.DES.OVERDUE'
LR.FLDS = 'L.LOAN.COND'
LR.POS = ''
CALL GET.LOC.REF(LR.APP,LR.FLDS,OD.LOAN.COND.POS)

RETURN

PROCESS:
*-------
CALL F.READ(FN.CUSTOMER.ACCOUNT,CUSTOMER.IDENTITY,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,ERR.CUS.ACC)

IF R.CUSTOMER.ACCOUNT THEN

TOT.ACC = DCOUNT(R.CUSTOMER.ACCOUNT,FM)

LOOP.VAR = 1
LOOP

WHILE LOOP.VAR LE TOT.ACC
Y.ACCT.NO = R.CUSTOMER.ACCOUNT<LOOP.VAR>
CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR)
ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
IF ARR.ID THEN
PROP.CLASS = 'OVERDUE'
PROPERTY = ''
R.Condition = ''
ERR.MSG = ''
EFF.DATE = ''
CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
LOAN.COND = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>

IF LOAN.COND NE 'Legal' THEN
CUSTOMER.IDENTITY = 1
RETURN
END ELSE
CUSTOMER.IDENTITY = 0
END
END ELSE
CUSTOMER.IDENTITY = 0
END
LOOP.VAR++
REPEAT
END ELSE
CUSTOMER.IDENTITY = 0
END

RETURN

END
