*-----------------------------------------------------------------------------
* <Rating>179</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CHK.REC.PIN.EXCEED

**************************************************************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Balagurunathan B
* PROGRAM NAME: REDO.ATM.ADVICE.MSG
* ODR NO      : ODR-2010-08-0469
*-----------------------------------------------------------------------------------------------------
*DESCRIPTION: It is a pre-Authorised message .In T24 only reference transaction will be stored
*The below routine will be attached to FT version to reject the transaction with response code NE 00 and mark the card as pin exceed when resp is 75
*Error message raised will be mapped with response code 00
*This will be attached as CHECK REC routine of LATAM.CARD.ORDER,REDO.PIN.EXCEED version attached in 0220xxxxxx

*******************************************************************************************************
*linked with :VERSIONS
*In parameter:
*Out parameter:
*****************************************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_AT.ISO.COMMON
$INSERT I_F.REDO.CARD.BIN
$INSERT I_F.LATAM.CARD.ORDER


  GOSUB OPEN.FILES

  GOSUB PROCESS.FUN

  RETURN
****************
OPEN.FILES:
*****************

  FN.REDO.CARD.BIN='F.REDO.CARD.BIN'

  F.REDO.CARD.BIN=''

  CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

  FN.LATAM.CARD.ORDER ='F.LATAM.CARD.ORDER'
  F.LATAM.CARD.ORDER=''

  CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)

  ID.BIN=AT$INCOMING.ISO.REQ(2)[1,6]

  CALL F.READ(FN.REDO.CARD.BIN,ID.BIN,R.REDO.CARD.BIN,F.REDO.CARD.BIN,ERR.BIN)

  RETURN

*****************
PROCESS.FUN:
*****************
*    REDO.CARD.BIN.BIN.TYPE
*    REDO.CARD.BIN.CARD.TYPE

  BIN.TYPE=R.REDO.CARD.BIN<REDO.CARD.BIN.BIN.TYPE>
  YCRD.TYPE=R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>

  CNT.TYPES.COUNT=DCOUNT(YCRD.TYPE,VM)

  Y.FLAG.CRD=1

  IF BIN.TYPE = 'CREDIT' THEN
    E="REJECTED ADVICE"
  END ELSE

    LOOP

      REMOVE YCRD.TYPE.ID FROM YCRD.TYPE SETTING POS.TYPE


    WHILE YCRD.TYPE.ID:POS.TYPE
      IF Y.FLAG.CRD THEN
        CARD.ID=YCRD.TYPE.ID: "." :AT$INCOMING.ISO.REQ(2)

        CRD.ERR =''
        CALL F.READ(FN.LATAM.CARD.ORDER,CARD.ID,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,CRD.ERR)

        IF CRD.ERR = '' THEN
          ID.NEW=CARD.ID
          IF R.LATAM.CARD.ORDER<CARD.IS.CARD.STATUS> EQ 75 THEN
            E='Card status changed to PIN EXCEEDED'
          END
          IF R.LATAM.CARD.ORDER<CARD.IS.CARD.STATUS> NE 75 AND R.LATAM.CARD.ORDER<CARD.IS.CARD.STATUS> NE 94 THEN
            E='Card is not Active to change PIN EXCEED, Refer card status'
          END
          IF R.LATAM.CARD.ORDER<CARD.IS.CARD.STATUS> EQ 94 THEN
            LOC.MSG='Card status changed to PIN EXCEEDED'

          END
          Y.FLAG.CRD=0
        END

      END
    REPEAT

  END

  UNIQUE.ID=TRIM(AT$INCOMING.ISO.REQ(38))

  RETURN


END
