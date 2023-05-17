*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.ST.TREASURY(Y.RET)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Arulprakasam P
* PROGRAM NAME: REDO.DS.ST.SELLERS
* ODR NO      : ODR-2010-07-0082
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the Product selected for LETTER

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.SEC.TRADE

  GOSUB PROCESS
  RETURN

PROCESS:
********

  ST.OVERRIDE = R.NEW(SC.SBS.OVERRIDE)
  IF ST.OVERRIDE NE '' THEN
    CHANGE VM TO FM IN ST.OVERRIDE
    Y.COUNT = DCOUNT(ST.OVERRIDE,FM)
    INIT = 1
    LOOP
    WHILE INIT LE Y.COUNT
      REMOVE ST.OVERRIDE.1 FROM ST.OVERRIDE SETTING POS
      FINDSTR '*' IN ST.OVERRIDE.1 SETTING POS.1 THEN
        Y.TRA = FIELD(ST.OVERRIDE.1,'*',3,1)
      END
      INIT++
    REPEAT
  END
  Y.RET = Y.TRA
  RETURN
END
