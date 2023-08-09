* @ValidationCode : MjotMTM4NzU0MzQwNzpDcDEyNTI6MTY5MTU3NjY4MTkzNjp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Aug 2023 15:54:41
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
    SUBROUTINE LAPAP.V.INP.CALC.CHEK.DIGIT (ID.CUENTA,CODIGO.ENTIDAD,RESPONSE)
*-----------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :LAPAP.V.INP.CALC.CHEK.DIGIT
*Basado en la logica de la rutina : REDO.V.INP.CALC.CHEK.DIGIT
*-----------------------------------------------------------------------------------

*DESCRIPTION       :This Program is used for calculate the value of CHECK.DIGIT,
*                   Alphanumeric Equivalent of the Account Number and its equivalent
*                   Standard account Number
*
*LINKED WITH       :
*-------------------------------------------------------------------------------------------------------------------------
*
* Modification History :
*-----------------------
*  DATE             WHO             REFERENCE                    DESCRIPTION
*09/08/2023       VIGNESHWARI   MANUAL R22 CODE CONVERSION  T24.BP,TAM.BP is removed in insertfile,SM TO @SM,VM TO @VM
*-------------------------------------------------------------------------------------------------------------------------
*
* -----------------------------------------------------------------------------------

    $INSERT   I_COMMON ;*MANUAL R22 CODE CONVERSION -T24.BP is removed in insertfile -START
    $INSERT   I_EQUATE
    $INSERT   I_F.BENEFICIARY ;*MANUAL R22 CODE CONVERSION -END
    $INSERT   I_F.REDO.H.REPORTS.PARAM ;*MANUAL R22 CODE CONVERSION -TAM.BP is removed in insertfile -START

    *ID.CUENTA = '14912290013'
    *CODIGO.ENTIDAD = 'BCBH'
    *RESPONSE = ''

    GOSUB INIT
    GOSUB PROCESS
    RETURN
*------------------------------------------------------------------------------------
INIT:

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    FV.REDO.H.REPORTS.PARAM = ''
    CALL OPF (FN.REDO.H.REPORTS.PARAM,FV.REDO.H.REPORTS.PARAM)
    R.REDO.H.REPORTS.PARAM = ''
    RTE.PARAM.ERR = ''
    RTE.PARAM.ID = 'DIGITO.VERIFICADOR'
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,RTE.PARAM.ID,R.REDO.H.REPORTS.PARAM,RTE.PARAM.ERR)
    Y.ARREGLO = '';
    COUNTRY.CODE = 132400
    RETURN

PROCESS:

    *DEBUG
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    END

    LOCATE "CHECK.DIGIT" IN Y.FIELD.NME.ARR<1,1> SETTING CASH.VER.POS THEN
        Y.TABLA = Y.FIELD.VAL.ARR<1,CASH.VER.POS>
        Y.TABLA.NUM = Y.DISP.TEXT.ARR<1,CASH.VER.POS>
    END

    Y.TABLA = CHANGE(Y.TABLA,@SM,@VM) ;*MANUAL R22 CODE CONVERSION
    Y.TABLA.NUM = CHANGE(Y.TABLA.NUM,@SM,@VM);*MANUAL R22 CODE CONVERSION

    LOCATE CODIGO.ENTIDAD[1,1] IN Y.TABLA<1,1> SETTING REGACC.POS1 THEN
        Y.ARREGLO<1> = Y.TABLA.NUM<1,REGACC.POS1>
    END
    LOCATE CODIGO.ENTIDAD[2,1] IN Y.TABLA<1,1> SETTING REGACC.POS2 THEN
        Y.ARREGLO<2> = Y.TABLA.NUM<1,REGACC.POS2>
    END

    LOCATE CODIGO.ENTIDAD[3,1] IN Y.TABLA<1,1> SETTING REGACC.POS3 THEN
        Y.ARREGLO<3> = Y.TABLA.NUM<1,REGACC.POS3>
    END

    LOCATE CODIGO.ENTIDAD[4,1] IN Y.TABLA<1,1> SETTING REGACC.POS4 THEN
        Y.ARREGLO<4> = Y.TABLA.NUM<1,REGACC.POS4>
    END

    NUMERIC.CODE.OF.GENERIC = Y.ARREGLO<1>:Y.ARREGLO<2>:Y.ARREGLO<3>:Y.ARREGLO<4>
    ACCOUNT.ID=ID.CUENTA


    ACC.ID.TWTY= FMT(ACCOUNT.ID,'R%20')
    ACC.ID.ELEV = FMT(ACCOUNT.ID,'R%11')

    TOTAL.DIGIT=NUMERIC.CODE.OF.GENERIC:ACC.ID.TWTY:COUNTRY.CODE
    CHECK.DIGIT=98-MOD(TOTAL.DIGIT,97)
    CHECK.DIGIT = FMT(CHECK.DIGIT,'R%2')
*R.NEW(AC.LOCAL.REF)<1,LOC.CHEK.DIGIT>= CHECK.DIGIT

    ALPHA.NUM.ID = 'DO':CHECK.DIGIT:CODIGO.ENTIDAD:ACC.ID.TWTY
    RESPONSE = ALPHA.NUM.ID;
*R.NEW(AC.LOCAL.REF)<1,LOC.ALPH.AC.NO>=ALPHA.NUM.ID
*STAND.NUM.ID = '214':NUMERIC.CODE.OF.GENERIC:ACC.ID.ELEV
*R.NEW(AC.LOCAL.REF)<1,LOC.STD.ACC.NO>=STAND.NUM.ID

    RETURN
END
