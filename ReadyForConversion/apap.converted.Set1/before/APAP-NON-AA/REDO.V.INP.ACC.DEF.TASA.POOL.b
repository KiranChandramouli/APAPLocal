*-----------------------------------------------------------------------------
* <Rating>-91</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.ACC.DEF.TASA.POOL
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is attached as input routine to the ACCOUNT versions used for ACCOUNT opening
* ------------------------------------------------------------------------------------------
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
* 01-APR-2011     H GANESH         PACS00052350           Modified as per issue
* 27-DEC-2011     H GANESH         PACS00164151           Pool rate table modified.
* 16-MAR-2012     S.Sudharsanan    PACS00186447           Pool rate is updated only for savings/current products
*---------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.ACCOUNT.CREDIT.INT
$INSERT I_F.GROUP.CREDIT.INT
$INSERT I_F.GROUP.DATE
$INSERT I_F.REDO.POOL.RATE
$INSERT I_F.AI.REDO.ARCIB.PARAMETER

  IF R.OLD(AC.CURR.NO) NE '' THEN
    RETURN
  END

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB PROCESS
  GOSUB PGM.END
  RETURN
*----------
INITIALISE:
*----------


  LREF.APPLNS = 'ACCOUNT'
  LREF.FIELDS = 'L.EB.REVIEW':VM:'L.EB.PROFITLOSS':VM:'L.EB.TASA.POOL'
  CALL MULTI.GET.LOC.REF(LREF.APPLNS,LREF.FIELDS,LREF.POS)
  POS.EB.REVIEW = LREF.POS<1,1>
  POS.EB.PROFITLOSS = LREF.POS<1,2>
  POS.EB.TASA.POOL = LREF.POS<1,3>
  RETURN
*----------
OPEN.FILES:
*----------

  FN.REDO.POOL.RATE = 'F.REDO.POOL.RATE'
  F.REDO.POOL.RATE = ''
  CALL OPF(FN.REDO.POOL.RATE,F.REDO.POOL.RATE)

  FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'
  F.GROUP.CREDIT.INT = ''
  CALL OPF(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)

  FN.GROUP.DATE = 'F.GROUP.DATE'
  F.GROUP.DATE = ''
  CALL OPF(FN.GROUP.DATE,F.GROUP.DATE)

  FN.AI.REDO.ARCIB.PARAM = 'F.AI.REDO.ARCIB.PARAMETER'

  CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAM,'SYSTEM',R.REDO.PARAM,PARAM.ERR)

  RETURN
*-------
PROCESS:
*-------

  ACC.CUR = R.NEW(AC.CURRENCY)
  ACC.CATEG = R.NEW(AC.CATEGORY)
*-----------PACS00186447--------------------
  POSSIBLE.VALUES = 'SAVINGS':FM:'CURRENT':FM:'AHORROS':FM:'CORRIENTE'
  ACCT.TYPE = R.REDO.PARAM<AI.PARAM.ACCOUNT.TYPE>
  START.VALUE = R.REDO.PARAM<AI.PARAM.CATEG.START>
  END.VALUE = R.REDO.PARAM<AI.PARAM.CATEG.END>
  START.VAL.CNT = DCOUNT(START.VALUE,VM)
  VM.CNT = 1
  LOOP
  WHILE VM.CNT LE START.VAL.CNT
    START.CATEG = START.VALUE<1,VM.CNT>
    END.CATEG   = END.VALUE<1,VM.CNT>
    IF ACC.CATEG GE START.CATEG AND ACC.CATEG LE END.CATEG THEN
      CHECK.TYPE = ACCT.TYPE<1,VM.CNT>
      LOCATE CHECK.TYPE IN POSSIBLE.VALUES SETTING VAL.POS THEN
        GOSUB CHECK.PROCESS
      END
      GOSUB PGM.END
    END
    ++VM.CNT
  REPEAT
  RETURN
*------------PACS00186447---------------------------
*--------------
CHECK.PROCESS:
*--------------
  ACC.COND = R.NEW(AC.CONDITION.GROUP)
  R.REDO.POOL.RATE = ''
  CALL F.READ(FN.REDO.POOL.RATE,ACC.CUR,R.REDO.POOL.RATE,F.REDO.POOL.RATE,PR.RPR)
  BUY.RATE = R.REDO.POOL.RATE<PL.RATE.INDEF.LIAB.RATE>
  R.NEW(AC.LOCAL.REF)<1,POS.EB.TASA.POOL> = BUY.RATE
  FIND.ID = ACC.COND:ACC.CUR
  GOSUB GET.INT.KEY
  R.GROUP.CREDIT.INT = ''
  CALL F.READ(FN.GROUP.CREDIT.INT,INT.KEY,R.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT,CGI.ERR)
  INT.RATE = R.GROUP.CREDIT.INT<IC.GCI.CR.INT.RATE,1>
  BASIC.RATE.KEY = R.GROUP.CREDIT.INT<IC.GCI.CR.BASIC.RATE,1>
  GOSUB GET.INT.RATE
  R.NEW(AC.LOCAL.REF)<1,POS.EB.PROFITLOSS> = FMT(BUY.RATE-ACC.INT.RATE,"L2#10")
*--------PACS00052350-----------------------------
*R.NEW(AC.LOCAL.REF)<1,POS.EB.REVIEW>='YES'
*--------PACS00052350-----------------------------
  RETURN
*-----------
GET.INT.KEY:
*-----------

  R.GROUP.DATE = ''
  CALL F.READ(FN.GROUP.DATE,FIND.ID,R.GROUP.DATE,F.GROUP.DATE,ERR.GD)
  GCI.DATE = R.GROUP.DATE<AC.GRD.CREDIT.GROUP.DATE>
  INT.KEY = FIND.ID:GCI.DATE

  RETURN

*------------
GET.INT.RATE:
*------------
*-----------------------------------------------------------------------------------------------------
* This section gets the interest rate based on the amount and assigns it to the variable ACC.INT.RATE
*-----------------------------------------------------------------------------------------------------
  IF  INT.RATE NE '' THEN
    ACC.INT.RATE = INT.RATE
    RETURN
  END
  BASIC.RATE.KEY := ACC.CUR:TODAY
  BASIC.RATE = ''
  CALL EB.GET.INTEREST.RATE(BASIC.RATE.KEY,BASIC.RATE)
  ACC.INT.RATE = BASIC.RATE
  RETURN

*--------
PGM.END:
*--------
END
