* @ValidationCode : MjotNTYxNzU0OTI0OkNwMTI1MjoxNjkwMTY3OTAwMzYwOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:35:00
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
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.UPD.BEN.OACT.RT.LOAD
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       FM TO @FM, VM to @VM
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_F.CUSTOMER
    $INSERT I_L.APAP.UPD.BEN.OACT.RT.COMMON

    GOSUB OPEN.FILES
    GOSUB GET.LOCALPOS

OPEN.FILES:
    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    CALL OPF(FN.CUS, F.CUS)

    FN.BEN = "F.BENEFICIARY"
    F.BEN = ""
    CALL OPF(FN.BEN, F.BEN)
RETURN

GET.LOCALPOS:
    Y.APP = "CUSTOMER":@FM:"BENEFICIARY"
    Y.FIELDS = "L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.PASS.NAT":@VM:"L.CU.NOUNICO":@VM:"L.CU.ACTANAC":@VM:"L.BEN.CEDULA":@VM:"L.BEN.OWN.ACCT"
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FIELDS,Y.FIELD.POS)
    L.CU.CIDENT.POS = Y.FIELD.POS<1,1>
    L.CU.RNC.POS = Y.FIELD.POS<1,2>
    L.CU.PASS.NAT.POS = Y.FIELD.POS<1,3>
    L.CU.NOUNICO.POS = Y.FIELD.POS<1,4>
*We're using GET.LOC.REF for BENEFICIARY LOCAL.REF instead of MULTI.GET.LOC.REF because position are switching
    L.BEN.CEDULA.POS = ''     ;*Y.FIELD.POS<2,1>
    CALL GET.LOC.REF("BENEFICIARY", "L.BEN.CEDULA",L.BEN.CEDULA.POS)

    L.BEN.OWN.ACCT.POS = ''   ;*Y.FIELD.POS<2,2>
    CALL GET.LOC.REF("BENEFICIARY", "L.BEN.OWN.ACCT",L.BEN.OWN.ACCT.POS)
RETURN

END
