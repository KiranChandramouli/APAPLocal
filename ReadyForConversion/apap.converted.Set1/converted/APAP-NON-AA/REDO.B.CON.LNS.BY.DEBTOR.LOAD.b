SUBROUTINE REDO.B.CON.LNS.BY.DEBTOR.LOAD
*--------------------------------------------------------------------------------------------------
*
* Description           : This is the Batch Load Routine used to initalize all the required variables
*
* Developed On          : 10-Sep-2013
*
* Developed By          : Emmanuel James Natraj Lvingston
*
* Development Reference : 786790(FS-205-DE13)
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
* PACS00365441           Ashokkumar.V.P                  27/02/2015      Optimized the relation between the customer.
* PACS00460183           Ashokkumar.V.P                  27/05/2015      new mapping changes.
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
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
    $INSERT I_F.AA.LIMIT
    $INSERT I_F.DATES
    $INSERT I_TSA.COMMON
*
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_REDO.B.CON.LNS.BY.DEBTOR.COMMON
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
*

    GOSUB INIT
    GOSUB INITIALISATION.1
    GOSUB INITIALISATION.2
    GOSUB FETCH.PARAM.VAL
    GOSUB FIND.LOC.REF
    GOSUB SELECT.RECORDS
*
RETURN
INIT:
*---
    FN.AA.PRODUCT.DESIGNER  = ''
    F.AA.PRODUCT.DESIGNER  = ''
    FN.LIMIT = ''
    F.LIMIT = ''
    FN.CUSTOMER = ''
    F.CUSTOMER = ''
    FN.REDO.REPORT.TEMP = ''
    F.REDO.REPORT.TEMP = ''
    FN.CCY.HISTORY  = ''
    F.CCY.HISTORY = ''
    FN.CCY = ''
    F.CCY = ''
    FN.AA.ARRANGEMENT = ''
    F.AA.ARRANGEMENT = ''
    FN.EB.LOOKUP = ''
    F.EB.LOOKUP = ''
    FN.CURRENCY.HIS = ''
    F.CURRENCY.HIS = ''
    FN.AA.PRD.DES.CHARGE = ''
    F.AA.PRD.DES.CHARGE = ''
    FN.AA.ARR.TERM.AMOUNT = ''
    F.AA.ARR.TERM.AMOUNT = ''
    FN.AA.PRODUCT.GROUP = ''
    F.AA.PRODUCT.GROUP = ''
    FN.AA.ACCOUNT.DETAILS = ''
    F.AA.ACCOUNT.DETAILS = ''
    FN.AA.ACTIVITY.HISTORY = ''
    F.AA.ACTIVITY.HISTORY = ''
    FN.AA.PRD.DES.ACTIVITY.CHARGES = ''
    F.AA.PRD.DES.ACTIVITY.CHARGES = ''
    FN.AA.PRD.CAT.ACTIVITY.CHARGES = ''
    F.AA.PRD.CAT.ACTIVITY.CHARGES = ''
    FN.AA.PRODUCT.DESIGNER = ''
    F.AA.PRODUCT.DESIGNER = ''
    FN.AA.INTEREST.ACCRUALS = ''
    F.AA.INTEREST.ACCRUALS = ''
    FN.AA.SCHEDULED.ACTIVITY = ''
    F.AA.SCHEDULED.ACTIVITY = ''
    FN.REDO.H.REPORTS.PARAM = ''
    F.REDO.H.REPORTS.PARAM = ''
    FN.AA.ARRANGEMENT.ACTIVITY = ''
    F.AA.ARRANGEMENT.ACTIVITY = ''
    FN.REDO.H.CUSTOMER.PROVISIONING = ''
    F.REDO.H.CUSTOMER.PROVISIONING = ''
    Y.L.LOCALIDAD.POS = ''
    Y.L.TIP.CLI.POS = ''
    L.CU.CIDENT.POS = ''
    L.CU.RNC.POS = ''
    L.CU.FOREIGN.POS= ''
    L.CU.TIPO.CL.POS= ''
    Y.L.LOAN.STATUS.1.POS= ''
    Y.L.STATUS.CHG.DT.POS= ''
    Y.L.RESTRUCT.TYPE.POS= ''
    Y.L.AA.PART.ALLOW.POS= ''
    Y.L.CR.FACILITY.POS= ''
    Y.L.AA.REV.RT.TY.POS= ''
    Y.L.AA.NXT.REV.DT.POS= ''
    Y.L.AA.CHG.RATE.POS= ''
    L.AA.CATEG.POS= ''
    FN.AA.LIMIT = ''
    F.AA.LIMIT = ''
    Y.AA.LINEAS.PAY.SCH = ''
    FN.REDO.APAP.PROPERTY.PARAM = ''
    F.REDO.APAP.PROPERTY.PARAM  = ''
    R.REDO.APAP.PROPERTY.PARAM  = ''
    SEL.LIST.3 = ''; L.AA.CAMP.TY.POS = ''
RETURN
*
*----------------
INITIALISATION.1:
*----------------
*

    FN.LIMIT = "F.LIMIT"
    F.LIMIT  = ""
    CALL OPF(FN.LIMIT,F.LIMIT)
*
    FN.AA.LIMIT = 'F.AA.ARR.LIMIT'
    F.AA.LIMIT = ''
    R.AA.LIMIT = ''
    CALL OPF(FN.AA.LIMIT,F.AA.LIMIT)
*
    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER  = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
    FN.REDO.REPORT.TEMP = "F.REDO.REPORT.TEMP"
    F.REDO.REPORT.TEMP  = ""
    CALL OPF(FN.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP)
*
    FN.CCY.HISTORY = "F.CCY.HISTORY"
    F.CCY.HISTORY  = ""
    CALL OPF(FN.CCY.HISTORY,F.CCY.HISTORY)
*
    FN.CCY = "F.CURRENCY"
    F.CCY  = ""
    CALL OPF(FN.CCY,F.CCY)
*
    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
    F.AA.ARRANGEMENT  = ""
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
*
    FN.EB.LOOKUP = "F.EB.LOOKUP"
    F.EB.LOOKUP  = ""
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)
*
    FN.CURRENCY.HIS = "F.CURRENCY$HIS"
    F.CURRENCY.HIS  = ""
    CALL OPF(FN.CURRENCY.HIS,F.CURRENCY.HIS)
*
    FN.AA.PRD.DES.CHARGE = "F.AA.PRD.DES.CHARGE"
    F.AA.PRD.DES.CHARGE  = ""
    CALL OPF(FN.AA.PRD.DES.CHARGE,F.AA.PRD.DES.CHARGE)
*
    FN.AA.ARR.TERM.AMOUNT = "F.AA.ARR.TERM.AMOUNT"
    F.AA.ARR.TERM.AMOUNT  = ""
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)
*
    FN.AA.PRODUCT.GROUP = "F.AA.PRODUCT.GROUP"
    F.AA.PRODUCT.GROUP  = ""
    CALL OPF(FN.AA.PRODUCT.GROUP,F.AA.PRODUCT.GROUP)
*
    FN.AA.ACCOUNT.DETAILS = "F.AA.ACCOUNT.DETAILS"
    F.AA.ACCOUNT.DETAILS  = ""
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)
*
    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'
    F.REDO.APAP.PROPERTY.PARAM  = ''
    CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)
*
RETURN
*
*----------------
INITIALISATION.2:
**---------------
*
    FN.AA.ACTIVITY.HISTORY = "F.AA.ACTIVITY.HISTORY"
    F.AA.ACTIVITY.HISTORY  = ""
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)
*
    FN.AA.PRD.DES.ACTIVITY.CHARGES = "F.AA.PRD.DES.ACTIVITY.CHARGES"
    F.AA.PRD.DES.ACTIVITY.CHARGES  = ""
    CALL OPF(FN.AA.PRD.DES.ACTIVITY.CHARGES,F.AA.PRD.DES.ACTIVITY.CHARGES)
*
    FN.AA.PRD.CAT.ACTIVITY.CHARGES = "F.AA.PRD.CAT.ACTIVITY.CHARGES"
    F.AA.PRD.CAT.ACTIVITY.CHARGES  = ""
    CALL OPF(FN.AA.PRD.CAT.ACTIVITY.CHARGES,F.AA.PRD.CAT.ACTIVITY.CHARGES)
*
    FN.AA.PRODUCT.DESIGNER = "F.AA.PRODUCT.DESIGNER"
    F.AA.PRODUCT.DESIGNER  = ""
    CALL OPF(FN.AA.PRODUCT.DESIGNER,F.AA.PRODUCT.DESIGNER)
*
    FN.AA.INTEREST.ACCRUALS = "F.AA.INTEREST.ACCRUALS"
    F.AA.INTEREST.ACCRUALS  = ""
    CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)
*
    FN.AA.SCHEDULED.ACTIVITY = "F.AA.SCHEDULED.ACTIVITY"
    F.AA.SCHEDULED.ACTIVITY  = ""
    CALL OPF(FN.AA.SCHEDULED.ACTIVITY,F.AA.SCHEDULED.ACTIVITY)
*
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    FN.AA.ARRANGEMENT.ACTIVITY = "F.AA.ARRANGEMENT.ACTIVITY"
    F.AA.ARRANGEMENT.ACTIVITY  = ""
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)
*
    FN.REDO.H.CUSTOMER.PROVISIONING = "F.REDO.H.CUSTOMER.PROVISIONING"
    F.REDO.H.CUSTOMER.PROVISIONING  = ""
    CALL OPF(FN.REDO.H.CUSTOMER.PROVISIONING,F.REDO.H.CUSTOMER.PROVISIONING)
*
    FN.AA.PRD.CAT.CHARGE = ''
    F.AA.PRD.CAT.CHARGE = ''
    FN.AA.PRD.CAT.CHARGE = "F.AA.PRD.CAT.CHARGE"
    F.AA.PRD.CAT.CHARGE = ""
    R.AA.PRD.CAT.CHARGE = ""
    CALL OPF(FN.AA.PRD.CAT.CHARGE,F.AA.PRD.CAT.CHARGE)
    LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)

    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.AA.MIG.PAY.START.DTE = 'F.REDO.AA.MIG.PAY.START.DTE'; F.REDO.AA.MIG.PAY.START.DTE = ''
    CALL OPF(FN.REDO.AA.MIG.PAY.START.DTE,F.REDO.AA.MIG.PAY.START.DTE)

    FN.REDO.CAMPAIGN.TYPES = 'F.REDO.CAMPAIGN.TYPES'; F.REDO.CAMPAIGN.TYPES = ''
    CALL OPF(FN.REDO.CAMPAIGN.TYPES,F.REDO.CAMPAIGN.TYPES)
    Y.TODAY = TODAY
RETURN
*
*---------------
FETCH.PARAM.VAL:
**--------------
*-----------------------------------------------------------------------------------------------------------
* EB.LOOKUP read and the parameterized value for field  VINCATION.TYPE  and CAPITAL INTEREST PAYMENT METHOD:
**----------------------------------------------------------------------------------------------------------
*
    Y.VINCATION.TYPE.ID = "REDO.CONSUMO.LOAN*VINCATION"
    Y.EB.LOOKUP.ID = Y.VINCATION.TYPE.ID
    GOSUB EB.LOOKUP.READ
    Y.VINCATION.DATA.NAME = R.EB.LOOKUP<EB.LU.DATA.NAME>
    Y.VINCATION.DATA.VAL  = R.EB.LOOKUP<EB.LU.DATA.VALUE>
*
    CHANGE @VM TO @FM IN Y.VINCATION.DATA.NAME
    CHANGE @VM TO @FM IN Y.VINCATION.DATA.VAL
*
    Y.CAP.INT.PAY.MTD.ID = "REDO.CONSUMO.LOAN*CAP.INT.PAY.MTD"
    Y.EB.LOOKUP.ID = Y.CAP.INT.PAY.MTD.ID
    GOSUB EB.LOOKUP.READ
    Y.CAP.INT.PAY.MTD.DATA.NAME = R.EB.LOOKUP<EB.LU.DATA.NAME>
    Y.CAP.INT.PAY.MTD.DATA.VAL  = R.EB.LOOKUP<EB.LU.DATA.VALUE>
*
    CHANGE @VM TO @FM IN Y.CAP.INT.PAY.MTD.DATA.NAME
    CHANGE @VM TO @FM IN Y.CAP.INT.PAY.MTD.DATA.VAL

    Y.AA.PAY.TYPE = ''
    Y.AA.PAY.TYPE.I = ''

    Y.EB.LOOK.ID.PAY = "AA.ARRANGEMENT*PAY.TYPE"
    CALL F.READ(FN.EB.LOOKUP,Y.EB.LOOK.ID.PAY,R.EB.LOOKUP.PAY,F.EB.LOOKUP,EB.LOOKUP.ERR)
    Y.AA.PAY.TYPE = R.EB.LOOKUP.PAY<EB.LU.DATA.NAME>

    Y.EB.LOOK.ID.PAY.I = "AA.ARRANGEMENT*PAY.TYPE.I"
    CALL F.READ(FN.EB.LOOKUP,Y.EB.LOOK.ID.PAY.I,R.EB.LOOKUP.PAY.I,F.EB.LOOKUP,EB.LOOKUP.ERR)
    Y.AA.PAY.TYPE.I = R.EB.LOOKUP.PAY.I<EB.LU.DATA.NAME>

*
*---------------------------------------------
* Fetching the PARAM id and RCL id from BATCH:
**--------------------------------------------
*
    Y.APAP.REP.PARAM.ID = "REDO.DE13"
    Y.RCL.ID            = "REDO.RCL.DE13"
*
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
    LOCATE "PRODUCT.GROUP" IN Y.FIELD.NME.ARR<1,1> SETTING PGRP.POS THEN
        Y.TXNPGRP.VAL.ARR = Y.FIELD.VAL.ARR<1,PGRP.POS>
    END
    Y.TXNPGRP.VAL.ARR = CHANGE(Y.TXNPGRP.VAL.ARR,@SM,' ')

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

*---------------------------------------
* Fetching values from AA.PRODUCT.GROUP:
**--------------------------------------
*
    Y.PRODUCT.GROUP = Y.TXNPGRP.VAL.ARR
*
    CALL CACHE.READ(FN.AA.PRODUCT.GROUP, Y.PRODUCT.GROUP, R.AA.PRODUCT.GROUP, AA.PRD.GRP.ERR)
    Y.ACTIVITY.PROPERTY.CLASS = R.AA.PRODUCT.GROUP<AA.PG.PROPERTY.CLASS>
    Y.ACTIVITY.PROPERTY       = R.AA.PRODUCT.GROUP<AA.PG.PROPERTY>
*
    Y.OUT.FILE.NAME = Y.FILE.NAME:".TEMP.":AGENT.NUMBER:".":SERVER.NAME
*
    CHANGE @VM TO '' IN Y.FILE.DIR
    OPENSEQ Y.FILE.DIR,Y.OUT.FILE.NAME TO Y$.SEQFILE.PTR ELSE
        CREATE Y.OUT.FILE.NAME ELSE
            Y.ERR.MSG   = "Unable to Open '":Y.OUT.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END
RETURN
*
*------------
FIND.LOC.REF:
*------------
*
    Y.APPL = "CUSTOMER":@FM:"AA.PRD.DES.OVERDUE":@FM:"AA.PRD.DES.TERM.AMOUNT":@FM:"AA.PRD.DES.INTEREST":@FM:"AA.PRD.DES.CHARGE":@FM:"INDUSTRY":@FM:"AA.PRD.DES.ACCOUNT":@FM:"AA.PRD.DES.PAYMENT.SCHEDULE":@FM:"AA.PRD.DES.CUSTOMER"
    Y.FLD  = "L.LOCALIDAD":@VM:"L.TIP.CLI":@VM:"L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.FOREIGN":@VM:"L.CU.TIPO.CL":@FM:"L.LOAN.STATUS.1":@VM:"L.STATUS.CHG.DT":@VM:"L.RESTRUCT.TYPE":@FM:"L.AA.PART.ALLOW":@VM:"L.CR.FACILITY":@FM:"L.AA.REV.RT.TY":@VM:"L.AA.NXT.REV.DT":@FM:"L.AA.CHG.RATE":@FM:"L.AA.CATEG":@FM:"L.CR.FACILITY":@VM:"ORIGEN.RECURSOS":@VM:"L.CR.ORIG":@FM:"L.MIGRATED.LN":@FM:"L.AA.CAMP.TY"
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
*
    Y.L.LOAN.STATUS.1.POS = Y.POS<2,1>
    Y.L.STATUS.CHG.DT.POS = Y.POS<2,2>
    Y.L.RESTRUCT.TYPE.POS = Y.POS<2,3>
*
    Y.L.AA.PART.ALLOW.POS = Y.POS<3,1>
    Y.L.CR.FACILITY.POS   = Y.POS<3,2>
*
    Y.L.AA.REV.RT.TY.POS  = Y.POS<4,1>
    Y.L.AA.NXT.REV.DT.POS = Y.POS<4,2>
*
    Y.L.AA.CHG.RATE.POS   = Y.POS<5,1>
*
    L.AA.CATEG.POS    = Y.POS<6,1>
*
    L.CR.FACILITY.POS = Y.POS<7,1>
    L.ORIGEN.RECURSOS.POS = Y.POS<7,2>
    L.CR.ORIG.POS = Y.POS<7,3>
*
    L.MIGRATED.LN.POS = Y.POS<8,1>
    L.AA.CAMP.TY.POS = Y.POS<9,1>
RETURN
*
*--------------
SELECT.RECORDS:
**-------------
*
    SEL.CMD.1 = "SELECT ":FN.AA.PRD.CAT.ACTIVITY.CHARGES
    CALL EB.READLIST(SEL.CMD.1,SEL.LIST.1,"",NOF.OF.REC,RET.CODE)
    Y.AA.PRD.CAT.ACTIVITY.CHARGES = SEL.LIST.1
*
    SEL.CMD.2 = "SELECT ":FN.AA.PRD.DES.CHARGE
    CALL EB.READLIST(SEL.CMD.2,SEL.LIST.2,"",NO.OF.REC,RET.CODE)
    Y.AA.PRD.DES.CHARGE = SEL.LIST.2
*
    SEL.CMD.3 =  "SELECT ":FN.AA.PRODUCT.DESIGNER:" BY @ID"
    CALL EB.READLIST(SEL.CMD.3,SEL.LIST.3,"",NO.OF.REC,RET.CODE)
    Y.AA.PRDT.CHG = SEL.LIST.3
*
    Y.AA.PRD.CAT.CHARGE = ''
    SEL.CMD.4 = "SELECT ":FN.AA.PRD.CAT.CHARGE:" BY @ID"
    CALL EB.READLIST(SEL.CMD.4,SEL.LIST.4,"",NO.OF.REC,RET.CODE)
    Y.AA.PRD.CAT.CHARGE = SEL.LIST.4
*
    CALL CACHE.READ(FN.AA.PRODUCT.GROUP, 'CONSUMO', R.AA.PRODUCT.GROUP.COS, PRDT.ERR)
    Y.PRTY.CLS.COM = R.AA.PRODUCT.GROUP.COS<AA.PG.PROPERTY.CLASS>
    Y.PRDT.LNE = R.AA.PRODUCT.GROUP.COS<AA.PG.PRODUCT.LINE>
    IF Y.PRDT.LNE EQ "LENDING" THEN
        LOCATE "ACTIVITY.CHARGES" IN Y.PRTY.CLS.COM<1,1> SETTING Y.COM.ACT.CHG.POS THEN
            Y.PROPER.NAME.COM = R.AA.PRODUCT.GROUP.COS<AA.PG.PROPERTY,Y.COM.ACT.CHG.POS>
        END
        LOCATE "PAYMENT.SCHEDULE" IN Y.PRTY.CLS.COM<1,1> SETTING Y.LIN.ACT.SCH.POS THEN
            Y.AA.LINEAS.PAY.SCH = R.AA.PRODUCT.GROUP.COS<AA.PG.PROPERTY,Y.LIN.ACT.SCH.POS>
        END
    END
    Y.ACT.CHG.PRTY = Y.PROPER.NAME.COM
RETURN
*
*--------------
EB.LOOKUP.READ:
**-------------
*
    EB.LOOKUP.ERR = ""
    R.EB.LOOKUP   = ""
    CALL F.READ(FN.EB.LOOKUP,Y.EB.LOOKUP.ID,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
*
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
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*
RETURN
*
END
