*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.STLMT.BIN.ADD.DIGIT
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.STLMT.BIN.ADD.DIGIT
*************************************************************************
*Description: This routine is to validate the card number in case of Excess
* 19 digit card number
****************************************************************************
*In parameter : NA
*Out paramter : NA
*Linked with : REDO.VISA.STLMT.FILE.PROCESS
**************************************************************************
*Modification History:
*-------------------------
** Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*03.12.2010   S DHAMU       ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON
$INSERT I_F.REDO.VISA.STLMT.05TO37
$INSERT I_F.LATAM.CARD.ORDER


  IF ERROR.MESSAGE NE '' THEN
    RETURN
  END


  GOSUB PROCESS

  RETURN

********
PROCESS:
********

  CARD.NUMBER=R.REDO.STLMT.LINE<VISA.SETTLE.ACCOUNT.NUMBER>

  IF Y.FIELD.VALUE NE 0 AND CHECK.ADD.DIGIT EQ 'TRUE' THEN
    Y.FIELD.VALUE=FMT(Y.FIELD.VALUE,'R0%3')
    CARD.NUMBER=CARD.NUMBER:Y.FIELD.VALUE
    LTM.CARD.NUMBER = CARD.TYPE.VAL:'.':CARD.NUMBER
    CALL F.READ(FN.LATAM.CARD.ORDER,LTM.CARD.NUMBER,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,CARD.ORDER.ER)
    IF R.LATAM.CARD.ORDER EQ '' THEN
      ERROR.MESSAGE = 'CARD.NUM.DOESNT.EXIST'
    END
  END

  IF Y.FIELD.VALUE EQ 0 AND CHECK.ADD.DIGIT EQ 'TRUE' THEN
    ERROR.MESSAGE = 'CARD.NUM.DOESNT.EXIST'
  END

  RETURN
END
*------------------End of program--------------------------------------
