*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.AGENCY.DET
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CONV.AGENCY.DET
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.CLASSIFICATION is a conversion routine attached to the ENQUIRY>
*                    REDO.APAP.NOF.LINK.RPT, the routine fetches the value from O.DATA delimited
*                    with stars and formats them according to the selection criteria and returns the value
*                     back to O.DATA
*Linked With       :
*In  Parameter     : N/A
*Out Parameter     : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*--------------------------------------------------------------------------------------------------------
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 20 OCT 2010              Dhamu S             ODR-2010-03-0098            Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
  GOSUB PROCESS.PARA

  RETURN
*------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

  IF NOT(O.DATA) THEN
    O.DATA = "ALL"
  END

  RETURN
END
*------------------------------------------------------------------------------------------------------
