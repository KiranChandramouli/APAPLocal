SUBROUTINE REDO.V.VAL.MOD.DISP.DI
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.MOD.DISP.DI
* Attached as     : ROUTINE
* Primary Purpose :
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            : Calc all values if the user change a values for VNG
*                   "VALOR NOMINAL DE LA GARANTIA"
*-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END


RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
    VAR.VNG = COMI

    R.NEW(COLL.EXECUTION.VALUE) = VAR.VNG
    R.NEW(COLL.GEN.LEDGER.VALUE) = VAR.VNG

*IF THE MAX VALUES IS NOT SET THEN SET THE SAME VALUE
    Y.MAX = R.NEW(COLL.MAXIMUM.VALUE)

    IF LEN(Y.MAX) EQ 0 THEN
        R.NEW(COLL.MAXIMUM.VALUE) = VAR.VNG
    END

*CALC THE REA VALUE
    CALL  REDO.V.VAL.REA.COLLATERAL


RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    FN.COLLATERAL   = 'F.COLLATERAL'
    F.COLLATERAL    = ''
    R.COLLATERAL    = ''


RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
RETURN
*------------
END
