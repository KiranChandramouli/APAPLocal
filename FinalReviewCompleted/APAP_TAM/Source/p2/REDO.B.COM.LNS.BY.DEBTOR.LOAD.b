* @ValidationCode : MjotMTc2NDYyNzkzODpDcDEyNTI6MTY4MzAzNDI0OTE5MjpJVFNTOi0xOi0xOjYxMTQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 May 2023 19:00:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 6114
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.B.COM.LNS.BY.DEBTOR.LOAD
*--------------------------------------------------------------------------------------------------
*
* Description           : This is the Batch Load Routine used to initalize all the required variables

* Developed On          : 23-Sep-2013
*
* Developed By          : Amaravathi Krithika B
*
* Development Reference : DE11
*
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*-----------------*
* Output Parameter:
* ----------------*
* Argument#2 : NA
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
* PACS00382500           Ashokkumar.V.P                  06/03/2015      Added new fields based on mapping
* PACS00382500           Ashokkumar.V.P                  31/03/2015      Insert file compilation.
* PACS00460182           Ashokkumar.V.P                  11/06/2015      Adding cahnges based on new mapping

*
* Date             Who                   Reference      Description
* 24.04.2023       Conversion Tool       R22            Auto Conversion     - INSERT file folder name removed T24.BP,LAPAP.BP & TAM.BP, FM TO @FM, VM TO @VM, SM TO @SM, SESSION.NO TO AGENT.NUMBER
* 24.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON                                        ;** R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.LIMIT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CURRENCY
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.CCY.HISTORY
    $INSERT I_BATCH.FILES
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.PRODUCT.GROUP
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.ACTIVITY.CHARGES
    $INSERT I_F.AA.PRODUCT.DESIGNER
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.SCHEDULED.ACTIVITY
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.REDO.H.CUSTOMER.PROVISIONING
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
    $INSERT I_F.COUNTRY
*   $INSERT I_F.AA.CHARGE
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_REDO.B.COM.LNS.BY.DEBTOR.COMMON
    $INSERT I_F.COLLATERAL
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.LIMIT
    $INSERT I_F.INDUSTRY
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
    $INSERT I_F.DATES
    $INSERT I_TSA.COMMON
*   $INSERT I_BATCH.FILES                                          ;** R22 Auto conversion - END
*
    $USING APAP.REDOCHNLS

    GOSUB INIT
    GOSUB INITIALISATION.1
    GOSUB INITIALISATION.2
    GOSUB FETCH.PARAM.VAL
    GOSUB FIND.LOC.REF
RETURN
*
INIT:
*----
    FN.LIMIT = '';    F.LIMIT = '';    FN.CUSTOMER = '';    F.CUSTOMER = ''
    FN.CCY.HISTORY = '';    F.CCY.HISTORY = '';    FN.CCY = '';    F.CCY = ''
    FN.AA.ARRANGEMENT = '';    F.AA.ARRANGEMENT = '';    FN.EB.LOOKUP = '';    F.EB.LOOKUP = ''
    FN.CURRENCY.HIS = ''; F.CURRENCY.HIS = ''; FN.AA.PRD.DES.CHARGE = ''; F.AA.PRD.DES.CHARGE = ''
    FN.AA.ARR.TERM.AMOUNT = ''; F.AA.ARR.TERM.AMOUNT = ''; FN.AA.PRODUCT.GROUP = ''; F.AA.PRODUCT.GROUP  = ''
    FN.AA.ACCOUNT.DETAILS = ''; F.AA.ACCOUNT.DETAILS = ''; FN.AA.ACTIVITY.HISTORY = ''; F.AA.ACTIVITY.HISTORY = ''
    FN.AA.PRD.DES.ACTIVITY.CHARGES = ''; F.AA.PRD.DES.ACTIVITY.CHARGES = ''; FN.AA.PRODUCT.DESIGNER  = ''; F.AA.PRODUCT.DESIGNER  = ''
    FN.AA.INTEREST.ACCRUALS = ''; F.AA.INTEREST.ACCRUALS = ''; FN.AA.SCHEDULED.ACTIVITY = ''; F.AA.SCHEDULED.ACTIVITY = ''
    FN.REDO.H.REPORTS.PARAM = ''; F.REDO.H.REPORTS.PARAM = ''; FN.AA.ARRANGEMENT.ACTIVITY = ''; F.AA.ARRANGEMENT.ACTIVITY = ''
    FN.REDO.H.CUSTOMER.PROVISIONING = ''; F.REDO.H.CUSTOMER.PROVISIONING = ''
    Y.L.LOCALIDAD.POS = ''; Y.L.TIP.CLI.POS   = ''; L.CU.CIDENT.POS   = ''; L.CU.RNC.POS      = ''; L.CU.FOREIGN.POS  = ''
    L.CU.TIPO.CL.POS  = ''; Y.L.LOAN.STATUS.1.POS = ''; Y.L.STATUS.CHG.DT.POS = ''; Y.L.RESTRUCT.TYPE.POS = ''
    Y.L.AA.PART.ALLOW.POS = ''; Y.L.CR.FACILITY.POS = ''; Y.L.AA.REV.RT.TY.POS = ''; Y.L.AA.NXT.REV.DT.POS = ''
    Y.L.AA.CHG.RATE.POS = ''; L.AA.CATEG.POS    = ''; Y.ORGN.FUND.POS  = ''
    FN.REDO.H.PROVISION.PARAM = ''; F.REDO.H.PROVISION.PARAM = ''; FN.AA.ACCOUNT = ''; F.AA.ACCOUNT = ''
    FN.COLLATERAL = ''; F.COLLATERAL = ''; FN.COUNTRY = ''; F.COUNTRY = ''; Y.AA.COL.POS = ''
    Y.AA.PAY.TYPE = ''; Y.AA.PAY.TYPE.I = ''; Y.AA.PAY.TYPE.I.VAL = ''; FN.AA.CHARGE = ''; F.AA.CHARGE = ''
    FN.AA.LIMIT = ''; F.AA.LIMIT = ''; Y.RISK.CLS.POS = ''; FN.INDUSTRY = ''; F.INDUSTRY = ''
    C$SPARE(351) = ''; C$SPARE(352) = ''; C$SPARE(353) = ''; C$SPARE(354) = ''; C$SPARE(355) = ''; C$SPARE(356) = ''; C$SPARE(357) = ''; C$SPARE(358) = ''; C$SPARE(359) = ''; C$SPARE(360) = ''; C$SPARE(361) = ''; C$SPARE(362) = ''
    C$SPARE(363) = ''; C$SPARE(364) = ''; C$SPARE(365) = ''; C$SPARE(366) = ''; C$SPARE(367) = ''; C$SPARE(368) = ''; C$SPARE(369) = ''; C$SPARE(370) = ''; C$SPARE(371) = ''; C$SPARE(372) = ''; C$SPARE(373) = ''; C$SPARE(374) = ''
    C$SPARE(375) = ''; C$SPARE(376) = ''; C$SPARE(377) = ''; C$SPARE(378) = ''; C$SPARE(379) = ''; C$SPARE(380) = ''; C$SPARE(381) = ''; C$SPARE(382) = ''; C$SPARE(383) = ''; C$SPARE(384) = ''; C$SPARE(385) = ''; C$SPARE(386) = ''
    C$SPARE(387) = ''; C$SPARE(388) = ''; C$SPARE(389) = ''; C$SPARE(390) = ''; C$SPARE(391) = ''; C$SPARE(392) = ''; C$SPARE(393) = ''; C$SPARE(394) = ''; C$SPARE(395) = ''; C$SPARE(396) = ''; C$SPARE(397) = ''; C$SPARE(398) = ''
    C$SPARE(399) = ''; C$SPARE(400) = ''; C$SPARE(401) = ''; C$SPARE(402) = ''; C$SPARE(403) = ''; C$SPARE(404) = ''; C$SPARE(405) = ''; C$SPARE(406) = ''
RETURN
*----------------
INITIALISATION.1:
*----------------
*
    FN.LIMIT = "F.LIMIT"; F.LIMIT  = ""; R.LIMIT = ""
    CALL OPF(FN.LIMIT,F.LIMIT)
*
    FN.AA.LIMIT = 'F.AA.ARR.LIMIT'; F.AA.LIMIT = ''; R.AA.LIMIT = ''
    CALL OPF(FN.AA.LIMIT,F.AA.LIMIT)
*
    FN.CUSTOMER = "F.CUSTOMER"; F.CUSTOMER  = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
    FN.CCY.HISTORY = "F.CCY.HISTORY"; F.CCY.HISTORY  = ""
    CALL OPF(FN.CCY.HISTORY,F.CCY.HISTORY)
*
    FN.CCY = "F.CURRENCY"; F.CCY  = ""
    CALL OPF(FN.CCY,F.CCY)
*
    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"; F.AA.ARRANGEMENT  = ""
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
*
    FN.EB.LOOKUP = "F.EB.LOOKUP"; F.EB.LOOKUP  = ""
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)
*
    FN.CURRENCY.HIS = "F.CURRENCY$HIS"; F.CURRENCY.HIS  = ""
    CALL OPF(FN.CURRENCY.HIS,F.CURRENCY.HIS)
*
    FN.AA.PRD.DES.CHARGE = "F.AA.PRD.DES.CHARGE"; F.AA.PRD.DES.CHARGE  = ""
    CALL OPF(FN.AA.PRD.DES.CHARGE,F.AA.PRD.DES.CHARGE)
*
    FN.AA.PRD.CAT.CHARGE = "F.AA.PRD.CAT.CHARGE"; F.AA.PRD.CAT.CHARGE = ""
    CALL OPF(FN.AA.PRD.CAT.CHARGE,F.AA.PRD.CAT.CHARGE)
*
    FN.AA.ARR.TERM.AMOUNT = "F.AA.ARR.TERM.AMOUNT"; F.AA.ARR.TERM.AMOUNT  = ""
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)
*
    FN.AA.PRODUCT.GROUP = "F.AA.PRODUCT.GROUP"; F.AA.PRODUCT.GROUP  = ""
    CALL OPF(FN.AA.PRODUCT.GROUP,F.AA.PRODUCT.GROUP)
*
    FN.AA.ACCOUNT.DETAILS = "F.AA.ACCOUNT.DETAILS"; F.AA.ACCOUNT.DETAILS  = ""
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)
*
    FN.REDO.H.PROVISION.PARAM = 'F.REDO.H.PROVISION.PARAMETER'; F.REDO.H.PROVISION.PARAM = ''
    CALL OPF(FN.REDO.H.PROVISION.PARAM,F.REDO.H.PROVISION.PARAM)
*
    FN.AA.ACCOUNT = 'F.AA.ARR.ACCOUNT'; F.AA.ACCOUNT = ''
    CALL OPF(FN.AA.ACCOUNT,F.AA.ACCOUNT)
*
    FN.COLLATERAL = 'F.COLLATERAL'; F.COLLATERAL = ''
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
*
    FN.COUNTRY = 'F.COUNTRY'; F.COUNTRY = ''
    CALL OPF(FN.COUNTRY,F.COUNTRY)
*
    FN.AA.ARRANGEMENT.DATED.XREF = 'F.AA.ARRANGEMENT.DATED.XREF'; F.AA.ARRANGEMENT.DATED.XREF = ''
    CALL OPF(FN.AA.ARRANGEMENT.DATED.XREF,F.AA.ARRANGEMENT.DATED.XREF)
*
    FN.INDUSTRY = 'F.INDUSTRY'; F.INDUSTRY = ''
    CALL OPF(FN.INDUSTRY,F.INDUSTRY)
*
    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'; F.REDO.APAP.PROPERTY.PARAM  = ''
    CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)

    FN.REDO.AA.SCHEDULE = 'F.REDO.AA.SCHEDULE'; F.REDO.AA.SCHEDULE = ''
    CALL OPF(FN.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE)
RETURN
*
*----------------
INITIALISATION.2:
**---------------
    FN.AA.ACTIVITY.HISTORY = "F.AA.ACTIVITY.HISTORY"; F.AA.ACTIVITY.HISTORY  = ""
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)
*
    FN.AA.PRD.DES.ACTIVITY.CHARGES = "F.AA.PRD.DES.ACTIVITY.CHARGES"; F.AA.PRD.DES.ACTIVITY.CHARGES  = ""
    CALL OPF(FN.AA.PRD.DES.ACTIVITY.CHARGES,F.AA.PRD.DES.ACTIVITY.CHARGES)
*
    FN.AA.PRD.CAT.ACTIVITY.CHARGES = "F.AA.PRD.CAT.ACTIVITY.CHARGES"; F.AA.PRD.CAT.ACTIVITY.CHARGES  = ""
    CALL OPF(FN.AA.PRD.CAT.ACTIVITY.CHARGES,F.AA.PRD.CAT.ACTIVITY.CHARGES)
*
    FN.AA.PRODUCT.DESIGNER = "F.AA.PRODUCT.DESIGNER"; F.AA.PRODUCT.DESIGNER  = ""
    CALL OPF(FN.AA.PRODUCT.DESIGNER,F.AA.PRODUCT.DESIGNER)
*
    FN.AA.INTEREST.ACCRUALS = "F.AA.INTEREST.ACCRUALS"; F.AA.INTEREST.ACCRUALS  = ""
    CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)
*
    FN.AA.SCHEDULED.ACTIVITY = "F.AA.SCHEDULED.ACTIVITY"; F.AA.SCHEDULED.ACTIVITY  = ""
    CALL OPF(FN.AA.SCHEDULED.ACTIVITY,F.AA.SCHEDULED.ACTIVITY)
*
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"; F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    FN.AA.ARRANGEMENT.ACTIVITY = "F.AA.ARRANGEMENT.ACTIVITY"; F.AA.ARRANGEMENT.ACTIVITY  = ""
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)
*
    FN.REDO.H.CUSTOMER.PROVISIONING = "F.REDO.H.CUSTOMER.PROVISIONING"; F.REDO.H.CUSTOMER.PROVISIONING  = ""
    CALL OPF(FN.REDO.H.CUSTOMER.PROVISIONING,F.REDO.H.CUSTOMER.PROVISIONING)
*
    FN.AA.CHARGE = 'F.AA.ARR.CHARGE'; F.AA.CHARGE = ''
    CALL OPF(FN.AA.CHARGE,F.AA.CHARGE)

    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.AA.MIG.PAY.START.DTE = 'F.REDO.AA.MIG.PAY.START.DTE'; F.REDO.AA.MIG.PAY.START.DTE = ''
    CALL OPF(FN.REDO.AA.MIG.PAY.START.DTE,F.REDO.AA.MIG.PAY.START.DTE)

    FN.REDO.CAMPAIGN.TYPES = 'F.REDO.CAMPAIGN.TYPES'; F.REDO.CAMPAIGN.TYPES = ''
    CALL OPF(FN.REDO.CAMPAIGN.TYPES,F.REDO.CAMPAIGN.TYPES)
    FN.DR.REG.DE11.WORKFILE = 'F.DR.REG.DE11.WORKFILE'; F.DR.REG.DE11.WORKFILE = ''
    CALL OPF(FN.DR.REG.DE11.WORKFILE, F.DR.REG.DE11.WORKFILE)

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'; F.AA.BILL.DETAILS = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)
    FN.AA.BILL.HST="F.AA.BILL.DETAILS.HIST"; F.AA.BILL.HST =''
    CALL OPF(FN.AA.BILL.HST,F.AA.BILL.HST)
    FN.REDO.APAP.COMMER.DEBT.DET = 'F.REDO.APAP.COMMER.DEBT.DET'; F.REDO.APAP.COMMER.DEBT.DET = ''
    CALL OPF(FN.REDO.APAP.COMMER.DEBT.DET,F.REDO.APAP.COMMER.DEBT.DET)
    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'; F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)
    FN.AA.ACCT.DET = "F.AA.ACCOUNT.DETAILS"
    F.AA.ACCT.DET = ""
    CALL OPF(FN.AA.ACCT.DET,F.AA.ACCT.DET)
    FN.REDO.CONCAT.ACC.NAB = 'F.REDO.CONCAT.ACC.NAB'
    F.REDO.CONCAT.ACC.NAB = ''
    CALL OPF(FN.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB)
    FN.EB.CON.BAL = "F.EB.CONTRACT.BALANCES"
    F.EB.CON.BAL = ""
    CALL OPF(FN.EB.CON.BAL,F.EB.CON.BAL)
    FN.REDO.CATEGORY.CIUU = 'F.REDO.CATEGORY.CIUU'; F.REDO.CATEGORY.CIUU = ''
    CALL OPF(FN.REDO.CATEGORY.CIUU,F.REDO.CATEGORY.CIUU)
RETURN
*
*---------------
FETCH.PARAM.VAL:
**--------------
*-----------------------------------------------------------------------------------------------------------
* EB.LOOKUP read and the parameterized value for field  VINCATION.TYPE  and CAPITAL INTEREST PAYMENT METHOD:
**----------------------------------------------------------------------------------------------------------
*
    CALL CACHE.READ(FN.REDO.H.PROVISION.PARAM,'SYSTEM',R.REDO.H.PROVISION.PARAM,PROV.PARAM)
    Y.VINCATION.TYPE.ID = "REDO.CONSUMO.LOAN*VINCATION"
    Y.EB.LOOKUP.ID = Y.VINCATION.TYPE.ID
    GOSUB EB.LOOKUP.READ
    Y.VINCATION.DATA.NAME = R.EB.LOOKUP<EB.LU.DATA.NAME>
    Y.VINCATION.DATA.VAL  = R.EB.LOOKUP<EB.LU.DATA.VALUE>
    CHANGE @VM TO @FM IN Y.VINCATION.DATA.NAME
    CHANGE @VM TO @FM IN Y.VINCATION.DATA.VAL
*
    Y.EB.LOOK.ID.PAY = "AA.ARRANGEMENT*PAY.TYPE"
    CALL F.READ(FN.EB.LOOKUP,Y.EB.LOOK.ID.PAY,R.EB.LOOKUP.PAY,F.EB.LOOKUP,EB.LOOKUP.ERR)
    Y.AA.PAY.TYPE = R.EB.LOOKUP.PAY<EB.LU.DATA.NAME>
*    Y.AA.PAY.TYPE.VAL = R.EB.LOOKUP.PAY<EB.LU.DATA.VALUE>
*
    Y.EB.LOOK.ID.PAY.I = "AA.ARRANGEMENT*PAY.TYPE.I"
    CALL F.READ(FN.EB.LOOKUP,Y.EB.LOOK.ID.PAY.I,R.EB.LOOKUP.PAY.I,F.EB.LOOKUP,EB.LOOKUP.ERR)
    Y.AA.PAY.TYPE.I = R.EB.LOOKUP.PAY.I<EB.LU.DATA.NAME>
*
    Y.CAP.INT.PAY.MTD.ID = "REDO.CONSUMO.LOAN*CAP.INT.PAY.MTD"
    Y.EB.LOOKUP.ID = ''
    Y.EB.LOOKUP.ID.CAP.INIT = Y.CAP.INT.PAY.MTD.ID
    CALL F.READ(FN.EB.LOOKUP,Y.EB.LOOKUP.ID.CAP.INIT,R.EB.LOOKUP.CAP.INT,F.EB.LOOKUP,EB.LOOKUP.ERR)
    Y.CAP.INT.PAY.MTD.DATA.NAME = R.EB.LOOKUP.CAP.INT<EB.LU.DATA.NAME>
    Y.CAP.INT.PAY.MTD.DATA.VAL = R.EB.LOOKUP.CAP.INT<EB.LU.DATA.VALUE>
    CHANGE @VM TO @FM IN Y.CAP.INT.PAY.MTD.DATA.NAME
    CHANGE @VM TO @FM IN Y.CAP.INT.PAY.MTD.DATA.VAL
*
*---------------------------------------------
* Fetching the PARAM id and RCL id from BATCH:
**--------------------------------------------
*
    LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.TODAY = TODAY
    CALL CDT('',Y.TODAY,'-1C')
    IF LAST.WORK.DAY[5,2] NE Y.TODAY[5,2] THEN
        COMI = LAST.WORK.DAY[1,6]:'01'
        CALL LAST.DAY.OF.THIS.MONTH
        Y.TODAY = COMI
    END
    Y.APAP.REP.PARAM.ID = "REDO.DE11"
    Y.RCL.ID            = "REDO.RCL.DE11"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.APAP.REP.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.OUTPUT.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.FILE.NAME  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FILE.DIR   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    END
*
    LOCATE "EARLY.PAYOFF" IN Y.FIELD.NME.ARR<1,1> SETTING EYPO.POS THEN
        Y.TXNEYPO.VAL.ARR = Y.FIELD.VAL.ARR<1,EYPO.POS>
    END
    Y.TXNEYPO.VAL.ARR = CHANGE(Y.TXNEYPO.VAL.ARR,@SM,' ')

    LOCATE "EARLY.PAYOFF.PERC" IN Y.FIELD.NME.ARR<1,1> SETTING EYPOP.POS THEN
        Y.TXNEYPOP.VAL.ARR = Y.FIELD.VAL.ARR<1,EYPOP.POS>
    END
    Y.TXNEYPOP.VAL.ARR = CHANGE(Y.TXNEYPOP.VAL.ARR,@SM,' ')

    LOCATE "TIPO.DE.TASA" IN Y.FIELD.NME.ARR<1,1> SETTING TDT.POS THEN
        Y.TXNTDT.VAL.ARR = Y.FIELD.VAL.ARR<1,TDT.POS>
        Y.TXNTDT.DIS.ARR = Y.DISP.TEXT.ARR<1,TDT.POS>
    END
    Y.TXNTDT.VAL.ARR = CHANGE(Y.TXNTDT.VAL.ARR,@SM,@VM)
    Y.TXNTDT.DIS.ARR = CHANGE(Y.TXNTDT.DIS.ARR,@SM,@VM)

    Y.OUT.FILE.NAME = Y.FILE.NAME:".TEMP.":AGENT.NUMBER:".":SERVER.NAME                   ;** R22 Auto conversion - SESSION.NO TO AGENT.NUMBER
*
    CHANGE @VM TO '' IN Y.FILE.DIR
    OPENSEQ Y.FILE.DIR,Y.OUT.FILE.NAME TO Y$.SEQFILE.PTR ELSE
        CREATE Y.OUT.FILE.NAME ELSE
            Y.ERR.MSG   = "Unable to Open '":Y.OUT.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
        END
    END
RETURN
*
*------------
FIND.LOC.REF:
*------------
*
    Y.APPL = "CUSTOMER":@FM:"AA.PRD.DES.OVERDUE":@FM:"AA.PRD.DES.TERM.AMOUNT":@FM:"AA.PRD.DES.INTEREST":@FM:"AA.PRD.DES.CHARGE":@FM:"INDUSTRY":@FM:'AA.PRD.DES.ACCOUNT':@FM:'COUNTRY':@FM:"AA.PRD.DES.PAYMENT.SCHEDULE":@FM:"AA.PRD.DES.CUSTOMER"
    Y.FLD  = "L.LOCALIDAD":@VM:"L.TIP.CLI":@VM:"L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.PASS.NAT":@VM:"L.CU.TIPO.CL":@VM:"L.CU.DEBTOR":@VM:"L.APAP.INDUSTRY":@VM:"L.AA.MMD.PYME":@VM:"L.CU.PRO.RATING":@VM:"L.AA.CAL.ISSUER":@VM:"L.CU.COM.CLASIF":@FM:"L.LOAN.STATUS.1":@VM:"L.STATUS.CHG.DT":@VM:"L.RESTRUCT.TYPE":@VM:"L.ADJ.DATE":@FM:"L.AA.PART.ALLOW":@VM:"L.AA.COL":@VM:"L.AA.COL.VAL":@FM:"L.AA.REV.RT.TY":@VM:"L.AA.NXT.REV.DT":@FM:"L.AA.CHG.RATE":@FM:"L.AA.CATEG":@FM:"ORIGEN.RECURSOS":@VM:"L.AA.LOAN.DSN":@VM:"L.CR.FACILITY":@VM:"L.AA.CATEG":@VM:"L.CR.ORIG":@FM:'L.CO.RISK.CLASS':@FM:"L.MIGRATED.LN":@FM:"L.AA.CAMP.TY"
    Y.POS  = ""
*
    CALL MULTI.GET.LOC.REF(Y.APPL,Y.FLD,Y.POS)
*
    Y.L.LOCALIDAD.POS = Y.POS<1,1>
    Y.L.TIP.CLI.POS   = Y.POS<1,2>
    L.CU.CIDENT.POS   = Y.POS<1,3>
    L.CU.RNC.POS      = Y.POS<1,4>
    L.CU.FOREIGN.POS  = Y.POS<1,5>
    L.CU.TIPO.CL.POS  = Y.POS<1,6>
    Y.CU.DEBTOR.POS = Y.POS<1,7>
    L.APAP.INDUSTRY.POS = Y.POS<1,8>
    L.AA.MMD.PYME.POS = Y.POS<1,9>
    L.CU.PRO.RATING.POS = Y.POS<1,10>
    L.AA.CAL.ISSUER.POS = Y.POS<1,11>
    L.CU.COM.CLASIF.POS = Y.POS<1,12>
*
    Y.L.LOAN.STATUS.1.POS = Y.POS<2,1>
    Y.L.STATUS.CHG.DT.POS = Y.POS<2,2>
    Y.L.RESTRUCT.TYPE.POS = Y.POS<2,3>
    ADJ.STA.DATE.POS = Y.POS<2,4>
*
    Y.L.AA.PART.ALLOW.POS = Y.POS<3,1>
    POS.L.AA.COL = Y.POS<3,2>
    POS.L.AA.COL.VAL = Y.POS<3,3>
*
    Y.L.AA.REV.RT.TY.POS  = Y.POS<4,1>
    Y.L.AA.NXT.REV.DT.POS = Y.POS<4,2>
*
    Y.L.AA.CHG.RATE.POS   = Y.POS<5,1>
*
    L.AA.CATEGN.POS    = Y.POS<6,1>
    Y.ORGN.FUND.POS = Y.POS<7,1>
    Y.L.AA.LOAN.DSN.POS = Y.POS<7,2>
    Y.L.CR.FACILITY.POS = Y.POS<7,3>
    L.AA.CATEG.POS = Y.POS<7,4>
    L.CR.ORIG.POS = Y.POS<7,5>
*
    Y.RISK.CLS.POS = Y.POS<8,1>
*
    L.MIGRATED.LN.POS = Y.POS<9,1>
    L.AA.CAMP.TY.POS = Y.POS<10,1>
RETURN
*
EB.LOOKUP.READ:
**-------------
*
    EB.LOOKUP.ERR = "";    R.EB.LOOKUP   = ""
    CALL F.READ(FN.EB.LOOKUP,Y.EB.LOOKUP.ID,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
RETURN
*
*--------------
RAISE.ERR.C.22:
*----------------------
*Handling error process
*----------------------
*
    MON.TP    = "13"
    REC.CON   = "DE13-":Y.ERR.MSG
    DESC      = "DE13-":Y.ERR.MSG
    INT.CODE  = 'REP001'
    INT.TYPE  = 'ONLINE'
    BAT.NO    = ''
    BAT.TOT   = ''
    INFO.OR   = ''
    INFO.DE   = ''
    ID.PROC   = ''
    EX.USER   = ''
    EX.PC     = ''
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
** R22 Manual conversion
    CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*
RETURN
*
END
