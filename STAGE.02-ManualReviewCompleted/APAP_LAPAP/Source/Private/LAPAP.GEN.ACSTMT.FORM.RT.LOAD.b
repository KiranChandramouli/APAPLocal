* @ValidationCode : MjoxMzY0MTg0Njk2OkNwMTI1MjoxNjkwMTY3NTQ1MTAyOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:05
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
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.GEN.ACSTMT.FORM.RT.LOAD

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 20-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts 

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ST.LAPAP.CONTROL.ESTADOS
    $INSERT I_LAPAP.GEN.ACSTMT.FORM.RT.COMMON

    FN.ACCOUNT = 'FBNK.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CE = 'FBNK.ST.LAPAP.CONTROL.ESTADOS'
    F.CE = ''
    CALL OPF(FN.CE,F.CE)

    FN.CAT = 'FBNK.ST.LAPAP.EC.CATEGORIA'
    F.CAT = ''
    CALL OPF(FN.CAT,F.CAT)

    FN.CUS = 'FBNK.CUSTOMER'
    F.CUS = ''
    CALL OPF(FN.CUS,F.CUS)

    FN.ES = "../bnk.interface/ESTADO"
    FV.ES = ""
    CALL OPF(FN.ES,FV.ES)


END
