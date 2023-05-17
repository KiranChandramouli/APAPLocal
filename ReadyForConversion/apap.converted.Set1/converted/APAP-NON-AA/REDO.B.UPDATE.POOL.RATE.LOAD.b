SUBROUTINE REDO.B.UPDATE.POOL.RATE.LOAD
*----------------------------------------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is the load routine of the batch job REDO.B.UPDATE.POOL.RATE which updates the local reference field TASA.POOL
*   based on the value in the local table POOL.RATE and other related local reference fields in ACCOUNT and AZ.ACCOUNT
* This routine initialises necessary variables, gets the position of the local reference fields and opens necessary files
* ---------------------------------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
*
* 03-MAY-2010  N.Satheesh Kumar   ODR-2009-10-0325       Initial Creation
* 19-DEC-2010  JEEVA T             PACS00171685          COB PERFORMANCE
* 20-DEC-2011  Pradeep S          PACS00171685           Logic changed to improve performance
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.POOL.RATE
    $INSERT I_REDO.B.UPDATE.POOL.RATE.COMMON

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB GET.ACI.GCI.IDS       ;* PACS00171685 -S/E
RETURN

*----------
INITIALISE:
*----------

    AZ.PROD.LST = ''
    DEP.OR.LOAN.LST = ''

    LREF.APPLNS = 'ACCOUNT':@FM:'AZ.ACCOUNT'
    LREF.FIELDS = 'L.EB.REVIEW':@VM:'L.EB.PROFITLOSS':@VM:'L.EB.TASA.POOL':@VM:'L.EB.OLD.RATE':@FM
    LREF.FIELDS := 'L.EB.REVIEW':@VM:'L.EB.PROFITLOSS':@VM:'L.EB.TASA.POOL':@VM:'L.EB.OLD.RATE':@VM:'L.AZ.GR.END.DAT':@VM:'L.AZ.GRACE.DAYS'
    LREF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APPLNS,LREF.FIELDS,LREF.POS)
    ACC.REVIEW.POS = LREF.POS<1,1>
    ACC.PROFITLOSS.POS = LREF.POS<1,2>
    ACC.TASA.POOL.POS = LREF.POS<1,3>
    ACC.OLD.RATE.POS = LREF.POS<1,4>
    AZ.REVIEW.POS = LREF.POS<2,1>
    AZ.PROFITLOSS.POS = LREF.POS<2,2>
    AZ.TASA.POOL.POS = LREF.POS<2,3>
    AZ.OLD.RATE.POS = LREF.POS<2,4>
    LOC.L.AZ.GR.END.DAT = LREF.POS<2,5>
    LOC.L.AZ.GRACE.DAYS = LREF.POS<2,6>
    Y.APPL=''
RETURN

*----------
OPEN.FILES:
*----------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.REDO.POOL.RATE = 'F.REDO.POOL.RATE'
    F.REDO.POOL.RATE = ''
    CALL OPF(FN.REDO.POOL.RATE,F.REDO.POOL.RATE)

    FN.ACCOUNT.CREDIT.INT = 'F.ACCOUNT.CREDIT.INT'
    F.ACCOUNT.CREDIT.INT = ''
    CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)

    FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'
    F.GROUP.CREDIT.INT = ''
    CALL OPF(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)

    FN.AZ.PRODUCT.PARAMETER = 'F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAMETER = ''
    CALL OPF(FN.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER)

    FN.REDO.W.UPD.REVIEW.ACCT = 'F.REDO.W.UPD.REVIEW.ACCT'
    F.REDO.W.UPD.REVIEW.ACCT = ''
    CALL OPF(FN.REDO.W.UPD.REVIEW.ACCT,F.REDO.W.UPD.REVIEW.ACCT)

*PACS00171685 - S
    FN.GROUP.DATE = 'F.GROUP.DATE'
    F.GROUP.DATE  = ''
    CALL OPF(FN.GROUP.DATE,F.GROUP.DATE)
*PACS00171685 - E

    FN.STMT.ACCT.CR = 'F.STMT.ACCT.CR'
    F.STMT.ACCT.CR = ''
    CALL OPF(FN.STMT.ACCT.CR,F.STMT.ACCT.CR)

RETURN

*---------------
GET.ACI.GCI.IDS:
*---------------

    FILE.NAME = ''
    FILE.DET = ''
    GCI.ID.LST = ''
    ACI.ID.LST = ''
    FILE.NAME = FN.GROUP.CREDIT.INT
    FILE.DET = ''
    CALL GIT(FILE.NAME,FILE.DET,GCI.ID.LST)
    FILE.NAME = FN.ACCOUNT.CREDIT.INT
    CALL GIT(FILE.NAME,FILE.DET,ACI.ID.LST)

RETURN

END
