* @ValidationCode : MjotNzM0MDk2ODE5OkNwMTI1MjoxNjgzMDE4MDk2MDIzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 May 2023 14:31:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TELLER.PROCESS.VALIDATE
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.TELLER.PROCESS table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN : -NA-
* OUT : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.TELLER.PROCESS.VALIDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*12.05.2010 SUDHARSANAN S ODR-2009-10-0322 INITIAL CREATION
*04.02.2011 Prabhu N HD1102532 As per the issue update concept field
*04.04.2011 Prabhu N HD1102529 line 146 added
*27-05-2011 Sudharsanan S PACS00062653 Modify the coding as per new workaround solution
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         FM TO @FM, VM TO @VM, SM TO @SM
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.TELLER.PROCESS
    $INSERT I_F.REDO.USER.ACCESS
    $INSERT I_F.REDO.TT.GROUP.PARAM
    $INSERT I_F.CUSTOMER
    $INSERT I_GTS.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.USER
    $INSERT I_F.COMPANY

    IF MESSAGE EQ 'VAL' THEN
        GOSUB INIT
        GOSUB PROCESS
    END
RETURN
*---
INIT:
*---
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.TT.GROUP.PARAM = 'F.REDO.TT.GROUP.PARAM'
    F.REDO.TT.GROUP.PARAM = ''
    CALL OPF(FN.REDO.TT.GROUP.PARAM,F.REDO.TT.GROUP.PARAM)

    LREF.APPL = 'CUSTOMER'
    LREF.FIELDS = 'L.CU.TIPO.CL'
    LREF.POS = ''
    CALL GET.LOC.REF(LREF.APPL,LREF.FIELDS,LREF.POS)

    TIPO.CL.POS = LREF.POS
    Y.SUB.GROUP = ''
    CALL CACHE.READ(FN.REDO.TT.GROUP.PARAM,'SYSTEM',R.REDO.TT.GROUP.PARAM,GRO.ERR)
    VAR.GROUP = R.REDO.TT.GROUP.PARAM<TEL.GRO.GROUP>

RETURN
*-------
PROCESS:
*-------
*To validate the fields and updates the value
    Y.CUSTOMER = R.NEW(TEL.PRO.CLIENT.ID)
    GOSUB CHECK.CUS.NAME
    Y.GROUP = R.NEW(TEL.PRO.GROUP)
*Y.SUB.GROUP = R.NEW(TEL.PRO.SUB.GROUP)
    CHANGE @VM TO @FM IN VAR.GROUP
    LOCATE Y.GROUP IN VAR.GROUP SETTING POS.VM THEN
        VAR.SUB.GROUP = R.REDO.TT.GROUP.PARAM<TEL.GRO.SUB.GROUP,POS.VM>
        CHANGE @SM TO @FM IN VAR.SUB.GROUP
        Y.SUB.GRP = VAR.SUB.GROUP
        CHANGE @FM TO '_' IN Y.SUB.GRP
        T(TEL.PRO.SUB.GROUP)<2> = Y.SUB.GRP
        Y.SUB.GROUP = R.NEW(TEL.PRO.SUB.GROUP)
        IF Y.SUB.GROUP THEN
            LOCATE Y.SUB.GROUP IN VAR.SUB.GROUP SETTING POS.SM THEN
                VAR.DESCRIPTION = R.REDO.TT.GROUP.PARAM<TEL.GRO.DESCRIPTION,POS.VM,POS.SM>
                VAR.CURRENCY = R.REDO.TT.GROUP.PARAM<TEL.GRO.CURRENCY,POS.VM,POS.SM>
                VAR.AMOUNT = R.REDO.TT.GROUP.PARAM<TEL.GRO.CHG.AMOUNT,POS.VM,POS.SM>
                VAR.CATEGORY = R.REDO.TT.GROUP.PARAM<TEL.GRO.CATEGORY,POS.VM,POS.SM>
                R.NEW(TEL.PRO.CONCEPT) = VAR.DESCRIPTION
                R.NEW(TEL.PRO.CURRENCY) = VAR.CURRENCY
                R.NEW(TEL.PRO.AMOUNT) = VAR.AMOUNT
                R.NEW(TEL.PRO.CATEGORY) = VAR.CATEGORY
            END
        END
    END ELSE
        AF = TEL.PRO.GROUP
        ETEXT = 'EB-PARAM.GROUP.NOT.DEFINED'
        CALL STORE.END.ERROR
    END
RETURN
*---------------------------------------------------------------------------------------
CHECK.CUS.NAME:
*-------------------------------------------------------------------------------------------
    R.CUSTOMER = '' ; CUS.ERR1 = ''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,CUS.ERR1)
    IF R.CUSTOMER THEN
        VAR.TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS>
        BEGIN CASE
            CASE VAR.TIPO.CL EQ 'PERSONA FISICA'
                VAR.GIV.NAM = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
                VAR.FAM.NAM = R.CUSTOMER<EB.CUS.FAMILY.NAME>
                Y.CUS.NAME = VAR.GIV.NAM:" ":VAR.FAM.NAM
            CASE VAR.TIPO.CL EQ 'PERSONA JURIDICA'
                VAR.NAME1=R.CUSTOMER<EB.CUS.NAME.1>
                VAR.NAME2=R.CUSTOMER<EB.CUS.NAME.2>
                Y.CUS.NAME = VAR.NAME1:VAR.NAME2
            CASE OTHERWISE
                VAR.GIV.NAM = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
                VAR.FAM.NAM = R.CUSTOMER<EB.CUS.FAMILY.NAME>
                Y.CUS.NAME = VAR.GIV.NAM:" ":VAR.FAM.NAM
        END CASE
        R.NEW(TEL.PRO.CLIENT.NAME) = Y.CUS.NAME
    END
RETURN
*-------------------------------------------------------------------------------------------
END
