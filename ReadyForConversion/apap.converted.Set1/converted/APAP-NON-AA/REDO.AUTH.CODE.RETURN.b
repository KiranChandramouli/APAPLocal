SUBROUTINE REDO.AUTH.CODE.RETURN(IN.VAR,RET.VAL)

*    $INCLUDE GLOBUS.BP I_COMMON        ;*/ TUS START
*    $INCLUDE GLOBUS.BP I_EQUATE
*    $INCLUDE  ATM.BP I_AT.ISO.COMMON

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AT.ISO.COMMON                ;*/ TUS END

******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :BALA GURUNATHAN
*  Program   Name    :REDO.AUTH.CODE.RETURN
***********************************************************************************
*linked with: NA
*In parameter: NA
*Out parameter: NA
**********************************************************************

* Modification History :
*-----------------------
*  DATE            WHO          REFERENCE          DESCRIPTION
* 22-11-2010  BALA GURUNATHAN  ODR-2010-08-0469    INITIAL CREATION
* ----------------------------------------------------------------------------




    RET.VAL=UNIQUE.ID


RETURN

END
