*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.CARD.REQUEST.ID(Y.CARD.NUM,REQUEST.ID,CARD.TYPE,ERR)

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.GET.CARD.REQUEST.ID
*--------------------------------------------------------------------------------
* Description:  This routine is to get the REDO.CARD.REQUEST ID from the Card Number
*
* Input Arg : Y.CARD.NUM -> Latam Card Number
* Out Arg   : REQUEST.ID -> Request ID
*             CARD.TYPE  -> Return the Card Type
*             ERR        -> Error If any
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 04-May-2011     H GANESH      PACS00054728   INITIAL CREATION
*
*----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CARD.BIN
$INSERT I_F.REDO.CARD.NUMBERS



  GOSUB INIT
  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

  REQUEST.ID=''
  POSITION=''
  ERR=''

  FN.REDO.CARD.BIN='F.REDO.CARD.BIN'
  F.REDO.CARD.BIN=''
  CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

  FN.REDO.CARD.NUMBERS='F.REDO.CARD.NUMBERS'
  F.REDO.CARD.NUMBERS=''
  CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
* This part gets the Card type REDO.CARD.BIN

  Y.BIN.NO=Y.CARD.NUM[1,6]
  CALL F.READ(FN.REDO.CARD.BIN,Y.BIN.NO,R.CARD.BIN,F.REDO.CARD.BIN,BIN.ERR)
  IF BIN.ERR THEN
    ERR='Bin Not Found'
    RETURN
  END
  Y.CARD.TYPE = R.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>
  GOSUB CHECK.CARD

  RETURN
*---------------------------------------------------------------------------------
CHECK.CARD:
*---------------------------------------------------------------------------------
* This part checks the REDO.CARD.NUMBERS for the Latam card and gets the respective REDO.CARD.REQUEST

  Y.NO.OF.CARD.TYPES=DCOUNT(Y.CARD.TYPE,VM)
  Y.VAR1=1
  LOOP
  WHILE Y.VAR1 LE Y.NO.OF.CARD.TYPES
    Y.CARD.NOS=Y.CARD.TYPE<1,Y.VAR1>:'.':ID.COMPANY
    CALL F.READ(FN.REDO.CARD.NUMBERS,Y.CARD.NOS,R.CARD.NUMBERS,F.REDO.CARD.NUMBERS,NUMS.ERR)
    LOCATE Y.CARD.NUM IN R.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER,1> SETTING CARD.POS THEN
      REQUEST.ID=R.CARD.NUMBERS<REDO.CARD.NUM.CRD.REQ.ID,CARD.POS>
      CARD.TYPE=Y.CARD.TYPE<1,Y.VAR1>
      CARD.STAT= R.CARD.NUMBERS<REDO.CARD.NUM.STATUS,CARD.POS>
      BREAK
    END
    Y.VAR1++
  REPEAT

  IF REQUEST.ID EQ ''OR (CARD.STAT EQ 'DAMAGED' OR CARD.STAT EQ 'LOST' OR CARD.STAT EQ 'DESTROY' ) THEN
    ERR='Request Not Found'
  END

  RETURN
END
