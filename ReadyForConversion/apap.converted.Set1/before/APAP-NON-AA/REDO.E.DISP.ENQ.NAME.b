*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.DISP.ENQ.NAME
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Martin
* Program Name : REDO.V.VAL.ARCIB.PART.PYMNT
*-----------------------------------------------------------------------------
* Description : The purpose is to display the report name in header
* In Parameter : ENQ.DATA
* Out Parameter : None
**DATE           ODR                   DEVELOPER               VERSION
*17/10/13      PACS00311745          Deepak                  Modification
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

  Y.ENQ.NAME = ENQ.SELECTION<1>

  BEGIN CASE
  CASE Y.ENQ.NAME EQ 'REDO.APAP.INVST.RATE'
    O.DATA = "REPORTE DE CAMBIOS DE TASA DE INSTRUMENTOS DE INVERSION"

  CASE Y.ENQ.NAME EQ 'REDO.E.OPEN.CAN.INVST.REP'
    O.DATA = 'REPORTE DE INVERSIONES APERTURADAS Y CANCELADAS'


  END CASE

  RETURN

END
