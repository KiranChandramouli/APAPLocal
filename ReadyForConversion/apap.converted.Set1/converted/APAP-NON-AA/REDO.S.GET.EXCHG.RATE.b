SUBROUTINE REDO.S.GET.EXCHG.RATE(EXCHG.RATE)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Chandra Prakash T
* Program Name  : REDO.S.GET.EXCHG.RATE
* ODR NUMBER    : ODR-2010-01-0213
*----------------------------------------------------------------------------------
* Description   : Deal slip routine attached to FX.FXSN.PSLIP, TT.FXSN.PSLIP & FT.FXSN.SLIP to retrieve exchange rate applied on the transaction, which
*                 depends on the application name
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 13-Jul-2010      Chandra Prakash T  ODR-2010-01-0213  Initial creation
*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
OPEN.FILES:

    FN.FOREX = 'F.FOREX'
    F.FOREX = ''
    CALL OPF(FN.FOREX,F.FOREX)

RETURN

PROCESS:

    CONTRACT.NO = ID.NEW

    BEGIN CASE
        CASE APPLICATION EQ "FOREX"
            IF R.NEW(FX.DEAL.TYPE) EQ 'SP' THEN
                EXCHG.RATE = R.NEW(FX.SPOT.RATE)
            END
            IF R.NEW(FX.DEAL.TYPE) EQ 'FW' THEN
                EXCHG.RATE = R.NEW(FX.FORWARD.RATE)
            END
            IF EXCHG.RATE EQ "" THEN
                EXCHG.RATE = R.NEW(FX.TREASURY.RATE)
            END
    END CASE

RETURN

END
