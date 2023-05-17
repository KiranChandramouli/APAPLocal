$PACKAGE APAP.TAM

SUBROUTINE REDO.V.VAL.ISS.REQ.PRDT.TYPE
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.V.VAL.ISS.REQ.PRDT.TYPE
*--------------------------------------------------------------------------------
* Description: This Validation routine is used to check on what product does the
* customer logs the request
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE         WHO         REFERENCE         DESCRIPTION
* 24-May-2011   Pradeep S   PACS00071066      INITIAL CREATION
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.REQUESTS

    IF COMI THEN
        GOSUB PROCESS
    END

RETURN

PROCESS:
*********

    BEGIN CASE

        CASE COMI EQ 'TARJETA.DE.CREDITO'
            T(ISS.REQ.ACCOUNT.ID)<3> = 'NOINPUT'
            N(ISS.REQ.CARD.NO) := '.1'
            R.NEW(ISS.REQ.ACCOUNT.ID) = ''
        CASE COMI EQ 'OTROS'
            R.NEW(ISS.REQ.ACCOUNT.ID) = ''
            R.NEW(ISS.REQ.CARD.NO) = ''
        CASE 1
            T(ISS.REQ.CARD.NO)<3> = 'NOINPUT'
            N(ISS.REQ.ACCOUNT.ID) := '.1'
            R.NEW(ISS.REQ.CARD.NO) = ''
    END CASE

RETURN

END
