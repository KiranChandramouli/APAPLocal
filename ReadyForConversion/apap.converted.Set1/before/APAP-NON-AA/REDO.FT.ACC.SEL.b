*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.FT.ACC.SEL
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is ID routine attached to TELLER, CUSTOMER, ACCOUNT, FUNDS.TRANSFER,
*USER and TELLER.ID version to prevent transaction input if status is closed
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
* Date who Reference Description
* 20-12-2010 JEEVAT N.45 Initial creation
* 21-07-2011 Bharath G PACS00085750 FT.DEBIT.THEIR.REF removed from version
* 23-07-2011 Bharath G PACS00085750 Code Review issue to remove F.READ and to use CACHE.READ
* 09-09-2011 Marimuthu S PACS00121111
* 13-JUL-2012 MARIMUTHU S PACS00203617
* 02-AUG-2012 Nandhini M PACS00210703
* 08/03/2013 Vignesh Kumaar M R PACS00251027 To update the credit account number
*------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.ACCOUNT
$INSERT I_F.MULTI.BRANCH.INTERNAL.ACCOUNT
$INSERT I_F.REDO.BRANCH.INT.ACCT.PARAM
$INSERT I_F.ACCOUNT

GOSUB INIT
GOSUB OPEN.FILES
GOSUB PROCESS
RETURN

*----*
INIT:
*----*
*-----------*
*Initialising
*-----------*
REC.ID='SYSTEM'
RETURN

*---------*
OPEN.FILES:
*---------*
*------------*
*Opening files
*------------*

FN.MULTI.BRANCH.INTERNAL.ACCOUNT ='F.MULTI.BRANCH.INTERNAL.ACCOUNT'
FN.ACCOUNT = 'F.ACCOUNT'
F.ACCOUNT = ''
F.MULTI.BRANCH.INTERNAL.ACCOUNT = ''

CALL OPF(FN.MULTI.BRANCH.INTERNAL.ACCOUNT,F.MULTI.BRANCH.INTERNAL.ACCOUNT)
CALL OPF(FN.ACCOUNT,F.ACCOUNT)

FN.REDO.BRANCH.INT.ACCT.PARAM = 'F.REDO.BRANCH.INT.ACCT.PARAM'
F.REDO.BRANCH.INT.ACCT.PARAM = ''
R.REDO.BRANCH.INT.ACCT.PARAM = ''
CALL OPF(FN.REDO.BRANCH.INT.ACCT.PARAM,F.REDO.BRANCH.INT.ACCT.PARAM)

FN.ACCOUNT = 'F.ACCOUNT'
F.ACCOUNT = ''
CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN

*-------*
PROCESS:
*-------*

*-----------------------------------------------------*
*Raising Error Message if the operation Status is Closes
*-----------------------------------------------------*
* PACS00085750 - S
* CALL F.READ(FN.MULTI.BRANCH.INTERNAL.ACCOUNT,REC.ID,R.MULTI.BRANCH.INTERNAL.ACCOUNT,F.MULTI.BRANCH.INTERNAL.ACCOUNT,Y.ERR)
CALL CACHE.READ(FN.MULTI.BRANCH.INTERNAL.ACCOUNT,REC.ID,R.MULTI.BRANCH.INTERNAL.ACCOUNT,Y.ERR)
* PACS00085750 - E

VAR.VERSION.NAME = R.MULTI.BRANCH.INTERNAL.ACCOUNT<REDO.BR.ACCT.VERSION>
Y.VERSION.NAME = APPLICATION:PGM.VERSION

LOCATE Y.VERSION.NAME IN VAR.VERSION.NAME<1,1> SETTING POS THEN
R.NEW(FT.CREDIT.ACCT.NO) = R.MULTI.BRANCH.INTERNAL.ACCOUNT<REDO.BR.ACCT.ACCOUNT,POS>
Y.CRD.ID = R.MULTI.BRANCH.INTERNAL.ACCOUNT<REDO.BR.ACCT.ACCOUNT,POS>
CALL F.READ(FN.ACCOUNT,Y.CRD.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
R.NEW(FT.CREDIT.CURRENCY) = R.ACCOUNT<AC.CURRENCY>
END

* PACS00085750 - S
IF Y.VERSION.NAME EQ 'FUNDS.TRANSFER,REDO.AA.CASH' OR Y.VERSION.NAME EQ 'FUNDS.TRANSFER,CHQ.OTHERS.LOAN.DUM' OR Y.VERSION.NAME EQ 'FUNDS.TRANSFER,REDO.AA.OTI' OR Y.VERSION.NAME EQ 'FUNDS.TRANSFER,CHQ.OTHERS.LOAN' THEN
Y.ACC.ID = COMI
IF Y.ACC.ID EQ '' THEN
Y.ACC.ID = R.NEW(FT.DEBIT.ACCT.NO)
END
LREF.APP = 'FUNDS.TRANSFER'
LREF.FIELDS = 'L.FT.CLIENT.COD'
LREF.POS = ''
CALL GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)

VAR.L.FT.CLIENT.COD.POS = LREF.POS<1,1>
CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,Y.ERR)
* R.NEW(FT.DEBIT.THEIR.REF) = R.ACCOUNT<AC.CUSTOMER>
R.NEW(FT.LOCAL.REF)<1,VAR.L.FT.CLIENT.COD.POS> = R.ACCOUNT<AC.CUSTOMER>
END
* PACS00085750 - E
**PACS00210703
CALL CACHE.READ(FN.REDO.BRANCH.INT.ACCT.PARAM,REC.ID,R.REDO.BRANCH.INT.ACCT.PARAM,E.REDO.BRANCH.INT.ACCT.PARAM)

* Fix for PACS00251027 [To update the credit account number]

Y.VERSION.NAME = APPLICATION:PGM.VERSION
GET.VERSION.ARR = R.REDO.BRANCH.INT.ACCT.PARAM<BR.INT.ACCT.VERSION.NAME>

LOCATE Y.VERSION.NAME IN GET.VERSION.ARR<1,1> SETTING ACC.POS THEN
Y.CRD.ID = R.REDO.BRANCH.INT.ACCT.PARAM<BR.INT.ACCT.INT.ACCOUNT,ACC.POS>
R.NEW(FT.CREDIT.ACCT.NO) = Y.CRD.ID
CALL F.READ(FN.ACCOUNT,Y.CRD.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
R.NEW(FT.CREDIT.CURRENCY) = R.ACCOUNT<AC.CURRENCY>
END

* End of Fix

***PACS00210703
* PACS00085750 - S
Y.ARR.ID = COMI
IF Y.ARR.ID EQ '' THEN
Y.ARR.ID = R.NEW(FT.DEBIT.ACCT.NO)
END
IF Y.ARR.ID[1,2] EQ 'AA' THEN
IN.ACC.ID = Y.ARR.ID
IN.ARR.ID = ''
OUT.ID = ''
ERR.TEXT = ''
CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)
Y.ARR.ID = OUT.ID
END

CALL F.READ(FN.ACCOUNT,Y.ARR.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
R.NEW(FT.DEBIT.CURRENCY) = R.ACCOUNT<AC.CURRENCY>
IF R.ACCOUNT<AC.ARRANGEMENT.ID> EQ '' THEN
AF = FT.DEBIT.ACCT.NO
ETEXT = "EB-NOT.ARRANGEMENT.ID"
CALL STORE.END.ERROR
END
* PACS00085750 - E
IF Y.VERSION.NAME EQ 'FUNDS.TRANSFER,REDO.AA.LTCC' THEN
R.NEW(FT.ORDERING.CUST) = R.ACCOUNT<AC.CUSTOMER>
END

RETURN
END