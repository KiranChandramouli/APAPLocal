* @ValidationCode : MjoxODYwMzc2OTQzOkNwMTI1MjoxNzAyOTg4MzQzNDkzOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.TASAS.ACTIVAS.CONCAT.LOAD
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.TASAS.ACTIVAS.CONCAT
* Date           : 27-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the Active Interest rates
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*   =====        ========             =========================
* 09-Oct-2014  Ashokkumar.V.P      PACS00305233:- Changed the parameter values.
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INCLUDE REGREP.BP TO $INSERT AND $INCLUDE LAPAP.BP TO $INSERT AND VM TO @VM AND FM TO @FM
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* 15-12-2023       Santosh C               MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES

    $INSERT I_DR.REG.TASAS.ACTIVAS.CONCAT.COMMON
    $INSERT I_F.DR.REG.ACTIVAS.PARAM
    $USING EB.LocalReferences

    GOSUB GET.LOCREF
    GOSUB INIT.PROCESS
RETURN

INIT.PROCESS:
*-----------*

    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT' ; F.AA.ARR.TERM.AMOUNT = ''
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)

    FN.AA.ARR.INTEREST = 'F.AA.ARR.INTEREST' ; F.AA.ARR.INTEREST = ''
    CALL OPF(FN.AA.ARR.INTEREST,F.AA.ARR.INTEREST)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'; F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.DR.REG.ACTIVAS.GROUP = 'F.DR.REG.ACTIVAS.GROUP'; F.DR.REG.ACTIVAS.GROUP = ''
    CALL OPF(FN.DR.REG.ACTIVAS.GROUP,F.DR.REG.ACTIVAS.GROUP)

    FN.BASIC.INTEREST = 'F.BASIC.INTEREST'; F.BASIC.INTEREST = ''
    CALL OPF(FN.BASIC.INTEREST,F.BASIC.INTEREST)

    FN.GROUP.DATE = 'F.GROUP.DATE'; F.GROUP.DATE = ''
    CALL OPF(FN.GROUP.DATE,F.GROUP.DATE)

    FN.MM.MONEY.MARKET = 'F.MM.MONEY.MARKET'; F.MM.MONEY.MARKET = ''
    CALL OPF(FN.MM.MONEY.MARKET,F.MM.MONEY.MARKET)

    FN.DR.REG.ACTIVAS.PARAM = 'F.DR.REG.ACTIVAS.PARAM'; F.DR.REG.ACTIVAS.PARAM = ''
    CALL OPF(FN.DR.REG.ACTIVAS.PARAM,F.DR.REG.ACTIVAS.PARAM)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY' ; F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    R.DR.REG.ACTIVAS.PARAM = ''; DR.REG.ACTIVAS.PARAM.ERR = ''; CAT.LIST = ''; REL.CHK.LIST = ''
    GRP1.VAL = ''; GRP2.VAL = ''; GRP3.VAL = ''; GRP4.VAL = ''; MM.RANGE1 = ''; MM.RANGE2 = ''
    MM.RANGE3 = ''; RANGE1 = ''; RANGE2 = '' ; RANGE4 = ''; RANGE5 = ''; LAST.WORK.DAY = ''

    LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)

    Y.SYS.ID = 'SYSTEM' ;*R22 Manual Code Conversion_Utility Check
    CALL CACHE.READ(FN.DR.REG.ACTIVAS.PARAM,Y.SYS.ID,R.DR.REG.ACTIVAS.PARAM,DR.REG.ACTIVAS.PARAM.ERR)
    CAT.LIST = R.DR.REG.ACTIVAS.PARAM<DR.ACTIVAS.PARAM.MM.CATEGORY>
    CHANGE @VM TO ' ' IN CAT.LIST
    REL.CHK.LIST = R.DR.REG.ACTIVAS.PARAM<DR.ACTIVAS.PARAM.BANK.EMP.REL>
    CHANGE @VM TO @FM IN REL.CHK.LIST
    GRP1.VAL = R.DR.REG.ACTIVAS.PARAM<DR.ACTIVAS.PARAM.GROUP.SEL,1>
    GRP2.VAL = R.DR.REG.ACTIVAS.PARAM<DR.ACTIVAS.PARAM.GROUP.SEL,2>
    GRP3.VAL = R.DR.REG.ACTIVAS.PARAM<DR.ACTIVAS.PARAM.GROUP.SEL,3>
    GRP4.VAL = R.DR.REG.ACTIVAS.PARAM<DR.ACTIVAS.PARAM.GROUP.SEL,4>

    MM.RANGE1 = R.DR.REG.ACTIVAS.PARAM<DR.ACTIVAS.PARAM.MM.RANGE.DAYS,1>
    MM.RANGE2 = R.DR.REG.ACTIVAS.PARAM<DR.ACTIVAS.PARAM.MM.RANGE.DAYS,2>
    MM.RANGE3 = R.DR.REG.ACTIVAS.PARAM<DR.ACTIVAS.PARAM.MM.RANGE.DAYS,3>

    RANGE1 = R.DR.REG.ACTIVAS.PARAM<DR.ACTIVAS.PARAM.AA.RANGE.DAYS,1>
    RANGE2 = R.DR.REG.ACTIVAS.PARAM<DR.ACTIVAS.PARAM.AA.RANGE.DAYS,2>
    RANGE3 = R.DR.REG.ACTIVAS.PARAM<DR.ACTIVAS.PARAM.AA.RANGE.DAYS,3>
    RANGE4 = R.DR.REG.ACTIVAS.PARAM<DR.ACTIVAS.PARAM.AA.RANGE.DAYS,4>
    RANGE5 = R.DR.REG.ACTIVAS.PARAM<DR.ACTIVAS.PARAM.AA.RANGE.DAYS,5>
RETURN

GET.LOCREF:
***********
    L.AA.CAMP.TY.POS = ''
*   CALL GET.LOC.REF("AA.PRD.DES.CUSTOMER","L.AA.CAMP.TY",L.AA.CAMP.TY.POS)
    EB.LocalReferences.GetLocRef("AA.PRD.DES.CUSTOMER","L.AA.CAMP.TY",L.AA.CAMP.TY.POS) ;*R22 Manual Code Conversion_Utility Check
RETURN

END
