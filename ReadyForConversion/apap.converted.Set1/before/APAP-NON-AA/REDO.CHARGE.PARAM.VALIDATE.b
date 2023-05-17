*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CHARGE.PARAM.VALIDATE
*-----------------------------------------------------------------------------
* This is associated with the template REDO.CHARGE.PARAM, to check if the category
* is within the range
* @author rshankar@temenos.com
*-----------------------------------------------------------------------------
* INPUT/OUTPUT:
*--------------
* IN :
* OUT :
* ----------------------------------------------------------------------------
* DEPENDENCIES:
*---------------
* CALLED BY :
* CALLS :
* ----------------------------------------------------------------------------
*   Date               who           Reference            Description
* 10-JAN-2010     SHANKAR RAJU     ODR-2009-10-0529     Initial Creation
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CHARGE.PARAM
$INSERT I_F.ACCOUNT.PARAMETER

  GOSUB INITIALISE
  GOSUB VALIDATE

  RETURN
*-----------------------------------------------------------------------------
INITIALISE:

  START.CATEG.VAL = "1000"
  END.CATEG.VAL = "9999"
  FN.ACCOUNT.PARAMETER='F.ACCOUNT.PARAMETER'
  F.ACCOUNT.PARAMETER= ''

  CALL OPF(FN.ACCOUNT.PARAMETER,F.ACCOUNT.PARAMETER)

  RETURN
*-----------------------------------------------------------------------------
VALIDATE:

  REC.ID="SYSTEM"
  CALL CACHE.READ(FN.ACCOUNT.PARAMETER,REC.ID,R.ACCOUNT.PARAMETER,ERR.AP)

  IF R.ACCOUNT.PARAMETER THEN
    CON.CAT.STR = R.ACCOUNT.PARAMETER<AC.PAR.CONT.CAT.STR>
    CON.CAT.END = R.ACCOUNT.PARAMETER<AC.PAR.CONT.CAT.END>
  END

  CNT.NO.OF.CONT = DCOUNT(CON.CAT.STR,VM)

  CATEG.START = R.NEW(CHG.PARAM.ACCT.CATEG.STR)
  NO.OF.STRT.CATEG=DCOUNT(CATEG.START,VM)

  COUNT.CAT = 1
  LOOP
  WHILE COUNT.CAT LE NO.OF.STRT.CATEG
    CATEG.STR = R.NEW(CHG.PARAM.ACCT.CATEG.STR)<1,COUNT.CAT>
    IF CATEG.STR GE START.CATEG.VAL AND CATEG.STR LE END.CATEG.VAL THEN
      GOSUB CHK.ACT.PARAM.CATG.STR
    END ELSE
      AF  = CHG.PARAM.ACCT.CATEG.STR
      ETEXT = 'EB-CATEG.NOT.RANGE'
      CALL STORE.END.ERROR
    END
    COUNT.CAT += 1
  REPEAT

  COUNT.CATEG = 1
  LOOP
  WHILE COUNT.CATEG LE NO.OF.STRT.CATEG
    CATEG.END = R.NEW(CHG.PARAM.ACCT.CATEG.END)<1,COUNT.CATEG>
    IF R.NEW(CHG.PARAM.ACCT.CATEG.END)<1,COUNT.CATEG> GE R.NEW(CHG.PARAM.ACCT.CATEG.END)<1,COUNT.CATEG> AND CATEG.END GE START.CATEG.VAL AND CATEG.END LE END.CATEG.VAL THEN
      GOSUB CHK.ACT.PARAM.CATG.END
    END ELSE
      AF  = CHG.PARAM.ACCT.CATEG.END
      ETEXT = 'EB-CATEG.NOT.RANGE'
      CALL STORE.END.ERROR
    END
    COUNT.CATEG += 1
  REPEAT

  PL.CATEG = R.NEW(CHG.PARAM.PL.CATEGORY)
  IF PL.CATEG THEN
    IF PL.CATEG LT 50000 OR PL.CATEG GT 69998 THEN
      AF=CHG.PARAM.PL.CATEGORY
      ETEXT='EB-CATEG.NOT.RANGE'
      CALL STORE.END.ERROR
    END
  END

  RETURN
*-----------------------------------------------------------------------------
CHK.ACT.PARAM.CATG.STR:

  START.CNT.CONT = 1
  LOOP
  WHILE START.CNT.CONT LE CNT.NO.OF.CONT
    AC.START.CATEG.VAL = R.ACCOUNT.PARAMETER<AC.PAR.CONT.CAT.STR,START.CNT.CONT>
    AC.END.CATEG.VAL = R.ACCOUNT.PARAMETER<AC.PAR.CONT.CAT.END,START.CNT.CONT>
    IF R.NEW(CHG.PARAM.ACCT.CATEG.STR)<1,COUNT.CAT> GE AC.START.CATEG.VAL AND R.NEW(CHG.PARAM.ACCT.CATEG.STR)<1,COUNT.CAT> LE AC.END.CATEG.VAL THEN
      AF = CHG.PARAM.ACCT.CATEG.STR
      AV = START.CNT.CONT
      ETEXT = 'EB-CATEG.NOT.RANGE'
      CALL STORE.END.ERROR
    END
    START.CNT.CONT = START.CNT.CONT + 1
  REPEAT

  RETURN
*-----------------------------------------------------------------------------
CHK.ACT.PARAM.CATG.END:

  END.CNT.CONT = 1
  LOOP
  WHILE END.CNT.CONT LE CNT.NO.OF.CONT
    AC.START.CATEG.VAL = R.ACCOUNT.PARAMETER<AC.PAR.CONT.CAT.STR,END.CNT.CONT>
    AC.END.CATEG.VAL = R.ACCOUNT.PARAMETER<AC.PAR.CONT.CAT.END,END.CNT.CONT>
    IF R.NEW(CHG.PARAM.ACCT.CATEG.END)<1,COUNT.CATEG> GE AC.START.CATEG.VAL AND R.NEW(CHG.PARAM.ACCT.CATEG.END)<1,COUNT.CATEG> LE AC.END.CATEG.VAL THEN
      AF = CHG.PARAM.ACCT.CATEG.END
      AV = END.CNT.CONT
      ETEXT = 'EB-CATEG.NOT.RANGE'
      CALL STORE.END.ERROR
    END
    END.CNT.CONT = END.CNT.CONT + 1
  REPEAT

  RETURN
*-----------------------------------------------------------------------------
END
