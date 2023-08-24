$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.REINV.DEPOSIT.PRD
*-----------------------------------------------------------------------------

*Description: This routine is hot validation routine for deposit product field in order to default the category in PRODUCT.CODE

*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 24-02-2011      H GANESH      PACS00033293       Initial Draft
** 18-04-2023 R22 Auto Conversion no changes
** 18-04-2023 Skanda R22 Manual Conversion - No changes
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.REDO.H.AZ.REINV.DEPOSIT


    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL CACHE.READ('F.AZ.PRODUCT.PARAMETER',COMI,R.AZ.PRD.PARAM,PARAM.ERR)
    R.NEW(REDO.AZ.REINV.PRODUCT.CODE)=R.AZ.PRD.PARAM<AZ.APP.ALLOWED.CATEG>

RETURN
END
