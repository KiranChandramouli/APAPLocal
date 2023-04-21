*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.IC.MANCTA.RT.LOAD
    
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO                REFERENCE                 DESCRIPTION

* 21-APR-2023     Conversion tool    R22 Auto conversion       No changes

*-----------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.DATES
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT T24.BP I_F.CUSTOMER.ACCOUNT
    $INSERT BP I_F.ST.LAPAP.EMP.COM.PAR
    $INSERT LAPAP.BP I_LAPAP.IC.MANCTA.RT.COMMON

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
    LOC.REF.FIELDS='L.CU.TIPO.CL':VM:'L.CU.SEGMENTO'
    LOC.REF.POS=''

    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    Y.L.CU.TIPO.CL.POS = LOC.REF.POS<1,1>
    Y.L.CU.SEGMENTO.POS = LOC.REF.POS<1,2>

    RETURN

END
