$PACKAGE APAP.TAM
SUBROUTINE REDO.B.INT.UPDATE.LOAD
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.INT.UPDATE.LOAD
*--------------------------------------------------------------------------------
* Description: This is the Load routine in batch to update the interest rate in arrangement
* as per the changes in rate of AZ.ACCOUNT OR ACI OR GCI
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE        WHO              REFERENCE            DESCRIPTION
*  ----------  -------------    ----------------     ------------
*  15.11.2009  H GANESH &       ODR-2009-10-0795     INITIAL CREATION
*              S SUDHARSANAN
*  13.05.2011  H GANESH         PACS00032743 &       Modified as per issue
*                               PACS00055013
*  21.11.2011  Luis Pazmino     ODR-2011-06-0242     Minor fixes to obtain the ACCOUNT.ID
*                                                    when a COLLATERAL is created through FC
*  05.01.2012  William Meza     ODR-2011-06-0242     Code Review - Multi Get Local Ref
** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.INT.UPDATE.COMMON

    GOSUB GET.LOC.REF
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    FN.REDO.T.DEP.COLLATERAL='F.REDO.T.DEP.COLLATERAL'
    F.REDO.T.DEP.COLLATERAL=''
    CALL OPF(FN.REDO.T.DEP.COLLATERAL,F.REDO.T.DEP.COLLATERAL)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.ARRANGEMENT=''
    CALL OPF(FN.ARRANGEMENT,F.ARRANGEMENT)

    FN.LI.COLLATERAL.RIGHT='F.LI.COLLATERAL.RIGHT'
    F.LI.COLLATERAL.RIGHT=''
    CALL OPF(FN.LI.COLLATERAL.RIGHT,F.LI.COLLATERAL.RIGHT)

    FN.COLLATERAL='F.COLLATERAL'
    F.COLLATERAL=''
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)

    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT=''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.GROUP.DATE='F.GROUP.DATE'
    F.GROUP.DATE=''
    CALL OPF(FN.GROUP.DATE,F.GROUP.DATE)

    FN.RIGHT.COLLATERAL='F.RIGHT.COLLATERAL'
    F.RIGHT.COLLATERAL=''
    CALL OPF(FN.RIGHT.COLLATERAL,F.RIGHT.COLLATERAL)

    FN.REDO.OFS.PARAM='F.REDO.OFS.PARAM'
    F.REDO.OFS.PARAM=''
    CALL OPF(FN.REDO.OFS.PARAM,F.REDO.OFS.PARAM)

    FN.GROUP.CREDIT.INT='F.GROUP.CREDIT.INT'
    F.GROUP.CREDIT.INT=''
    CALL OPF(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)

    FN.ACCOUNT.CREDIT.INT='F.ACCOUNT.CREDIT.INT'
    F.ACCOUNT.CREDIT.INT=''
    CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)


RETURN
*---------------------------------------------------------------------------
GET.LOC.REF:
*---------------------------------------------------------------------------
    LOC.REF.APPLICATION = "AA.PRD.DES.INTEREST"
    LOC.REF.FIELDS = 'L.AA.REV.RT.TY'
    LOC.REF.POS = ''

* lfpazmino 22.11.2011
* Obtain local field for collaterals created through FC
    CL.APPLICATION = 'COLLATERAL'
    CL.LOCAL.REF = 'LOCAL.REF'
    CL.INST.FIELD = 'L.COL.NUM.INSTR'

    CALL EB.FIND.FIELD.NO(CL.APPLICATION, CL.LOCAL.REF)

    CL.APPLICATION = LOC.REF.APPLICATION : @FM : CL.APPLICATION
    CL.INST.FIELD = LOC.REF.FIELDS : @FM : CL.INST.FIELD
    CL.INST.POS = ''

    CALL MULTI.GET.LOC.REF(CL.APPLICATION, CL.INST.FIELD, CL.INST.POS)
    POS.L.AA.REV.RT.TY = CL.INST.POS<1,1>
    CL.INST.POS = CL.INST.POS<2,1>
RETURN
END
