* @ValidationCode : MjoxNzk0ODc3MzA2OkNwMTI1MjoxNjkxNTU4NjY4ODYwOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Aug 2023 10:54:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.CUENTA.REG.MASK
*-----------------------------------------------------------------------------
* Proposito: Identifica si la cuenta corresponde a una cuenta de cliente o interna.
* Parametro de entrada: TT o FT de la transaccion
* Parametro de salida: Cuenta regional debito o credito con el formato 1234********************5678
*-----------------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 09-08-2023      Harishvikram C   Manual R22 conversion      BP Removed, $INCLUDE to $INSERT
*-----------------------------------------------------------------------------------------------

    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.TELLER
    $INSERT  I_F.ACCOUNT

    Y.CUENTA = '' ; Y.CUENTA = COMI;
    GOSUB OPEN.FILE
    GOSUB GET.ACCOUNT.REG
RETURN

OPEN.FILE:
    FN.ACCOUNT = 'F.ACCOUNT'
    FV.ACCOUNT = '';
    CALL OPF (FN.ACCOUNT,FV.ACCOUNT)
    L.AC.ALPH.AC.NO.POS = '';
    CALL GET.LOC.REF("ACCOUNT","L.AC.ALPH.AC.NO",L.AC.ALPH.AC.NO.POS)
RETURN

GET.ACCOUNT.REG:
    Y.CUENTA.REGIONAL =''; Y.LONGITUD = 0; Y.MASCARA = ''; Y.LOGINTUD2 = ''
    CALL F.READ (FN.ACCOUNT,Y.CUENTA,R.ACCOUNT,FV.ACCOUNT,ERROR.ACCOUNT)
    Y.CUENTA.REGIONAL =  R.ACCOUNT<AC.LOCAL.REF,L.AC.ALPH.AC.NO.POS>
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
**-----------------------------RELLENAR CON * LA POSICION DEL MEDIO
    FOR I =  1 TO LEN(Y.VALOR.MEDIO)
        Y.MASK:= "*"
    NEXT I
    COMI = Y.VALOR.INICIAR : Y.MASK : Y.VALOR.FINAL
RETURN

END
