$PACKAGE APAP.DRREG
* @ValidationCode : MjotMTE4MTU0NzE3ODpDcDEyNTI6MTcwMjUzMDYyMjAxNzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Dec 2023 10:40:22
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

SUBROUTINE DR.REG.RIEN4.AZ.EXT.LOAD
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN4.AZ.EXT.LOAD
* Date           : 27-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the AZ.ACCOUNT Details for PRODUCT Wise.
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 16-09-2014   Ashokkumar             PACS00367490- Added interest amount to the PRINCIPAL balance.
*                                               corrected the interest rate issue.
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*06-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM , FM to @FM
*06-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*14/12/2023       Suresh                      R22 Manual Conversion      Change Hardcoding the value to IDVAR
*----------------------------------------------------------------------------------------



*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_DR.REG.RIEN4.AZ.EXT.COMMON
    $INSERT I_F.DR.REG.RIEN4.PARAM

    GOSUB INIT.PROCESS
RETURN

INIT.PROCESS:
*-----------*

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.BASIC.INTEREST = 'F.BASIC.INTEREST'
    F.BASIC.INTEREST = ''
    CALL OPF(FN.BASIC.INTEREST,F.BASIC.INTEREST)

    FN.GROUP.DATE = 'F.GROUP.DATE'
    F.GROUP.DATE = ''
    CALL OPF(FN.GROUP.DATE,F.GROUP.DATE)

    FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'
    F.GROUP.CREDIT.INT = ''
    CALL OPF(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.DR.REG.RIEN4.AZ.REP = 'F.DR.REG.RIEN4.AZ.REP'
    F.DR.REG.RIEN4.AZ.REP = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP,F.DR.REG.RIEN4.AZ.REP)

    FN.DR.REG.RIEN4.AZ.REP2 = 'F.DR.REG.RIEN4.AZ.REP2'
    F.DR.REG.RIEN4.AZ.REP2 = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP2,F.DR.REG.RIEN4.AZ.REP2)

    FN.DR.REG.RIEN4.AZ.REP3 = 'F.DR.REG.RIEN4.AZ.REP3'
    F.DR.REG.RIEN4.AZ.REP3 = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP3,F.DR.REG.RIEN4.AZ.REP3)

    FN.DR.REG.RIEN4.AZ.REP4 = 'F.DR.REG.RIEN4.AZ.REP4'
    F.DR.REG.RIEN4.AZ.REP4 = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP4,F.DR.REG.RIEN4.AZ.REP4)

    FN.DR.REG.RIEN4.AC.REP1 = 'F.DR.REG.RIEN4.AC.REP1'
    F.DR.REG.RIEN4.AC.REP1 = ''
    CALL OPF(FN.DR.REG.RIEN4.AC.REP1,F.DR.REG.RIEN4.AC.REP1)

    FN.DR.REG.RIEN4.AC.REP2 = 'F.DR.REG.RIEN4.AC.REP2'
    F.DR.REG.RIEN4.AC.REP2 = ''
    CALL OPF(FN.DR.REG.RIEN4.AC.REP2,F.DR.REG.RIEN4.AC.REP2)

    FN.DR.REG.RIEN4.AZ.REP.OUT = 'F.DR.REG.RIEN4.AZ.REP.OUT'
    F.DR.REG.RIEN4.AZ.REP.OUT = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP.OUT,F.DR.REG.RIEN4.AZ.REP.OUT)

    FN.DR.REG.RIEN4.AZ.REP.OUT2 = 'F.DR.REG.RIEN4.AZ.REP.OUT2'
    F.DR.REG.RIEN4.AZ.REP.OUT2 = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP.OUT2,F.DR.REG.RIEN4.AZ.REP.OUT2)

    FN.DR.REG.RIEN4.AZ.REP.OUT3 = 'F.DR.REG.RIEN4.AZ.REP.OUT3'
    F.DR.REG.RIEN4.AZ.REP.OUT3 = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP.OUT3,F.DR.REG.RIEN4.AZ.REP.OUT3)

    FN.DR.REG.RIEN4.AZ.REP.OUT4 = 'F.DR.REG.RIEN4.AZ.REP.OUT4'
    F.DR.REG.RIEN4.AZ.REP.OUT4 = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP.OUT4,F.DR.REG.RIEN4.AZ.REP.OUT4)

    FN.DR.REG.RIEN4.PARAM = 'F.DR.REG.RIEN4.PARAM'
    F.DR.REG.RIEN4.PARAM = ''
    CALL OPF(FN.DR.REG.RIEN4.PARAM,F.DR.REG.RIEN4.PARAM)

    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.AZ.ACCOUNT.HST = 'F.AZ.ACCOUNT$HIS'
    F.AZ.ACCOUNT.HST = ''
    CALL OPF(FN.AZ.ACCOUNT.HST,F.AZ.ACCOUNT.HST)

    FN.ACCOUNT.HST = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HST = ''
    CALL OPF(FN.ACCOUNT.HST,F.ACCOUNT.HST)

    R.DR.REG.RIEN4.PARAM = ''; DR.REG.RIEN4.PARAM.ERR = ''
    IDVAR='SYSTEM' ;*R22 Manual Conversion
    CALL CACHE.READ(FN.DR.REG.RIEN4.PARAM,IDVAR,R.DR.REG.RIEN4.PARAM,DR.REG.RIEN4.PARAM.ERR) ;*R22 Manual Conversion
    CAT.LIST1 = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.CATEGORY.REP1>
    CAT.LIST2 = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.CATEGORY.REP2>
    CAT.LIST3 = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.CATEGORY.REP3>
    CAT.LIST4 = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.CATEGORY.REP4>
    CAT.LIST5 = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.CATEGORY.REP5>
    CAT.LIST6 = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.CATEGORY.REP6>

    YCAT.LIST1 = CAT.LIST1
    YCAT.LIST2 = CAT.LIST2
    YCAT.LIST3 = CAT.LIST3
    YCAT.LIST4 = CAT.LIST4
    YCAT.LIST5 = CAT.LIST5
    YCAT.LIST6 = CAT.LIST6

    CHANGE @VM TO ' ' IN CAT.LIST1
    CHANGE @VM TO ' ' IN CAT.LIST2
    CHANGE @VM TO ' ' IN CAT.LIST3
    CHANGE @VM TO ' ' IN CAT.LIST4
    CHANGE @VM TO ' ' IN CAT.LIST5     ;*R22 AUTO CODE CONVERSION
    CHANGE @VM TO ' ' IN CAT.LIST6
    CHANGE @VM TO @FM IN YCAT.LIST1
    CHANGE @VM TO @FM IN YCAT.LIST2
    CHANGE @VM TO @FM IN YCAT.LIST3
    CHANGE @VM TO @FM IN YCAT.LIST4
    CHANGE @VM TO @FM IN YCAT.LIST5
    CHANGE @VM TO @FM IN YCAT.LIST6

    YAZ.CAT.LIST = CAT.LIST1:' ':CAT.LIST2:' ':CAT.LIST3:' ':CAT.LIST4
    YAC.CAT.LIST = CAT.LIST5:' ':CAT.LIST6

    Y.TODAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.LWORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)

    FLD.POS = ''
    APP.NME = 'ACCOUNT'
    FLD.NME = 'L.AC.REINVESTED':@VM:'L.AC.AV.BAL'
    CALL MULTI.GET.LOC.REF(APP.NME,FLD.NME,FLD.POS)
    L.AC.REINVESTED.POS = FLD.POS<1,1>
    L.AC.AV.BAL.POS = FLD.POS<1,2>
RETURN
END
