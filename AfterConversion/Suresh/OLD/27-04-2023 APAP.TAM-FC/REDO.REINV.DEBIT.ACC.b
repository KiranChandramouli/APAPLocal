* @ValidationCode : Mjo3OTQ1OTY3NzA6Q3AxMjUyOjE2ODI0OTY0MzM0MTQ6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Apr 2023 13:37:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.REINV.DEBIT.ACC

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.REINV.DEBIT.ACC
*--------------------------------------------------------------------------------
* Description: This Validation routine is to check whether the entered debit account
* has sufficient fund
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE          DESCRIPTION
* 05-Jul-2011    H GANESH      PACS00072695_N.11  INITIAL CREATION
*
** 13-04-2023 R22 Auto Conversion no changes
** 13-04-2023 Skanda R22 Manual Conversion - added APAP.TAM, CALL routine format modified
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_EB.TRANS.COMMON

    IF COMI EQ '' THEN
        RETURN
    END

    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    LOC.REF.APPLICATION="ACCOUNT"
    LOC.REF.FIELDS="L.AC.AV.BAL"
    LOC.REF.POS=''
    CALL APAP.TAM.MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS) ;*MANUAL R22 CODE CONVERSION

    POS.L.AC.AV.BAL = LOC.REF.POS<1,1>

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    Y.ACC.ID = COMI
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACC,F.ACCOUNT,ACC.ERR)
    Y.ACC.BAL = R.ACC<AC.LOCAL.REF,POS.L.AC.AV.BAL>
*C$SPARE(456) = Y.ACC.BAL
    Y.PRINCIPAL     = R.NEW(AZ.PRINCIPAL)

    IF Y.PRINCIPAL GT Y.ACC.BAL THEN

*AF = AZ.REPAY.ACCOUNT
*ETEXT = "EB-INSUFFICIENT.FUNDS"
*CALL STORE.END.ERROR

    END



RETURN
END
