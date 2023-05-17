*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*----------------------------------------------------------------------------
    SUBROUTINE REDO.V.VAL.COLL.RIGHT.CUR


*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.COLL.RIGHT
* Attached as     : ROUTINE
* Primary Purpose : ASSING CURRENCY TO VARIABLE FROM
*                   COLLATERAL
* Incoming:
* ---------


* Outgoing:
* ---------
*
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : JP Armas - Temenos
* Date            :
*
*----------------------------------------------------------------------------------

    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_F.COLLATERAL
    $INCLUDE T24.BP I_System

        Y.COLL.CUR = COMI
        CALL System.setVariable("CURRENT.COL.CUR",Y.COLL.CUR)

RETURN
END
