* @ValidationCode : MjoxNDE5MTc1Njc1OkNwMTI1MjoxNjgwNjc3NjY4MzQzOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 12:24:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
SUBROUTINE DR.REG.INT.TAX.PAYMENT.LOAD
**************************************************************************
* This routine initializes all the files required by report Impuesto al Pago de Intereses
*
**************************************************************************
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
* 01-Aug-2014     V.P.Ashokkumar      PACS00305231 - Added RELATION file
*DATE               WHO                       REFERENCE                 DESCRIPTION
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_DR.REG.INT.TAX.PAYMENT.COMMON
    $INSERT I_DR.REG.INT.TAX.COMMON
    $INSERT I_F.DR.REG.INT.TAX.PAY.PARAM

    GOSUB GET.LOCAL.POS
    GOSUB OPEN.FILES
RETURN

*----------------------------------------------------------------------------
OPEN.FILES:
***********
*    FN.DR.REGREP.PARAM = "F.DR.REGREP.PARAM"
*    F.DR.REGREP.PARAM = ""
*    CALL OPF(FN.DR.REGREP.PARAM,F.DR.REGREP.PARAM)

    FN.DR.REG.INT.TAX.PAY.PARAM = "F.DR.REG.INT.TAX.PAY.PARAM"
    F.DR.REG.INT.TAX.PAY.PARAM = ""
    CALL OPF(FN.DR.REG.INT.TAX.PAY.PARAM,F.DR.REG.INT.TAX.PAY.PARAM)
    CALL CACHE.READ(FN.DR.REG.INT.TAX.PAY.PARAM,'SYSTEM',R.DR.REG.INT.TAX.PAY.PARAM,DR.REG.INT.TAX.PAY.PARAM.ERR)
    YLWORK.DAY = ''; ST.DATE = ''; ED.DATE = ''
    ST.DATE = R.DR.REG.INT.TAX.PAY.PARAM<INT.TAX.PAY.PARAM.FROM.DATE>
    ED.DATE = R.DR.REG.INT.TAX.PAY.PARAM<INT.TAX.PAY.PARAM.TO.DATE>
    YLWORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.STMT.ACCT.CR = "F.STMT.ACCT.CR"
    F.STMT.ACCT.CR = ''
    CALL OPF(FN.STMT.ACCT.CR,F.STMT.ACCT.CR)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

* Byron PACS00305231/start
    FN.ACCOUNT$HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT$HIS = ''
    CALL OPF(FN.ACCOUNT$HIS,F.ACCOUNT$HIS)
* Byron PACS00305231/ends

    FN.COMPANY =  'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    FN.DR.REG.INT.TAX.PAYMENT.WORKFILE = 'F.DR.REG.INT.TAX.PAYMENT.WORKFILE'
    F.DR.REG.INT.TAX.PAYMENT.WORKFILE = ''
    CALL OPF(FN.DR.REG.INT.TAX.PAYMENT.WORKFILE,F.DR.REG.INT.TAX.PAYMENT.WORKFILE)

    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
    CALL OPF(FN.RELATION,F.RELATION)

RETURN
*----------------------------------------------------------------------------
GET.LOCAL.POS:
***************

    APP.LIST = 'CUSTOMER'
    FLD.LIST = 'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.NOUNICO':@VM:'L.CU.ACTANAC':@VM:'L.CU.TIPO.CL':@VM:'L.CU.FOREIGN'
    FLD.POS = ''
    CIDENT.POS = ''
    RNC.POS = ''
    NOUNICO.POS = ''
    ACTANAC.POS = ''
    TIPO.CL.POS = ''
    CALL MULTI.GET.LOC.REF(APP.LIST,FLD.LIST,FLD.POS)
    CIDENT.POS = FLD.POS<1,1>
    RNC.POS = FLD.POS<1,2>
    NOUNICO.POS = FLD.POS<1,3>
    ACTANAC.POS = FLD.POS<1,4>
    TIPO.CL.POS = FLD.POS<1,5>
    L.CU.FOREIGN.POS = FLD.POS<1,6>
RETURN
*----------------------------------------------------------------------------
END
