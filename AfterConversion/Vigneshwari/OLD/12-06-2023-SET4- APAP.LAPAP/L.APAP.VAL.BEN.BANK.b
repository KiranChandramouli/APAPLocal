* @ValidationCode : MjotMTg3NDU2MzM4OTpDcDEyNTI6MTY4NjU3NDU3MzYxMjp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jun 2023 18:26:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Rutina para validar que el campo : L.BEN.BANK  "Banco receptor" no este vacio cuando se va
* a crear un beneficiario de un banco externo
* relacionada a la version BENEFICIARY,AI.REDO.ADD.OTHER.BANK.BEN.CONFIRM
* operacion 72 del webservice generico IVRInterfaceTWS
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE		   AUTHOR		   Modification                 DESCRIPTION
*12/06/2023	 VIGNESHWARI   MANUAL R22 CODE CONVERSION       NOCHANGE
*12/06/2023	 CONVERSION    TOOL R22 CODE CONVERSION         F.READ to CACHE.READ,VM to @VM, FM to @FM,T24.BP is removed in insert file.
*-----------------------------------------------------------------------------------------------------------------------
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
        CALL CACHE.READ(FN.EB.ERROR, 'EB-LAPAP.BC.RECEPTOR', R.EB.ERROR, ERROR.EB.ERROR) ;*AUTO R22 CODE CONVERSION
        Y.MENSAJE.ERROR =   R.EB.ERROR<EB.ERR.ERROR.MSG>
        Y.MENSAJE.ERROR = CHANGE(Y.MENSAJE.ERROR,@VM,@FM)
        Y.MENSAJE.ERROR = CHANGE(Y.MENSAJE.ERROR,@SM,@FM)
        ETEXT = Y.MENSAJE.ERROR<2>
        CALL STORE.END.ERROR
        ETEXT = ''
        RETURN

    END
