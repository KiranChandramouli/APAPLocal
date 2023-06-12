* @ValidationCode : Mjo1NTgxNzkyOTE6Q3AxMjUyOjE2ODY1NzQ1Mjc5MDc6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Jun 2023 18:25:27
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
*-----------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE		   AUTHOR				Modification                 DESCRIPTION
*12/06/2023	 VIGNESHWARI	    MANUAL R22 CODE CONVERSION	       NOCHANGE
*12/06/2023	 CONVERSION TOOL    AUTO R22 CODE CONVERSION	       T24.BP is removed in insert file
*-----------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.TRN.DUPLICADA
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.DATES
* Valida si un FT esta duplicado
    GOSUB OPEN.APLICACION
    GOSUB FT.PROCESS

RETURN


OPEN.APLICACION:
    FN.FT = "F.FUNDS.TRANSFER"
    FV.FT = ""
    CALL OPF (FN.FT,FV.FT)

RETURN
FT.PROCESS:
***********
    CALL GET.LOC.REF("FUNDS.TRANSFER","EXT.REF.EPAY",EXT.REF.EPAY.POS)
    Y.TRN = R.NEW(FT.LOCAL.REF)<1,EXT.REF.EPAY.POS>
    Y.CUENTA.DEBITO = TRIM(R.NEW(FT.DEBIT.ACCT.NO))
    Y.CUENTA.CREDITO = TRIM(R.NEW(FT.CREDIT.ACCT.NO))
    Y.MONTO.CREDITO =  TRIM(R.NEW(FT.CREDIT.AMOUNT))
    Y.DATOS.1 = TIMEDATE()
    Y.DATOS.1 = CHANGE(Y.DATOS.1,':','')
    TIME.HH.1 = Y.DATOS.1[1,2]
    GOSUB READ.FT
    IF Y.FT.ANTERIOR NE '' THEN
        Y.RESULTADO =  TIME.HH.1 - TIME.HH
        IF Y.RESULTADO GE 0 AND Y.RESULTADO LE 12 THEN
            ETEXT  = 'TRANSACCION DUPLICADA CON EL FT ANTERIOR: ':Y.FT.ANTERIOR :" HORA ":TIME.HH:":":TIME.MM
            CALL STORE.END.ERROR
            RETURN
        END
    END
RETURN

READ.FT:
**************
    Y.FT.ANTERIOR = '';  Y.FT.ID = ''; Y.HORA.OLD = ''; Y.SEGUNDO.OLD = '';
    SEL.CMD = " SELECT ":FN.FT:" WITH DEBIT.ACCT.NO EQ ":Y.CUENTA.DEBITO
    SEL.CMD:= " AND CREDIT.ACCT.NO EQ ":Y.CUENTA.CREDITO
    SEL.CMD:= " AND CREDIT.AMOUNT EQ ":Y.MONTO.CREDITO
    SEL.CMD:= " AND EXT.REF.EPAY EQ ":Y.TRN

    CALL EB.READLIST(SEL.CMD, SEL.LIST,"", NO.OF.REC, SEL.ERR)
    LOOP
        REMOVE Y.FT.ID FROM SEL.LIST SETTING FT.POS
    WHILE  Y.FT.ID DO
        CALL F.READ (FN.FT,Y.FT.ID, R.FT , FV.FT, ERROR.FT )
        Y.DATOS  = R.FT<FT.DATE.TIME>
        DATE.YY = Y.DATOS[1,2]
        DATE.MM = Y.DATOS[3,2]
        DATE.DD = Y.DATOS[5,2]
        TIME.HH = Y.DATOS[7,2]
        TIME.MM = Y.DATOS[9,2]
        Y.FT.ANTERIOR = Y.FT.ID
        RETURN
    REPEAT
RETURN
END
