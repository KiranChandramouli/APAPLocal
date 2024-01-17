* @ValidationCode : MjotMTgwMTI1OTA2NDpDcDEyNTI6MTcwMzU2NzMwMDM5ODozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Dec 2023 10:38:20
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.COMP.SHARE.GROUP.POST
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine reads TEMP.DIR and generates a flat file
*
* Developed By          : Kalyani L K, Capgemini
*
* Development Reference : REGN3-GR02
*
* Attached To           : Batch - BNK/REDO.B.COMP.SHARE.GROUP
*
* Attached As           : Post Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#2 : NA
*
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* REGN3-GR02             Kalyani L K                     2014-02-19           Initial Draft
*                        Rashmitha M                     2014-03-19         Following is incorporated: First field
*                                                                           should contain seven characters. If the
*                                                                           number of characters is less than seven,
*                                                                           then "0" should be displayed as prefix
* Date                   who                   Reference
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND FM TO @FM AND ++ TO += 1 AND ! TO *
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                R22 Manual Conversion   Change F.READ to F.READU
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.COMP.SHARE.GROUP.COMMON
    $USING APAP.REDOCHNLS
*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para of the program, from where the execution of the code starts
**

    Y.SUC.FLAG=1
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

    IF Y.SUC.FLAG THEN
*        CALL F.WRITE(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM)
        Y.RGRC.ID='GR02':TODAY
*        CALL F.READ(FN.REDO.GR.REP.CUST,Y.RGRC.ID,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,Y.REP.ERR)
        CALL F.READU(FN.REDO.GR.REP.CUST,Y.RGRC.ID,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,Y.REP.ERR,"") ;*R22 Manual Conversion
        IF R.REDO.GR.REP.CUST THEN
            CALL F.DELETE(FN.REDO.GR.REP.CUST,Y.RGRC.ID)
        END
        Y.SEL.CMD="SSELECT ":FN.REDO.GR.REP.CUST:" WITH @ID LIKE GR02":TODAY:"..."
        CALL EB.READLIST(Y.SEL.CMD,Y.REP.LIST,'',NO.OF.REC,SEL.ERR)
        Y.REP.CNT=1
        LOOP
        WHILE Y.REP.CNT LE NO.OF.REC
*     CALL F.READ(FN.REDO.GR.REP.CUST,Y.REP.LIST<Y.REP.CNT>,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,Y.REP.ERR)
            CALL F.READU(FN.REDO.GR.REP.CUST,Y.REP.LIST<Y.REP.CNT>,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,Y.REP.ERR,"") ;*R22 Manual Conversion
            Y.REP.CUST.LIST<-1>=R.REDO.GR.REP.CUST
            CALL F.DELETE(FN.REDO.GR.REP.CUST,Y.REP.LIST<Y.REP.CNT>)
            Y.REP.CNT += 1
        REPEAT
        CALL F.WRITE(FN.REDO.GR.REP.CUST,Y.RGRC.ID,Y.REP.CUST.LIST)
    END
RETURN

*-----------------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the program, the files are opened
**
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM  = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.REDO.GR.REP.CUST='F.REDO.GR.REP.CUST'
    F.REDO.GR.REP.CUST =''
    CALL OPF(FN.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST)

RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts
**
    GOSUB GET.PARAM.VALUES

    CURR.MONTH = TODAY[5,2]
    CURR.MONTH = CURR.MONTH + 1 - 1

    LOCATE CURR.MONTH IN FIELD.GEN.VAL<1> SETTING FOUND.POS ELSE
        RETURN
    END

    GOSUB GET.REPORT.LINES

RETURN
*-----------------------------------------------------------------------------------------------------------------
*****************
GET.PARAM.VALUES:
*****************
* In this para of the program, the values from REDO.H.REPORTS.PARAM are fetched
**
    REDO.H.REPORTS.PARAM.ID = BATCH.DETAILS<3,1,1>
    GOSUB READ.REDO.H.REPORTS.PARAM

    FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    OUT.DIR   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>

    LOCATE 'REP.GEN.MONTH' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING GEN.FOUND.POS THEN
        FIELD.GEN.VAL = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,GEN.FOUND.POS>
        FIELD.GEN.VAL = RAISE(FIELD.GEN.VAL)
        FIELD.GEN.VAL = RAISE(FIELD.GEN.VAL)
    END

    CHANGE @VM TO '' IN OUT.DIR

    FINAL.OUT.FILE.NAME = FILE.NAME :'_': R.DATES(EB.DAT.LAST.WORKING.DAY) :'.csv'
    GOSUB OPEN.SEQ.FILE

RETURN
*-----------------------------------------------------------------------------------------------------------------
*****************
GET.REPORT.LINES:
*****************
* In this para of the program, the report lines are fecthed from TEMP directory
**
    OPEN TEMP.PATH TO TEMP.PTR ELSE
        INT.CODE = "REP001"
        INT.TYPE = "ONLINE"
        MON.TP   = 04
        REC.CON  = "GR02"
        DESC     = "GR02"
*      CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
    END
*20140320 (S)
    SEQ.NO = 1
*20140320 (E)
    SEL.CMD = "SELECT ":TEMP.PATH:" LIKE ":FILE.NAME:"..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

    IF NOT(SEL.LIST) THEN
        RETURN
    END

    LOOP
        REMOVE REC.ID FROM SEL.LIST SETTING REC.POS
    WHILE REC.ID : REC.POS
*20140320 (S)
        R.TEMP.PATH=''; ERR.MSG=''
*        CALL F.READ(TEMP.PATH,REC.ID,R.TEMP.PATH,TEMP.PTR,ERR.MSG)
        CALL F.READU(TEMP.PATH,REC.ID,R.TEMP.PATH,TEMP.PTR,ERR.MSG,"")
        IF ERR.MSG NE '' THEN
*20140320 (E)
            INT.CODE = "REP001"
            INT.TYPE = "ONLINE"
            MON.TP   = 04
            REC.CON  = "GR02"
            DESC     = "GR02"
*           CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
        END

        REPORT.LINES = R.TEMP.PATH
*20140320 (S)
        CALL F.DELETE(TEMP.PATH,REC.ID)
        GOSUB APPEND.SEQ.NUM
*20140320 (E)

    REPEAT

RETURN
*-----------------------------------------------------------------------------------------------------------------
***************
APPEND.SEQ.NUM:
***************
* In this para of the program, the sequence number is added to thereport lines
**

    LOOP
        REMOVE REPORT.LINE FROM REPORT.LINES SETTING REP.POS
    WHILE REPORT.LINE : REP.POS
*20140320 (S)
        SEQ.NO = FMT(SEQ.NO,"R%7")
*20140320 (E)
        IF FINAL.ARRAY THEN
            FINAL.ARRAY = FINAL.ARRAY :@FM: SEQ.NO:REPORT.LINE
        END ELSE
            FINAL.ARRAY = SEQ.NO:REPORT.LINE
        END

        SEQ.NO += 1
    REPEAT

    IF FINAL.ARRAY THEN
        GOSUB WRITE.TO.FILE
        FINAL.ARRAY=''
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************************
READ.REDO.H.REPORTS.PARAM:
**************************
* In this para of the program, file REDO.H.REPORTS.PARAM is read
**
    R.REDO.H.REPORTS.PARAM  = ''
    REDO.H.REPORTS.PARAM.ER = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ER)

*    LOCATE 'LAST.GEN.DATE' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING LST.GEN.POS THEN
*        R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,LST.GEN.POS>=TODAY
*    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************
OPEN.SEQ.FILE:
**************
* In this para of the program, the out file is opened
**
    OPENSEQ OUT.DIR, FINAL.OUT.FILE.NAME TO OUT.PTR ELSE
        CREATE OUT.PTR ELSE
            Y.SUC.FLAG=''
            INT.CODE = "REP001"
            INT.TYPE = "ONLINE"
            MON.TP   = 04
            REC.CON  = "GR02"
            DESC     = "GR02"
*          CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)     ;*R22 Manual Code Conversion
        END
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************
WRITE.TO.FILE:
**************
* In this para of the program, the final array is written to the file
**
    CHANGE @FM TO CHARX(13):CHARX(10) IN FINAL.ARRAY

    WRITESEQ FINAL.ARRAY APPEND TO OUT.PTR ELSE
        Y.SUC.FLAG=''
        INT.CODE = "REP001"
        INT.TYPE = "ONLINE"
        MON.TP   = 04
        REC.CON  = "GR02"
        DESC     = "GR02"
*       CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
