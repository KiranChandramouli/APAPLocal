* @ValidationCode : MjoxNDk3ODMyMjIwOkNwMTI1MjoxNjg5ODM3OTA1ODEyOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Jul 2023 12:55:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.ASA.RT.LOAD

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 20-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ST.L.APAP.SOYB
    $INSERT I_F.ST.L.APAP.ASAMBLEA.PARAM
    $INSERT I_F.ST.L.APAP.ASAMBLEA.EXCL
    $INSERT I_F.ST.L.APAP.ASAMBLEA.PARTIC
    $INSERT I_F.ST.L.APAP.BALANCE.MENSUAL
    $INSERT I_F.ST.L.APAP.ASAMBLEA.RELAC
    $INSERT I_LAPAP.ASA.RT.COMMON


    GOSUB INITIAL
    GOSUB GET.PARAMS
    GOSUB GET.LOCAL.REFS

RETURN

INITIAL:
    FN.AC = "FBNK.ACCOUNT"
    FV.AC = ""
    CALL OPF(FN.AC,FV.AC)

    FN.SOYB = "FBNK.ST.L.APAP.SOYB"
    FV.SOYB = ""
    CALL OPF(FN.SOYB,FV.SOYB)


    FN.CUS = "FBNK.CUSTOMER"
    FV.CUS = ""
    CALL OPF(FN.CUS,FV.CUS)


    FN.PRM = "FBNK.ST.L.APAP.ASAMBLEA.PARAM"
    FV.PRM = ""
    CALL OPF(FN.PRM,FV.PRM)


    FN.ECL = "FBNK.ST.L.APAP.ASAMBLEA.EXCL"
    FV.ECL = ""
    CALL OPF(FN.ECL,FV.ECL)


    FN.PA = "FBNK.ST.L.APAP.ASAMBLEA.PARTIC"
    FV.PA = ""
    CALL OPF(FN.PA,F.PA)

    FN.BM = "FBNK.ST.L.APAP.BALANCE.MENSUAL"
    FV.BM = ""
    CALL OPF(FN.BM,FV.BM)

    FN.REL = "FBNK.ST.L.APAP.ASAMBLEA.RELAC"
    FV.REL = ""
    CALL OPF(FN.REL,FV.REL)


    Y.FECHA = R.DATES(EB.DAT.TODAY)

*    EXECUTE("CLEAR.FILE FBNK.ST.L.APAP.BALANCE.MENSUAL")
*    EXECUTE("CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.PARTIC")
*    EXECUTE("CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.EXCL")
*    EXECUTE("CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.RELAC")

*    EXECUTE("CLEAR.FILE FBNK.ST.L.APAP.BALANCE.MENSUAL$HIS")
*    EXECUTE("CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.PARTIC$HIS")
*    EXECUTE("CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.EXCL$HIS")
*    EXECUTE("CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.RELAC$HIS")

RETURN
GET.PARAMS:
    CALL F.READ(FN.PRM, "1", R.PRM1, FV.PRM, PRM1.ERR)
    Y.PA.BALANCE.INICIO = R.PRM1<ST.L.A95.VALOR>
    CALL F.READ(FN.PRM, "2", R.PRM2, FV.PRM, PRM1.ERR)
    Y.PA.BALANCE.PROMEDIO = R.PRM2<ST.L.A95.VALOR>
    CALL F.READ(FN.PRM, "3", R.PRM3, FV.PRM, PRM1.ERR)
    Y.PA.MAXIMO.BOLETOS = R.PRM3<ST.L.A95.VALOR>
    CALL F.READ(FN.PRM, "4", R.PRM4, FV.PRM, PRM1.ERR)
    Y.PA.FECHA.ASAMBLEA = R.PRM4<ST.L.A95.VALOR>
    Y.ANO = Y.PA.FECHA.ASAMBLEA[1,4]
    Y.ANO.ACT = Y.ANO - 1
RETURN

GET.LOCAL.REFS:
    CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',Y.TCL.POS)
    Y.CUS.TIPO.CL.POS  = Y.TCL.POS
RETURN



END
