*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CHK.ATH.REV.MSG

**************************************************************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Prabhu N
* PROGRAM NAME: REDO.CHK.ATH.REV.MSG
* ODR NO      : ODR-2010-08-0469
*-----------------------------------------------------------------------------------------------------
*DESCRIPTION: this routine is only for ATH 420 messages. When network code is 3 and MTI is 420 then routine will process
*checks ale record exist and if exist return
*if record not exist then check the transaction details and system returns LOC.MSG and new error.
*******************************************************************************************************
*linked with :VERSIONS
*In parameter:
*Out parameter:
*****************************************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_AT.ISO.COMMON
$INSERT I_F.ATM.REVERSAL


  GOSUB OPEN.FILES

  GOSUB PROCESS.FUN

  RETURN
****************
OPEN.FILES:
*****************

  FN.AC.LOCKED.EVENTS='F.AC.LOCKED.EVENTS'

  F.AC.LOCKED.EVENTS =''

  CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)


  RETURN

*****************
PROCESS.FUN:
*****************

  IF AT$INCOMING.ISO.REQ(32) EQ '03' AND AT$INCOMING.ISO.REQ(1) EQ '0420' THEN

    Y.ID.NEW=COMI
    CALL F.READ(FN.AC.LOCKED.EVENTS,Y.ID.NEW,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,ERR)

    IF NOT(R.AC.LOCKED.EVENTS) THEN
      Y.REVERSAL.ID=AT$INCOMING.ISO.REQ(2):'.':AT$INCOMING.ISO.REQ(38)
      CALL F.READ(FN.ATM.REVERSAL,Y.REVERSAL.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ERR)

      Y.REV.ID=R.ATM.REVERSAL<AT.REV.TERM.ID>
      Y.REV.TR=R.ATM.REVERSAL<AT.REV.TRACE>
      Y.REV.DT=R.ATM.REVERSAL<AT.REV.LOCAL.DATE>
      Y.REV.MT=R.ATM.REVERSAL<AT.REV.MESSAGE.TYPE>

      IF AT$INCOMING.ISO.REQ(41) EQ Y.REV.ID AND AT$INCOMING.ISO.REQ(11) EQ Y.REV.TR AND AT$INCOMING.ISO.REQ(13) EQ Y.REV.DT AND AT$INCOMING.ISO.REQ(1) EQ Y.REV.MT THEN
        E="APPROVED ADVICE"
      END
    END
  END
  RETURN
END
