* @ValidationCode : MjoxMTI3MTA1MDU6Q3AxMjUyOjE2ODIzMzE1NjU5ODQ6SVRTUzotMTotMToxMjcxOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1271
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.COMMER.DEBTOR.BAL.LOAD
*--------------------------------------------------------------------------------------------------
*
* Description           : This is the Batch Load Routine used to Load the Required Variaables
*
*
* Developed On          : 13-Nov-2013
*
* Developed By          : Amaravathi Krithika B
*
* Development Reference : DE08
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
* PACS00361295           Ashokkumar.V.P                 04/11/2014            Added additonal loans
* PACS00361295           Ashokkumar.V.P                 15/05/2015            Added new fields to show customer loans.
* PACS00464363           Ashokkumar.V.P                 22/06/2015            Changed to avoid ageing problem and mapping changes.
* PACS00466000           Ashokkumar.V.P                 24/06/2015            Mapping changes - Remove L.CU.DEBTOR field

* 21.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM, INSERT file folder name removed T24.BP, TAM.BP, LAPAP.BP
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*--------------------------------------------------------------------------------------------------

* Include files
*--------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON                            ;** R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_BATCH.FILES
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.DATES
    $INSERT I_TSA.COMMON
*   $INSERT I_BATCH.FILES
    $INSERT I_REDO.B.COMMER.DEBTOR.BAL.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON          ;** R22 Auto conversion - END
*
    GOSUB INIT
    GOSUB FIND.LOC.REF
    GOSUB PROCESS
    GOSUB GET.VALUES
RETURN

INIT:
*---
    FN.REDO.H.REPORTS.PARAM = ''
    F.REDO.H.REPORTS.PARAM = ''
    FN.EB.CON.BAL = ''
    F.EB.CON.BAL = ''
    FN.CUSTOMER = ''
    F.CUSTOMER = ''
    FN.AA.ARR.TERM.AMOUNT = ''
    F.AA.ARR.TERM.AMOUNT = ''
    L.TIP.CLI.POS = ''
    FN.AA.ARRANGEMENT = ''
    F.AA.ARRANGEMENT = ''
    L.CU.FOREIGN.POS = ''
    L.APAP.INDUSTRY.POS = ''; YTODAY.DAT = ''
RETURN

FIND.LOC.REF:
*-----------
    Y.APP = "CUSTOMER":@FM:"INDUSTRY":@FM:"AA.PRD.DES.OVERDUE":@FM:'ACCOUNT'
    Y.FIELDS = "L.CU.TIPO.CL":@VM:"L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.DEBTOR":@VM:"L.TIP.CLI":@VM:"L.CU.PASS.NAT":@VM:"L.APAP.INDUSTRY":@VM:"L.AA.MMD.PYME":@FM:"L.AA.CATEG":@FM:"L.LOAN.STATUS.1":@FM:"L.OD.STATUS"
    Y.FIELD.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FIELDS,Y.FIELD.POS)
    L.CU.TIPO.CL.POS = Y.FIELD.POS<1,1>
    L.CU.CIDENT.POS = Y.FIELD.POS<1,2>
    L.CU.RNC.POS = Y.FIELD.POS<1,3>
    L.CU.DEBTOR.POS = Y.FIELD.POS<1,4>
    L.TIP.CLI.POS = Y.FIELD.POS<1,5>
    L.CU.FOREIGN.POS =  Y.FIELD.POS<1,6>
    L.APAP.INDUSTRY.POS = Y.FIELD.POS<1,7>
    L.AA.MMD.PYME.POS = Y.FIELD.POS<1,8>
    L.AA.CATEG.POS = Y.FIELD.POS<2,1>
    Y.L.LOAN.STATUS.1.POS = Y.FIELD.POS<3,1>
    L.OD.STATUS.POS = Y.FIELD.POS<4,1>
RETURN

PROCESS:
*------
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    FN.REDO.CUSTOMER.ARRANGEMENT = 'F.REDO.CUSTOMER.ARRANGEMENT'
    F.REDO.CUSTOMER.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT)
*
    FN.EB.CON.BAL = 'F.EB.CONTRACT.BALANCES'
    F.EB.CON.VAL = ''
    CALL OPF(FN.EB.CON.BAL,F.EB.CON.BAL)
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
    FN.AA.ARR.TERM.AMOUNT = "F.AA.ARR.TERM.AMOUNT"
    F.AA.ARR.TERM.AMOUNT  = ""
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)
*
    FN.REDO.CONCAT.ACC.NAB = 'F.REDO.CONCAT.ACC.NAB'
    F.REDO.CONCAT.ACC.NAB = ''
    CALL OPF(FN.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'; F.REDO.APAP.PROPERTY.PARAM = ''
    CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'; F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.DR.REG.DE08.WORKFILE = 'F.DR.REG.DE08.WORKFILE'
    F.DR.REG.DE08.WORKFILE = ''
    CALL OPF(FN.DR.REG.DE08.WORKFILE, F.DR.REG.DE08.WORKFILE)
    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'; F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)
RETURN

GET.VALUES:
*----------
    YLAST.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.TODAY = TODAY
    YTODAY.DAT = Y.TODAY
    CALL CDT('',YTODAY.DAT,'-1C')
    IF YLAST.DATE[5,2] NE YTODAY.DAT[5,2] THEN
        COMI = YLAST.DATE[1,6]:'01'
        CALL LAST.DAY.OF.THIS.MONTH
        YTODAY.DAT = COMI
    END
    Y.REP.PARAM.ID = "REDO.DE08"
    Y.RCL.DEB.ID = "REDO.RCL.DE08"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.REP.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.OUTPUT.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.FILE.NAME  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FILE.DIR   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        Y.FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    END
RETURN
END
