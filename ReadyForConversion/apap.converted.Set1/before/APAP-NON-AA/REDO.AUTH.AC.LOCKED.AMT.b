*-----------------------------------------------------------------------------
* <Rating>-108</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AUTH.AC.LOCKED.AMT
*
* Subroutine Type : ROUTINE
* Attached to     : Version
* Attached as     : AUTH ROUTINE
* Primary Purpose :
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Jorge Valarezo - TAM Latin America
* Date            : 20-Nov-2012
*
*-----------------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COLLATERAL
$INSERT I_F.AC.LOCKED.EVENTS
*
  GOSUB INITIALISE
  GOSUB OPEN.FILES  ;* PACS00307769 - S/E
  GOSUB PROCESS
*
  RETURN  ;* Program RETURN
*----------------------------------------------------------------------------------
PROCESS:
*======
*
  GOSUB FIND.MULTI.LOCAL.REF
  Y.TO.DATE=""
* PACS00307565 - S
*    Y.FROM.DATE = R.NEW(COLL.VALUE.DATE)
  Y.FROM.DATE = TODAY
* PACS00307565 - E
  Y.ACCOUNT.NO = R.NEW(COLL.LOCAL.REF)<1,L.NUM.INST>
  GOSUB CALC.LOCKED.AMT
* PACS00307769 - S
* Whenever user increase o reduce the VALOR NOMINAL DE LA GARANTIA field value, amount process continues
*      IF NOT(Y.LOCKED.AMOUNT) THEN
*         RETURN
*      END
*
  Y.ARRANGEMENT.ID = R.NEW(COLL.LOCAL.REF)<1,L.ARR.ID>
  Y.ARR.ID.OLD     = R.OLD(COLL.LOCAL.REF)<1,L.ARR.ID>
* PACS00307565 - S
  Y.AA.CNT         = DCOUNT(Y.ARRANGEMENT.ID,SM)
  Y.ARRANGEMENT.ID = FIELD(Y.ARRANGEMENT.ID,SM,Y.AA.CNT)
*
  IF Y.ARRANGEMENT.ID NE Y.ARR.ID.OLD AND Y.VNG.DIF NE 0 AND PGM.VERSION MATCHES '...REDO.MODIFICA...' THEN
    GOSUB DECREASE.AMT.OFS
    RETURN
  END
*
* PACS00307565 - E
*
  IF Y.VNG.DIF GT 0 THEN
    GOSUB INCREASE.AMT.OFS
  END
*
  IF Y.VNG.DIF LT 0 THEN
    GOSUB DECREASE.AMT.OFS
  END
*
* PACS00307769 - E
*
  RETURN
*
*----------------------------------------------------------------------------

INITIALISE:
*=========

  APPL.ARRAY = ''
  FLD.ARRAY  = ''
  FLD.POS    = ''
  L.NUM.INST = ''
  L.AVA.AMT  = ''
  L.ARR.ID   = ''
  Y.LOCKED.AMOUNT = 0
  Y.VNG.DIF  = ''
* PACS00307769 - S
  FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
  F.AC.LOCKED.EVENTS = ''
  R.AC.LOCKED.EVENTS = ''
* PACS00307769 - E
* PACS00307565 - S
  Y.CO.ID      = ID.NEW
  Y.ALE.ACCT   = ''
  Y.ALE.TYPE   = ''
  Y.ALE.DESC   = ''
  Y.ARR.ID.OLD = ''
* PACS00307565 - E
  RETURN

OPEN.FILES:
*==========
*
  CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)
*
  RETURN
*
**********************
FIND.MULTI.LOCAL.REF:
**********************
* PACS00307769 - S
  APPL.ARRAY = 'COLLATERAL':FM:'AC.LOCKED.EVENTS'
  FLD.ARRAY  = 'L.COL.NUM.INSTR' : VM : 'L.AVA.AMO.INS' : VM : 'L.AC.LK.COL.ID' : FM : 'L.AC.LOCKE.TYPE'
* PACS00307769 - E

  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

  L.NUM.INST = FLD.POS<1,1>
  L.AVA.AMT  = FLD.POS<1,2>
  L.ARR.ID   = FLD.POS<1,3>
  L.LE.LTYPE = FLD.POS<2,1>   ;* PACS00307769 - S/E

  RETURN
*====================
CALC.LOCKED.AMT:
*====================
* PACS00307565 - S
  Y.VNG.OLD = R.OLD(COLL.NOMINAL.VALUE)
  Y.VNG.NEW = R.NEW(COLL.NOMINAL.VALUE)
  IF PGM.VERSION MATCHES '...REDO.INGRESO...' AND Y.VNG.NEW NE Y.VNG.OLD THEN
    Y.LOCKED.AMOUNT = R.NEW(COLL.NOMINAL.VALUE)
    Y.VNG.DIF       = Y.LOCKED.AMOUNT
  END
* PACS00307565 - E
* PACS00255616 -  S
  IF PGM.VERSION MATCHES '...REDO.MODIFICA...' THEN
    Y.VNG.DIF = Y.VNG.NEW - Y.VNG.OLD
*
    IF Y.VNG.DIF GT 0 THEN
      Y.LOCKED.AMOUNT = Y.VNG.DIF
    END
  END
* PACS00255616 -  E
*
  RETURN
*
*================
DECREASE.AMT.OFS:
*================
*
* PACS00307565 - E
*    SEL.AC.LOCKED.EVENTS.CMD="SELECT ":FN.AC.LOCKED.EVENTS:" WITH ACCOUNT.NUMBER EQ " :Y.ACCOUNT.NO
*
  SEL.AC.LOCKED.EVENTS.CMD="SELECT ":FN.AC.LOCKED.EVENTS
*
* PACS00307565 - S
*      : " AND WITH L.AC.LK.COL.ID EQ " :Y.ARRANGEMENT.ID ;* Considering for migrated COs.
  CALL EB.READLIST(SEL.AC.LOCKED.EVENTS.CMD,SEL.LIST,'',NO.OF.REC,ERR)
  LOOP
    REMOVE Y.AC.LOCK.ID FROM SEL.LIST SETTING AC.LOCK.POS
  WHILE Y.AC.LOCK.ID:AC.LOCK.POS
    CALL F.READ(FN.AC.LOCKED.EVENTS,Y.AC.LOCK.ID,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,AC.LOCK.ERR)
* PACS00307565 - S
    Y.ALE.ACCT = R.AC.LOCKED.EVENTS<AC.LCK.ACCOUNT.NUMBER>
    Y.ALE.TYPE = R.AC.LOCKED.EVENTS<AC.LCK.LOCAL.REF,L.LE.LTYPE>
    Y.ALE.DESC = R.AC.LOCKED.EVENTS<AC.LCK.DESCRIPTION>
    IF Y.ALE.TYPE EQ 'GUARANTEE.STATUS' AND Y.ALE.ACCT EQ Y.ACCOUNT.NO AND Y.CO.ID EQ Y.ALE.DESC THEN
* PACS00307565 - E
      OFS.SOURCE.ID            = 'APAP.B.180.OFS'
      APPLICATION.NAME         = 'AC.LOCKED.EVENTS'
      TRANS.FUNC.VAL           = 'R'    ;*Instead Input function must be used reverser Function
      TRANS.OPER.VAL           = 'PROCESS'
      APPLICATION.NAME.VERSION = 'AC.LOCKED.EVENTS,APAP'
      NO.AUT                   = '0'
      OFS.MSG.ID               = ''
      APPLICATION.ID           =  Y.AC.LOCK.ID
      OFS.POST.MSG             = ''
      OFS.AZ.MSG1              = APPLICATION.NAME.VERSION:'/':TRANS.FUNC.VAL:'/':TRANS.OPER.VAL:'///,//,':Y.AC.LOCK.ID
      OFS.BODY                 = ''     ;*',TO.DATE:1:1=':TODAY             in reverser function is not be avaliable to input new values
      OFS.REQ.MSG              = OFS.AZ.MSG1:OFS.BODY
      CALL OFS.POST.MESSAGE (OFS.REQ.MSG,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
*
      Y.LOCKED.AMOUNT = Y.VNG.NEW
*
    END
*
  REPEAT
* PACS00260025 - S
  GOSUB INCREASE.AMT.OFS      ;* Locking new amount after first (original) amount reversal
* PACS00260025 - E
  RETURN
*
*================
INCREASE.AMT.OFS:
*================
*
* PACS00307565 - S
*    OFS.STR  = 'AC.LOCKED.EVENTS,APAP/I/PROCESS,/,,TRANSACTION.REF:1:1:=':',ACCOUNT.NUMBER:1:1:=':Y.ACCOUNT.NO:',FROM.DATE:1:1:=':Y.FROM.DATE:',TO.DATE:1:1:=':Y.TO.DATE:',LOCKED.AMOUNT:1:1:=':Y.LOCKED.AMOUNT
  OFS.STR  = 'AC.LOCKED.EVENTS,APAP/I/PROCESS,/,,TRANSACTION.REF:1:1:=':',DESCRIPTION:1:1:=':Y.CO.ID:',ACCOUNT.NUMBER:1:1:=':Y.ACCOUNT.NO:',FROM.DATE:1:1:=':Y.FROM.DATE:',TO.DATE:1:1:=':Y.TO.DATE:',LOCKED.AMOUNT:1:1:=':Y.LOCKED.AMOUNT
* PACS00307565 - E
  OFS.STR := ',L.AC.LOCKE.TYPE:=GUARANTEE.STATUS,L.AC.STATUS2:=GUARANTEE.STATUS,L.AC.LK.COL.ID:=':Y.ARRANGEMENT.ID
  OFS.SRC= 'FC.OFS'
  OFS.MSG.ID = ''
  OPTIONS = ''
*
  CALL OFS.POST.MESSAGE(OFS.STR,OFS.MSG.ID,OFS.SRC,OPTIONS)
*
END
