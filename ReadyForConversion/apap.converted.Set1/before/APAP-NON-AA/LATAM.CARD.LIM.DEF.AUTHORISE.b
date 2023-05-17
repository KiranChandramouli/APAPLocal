*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE LATAM.CARD.LIM.DEF.AUTHORISE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : LATAM.CARD.LIM.DEF.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Description       :  LATAM.CARD.LIM.DEF.AUTHORISE is an authorisation routine for the template LATAM.CARD.LIM.DEF,
*                     the routine updates the table REDO.INCR.DECR.ATM.POS.AMT with required values
*
*In Parameter      :N/A
*Out Parameter     :N/A
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference                      Description
*   ------         ------               -------------                    -------------
*  02/09/2010      MD.PREETHI          ODR-2010-03-0106 131                 Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.LATAM.CARD.LIM.DEF

  GOSUB PROCESS.PARA

  RETURN

PROCESS.PARA:

  CALL REDO.APAP.INCR.DECR.ATM.POS.AMT.UPD

  RETURN
END
