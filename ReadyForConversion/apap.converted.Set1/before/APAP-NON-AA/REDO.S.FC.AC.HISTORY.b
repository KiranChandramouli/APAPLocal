*-----------------------------------------------------------------------------
* <Rating>208</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.FC.AC.HISTORY(AC.ID, AC.REC)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose :
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* AC.REC - data returned to the routine
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            :
*
*-----------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.EB.CONTRACT.BALANCES
$INSERT I_F.ACCT.ACTIVITY
$INSERT I_F.STMT.ACCT.CR
$INSERT I_F.ACCOUNT
*Tus Start
$INSERT I_F.EB.CONTRACT.BALANCES
*Tus End


  GOSUB INITIALISE
  GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======

  CALL F.READ(FN.EB.CONTRACT.BALANCES,AC.ID,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES,"")

  IF R.EB.CONTRACT.BALANCES THEN
    NRO.MONTHS = DCOUNT(R.EB.CONTRACT.BALANCES<ECB.ACTIVITY.MONTHS>,VM)
    GOSUB GET.STMT.ACCT.CR
    FOR I = NRO.MONTHS TO 1 STEP -1
*---------------------------------
      Y.CUR.CAMPO = "ACTIVITY.MONTHS"
      Y.ACT.MONTH = R.EB.CONTRACT.BALANCES<ECB.ACTIVITY.MONTHS,I>
      Y.VALUE.FLD = Y.CUR.CAMPO:"*":Y.ACT.MONTH
      AC.REC <-1> = Y.VALUE.FLD
*---------------------------------
      Y.CUR.CAMPO = "CR.VAL.BALANCE"
      GOSUB GET.STMT.ACCT.CR.DETAIL
      IF Y.LST.HRD THEN
        ID.STMT.AC = Y.LST.HRD<1>
        CALL F.READ(FN.R.STMT.ACCT.CR,ID.STMT.AC,R.STMT.ACCT.CR,F.STMT.ACCT.CR,"")
        NRO.VAL = DCOUNT(R.STMT.ACCT.CR<IC.STMCR.CR.VAL.BALANCE>,VM)
        Y.VALUE.FLD = R.STMT.ACCT.CR<IC.STMCR.CR.VAL.BALANCE,NRO.VAL>
      END ELSE
        Y.VALUE.FLD = 'NULO'
      END
      Y.VALUE.FLD = Y.CUR.CAMPO:"*":Y.VALUE.FLD
      AC.REC <-1> = Y.VALUE.FLD
*---------------------------------
      Y.CUR.CAMPO = "BOOK.TOVR.CR"
      GOSUB GET.BOOK.TOVR.CR
      Y.VALUE.FLD = Y.BOOK.TOVR.CR
      Y.VALUE.FLD = Y.CUR.CAMPO:"*":Y.VALUE.FLD
      AC.REC <-1> = Y.VALUE.FLD
*---------------------------------
      Y.CUR.CAMPO = "CR.INT.AMT"
      IF Y.LST.HRD THEN
        Y.VALUE.FLD = 0
        FOR K = 1 TO NRO.VAL
          Y.VALUE.FLD += R.STMT.ACCT.CR<IC.STMCR.CR.INT.AMT,K>
        NEXT
      END ELSE
        Y.VALUE.FLD = 'NULO'
      END
      Y.VALUE.FLD = Y.CUR.CAMPO:"*":Y.VALUE.FLD
      AC.REC <-1> = Y.VALUE.FLD
*---------------------------------
      Y.CUR.CAMPO = "BOOK.TOVR.DB"
      Y.VALUE.FLD = Y.BOOK.TOVR.DB
      Y.VALUE.FLD = Y.CUR.CAMPO:"*":Y.VALUE.FLD
      AC.REC <-1> = Y.VALUE.FLD
*---------------------------------
      Y.CUR.CAMPO = "ONLINE.ACTUAL.BAL"
      CALL F.READ(FN.ACCOUNTN,AC.ID,R.ACCOUNTN,F.ACCOUNTN,"")
*      Y.VALUE.FLD = R.ACCOUNTN<AC.ONLINE.ACTUAL.BAL>
* Tus Start
R.ECB = ''
ECB.ERR =''
      CALL EB.READ.HVT("EB.CONTRACT.BALANCES",AC.ID,R.ECB,ECB.ERR)
      Y.VALUE.FLD = R.ECB<ECB.ONLINE.ACTUAL.BAL> 
      * Tus End
      Y.VALUE.FLD = Y.CUR.CAMPO:"*":Y.VALUE.FLD
      AC.REC <-1> = Y.VALUE.FLD
    NEXT
  END
  RETURN

*------------------
GET.BOOK.TOVR.CR:
*------------------
  Y.ID.ACT = AC.ID:'-':Y.ACT.MONTH
  Y.BOOK.TOVR.CR = 0
  Y.BOOK.TOVR.DB = 0
  CALL F.READ(FN.ACCT.ACTIVITY,Y.ID.ACT, R.ACCT.ACTIVITY, F.ACCT.ACTIVITY,'')
  IF R.ACCT.ACTIVITY THEN
*DEBUG
    Y.CONT = DCOUNT(R.ACCT.ACTIVITY<IC.ACT.VALUE.DAY>,VM)
    FOR II = 1 TO Y.CONT
      Y.CONT2 = DCOUNT(R.ACCT.ACTIVITY<IC.ACT.BOOK.TOVR.CR,II>,SM)
      FOR III = 1 TO Y.CONT2
        Y.BOOK.TOVR.CR += R.ACCT.ACTIVITY<IC.ACT.BOOK.TOVR.CR,II,III>
        Y.BOOK.TOVR.DB += R.ACCT.ACTIVITY<IC.ACT.BOOK.TOVR.DB,II,III>
      NEXT
    NEXT
  END
  RETURN

*-----------------
GET.STMT.ACCT.CR:
*-----------------
  SEL.CMD = 'SELECT ':FN.STMT.ACCT.CR:' LIKE ':AC.ID:'... BY-DSND @ID'
  LISTA.HDR = ''
  NO.REC.HEADER = ''
  RET.CODE = ''
  CALL EB.READLIST(SEL.CMD, LISTA.HDR, '', NO.REC.HEADER, RET.CODE)

  RETURN
*------------------------
GET.STMT.ACCT.CR.DETAIL:
*------------------------
  LISTA.HDR.AUX = LISTA.HDR
  Y.ID.STMT = AC.ID:'-':Y.ACT.MONTH
  Y.LST.HRD = ''
  Y.I = 0
  IF LISTA.HDR.AUX THEN
    LOOP
      REMOVE ID.STMT.CR FROM LISTA.HDR.AUX SETTING POS
    WHILE (ID.STMT.CR AND (Y.I LT 12))
      Y.TAM = LEN(ID.STMT.CR)-2
      ID.STMT.CR.AUX = ID.STMT.CR[1,Y.TAM]
      IF Y.ID.STMT EQ ID.STMT.CR.AUX THEN
        Y.LST.HRD<-1> = ID.STMT.CR
        Y.I ++
      END

    REPEAT
  END
  RETURN

*************************
INITIALISE:
*=========
  PROCESS.GOAHEAD = 1

  FN.EB.CONTRACT.BALANCES  = 'F.EB.CONTRACT.BALANCES'
  F.EB.CONTRACT.BALANCES   = ''
  R.EB.CONTRACT.BALANCES  = ''

  FN.STMT.ACCT.CR = 'F.STMT.ACCT.CR'
  F.STMT.ACCT.CR  = ''
  R.STMT.ACCT.CR  = ''

  FN.ACCT.ACTIVITY = 'F.ACCT.ACTIVITY'
  F.ACCT.ACTIVITY  = ''
  R.ACCT.ACTIVITY  = ''

  FN.ACCOUNTN = 'F.ACCOUNT'
  F.ACCOUNTN  = ''
  R.ACCOUNTN  = ''

  RETURN

*------------------------
OPEN.FILES:
*=========
  CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)
  CALL OPF(FN.STMT.ACCT.CR,F.STMT.ACCT.CR)
  CALL OPF(FN.ACCT.ACTIVITY, F.ACCT.ACTIVITY)
  CALL OPF(FN.ACCOUNTN,F.ACCOUNTN)

  RETURN
*------------
END
