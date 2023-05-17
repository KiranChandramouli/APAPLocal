*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.BLD.E.REPRINT.TXN(ENQ.DATA)

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  :
* Program Name  : REDO.BLD.E.REPRINT.TXN
*-------------------------------------------------------------------------
* Description:
*
*----------------------------------------------------------
* Linked with: All enquiries with REDO.APAP.H.DEAL.SLIP.QUEUE no as selection field
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
***********************************************************************
*DATE                WHO                   REFERENCE         DESCRIPTION
*20-12-2010        S.DHAMU              ODR-2011-01-0103    INITIAL CREATION
*27.1.2011         C.SRIRAMAN           ODR-2011-01-0103    INITIAL CREATION
****************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.APAP.H.REPRINT.SEQ

  FN.REDO.APAP.H.REPRINT.SEQ.NAU = 'F.REDO.APAP.H.REPRINT.SEQ$NAU'
  F.REDO.APAP.H.REPRINT.SEQ.NAU = ''
  CALL OPF(FN.REDO.APAP.H.REPRINT.SEQ.NAU,F.REDO.APAP.H.REPRINT.SEQ.NAU)

  CALL F.READ(FN.REDO.APAP.H.REPRINT.SEQ.NAU,ENQ.DATA<4,1>,R.REDO.APAP.H.REPRINT.SEQ,F.REDO.APAP.H.REPRINT.SEQ.NAU,REDO.APAP.H.REPRINT.SEQ.ERR)

  IF R.REDO.APAP.H.REPRINT.SEQ THEN
    ENQ.ERROR = 'REIMPRIMIR REQUIERE AUTORIZACION - ':ENQ.DATA<4,1>
  END

  RETURN
