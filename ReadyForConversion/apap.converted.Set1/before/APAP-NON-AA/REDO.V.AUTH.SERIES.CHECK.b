*-----------------------------------------------------------------------------
* <Rating>-38</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.AUTH.SERIES.CHECK
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.ORDER.DETAILS
*----------------------------------------------------------------------------
* Description:
* This routine will be attached to the version REDO.ORDER.DETAIL,ITEM.REQUEST as
* a auth routine
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.V.AUTH.SERIES.CHECK
*-------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE             DESCRIPTION
* 12.04.2010  MARIMUTHU S     FIX FOR ISSUE HD1053868  INITIAL CREATION
* ------------------------------------------------------------------------
*----------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------------------
  GOSUB INIT
  GOSUB PROCESS
  RETURN

*-----------------------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------------------
  Y.REJ.ORDER = ''
  Y.REJ.ORDER = R.NEW(RE.ORD.REJECTED.ORDER)

  RETURN
*-----------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------

  IF Y.REJ.ORDER EQ 'YES' THEN

    R.NEW(RE.ORD.ORDER.STATUS) = "Orden Rechazada"

  END

  IF (Y.REJ.ORDER EQ 'NO' OR Y.REJ.ORDER EQ '') THEN

    R.NEW(RE.ORD.ORDER.STATUS) = "Orden Despachada"

  END

  RETURN
END
