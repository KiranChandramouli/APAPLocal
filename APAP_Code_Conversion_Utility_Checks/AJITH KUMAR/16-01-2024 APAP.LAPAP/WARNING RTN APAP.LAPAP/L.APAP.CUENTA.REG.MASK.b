* @ValidationCode : MjotNDE0MDkxOTM2OkNwMTI1MjoxNzAwODQyNjQ1NDA1OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Nov 2023 21:47:25
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
*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.CUENTA.REG.MASK
*-----------------------------------------------------------------------------

* Proposito: Identifica si la cuenta corresponde a una cuenta de cliente o interna.
* Parametro de entrada: TT o FT de la transaccion
* Parametro de salida: Cuenta regional debito o credito con el formato 1234********************5678
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
* 09-08-2023      Harishvikram C       Manual R22 conversion      BP Removed, $INCLUDE to $INSERT
* 21/11/2023         Suresh             R22 Manual Conversion      Latest Routine- Changes
*----------------------------------------------------------------------------------------

*    $INCLUDE I_COMMON
*    $INCLUDE I_EQUATE
*    $INCLUDE I_F.FUNDS.TRANSFER
*    $INCLUDE I_F.TELLER
*    $INCLUDE I_F.ACCOUNT


    $INSERT I_COMMON ;*R22 Manual Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT ;*R22 Manual Conversion - End
   $USING EB.LocalReferences


    Y.CUENTA = '' ; Y.CUENTA = COMI;
    GOSUB OPEN.FILE
    GOSUB GET.ACCOUNT.REG
RETURN

OPEN.FILE:
    FN.ACCOUNT = 'F.ACCOUNT'
    FV.ACCOUNT = '';
    CALL OPF (FN.ACCOUNT,FV.ACCOUNT)
    L.AC.ALPH.AC.NO.POS = '';
*    CALL GET.LOC.REF("ACCOUNT","L.AC.ALPH.AC.NO",L.AC.ALPH.AC.NO.POS)
EB.LocalReferences.GetLocRef("ACCOUNT","L.AC.ALPH.AC.NO",L.AC.ALPH.AC.NO.POS);* R22 UTILITY AUTO CONVERSION
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
