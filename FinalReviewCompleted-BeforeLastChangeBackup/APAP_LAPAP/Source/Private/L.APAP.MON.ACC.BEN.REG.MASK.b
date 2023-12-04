* @ValidationCode : MjotMTAzNjM5NjE1NjpDcDEyNTI6MTcwMDg0MjY1MTQ5MDpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Nov 2023 21:47:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*--------------------------------------------------------------------------------------------------------------------------
* <Rating>-61</Rating>
*Rutina creada para enviar la cuenta regional de los clientes de otros bancos a la interfaz de monitor
* TABLA FBNK.BENEFICIARY
* CAMPO L.BEN.CTA.REG
* LOGICA, BUSCAR LA CUENTA REGIONAL DEL CAMPO: L.BEN.CTA.REG y retornal la misma en el formato: DO31********************5458
*---------------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.MON.ACC.BEN.REG.MASK
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*21/11/2023         Suresh             R22 Manual Conversion            T24.BP, TAM.BP File Removed
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Manual Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_F.REDO.ACH.PARTICIPANTS
    $INSERT I_F.FUNDS.TRANSFER ;*R22 Manual Conversion - End

    GOSUB INITIAL
    GOSUB PROCESS
 
RETURN
INITIAL:
    FT.ID = COMI
    FN.REDO.ACH.PARTICIPANTS = 'F.REDO.ACH.PARTICIPANTS';
    FV.REDO.ACH.PARTICIPANTS = ''
    CALL OPF (FN.REDO.ACH.PARTICIPANTS,FV.REDO.ACH.PARTICIPANTS)

    FN.BENEFICIARY = 'F.BENEFICIARY'
    FV.BENEFICIARY = ''
    CALL OPF (FN.BENEFICIARY,FV.BENEFICIARY)

    FN.FT = 'F.FUNDS.TRANSFER'
    FV.FT = ''
    CALL OPF (FN.FT,FV.FT)

    L.BEN.BANK.POS = ''; L.BEN.PROD.TYPE.POS = ''; L.BEN.ACCOUNT.POS = ''; L.LBTR.BIC.POS = '';
    L.BEN.CTA.REG.POS = '';
    CALL GET.LOC.REF("BENEFICIARY","L.BEN.BANK",L.BEN.BANK.POS)
    CALL GET.LOC.REF("BENEFICIARY","L.BEN.PROD.TYPE",L.BEN.PROD.TYPE.POS)
    CALL GET.LOC.REF("BENEFICIARY","L.BEN.ACCOUNT",L.BEN.ACCOUNT.POS)
    CALL GET.LOC.REF("BENEFICIARY","L.BEN.CTA.REG",L.BEN.CTA.REG.POS)
    CALL GET.LOC.REF("REDO.ACH.PARTICIPANTS","L.LBTR.BIC",L.LBTR.BIC.POS)
    CALL GET.LOC.REF("FUNDS.TRANSFER","L.FT.ACH.B.ACC",L.FT.ACH.B.ACC.POS)
    CALL GET.LOC.REF("FUNDS.TRANSFER","L.FTST.ACH.PART",L.FTST.ACH.PART.POS)

RETURN

GET.FUNDS.TRANSFER:
    R.FT = ''; ERROR.FT = '';
    CALL F.READ (FN.FT,FT.ID,R.FT,FV.FT,ERROR.FT)

RETURN


GET.BENEFICIARY:
    R.BENEFICIARY = ''; ERROR.BENEFICIARY = ''; Y.L.BEN.BANK = ''; Y.L.BEN.ACCOUNT = ''; Y.L.BEN.PROD.TYPE = '';
    Y.L.BEN.CTA.REG = '';
    CALL F.READ (FN.BENEFICIARY,ID.BENEFICIARY,R.BENEFICIARY,FV.BENEFICIARY,ERROR.BENEFICIARY)
    Y.L.BEN.BANK =      R.BENEFICIARY<ARC.BEN.LOCAL.REF,L.BEN.BANK.POS,1>
    Y.L.BEN.ACCOUNT =   R.BENEFICIARY<ARC.BEN.LOCAL.REF,L.BEN.ACCOUNT.POS,1>
    Y.L.BEN.PROD.TYPE = R.BENEFICIARY<ARC.BEN.LOCAL.REF,L.BEN.PROD.TYPE.POS,1>
    Y.L.BEN.CTA.REG = R.BENEFICIARY<ARC.BEN.LOCAL.REF,L.BEN.CTA.REG.POS,1>
RETURN
GET.REDO.ACH.PARTICIPANTS:
    Y.L.LBTR.BIC = '';
    CALL F.READ (FN.REDO.ACH.PARTICIPANTS,Y.L.BEN.BANK,R.REDO.ACH.PARTICIPANTS,FV.REDO.ACH.PARTICIPANTS,ERROR.REDO.ACH.PARTICIPANTS)
    Y.L.LBTR.BIC = R.REDO.ACH.PARTICIPANTS<REDO.ACH.PARTI.LOCAL.REF,L.LBTR.BIC.POS>
RETURN
PROCESS:
    GOSUB GET.FUNDS.TRANSFER
    IF R.FT<FT.BENEFICIARY.ID> EQ '' THEN
        Y.L.BEN.ACCOUNT = R.FT<FT.LOCAL.REF,L.FT.ACH.B.ACC.POS>
        Y.L.BEN.BANK = R.FT<FT.LOCAL.REF,L.FTST.ACH.PART.POS>
        IF Y.L.BEN.BANK EQ '' THEN
            COMI = "";
            RETURN
        END
        GOSUB  GET.REDO.ACH.PARTICIPANTS
        ID.CUENTA = ''; CODIGO.ENTIDAD = '';
        ID.CUENTA = Y.L.BEN.ACCOUNT;
        CODIGO.ENTIDAD = Y.L.LBTR.BIC[1,4]
        RESPONSE = '';
*       CALL LAPAP.V.INP.CALC.CHEK.DIGIT(ID.CUENTA,CODIGO.ENTIDAD,RESPONSE)  ;*R22 Manual Conversion
        APAP.LAPAP.lapapVInpCalcChekDigit(ID.CUENTA,CODIGO.ENTIDAD,RESPONSE)
        GOSUB GET.ACCOUNT.REG
        RETURN
    END

***-----------------------------------------------------
***Si FT tiene el beneficiario se busca por esta opcion
***-----------------------------------------------------
    ID.BENEFICIARY = R.FT<FT.BENEFICIARY.ID>
    GOSUB GET.BENEFICIARY


    IF Y.L.BEN.BANK EQ '' THEN
        COMI = "";
        RETURN
    END
    IF (Y.L.BEN.PROD.TYPE EQ 'AC.AHO' OR Y.L.BEN.PROD.TYPE EQ 'AC.CUR') THEN
        GOSUB  GET.REDO.ACH.PARTICIPANTS
        ID.CUENTA = ''; CODIGO.ENTIDAD = '';
        ID.CUENTA = Y.L.BEN.ACCOUNT;
        CODIGO.ENTIDAD = Y.L.LBTR.BIC[1,4]
        RESPONSE = '';
        IF Y.L.BEN.CTA.REG EQ '' THEN
*           CALL LAPAP.V.INP.CALC.CHEK.DIGIT(ID.CUENTA,CODIGO.ENTIDAD,RESPONSE) ;*R22 Manual Conversion
            APAP.LAPAP.lapapVInpCalcChekDigit(ID.CUENTA,CODIGO.ENTIDAD,RESPONSE)
        END ELSE
            RESPONSE = Y.L.BEN.CTA.REG;
        END
        GOSUB GET.ACCOUNT.REG
    END
RETURN

GET.ACCOUNT.REG:
    Y.CUENTA.REGIONAL =''; Y.LONGITUD = 0; Y.MASCARA = ''; Y.LOGINTUD2 = ''
    Y.VALOR.INICIAR = '';Y.VALOR.MEDIO = ''; Y.VALOR.FINAL = ''; Y.MASK = '';
    Y.CUENTA.REGIONAL = RESPONSE;
    IF NOT(Y.CUENTA.REGIONAL) THEN
        COMI = "";
        RETURN
    END
    Y.CUENTA.REGIONAL = TRIM(Y.CUENTA.REGIONAL)
    Y.LONGITUD = LEN(Y.CUENTA.REGIONAL)
    Y.VALOR.INICIAR = Y.CUENTA.REGIONAL[1,4]
    Y.LONGITUD2 = Y.CUENTA.REGIONAL[5,(Y.LONGITUD-4)]
    Y.VALOR.MEDIO = Y.CUENTA.REGIONAL[5,LEN(Y.LONGITUD2)-4]
    Y.VALOR.FINAL = Y.CUENTA.REGIONAL[(Y.LONGITUD - 3 ),Y.LONGITUD]
    FOR I =  1 TO LEN(Y.VALOR.MEDIO)
        Y.MASK:= "*"
    NEXT I
    COMI = Y.VALOR.INICIAR : Y.MASK : Y.VALOR.FINAL
RETURN


END
