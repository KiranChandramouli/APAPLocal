SUBROUTINE REDO.CONV.BEN.PRODUCT.TYPE
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------

*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 07-03-2012         RIYAS      ODR-2012-03-0162     Initial Creation
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    BEGIN CASE
        CASE O.DATA EQ 'LOAN'
            O.DATA = 'Prestamo'
        CASE O.DATA EQ 'CARDS'
            O.DATA = 'Tarjeta'
        CASE 1
            O.DATA = 'Cuenta'
    END CASE
RETURN
*-----------------------------------------------------------------------------
END
