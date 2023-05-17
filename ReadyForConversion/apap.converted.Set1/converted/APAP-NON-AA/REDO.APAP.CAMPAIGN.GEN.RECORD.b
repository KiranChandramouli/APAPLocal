SUBROUTINE REDO.APAP.CAMPAIGN.GEN.RECORD
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep P
* Program Name  : REDO.APAP.CAMPAIGN.GEN.RECORD
* ODR NUMBER    : ODR-2010-08-0228
*----------------------------------------------------------------------------------
* Description : This Record routine is create a new record in the Template
* In parameter : None
* out parameter : None
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE             WHO          REFERENCE         DESCRIPTION
* 25-08-2010     Pradeep P    ODR-2010-08-0228    Initial Creation
* ----------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.CAMPAIGN.GEN

    IF V$FUNCTION EQ 'I' THEN
        IF R.NEW(REDO.CAMPGN.GEN.CAMPAIGN.ID) NE '' THEN
            R.NEW(REDO.CAMPGN.GEN.CAMPAIGN.ID) = ''
        END
    END
RETURN
END
