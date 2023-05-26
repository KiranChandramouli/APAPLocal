* @ValidationCode : MjotODc1NzgxMjY5OkNwMTI1MjoxNjg0ODU0Mzk1ODg4OklUU1M6LTE6LTE6ODI1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 825
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.REPORTE.ACTIVIDAD.LOAD
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      :
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description: This is a .LOAD Subroutine
*
*-------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*-----------------------------------------------------------------------------------------------------------------
* PACS00363969           Ashokkumar.V.P                 27/11/2014            Added OPF for REDO.CONCAT.ACC.NAB.
*                                                                             Added new local ref 'L.CR.FACILITY, L.LOAN.STATUS.1'
* PACS00363969           Ashokkumar.V.P                 03/03/2015            Replaced with AA.ARR.ACCOUNT>L.CR.FACILITY field to fetch details and group.
* PACS00466618           Ashokkumar.V.P                 26/06/2015            Fixed the NAB account created on same date for old NAB loans.
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND SM TO @SM AND SESSION.NO TO AGENT.NUMBER
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES

    $INSERT I_REDO.B.REPORTE.ACTIVIDAD.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM

    $INSERT I_TSA.COMMON
    $INSERT I_BATCH.FILES
*
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
*
RETURN
*-------------------------------------------------------------------------------
OPEN.PARA:
*---------
*
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
*
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)
*
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    FN.REDO.CONCAT.ACC.NAB = 'F.REDO.CONCAT.ACC.NAB'
    F.REDO.CONCAT.ACC.NAB = ''
    CALL OPF(FN.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)
RETURN
*--------------------------------------------------------------------------------
PROCESS.PARA:
*------------
*
    GOSUB GET.PARAM.DETAILS
    GOSUB OPEN.PATHS
    GOSUB GET.MULTI.LOCAL.REF
    GOSUB FETCH.MIN.MAX.VALUES
    GOSUB FETCH.SELECTION.LIST
*
    PROCESS.POST.RTN = ''
RETURN
*----------------
GET.PARAM.DETAILS:
*---------------
***************************************************************
* Read the Parameter File REDO.H.REPORTS.PARAM  Application
***************************************************************
    REDO.H.REPORTS.PARAM.ID = "REDO.RPT.AA.ACTIVIDAD"
*
    R.REDO.H.REPORTS.PARAM = ''; REDO.PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
*
    FILE.NAME = '' ; TEMP.PATH = ''; OUT.PATH = ''; FIELD.NAME = ''; FIELD.VALUE= ''
    IF REDO.H.REPORTS.PARAM.ID THEN
        FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        FIELD.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        FILE.NAME = FILE.NAME:".TEMP.":AGENT.NUMBER:".":SERVER.NAME ;*R22 AUTO CONVERSTION SESSION.NO TO AGENT.NUMBER
    END
RETURN
*---------------------------------------------------------------------------------
OPEN.PATHS:
*--------------
    SEQ.PTR = ''
*
    IF TEMP.PATH THEN
        OPEN TEMP.PATH TO TEMP.PATH1 ELSE
            CREATE TEMP.PATH ELSE
                Y.PATH = TEMP.PATH
                GOSUB RAISE.ERR.C.22
            END
        END
    END ELSE
        Y.PATH = 'Temp Path Missing In Parameter file'
        GOSUB RAISE.ERR.C.22
    END
*
    IF OUT.PATH THEN
        OPEN OUT.PATH TO OUT.PATH1 ELSE
            CREATE OUT.PATH ELSE
                Y.PATH = OUT.PATH
                GOSUB RAISE.ERR.C.22
            END
        END
    END ELSE
        Y.PATH = 'Out Path Missing In Parameter file'
        GOSUB RAISE.ERR.C.22
    END
RETURN
*------------------------------------------------------------------------
GET.MULTI.LOCAL.REF:
*-------------------
    Y.POS = ''
    Y.APPLICATION = 'ACCOUNT':@FM:'AA.PRD.DES.ACCOUNT':@FM:'AA.PRD.DES.OVERDUE'
    Y.FIELDS = 'L.OD.STATUS'::@FM:'L.CR.FACILITY':@FM:'L.LOAN.STATUS.1'
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELDS,Y.POS)
    L.OD.STATUS.POS = Y.POS<1,1>
    L.CR.FACILITY.POS = Y.POS<2,1>
    Y.L.LOAN.STATUS.1.POS = Y.POS<3,1>

    Y.TODAY = R.DATES(EB.DAT.TODAY)
    Y.LAST.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.PST.TODAY = Y.TODAY
    CALL CDT('',Y.PST.TODAY,'-1C')
    IF Y.LAST.DAY[5,2] NE Y.PST.TODAY[5,2] THEN
        COMI = Y.LAST.DAY
        CALL LAST.DAY.OF.THIS.MONTH
        Y.PST.TODAY = COMI
    END
RETURN
*----------------------------------------------------------------------
FETCH.MIN.MAX.VALUES:
*--------------------
*
    LOCATE 'L.INV.FACILITY.RANGE' IN FIELD.NAME<1,1> SETTING FL.FOUND.POS THEN
        Y.VALUES = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,FL.FOUND.POS>
        CHANGE @SM TO @FM IN Y.VALUES
        Y.MIN.VAL = Y.VALUES<1>
        Y.MAX.VAL = Y.VALUES<2>
    END
RETURN
*----------------------------------------------------------------------
FETCH.SELECTION.LIST:
*--------------------
*
    LOCATE 'FL.SELECTION' IN FIELD.NAME<1,1> SETTING FL.FOUND.POS THEN
        Y.VALUES = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,FL.FOUND.POS>
        CHANGE @SM TO @FM IN Y.VALUES
        Y.SEL.VAL.1 = Y.VALUES<1>
        Y.SEL.VAL.2 = Y.VALUES<2>
    END
RETURN
***************
RAISE.ERR.C.22:
****************
*
    ERR.MSG = "Unable to open '":Y.PATH:"'"
    INT.CODE = "REP001"
    INT.TYPE = "ONLINE"
    MON.TP = "04"
    REC.CON = "AA.ACTIVIDAD-":ERR.MSG
    DESC = "AA.ACTIVIDAD-":ERR.MSG
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
RETURN
END
