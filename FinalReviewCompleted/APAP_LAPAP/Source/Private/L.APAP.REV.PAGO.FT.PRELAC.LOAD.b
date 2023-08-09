* @ValidationCode : MjoxMDA4MjAyNDA1OkNwMTI1MjoxNjkwMTY3NTM1MDk1OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.REV.PAGO.FT.PRELAC.LOAD
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.ST.L.APAP.PRELACION.COVI19.DET
    $INSERT  I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT  I_L.APAP.REV.PAGO.FT.PRELAC.COMMON
    GOSUB TABLAS

RETURN

TABLAS:

    FN.FUNDS.TRANSFER$HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER$HIS = ''
    CALL OPF (FN.FUNDS.TRANSFER$HIS,F.FUNDS.TRANSFER$HIS)

    FN.ST.L.APAP.PRELACION.COVID19.DET = 'F.ST.L.APAP.PRELACION.COVI19.DET'
    FV.ST.L.APAP.PRELACION.COVID19.DET =  ''
    CALL OPF (FN.ST.L.APAP.PRELACION.COVID19.DET,FV.ST.L.APAP.PRELACION.COVID19.DET)

    FN.ST.L.APAP.COVID.PRELACIONIII = 'F.ST.L.APAP.COVI.PRELACIONIII'
    FV.ST.L.APAP.COVID.PRELACIONIII = ''
    CALL OPF (FN.ST.L.APAP.COVID.PRELACIONIII,FV.ST.L.APAP.COVID.PRELACIONIII)

RETURN

END


