*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.PRINT.CHQS
*---------------------------------------------------------------------------------
* This is an routine to call the deal slip for printing
*----------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHOROS Y PRESTAMOS
* Developed By  : SHANKAR RAJU
* ODR NUMBER    : ODR-2010-03-0447
*----------------------------------------------------------------------
*MODIFICATION DETAILS:
*---------------------
*   DATE           RESOURCE           REFERENCE             DESCRIPTION

* 09-03-2011     SHANKAR RAJU      ODR-2010-03-0447     Printing of Cheques
*----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.USER
$INSERT I_RC.COMMON
$INSERT I_GTS.COMMON

  GOSUB INITIALISE

  RETURN
*----------------------------------------------------------------------------------
INITIALISE:
*----------

  DEAL.SLIP.ID = 'CHQ.PRINT.ADMIN'
  OFS$DEAL.SLIP.PRINTING = 1
  CALL PRODUCE.DEAL.SLIP(DEAL.SLIP.ID)

  RETURN
*----------------------------------------------------------------------------------
END
