* @ValidationCode : MjotMTU5NjA3MjY6VVRGLTg6MTY4OTgzMDI1Njk5MDpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Jul 2023 10:47:36
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
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
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.IC.MANCTA.RT.LOAD
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 13-07-2023    Conversion Tool        R22 Auto Conversion     No Changes
* 13-07-2023    Narmadha V             R22 Manual Conversion   BP is removed in insert file,VM to @VM
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON ;*R22 Manual Conversion -START
    $INSERT  I_EQUATE
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.DATES
    $INSERT  I_F.CUSTOMER
    $INSERT  I_F.CUSTOMER.ACCOUNT
    $INSERT  I_F.ST.LAPAP.EMP.COM.PAR
    $INSERT  I_LAPAP.IC.MANCTA.RT.COMMON ;*R22 Manual Conversion -END

    GOSUB INITIAL
    GOSUB GET.PARAMS
    GOSUB GET.LOCREF
RETURN
INITIAL:

    FN.AC = "FBNK.ACCOUNT"
    FV.AC = ""
    CALL OPF(FN.AC,FV.AC)

    FN.CUS = "FBNK.CUSTOMER"
    FV.CUS = ""
    CALL OPF(FN.CUS,FV.CUS)

    FN.CUSAC = "FBNK.CUSTOMER.ACCOUNT"
    FV.CUSAC = ""
    CALL OPF(FN.CUSAC,FV.CUSAC)

    FN.ECP = "FBNK.ST.LAPAP.EMP.COM.PAR"
    FV.ECP = ""
    CALL OPF(FN.ECP,FV.ECP)



RETURN

GET.PARAMS:
    CALL F.READ(FN.ECP, "SYSTEM", R.ECP, FV.ECP, ECP.ERR)
    Y.PA.SEGMENT = R.ECP<ST.LAP30.CUS.SEGMENT>
    Y.PA.CHG.CODE = R.ECP<ST.LAP30.CHARGE.CODE>
*    Y.PA.CHG.AMT =  R.ECP<ST.LAP30.CHARGE.AMT>
    Y.PA.WAIV.CAT = R.ECP<ST.LAP30.WAIV.CATEGORIES>

RETURN

GET.LOCREF:
    LOC.REF.APPLICATION="CUSTOMER"
    LOC.REF.FIELDS='L.CU.TIPO.CL':@VM:'L.CU.SEGMENTO'
    LOC.REF.POS=''

    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    Y.L.CU.TIPO.CL.POS = LOC.REF.POS<1,1>
    Y.L.CU.SEGMENTO.POS = LOC.REF.POS<1,2>

RETURN

END
