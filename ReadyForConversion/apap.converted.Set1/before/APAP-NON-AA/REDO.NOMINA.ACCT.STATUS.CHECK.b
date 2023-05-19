*-----------------------------------------------------------------------------
* <Rating>-80</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOMINA.ACCT.STATUS.CHECK(Y.ACCT.ID,Y.ACCT.TYPE,Y.ACCT.STATUS)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By :
* Program Name : REDO.UPLOAD.DEBIT.ACCOUNT.CHECK
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.CUSTOMER.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.CATEGORY
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.REDO.INTERFACE.C18.PARAM
$INSERT I_F.ACCOUNT.CLASS
$INSERT I_F.REDO.H.TELLER.TXN.CODES
$INSERT I_F.AI.REDO.ARCIB.PARAMETER

  GOSUB INITIALISE
  GOSUB FORM.ACCT.ARRAY

  RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
  FN.ACC = 'F.ACCOUNT'
  F.ACC = ''
  CALL OPF(FN.ACC,F.ACC)

  FN.AZ = 'F.AZ.ACCOUNT'
  F.AZ  = ''
  CALL OPF(FN.AZ,F.AZ)

  FN.AI.REDO.ARC.PARAM='F.AI.REDO.ARCIB.PARAMETER'
  FN.REDO.INTERFACE.C18.PARAM = 'F.REDO.INTERFACE.C18.PARAM'


  CALL CACHE.READ(FN.AI.REDO.ARC.PARAM,'SYSTEM',R.AI.REDO.ARC.PARAM,PARAM.ERR)
  LIST.ACCT.TYPE=R.AI.REDO.ARC.PARAM<AI.PARAM.ACCOUNT.TYPE>

  Y.FIELD.COUNT = ''
  R.ACCT.REC = ''
  Y.FLAG = ''
  LOAN.FLG = ''
  DEP.FLG = ''
  R.AZ.REC = ''
  R.ACC = ''
  LREF.POS = ''
  LREF.APP='ACCOUNT'
  LREF.FIELDS='L.AC.STATUS1':VM:'L.AC.AV.BAL':VM:'L.AC.NOTIFY.1':VM:'L.AC.STATUS2'
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
  ACCT.STATUS.POS   = LREF.POS<1,1>
  ACCT.OUT.BAL.POS  = LREF.POS<1,2>
  NOTIFY.POS        = LREF.POS<1,3>
  ACCT.STATUS2.POS  = LREF.POS<1,4>

  RETURN
******************
FORM.ACCT.ARRAY:
*****************

  CALL CACHE.READ(FN.REDO.INTERFACE.C18.PARAM,'SYSTEM',R.REDO.INTERFACE.C18.PARAM,RES.ERR)
  Y.RESTRICT.ACCT.TYPE = R.REDO.INTERFACE.C18.PARAM<C18.PARAM.RESTRICT.ACCT.TYPE>
  CHANGE VM TO FM IN Y.RESTRICT.ACCT.TYPE

  ACC.ERR= ''
  CHECK.CATEG=''
  SAV.FLG=''
  Y.FLAG = ''
  CURR.FLG=''
  CUR.ACCT.STATUS = ''
  AC.NOFITY.STATUS = ''
  Y.POSTING.RESTRICT = ''


  CALL F.READ(FN.ACC,Y.ACCT.ID,R.ACC,F.ACC,ACC.ERR)
  IF NOT(R.ACC) THEN
    Y.ACCT.STATUS = "INVALID ACCOUNT"
    RETURN
  END ELSE

    IF R.ACC<AC.CUSTOMER> EQ '' THEN
      RETURN
    END
    AC.NOFITY.STATUS = R.ACC<AC.LOCAL.REF><1,NOTIFY.POS>
    CUR.ACCT.STATUS1 = R.ACC<AC.LOCAL.REF><1,ACCT.STATUS.POS>
    CUR.ACCT.STATUS2=R.ACC<AC.LOCAL.REF><1,ACCT.STATUS2.POS>
    ACCT.BAL = R.ACC<AC.LOCAL.REF><1,ACCT.OUT.BAL.POS>
    Y.POSTING.RESTRICT= R.ACC<AC.POSTING.RESTRICT>
    CHANGE SM TO FM IN CUR.ACCT.STATUS2
    CHANGE SM TO FM IN AC.NOFITY.STATUS
    CHECK.CATEG = R.ACC<AC.CATEGORY>
  END


  GOSUB LOCATE.CUR.SAV.ACC
  GOSUB CHECK.LOAN.ACC
  GOSUB CHECK.AZ.ACC
  LOCATE Y.ACCT.TYPE IN Y.RESTRICT.ACCT.TYPE SETTING RES.ACCT.POS THEN
    GOSUB STATUS.RESTRICTION.PARA
    GOSUB NOTIFY.RESTRICTION.PARA
    GOSUB POSTING.RESTRICTION.PARA

  END


  RETURN
*******************
LOCATE.CUR.SAV.ACC:
*****************
  CHANGE VM TO FM IN LIST.ACCT.TYPE
  Y.CNT.CATEG.TYPE  = DCOUNT(LIST.ACCT.TYPE,FM)
  Y.CNT.CAT = 1
  LOOP
  WHILE  Y.CNT.CAT LE Y.CNT.CATEG.TYPE
    Y.CATEG.ID = LIST.ACCT.TYPE<Y.CNT.CAT>
    IF 'SAVINGS' EQ Y.CATEG.ID THEN
      SAV.STR.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.START,Y.CNT.CAT>
      SAV.END.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.END,Y.CNT.CAT>
      IF CHECK.CATEG GE SAV.STR.RGE AND CHECK.CATEG LE SAV.END.RGE THEN
        RETURN
      END
    END
    Y.CNT.CAT++
  REPEAT

  LOCATE 'CURRENT' IN LIST.ACCT.TYPE SETTING CUR.ACCT.POS THEN
    CUR.STR.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.START,CUR.ACCT.POS>
    CUR.END.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.END,CUR.ACCT.POS>
    IF CHECK.CATEG GE CUR.STR.RGE AND CHECK.CATEG LE CUR.END.RGE THEN
      RETURN
    END
  END
  Y.ACCT.STATUS = "INVALID ACCT TYPE"

  RETURN
************************
STATUS.RESTRICTION.PARA:
************************
  IF CUR.ACCT.STATUS1 THEN
    CUR.ACCT.STATUS = CUR.ACCT.STATUS1
  END
  IF CUR.ACCT.STATUS2 THEN
    CUR.ACCT.STATUS = CUR.ACCT.STATUS2
  END
  IF CUR.ACCT.STATUS1 AND CUR.ACCT.STATUS2 THEN
    CUR.ACCT.STATUS = CUR.ACCT.STATUS1:FM:CUR.ACCT.STATUS2
  END

  Y.CNT.STATUS = DCOUNT(CUR.ACCT.STATUS,FM)
  IF Y.CNT.STATUS GE 1 THEN
    Y.INT.STATUS.CNT = 1
    LOOP
    WHILE Y.INT.STATUS.CNT LE Y.CNT.STATUS
      Y.STATUS2 = CUR.ACCT.STATUS<Y.INT.STATUS.CNT>
      Y.RESTRICT.STATUS = R.REDO.INTERFACE.C18.PARAM<C18.PARAM.ACCT.STATUS,RES.ACCT.POS>
      CHANGE SM TO FM IN Y.RESTRICT.STATUS
      LOCATE Y.STATUS2 IN Y.RESTRICT.STATUS SETTING RES.STATUS.POS THEN
        Y.ACCT.STATUS<-1> = "ACCOUNT INACTIVE"
      END
      Y.INT.STATUS.CNT++
    REPEAT
  END

  RETURN
************************
NOTIFY.RESTRICTION.PARA:
************************

  Y.CNT.NOTIFY = DCOUNT(AC.NOFITY.STATUS,FM)
  IF Y.CNT.NOTIFY GE 1 THEN
    Y.INT.NOTIFY.CNT = 1
    LOOP
    WHILE Y.INT.NOTIFY.CNT LE Y.CNT.NOTIFY
      Y.NOTIFY = AC.NOFITY.STATUS<Y.INT.NOTIFY.CNT>
      Y.RESTRICT.NOTIFY = R.REDO.INTERFACE.C18.PARAM<C18.PARAM.ACCT.NOTIFY.1,RES.ACCT.POS>
      CHANGE SM TO FM IN Y.RESTRICT.NOTIFY
      LOCATE Y.NOTIFY IN Y.RESTRICT.NOTIFY SETTING RES.NOTIFY.POS THEN
        Y.ACCT.STATUS = "ACCOUNT NOTIFICATION"
      END
      Y.INT.NOTIFY.CNT++
    REPEAT
  END

  RETURN

*************************
POSTING.RESTRICTION.PARA:
*************************
  Y.RESTRICT.ACCT.POSTING = R.REDO.INTERFACE.C18.PARAM<C18.PARAM.POSTING.RESTRICT,RES.ACCT.POS>
  CHANGE SM TO FM IN Y.RESTRICT.ACCT.POSTING
  IF Y.POSTING.RESTRICT THEN
    LOCATE Y.POSTING.RESTRICT IN Y.RESTRICT.ACCT.POSTING SETTING POSTING.POS THEN
      Y.ACCT.STATUS = " POSTING RESTRICTION"
    END
  END

  RETURN

******************
CHECK.LOAN.ACC:
******************

  ARR.ID = R.ACC<AC.ARRANGEMENT.ID>
  IF ARR.ID THEN
    Y.ACCT.STATUS = "LOAN ACCOUNT"
  END

  RETURN

*******************
CHECK.AZ.ACC:
******************
  CALL F.READ(FN.AZ,Y.ACCT.ID,R.AZ.REC,F.AZ,AZ.ERR)
  IF R.AZ.REC THEN
    Y.ACCT.STATUS = "DEPOSIT ACCOUNT"
  END
  RETURN
END