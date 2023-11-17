* @ValidationCode : MjotMTAxMDQ1OTY3MzpDcDEyNTI6MTY5MTY2NjI1Mzk5MjpJVFNTOi0xOi0xOjE4MzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Aug 2023 16:47:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 183
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.SET.ACC.REG
*-----------------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 09-08-2023      Harishvikram C   Manual R22 conversion      BP Removed, $INCLUDE to $INSERT, CALL routine format modified
*-----------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_F.REDO.ACH.PARTICIPANTS

    GOSUB INITIAL
    GOSUB PROCESS
RETURN
INITIAL:

    FN.REDO.ACH.PARTICIPANTS = 'F.REDO.ACH.PARTICIPANTS';
    FV.REDO.ACH.PARTICIPANTS = ''
    CALL OPF (FN.REDO.ACH.PARTICIPANTS,FV.REDO.ACH.PARTICIPANTS)
    L.BEN.BANK.POS = ''; L.BEN.PROD.TYPE.POS = ''; L.BEN.ACCOUNT.POS = ''; L.LBTR.BIC.POS = '';
    CALL GET.LOC.REF("BENEFICIARY","L.BEN.BANK",L.BEN.BANK.POS)
    CALL GET.LOC.REF("BENEFICIARY","L.BEN.PROD.TYPE",L.BEN.PROD.TYPE.POS)
    CALL GET.LOC.REF("BENEFICIARY","L.BEN.ACCOUNT",L.BEN.ACCOUNT.POS)
    CALL GET.LOC.REF("BENEFICIARY","L.BEN.CTA.REG",L.BEN.CTA.REG.POS)
    CALL GET.LOC.REF("REDO.ACH.PARTICIPANTS","L.LBTR.BIC",L.LBTR.BIC.POS)
    Y.L.BEN.BANK = R.NEW(ARC.BEN.LOCAL.REF)<1,L.BEN.BANK.POS,1>
    Y.L.BEN.ACCOUNT = R.NEW(ARC.BEN.LOCAL.REF)<1,L.BEN.ACCOUNT.POS,1>
    Y.L.BEN.PROD.TYPE =  R.NEW(ARC.BEN.LOCAL.REF)<1,L.BEN.PROD.TYPE.POS,1>

RETURN

GET.REDO.ACH.PARTICIPANTS:
    CALL F.READ (FN.REDO.ACH.PARTICIPANTS,Y.L.BEN.BANK,R.REDO.ACH.PARTICIPANTS,FV.REDO.ACH.PARTICIPANTS,ERROR.REDO.ACH.PARTICIPANTS)
    Y.L.LBTR.BIC = R.REDO.ACH.PARTICIPANTS<REDO.ACH.PARTI.LOCAL.REF,L.LBTR.BIC.POS>

RETURN



PROCESS:
    IF Y.L.BEN.BANK EQ '' THEN
        RETURN
    END
    IF (Y.L.BEN.PROD.TYPE EQ 'AC.AHO' OR Y.L.BEN.PROD.TYPE EQ 'AC.CUR') THEN
        GOSUB  GET.REDO.ACH.PARTICIPANTS
        ID.CUENTA = ''; CODIGO.ENTIDAD = '';
        ID.CUENTA = Y.L.BEN.ACCOUNT;
        CODIGO.ENTIDAD = Y.L.LBTR.BIC[1,4]
        RESPONSE = '';
*        CALL LAPAP.V.INP.CALC.CHEK.DIGIT(ID.CUENTA,CODIGO.ENTIDAD,RESPONSE)
        APAP.LAPAP.lapapVInpCalcChekDigit(ID.CUENTA,CODIGO.ENTIDAD,RESPONSE)    ;*Manual R22 conversion
        R.NEW(ARC.BEN.LOCAL.REF)<1,L.BEN.CTA.REG.POS,1> = RESPONSE;
    END
RETURN

END
