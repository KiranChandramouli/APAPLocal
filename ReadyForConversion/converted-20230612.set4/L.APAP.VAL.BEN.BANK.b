* Rutina para validar que el campo : L.BEN.BANK  "Banco receptor" no este vacio cuando se va
* a crear un beneficiario de un banco externo
* relacionada a la version BENEFICIARY,AI.REDO.ADD.OTHER.BANK.BEN.CONFIRM
* operacion 72 del webservice generico IVRInterfaceTWS
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.BEN.BANK
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_F.EB.ERROR

    GOSUB INITIAL
    GOSUB PROCESS

RETURN


INITIAL:
    FN.EB.ERROR = 'F.EB.ERROR'
    FV.EB.ERROR = ''
    CALL OPF(FN.EB.ERROR,FV.EB.ERROR)
    CALL GET.LOC.REF("BENEFICIARY","L.BEN.BANK",L.BEN.BANK.POS)
RETURN

PROCESS:
    IF NOT(R.NEW(ARC.BEN.LOCAL.REF)<1,L.BEN.BANK.POS>) THEN
        CALL CACHE.READ(FN.EB.ERROR, 'EB-LAPAP.BC.RECEPTOR', R.EB.ERROR, ERROR.EB.ERROR)
        Y.MENSAJE.ERROR =   R.EB.ERROR<EB.ERR.ERROR.MSG>
        Y.MENSAJE.ERROR = CHANGE(Y.MENSAJE.ERROR,@VM,@FM)
        Y.MENSAJE.ERROR = CHANGE(Y.MENSAJE.ERROR,@SM,@FM)
        ETEXT = Y.MENSAJE.ERROR<2>
        CALL STORE.END.ERROR
        ETEXT = ''
        RETURN

    END
