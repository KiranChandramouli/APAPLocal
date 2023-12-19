* @ValidationCode : MjotODgxODQxNzA6Q3AxMjUyOjE3MDI5NjM5OTAzNzQ6MzMzc3U6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 11:03:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN8.EXTRACT.LOAD
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN8.EXTRACT
* Date           : 3-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the MM and SEC.TRADE in DOP and non DOP.
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description

*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*10-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*10-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*14/12/2023       Suresh                    R22 Manual Conversion      Change Hardcoding the value to IDVAR

*----------------------------------------------------------------------------------------





*-----------------------------------------------------------------------------
 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_DR.REG.RIEN8.EXTRACT.COMMON
    $INSERT I_F.DR.REG.RIEN8.PARAM

    GOSUB INIT.PROCESS

RETURN

*-----------------------------------------------------------------------------
INIT.PROCESS:
*-----------*

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.MM.MONEY.MARKET = 'F.MM.MONEY.MARKET'
    F.MM.MONEY.MARKET = ''
    CALL OPF(FN.MM.MONEY.MARKET,F.MM.MONEY.MARKET)

    FN.SEC.TRADE = 'F.SEC.TRADE'
    F.SEC.TRADE = ''
    CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)

    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER = ''
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)

    FN.DR.REG.RIEN8.WORKFILE = 'F.DR.REG.RIEN8.WORKFILE'
    F.DR.REG.RIEN8.WORKFILE = ''
    CALL OPF(FN.DR.REG.RIEN8.WORKFILE,F.DR.REG.RIEN8.WORKFILE)

    FN.DR.REG.RIEN8.WORKFILE.FCY = 'F.DR.REG.RIEN8.WORKFILE.FCY'
    F.DR.REG.RIEN8.WORKFILE.FCY = ''
    CALL OPF(FN.DR.REG.RIEN8.WORKFILE.FCY,F.DR.REG.RIEN8.WORKFILE.FCY)

*FN.RE.STAT.LINE.CONT = 'F.RE.STAT.LINE.CONT'
*F.RE.STAT.LINE.CONT = ''
*CALL OPF(FN.RE.STAT.LINE.CONT,F.RE.STAT.LINE.CONT)

*FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
*F.EB.CONTRACT.BALANCES = ''
*CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.REDO.AZACC.DESC = 'F.REDO.AZACC.DESC'
    F.REDO.AZACC.DESC = ''
    CALL OPF(FN.REDO.AZACC.DESC,F.REDO.AZACC.DESC)

    FN.DR.REG.RIEN8.PARAM = 'F.DR.REG.RIEN8.PARAM'
    F.DR.REG.RIEN8.PARAM = ''
    CALL OPF(FN.DR.REG.RIEN8.PARAM,F.DR.REG.RIEN8.PARAM)
*  CALL F.READ(FN.DR.REG.RIEN8.PARAM,'SYSTEM',R.DR.REG.RIEN8.PARAM,F.DR.REG.RIEN8.PARAM,DR.REG.RIEN8.PARAM.ERR) ;*Tus Start
    IDVAR='SYSTEM' ;*R22 Manual Conversion
    CALL CACHE.READ(FN.DR.REG.RIEN8.PARAM,IDVAR,R.DR.REG.RIEN8.PARAM,DR.REG.RIEN8.PARAM.ERR) ; * Tus End ;*R22 Manual Conversion
    MM.CAT1 = R.DR.REG.RIEN8.PARAM<RIEN8.PARAM.MM.CATEGORY,1>
    MM.CAT2 = R.DR.REG.RIEN8.PARAM<RIEN8.PARAM.MM.CATEGORY,2>
    Y.TODAY = R.DATES(EB.DAT.TODAY)

    Y.APP = 'CUSTOMER':@FM:'SEC.TRADE':@FM:'SECURITY.MASTER'
    Y.FLD = 'L.CU.RNC':@VM:'L.AA.CAL.ISSUER':@VM:'L.CU.TIPO.CL':@VM:'L.APAP.INDUSTRY':@FM:'L.DIRTY.PERCENT':@VM:'L.SC.TRN.YIELD':@VM:'L.CLEAN.PERCENT':@FM:'L.ISIN.CODE'
    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD,Y.POS)

    L.CU.RNC.POS = Y.POS<1,1>
    L.AA.CAL.ISSUER.POS = Y.POS<1,2>
    L.CU.TIPO.CL.POS = Y.POS<1,3>
    Y.APAP.INDUS.POS = Y.POS<1,4>

    L.ISIN.CODE.POS = Y.POS<3,1>
    L.DIRTY.PERCENTAGE.POS = Y.POS<2,1>
    L.SC.TRN.YIELD.POS = Y.POS<2,2>
    L.CLEAN.PERCENTAGE.POS = Y.POS<2,3>

RETURN
*-----------------------------------------------------------------------------
END
