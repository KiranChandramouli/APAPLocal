*-----------------------------------------------------------------------------
* <Rating>-78</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.S.INS.VAL

*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* Date         : 25.07.2011
* Description  : Validaciones Generales de Insurance (controladas desde FC)
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date            Who               Reference      Description
* 1.0       25.07.2011      lpazmino          CR.180         Initial Version
* 1.1       03.07.2012      MGUDINO           CR.180         FIX
*-----------------------------------------------------------------------------
* Input/Output: N/A
* Dependencies: N/A
*-----------------------------------------------------------------------------
* <region name="INCLUDES">
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CREATE.ARRANGEMENT
* </region>
  GOSUB PROCESS

  GOSUB SET.DATE.CHARGE
  RETURN
* <region name="INIT" description="Initialise">
INIT:
  Y.NUM.INS  = ''
  Y.MAT.DATE = ''

  RETURN

* </region>

* <region name="COMPARE.DATES" description="Compare Dates">
COMPARE.DATES:
  Y.CONT = 1
  Y.BAND = 1
  LOOP
    Y.DAY = SUBSTRINGS(R.NEW(REDO.FC.INS.DATE.BEG.CHARG)<I,Y.CONT>,7,2)
    IF R.NEW(REDO.FC.INS.DATE.BEG.CHARG)<I,Y.CONT> EQ '' THEN
      Y.BAND = 0
    END
  WHILE Y.BAND

    IF Y.DAY AND R.NEW(REDO.FC.PAYMT.DAY) AND  Y.DAY NE R.NEW(REDO.FC.PAYMT.DAY) THEN
      Y.BAND = 0
      AF = REDO.FC.INS.DATE.BEG.CHARG
      AV = I
      AS = Y.CONT
      TEXT = 'APAP.ASSOCIATED.LOAN.DATE'
      NRO.OVE = DCOUNT(R.NEW(REDO.FC.OVERRIDE),VM) + 1
      CALL STORE.OVERRIDE(NRO.OVE)
    END
    Y.CONT += 1
  REPEAT

  RETURN


* <region name="PROCESS" description="Main process">

PROCESS:

  Y.NUM.INS = DCOUNT(R.NEW(REDO.FC.INS.POLICY.TYPE),VM)
  IF R.NEW(REDO.FC.INS.POLICY.TYPE) AND Y.NUM.INS EQ 0 THEN
    Y.NUM.INS = 1
  END
* Capture the AA Customer

  Y.CUSTOMER = R.NEW(REDO.FC.CUSTOMER)
  I = 1
  LOOP
  WHILE I LE Y.NUM.INS
    Y.INS.CUSTOMER = FIELD(R.NEW(REDO.FC.CUSTOMER.POL),VM,I)
*BEGIN MG 27062012 - compare date with loan creation date.
    GOSUB COMPARE.DATES
*END MG 27062012 - compare date with loan creation date.
    IF NOT(Y.INS.CUSTOMER) THEN
      AF = REDO.FC.CUSTOMER.POL
      AV = I
      ETEXT = 'EB-FLD.NO.MISSING'
      CALL STORE.END.ERROR
      RETURN
    END ELSE
      IF Y.INS.CUSTOMER NE Y.CUSTOMER THEN
        AF = REDO.FC.CUSTOMER.POL
        AV = I
        ETEXT = 'EB-FC-CUS-NO-SAME-INSU'
        CALL STORE.END.ERROR
        RETURN
      END
    END
    I += 1

  REPEAT

  Y.NUM.ADD.INFO = DCOUNT(R.NEW(REDO.FC.INS.POLICY.TYPE),VM)
  Y.OTHER.PARTY  = R.NEW(REDO.FC.INS.OTHER.PARTY)
  FOR I = 1 TO Y.NUM.ADD.INFO
    IF R.NEW(REDO.FC.INS.OTHER.PARTY)<1,I> THEN
      LOCATE R.NEW(REDO.FC.INS.OTHER.PARTY)<1,I> IN R.NEW(REDO.FC.OTHER.PARTY)<1,1> SETTING POS ELSE
        AF = REDO.FC.INS.OTHER.PARTY
        AV = I
        ETEXT = 'EB-FC-CUS-PARTH-INS'
        CALL STORE.END.ERROR
      END
    END
  NEXT I

  Y.NUM.OTHER.PARTY = DCOUNT(R.NEW(REDO.FC.OTHER.PARTY),VM)

  RETURN

* </region>

* <region name="CHECK.INS.OTHER.PARTY" description="Check Other Party">
CHECK.INS.OTHER.PARTY:

  IF R.NEW(REDO.FC.INS.POLICY.TYPE) THEN
    LOCATE R.NEW(REDO.FC.OTHER.PARTY)<1,I.C> IN R.NEW(REDO.FC.INS.OTHER.PARTY)<1,1> SETTING POS ELSE
      AF = REDO.FC.OTHER.PARTY
      AV = I.C
      ETEXT = 'EB-FC-CUS-NO-SAME-INFO'
      CALL STORE.END.ERROR
    END
  END
  RETURN

* </region>
* <region name="SET.DATE.CHARGE" description="Set Date End for Charges">
SET.DATE.CHARGE:


  FOR I = 1 TO Y.NUM.INS
* Ins Mon Pol Amt
    Y.CHK.VA = R.NEW(REDO.FC.INS.MON.POL.AMT)<1,I>
    Y.NUM.MON.POL = DCOUNT(R.NEW(REDO.FC.INS.MON.POL.AMT)<1,I>,SM)
    JK.K = R.NEW(REDO.FC.INS.MON.POL.AMT)<1,I,Y.NUM.MON.POL>
    IF R.NEW(REDO.FC.INS.MON.POL.AMT)<1,I,Y.NUM.MON.POL> EQ '' AND R.NEW(REDO.FC.CLASS.POLICY)<1,I> NE 'ED' THEN
      CONTINUE
    END ELSE
* Set the last SM field
      Y.MAT.DATE = R.NEW(REDO.FC.TERM)
      Y.FEC.CREA = R.NEW(REDO.FC.EFFECT.DATE)
      IF R.NEW(REDO.FC.PAYMT.DAY) THEN
        Y.PAYDAY = R.NEW(REDO.FC.PAYMT.DAY)
        Y.PAYDAY = FMT(Y.PAYDAY,"2'0'R")
        Y.FEC.CREA = Y.FEC.CREA[1,6]:Y.PAYDAY
      END
      CALL CALENDAR.DAY(Y.FEC.CREA,'+',Y.MAT.DATE)
*JP20110909 Solo se establece las nuevas fechas si no existe datos
      Y.CKL = R.NEW(REDO.FC.INS.DATE.END.CHARG)<1,I,Y.NUM.MON.POL>
      IF NOT(R.NEW(REDO.FC.INS.DATE.END.CHARG)<1,I,Y.NUM.MON.POL>) THEN
        R.NEW(REDO.FC.INS.DATE.END.CHARG)<1,I,Y.NUM.MON.POL> = Y.MAT.DATE
      END
    END
* Ins Sec Com Amt
    Y.NUM.SEC.COM = DCOUNT(R.NEW(REDO.FC.INS.SEC.COM.TYPE)<1,I>,SM) ; FLG = ''

    IF R.NEW(REDO.FC.INS.SEC.COM.AMT)<1,I,Y.NUM.SEC.COM> EQ '' THEN
      CONTINUE
    END ELSE
      GOSUB SET.INS.SEC.COM.AMT
    END
* Expire Date by JP20110728
    IF R.NEW(REDO.FC.CLASS.POLICY)<1,I> EQ 'GROUP' AND NOT(R.NEW(REDO.FC.INS.POL.EXP.DATE)<1,I>) THEN
      Y.MAT.DATE = R.NEW(REDO.FC.TERM)
      Y.FEC.CREA = R.NEW(REDO.FC.EFFECT.DATE)
      CALL CALENDAR.DAY(Y.FEC.CREA,'+',Y.MAT.DATE)
      R.NEW(REDO.FC.INS.POL.EXP.DATE)<1,I> = Y.MAT.DATE
* Ins amount by JP
      IF R.NEW(REDO.FC.INS.POLICY.TYPE)<1,I> EQ 'VI' AND NOT(R.NEW(REDO.FC.INS.AMOUNT)<1,I,1>) THEN
        R.NEW(REDO.FC.INS.AMOUNT)<1,I,1> = R.NEW(REDO.FC.AMOUNT)
      END
    END
  NEXT I
  RETURN

* </region>
* <region name="SET.INS.SEC.COM.AMT" description="Set Ins Sec Com Amt">
SET.INS.SEC.COM.AMT:
* Set the last SM field


  Y.MAT.DATE = R.NEW(REDO.FC.TERM)
  Y.FEC.CREA = R.NEW(REDO.FC.EFFECT.DATE)
  IF R.NEW(REDO.FC.PAYMT.DAY) THEN
    Y.PAYDAY = R.NEW(REDO.FC.PAYMT.DAY)
    Y.PAYDAY = FMT(Y.PAYDAY,"2'0'R")
* Y.FEC.CREA = Y.FEC.CREA[1,6]:Y.PAYDAY
    Y.FEC.CREA = R.NEW(REDO.FC.EFFECT.DATE)
  END
  CALL CALENDAR.DAY(Y.FEC.CREA,'+',Y.MAT.DATE)
*JP20110909 Solo se establece las nuevas fechas si no existe datos

  LOOP
  WHILE Y.NUM.SEC.COM GT 0 DO
    FLG += 1
    IF R.NEW(REDO.FC.DATE.BEG.CHARG)<1,I,FLG> EQ '' THEN
      AF = REDO.FC.DATE.BEG.CHARG
      AV = I
      AS = FLG
      ETEXT = 'EB-INT.CARGO.DTE'
      CALL STORE.END.ERROR
    END
    IF NOT(R.NEW(REDO.FC.DATE.END.CHARG)<1,I,FLG>) THEN
      R.NEW(REDO.FC.DATE.END.CHARG)<1,I,FLG> = Y.MAT.DATE
    END ELSE
      IF R.NEW(REDO.FC.DATE.END.CHARG)<1,I,FLG> GT Y.MAT.DATE THEN
        AF = REDO.FC.DATE.END.CHARG
        AV = I
        AS = FLG
        ETEXT = 'EB-END.CARGO.DTE'
        CALL STORE.END.ERROR
      END
    END
    Y.NUM.SEC.COM -= 1
  REPEAT

  RETURN
* </region>
END
