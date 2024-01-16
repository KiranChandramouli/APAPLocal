* @ValidationCode : MjotMTQ1NTY4NDQ5MTpVVEYtODoxNjg0MjIyODI4NDkzOklUU1M6LTE6LTE6OTYwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:28
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 960
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.YER.END.FX.SALE.LOAD
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
* Modification History
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00375392          Ashokkumar.V.P                  16/12/2014           Rewritten the routine based on mapping

** 24-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 24-04-2023 Skanda R22 Manual Conversion - Call method format changed
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_TSA.COMMON ;* R22 Auto conversion
    $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_REDO.B.YER.END.FX.SALE.COMMON ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $USING APAP.REDOCHNLS

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN
*-------------------------------------------------------------------------------
OPEN.PARA:
*---------

    FN.FOREX = 'F.FOREX'; F.FOREX = ''
    CALL OPF(FN.FOREX,F.FOREX)

    FN.FOREX.HST = 'F.FOREX$HIS'; F.FOREX.HST = ''
    CALL OPF(FN.FOREX.HST,F.FOREX.HST)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'; F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER.HST = 'F.FUNDS.TRANSFER$HIS';  F.FUNDS.TRANSFER.HST = ''
    CALL OPF(FN.FUNDS.TRANSFER.HST,F.FUNDS.TRANSFER.HST)

    FN.TELLER = 'F.TELLER'; F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TELLER.HST = 'F.TELLER$HIS'; F.TELLER.HST = ''
    CALL OPF(FN.TELLER.HST,F.TELLER.HST)

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'; F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.REDO.FX.CCY.POSN = 'F.REDO.FX.CCY.POSN'; F.REDO.FX.CCY.POSN = ''
    CALL OPF(FN.REDO.FX.CCY.POSN,F.REDO.FX.CCY.POSN)

    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT='F.ACCOUNT'; F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    INT.TYPE = ""
    BAT.NO   = ""
    BAT.TOT  = ""
    INFO.OR  = ""
    INFO.DE  = ""
    ID.PROC  = ""
    EX.USER  = ""
    EX.PC    = ""
    Y.FLAG = 1
RETURN
*--------------------------------------------------------------------------------
PROCESS.PARA:
*------------
    GOSUB GET.PARAM.DETAILS
    GOSUB OPEN.TEMP.PATH
    GOSUB GET.MULTI.LOCAL.REF
RETURN
*-------------------------------------------------------------------------------
GET.PARAM.DETAILS:
*-----------------
    REDO.H.REPORTS.PARAM.ID = BATCH.DETAILS<3,1,1>
*
    R.REDO.H.REPORTS.PARAM = ''; REDO.PARAM.ERR = ''
*    CALL CACHE.READ('F.REDO.H.REPORTS.PARAM',REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM';* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR);* R22 UTILITY AUTO CONVERSION
*
    IF REDO.H.REPORTS.PARAM.ID THEN
        FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        FIELD.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        DISPLAY.TEXT = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
        FILENAME.DATA = FILE.NAME:".TEMP.":AGENT.NUMBER:".":SERVER.NAME ;* R22 Auto conversion
    END
RETURN
*---------------------------------------------------------------------------------
OPEN.TEMP.PATH:
*--------------
    OPENSEQ TEMP.PATH,FILENAME.DATA TO SEQ.PTR ELSE
        CREATE SEQ.PTR ELSE
            ERR.MSG = "Unable to open ":FILE.NAME
            INT.CODE = "RGN21"
            INT.TYPE = "ONLINE"
            MON.TP = "04"
            REC.CON = "RGN21-":ERR.MSG
            DESC = "RGN21-":ERR.MSG
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*R22 Manual Conversion
        END
    END
RETURN
*------------------------------------------------------------------------
GET.MULTI.LOCAL.REF:
*-------------------
    Y.FIELDS = ''; FLD.POS = ''; Y.APPLICATION = ''
    Y.APPLICATION = 'FOREX':@FM:'FUNDS.TRANSFER':@FM:'TELLER'
    Y.FIELDS = 'L.FX.LEGAL.ID':@FM:'L.FT.LEGAL.ID':@FM:'L.TT.LEGAL.ID':@VM:'L.TT.DOC.NUM'
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELDS,FLD.POS)
    L.FX.LEGAL.ID.POS = FLD.POS<1,1>
    L.FT.LEGAL.ID.POS = FLD.POS<2,1>
    L.TT.LEGAL.ID.POS = FLD.POS<3,1>
    L.TT.DOC.NUM.POS = FLD.POS<3,2>
RETURN
*----------------------------------------------------------------------
END
