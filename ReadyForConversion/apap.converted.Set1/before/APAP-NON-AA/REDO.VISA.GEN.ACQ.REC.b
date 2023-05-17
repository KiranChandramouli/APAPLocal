*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.VISA.GEN.ACQ.REC(REC.ID)
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.VISA.GEN.ACQ.REC
*Date              : 07.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --REC.ID--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*07/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_REDO.VISA.GEN.ACQ.REC.COMMON
$INSERT I_F.REDO.VISA.OUT.MAP
$INSERT I_F.REDO.VISA.OUTGOING
$INSERT I_F.ATM.REVERSAL
$INSERT I_BATCH.FILES

  ATM.ID=FIELD(REC.ID,"*",2)
  IF ATM.ID THEN
    GOSUB PROCESS
  END

  RETURN


*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------
  R.REDO.VISA.OUTGOING=''
  R.ATM.REVERSAL = ''
  CALL F.READ(FN.ATM.REVERSAL,ATM.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.ERROR)
  Y.FIELD.NAME = R.REDO.VISA.OUT.MAP<V.OUT.MAP.FIELD.NAME>
  CNT.FILD.NAME  = DCOUNT(Y.FIELD.NAME,VM)

  Y.VAR = 1
  LOOP
  WHILE Y.VAR LE CNT.FILD.NAME
    FIELD.CONST = ''
    FIELD.VALUE = ''

    FIELD.CONST= R.REDO.VISA.OUT.MAP<V.OUT.MAP.CONSTANT,Y.VAR>
    FLD.POS= R.REDO.VISA.OUT.MAP<V.OUT.MAP.FIELD.POS,Y.VAR>
    ATM.FLD.POS= R.REDO.VISA.OUT.MAP<V.OUT.MAP.ATM.REV.POS,Y.VAR>

    IF ATM.FLD.POS NE '' THEN
      FIELD.VALUE=R.ATM.REVERSAL<ATM.FLD.POS>
    END ELSE
      FIELD.VALUE=FIELD.CONST
    END

    VAL.RTN = R.REDO.VISA.OUT.MAP<V.OUT.MAP.VALUE.RTN,Y.VAR>

    IF VAL.RTN NE '' THEN
      CALL @VAL.RTN
    END

    R.REDO.VISA.OUTGOING<FLD.POS>=FIELD.VALUE

    Y.VAR++
  REPEAT

  R.REDO.VISA.OUTGOING<VISA.OUT.PURCHASE.DATE>=R.ATM.REVERSAL<AT.REV.TRANS.DATE.TIME>[1,4]
  R.REDO.VISA.OUTGOING<VISA.OUT.ACQR.REF.NUM>=FIELD(ATM.ID,".",2)
  R.REDO.VISA.OUTGOING<VISA.OUT.PROCESS.DATE> = TODAY
  R.REDO.VISA.OUTGOING<VISA.OUT.STATUS> ='PENDING'
  GOSUB VISA.NEXT.ID
  CALL REDO.VISA.OUTGOING.WRITE(Y.ID,R.REDO.VISA.OUTGOING)
  VAR.ID = Y.ID:'*':'REDO.VISA.OUTGOING'
  CALL F.WRITE(FN.REDO.VISA.GEN.OUT,VAR.ID,'')
  RETURN
*---------------------------------------------------------------------------------------
VISA.NEXT.ID:
*----------------------------------------------------------------------------------------
  Y.ID.COMPANY=ID.COMPANY
  CALL LOAD.COMPANY(Y.ID.COMPANY)
  FULL.FNAME =FN.REDO.VISA.OUTGOING
  ID.T  = 'A'
  ID.N ='15'
  ID.CONCATFILE = ''
  COMI = ''
  PGM.TYPE = '.IDA'
  ID.NEW = ''
  V$FUNCTION = 'I'
  ID.NEW.LAST = ''
  ID.NEWLAST=ID.NEW.LAST
  CALL GET.NEXT.ID(ID.NEWLAST,'F')
  ID.NEW.LAST=ID.NEWLAST
  Y.ID= COMI
  RETURN
*-----------------------------------------------------------------------------------------------------
END
