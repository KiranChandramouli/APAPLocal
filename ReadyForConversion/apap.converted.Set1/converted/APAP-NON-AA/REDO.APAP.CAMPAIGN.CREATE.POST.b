SUBROUTINE REDO.APAP.CAMPAIGN.CREATE.POST
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep P
* Program Name  : REDO.APAP.CAMPAIGN.CREATE
* ODR NUMBER    : ODR-2010-08-0228
*----------------------------------------------------------------------------------
* Description : This is a batch routine which creates the file in the o/p format
* In parameter : None
* out parameter : None
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE             WHO          REFERENCE         DESCRIPTION
* 25-08-2010     Pradeep P    ODR-2010-08-0228    Initial Creation
* ----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    INT.CODE = 'CTI001'
    CALL REDO.INTERFACE.ACT.POST(INT.CODE)
RETURN
END
