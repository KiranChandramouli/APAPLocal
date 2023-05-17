*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CONV.ABS.RTN
****************************************************
*Company Name: Asociacion Popular de Ahorros y Prestamos
*Program Name: REDO.E.CONV.ABS.RTN
************************************************************
*Description: This conversion routine returns absolute value
************************************************************
*Modification Details:
*=====================
*      Date          Who             Reference               Description
*     ------         -----           -------------           -------------
*   10/09/2010       MD Preethi       0DR-2010-07-0073 FX002  Initial Creation
*******************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

*Process Para:
***************

  Y.POSITION.RATE=O.DATA
  Y.POSITION.RATE=ABS(Y.POSITION.RATE)
  O.DATA=Y.POSITION.RATE

  RETURN
END
