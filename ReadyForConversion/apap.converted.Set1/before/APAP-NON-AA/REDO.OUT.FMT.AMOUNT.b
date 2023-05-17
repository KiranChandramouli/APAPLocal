*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.OUT.FMT.AMOUNT
*************************************************************************
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : H GANESH
* Program Name : REDO.OUT.FMT.AMOUNT
*****************************************************************
*Description: This routine is to format the transaction amount
*******************************************************************************
*In parameter : None
*Out parameter : None
****************************************************************************
*Modification History:
**************************
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   5-01-2011       H Ganesh              ODR-2010-08-0469         Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON


  GOSUB PROCESS
  RETURN


PROCESS:

  Y.AMT=Y.FIELD.VALUE*100
  Y.FIELD.VALUE=Y.AMT

  RETURN
END
