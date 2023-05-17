*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AUT.ACTIVATION.TIME
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: SWAMINATHAN
* PROGRAM NAME: REDO.AUT.ACTIVATION.TIME
* ODR NO      : ODR-2010-03-0400
*----------------------------------------------------------------------
*DESCRIPTION: This routine is authorisation routine to update time
* LATAM.CARD.ORDER,REDO.ACTIVATION
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*9.03.2011  Swaminathan    ODR-2010-03-0400  INITIAL CREATION
*1 JUL 2011 KAVITHA        ODR-2010-03-0400  PACS00082441 FIX
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.LATAM.CARD.ORDER

  FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
  F.LATAM.CARD.ORDER = ''
  CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)


  Y.TIME = OCONV(TIME(),"MTS")
*PACS00082441 -S
*    Y.DATE = OCONV(DATE(),"D2")
  Y.DATE = TODAY
*PACS00082441 -E

  IF R.NEW(CARD.IS.CARD.STATUS) EQ '94' OR R.NEW(CARD.IS.CARD.STATUS) EQ '50' THEN
    R.NEW(CARD.IS.ACTIVE.DATE) = Y.DATE
    R.NEW(CARD.IS.ACTIVE.TIME) = Y.TIME
  END
  RETURN
END
