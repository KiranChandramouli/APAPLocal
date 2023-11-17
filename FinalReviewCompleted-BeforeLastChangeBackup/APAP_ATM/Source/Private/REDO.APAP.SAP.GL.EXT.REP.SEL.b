* @ValidationCode : Mjo1MDE3NDAwMjQ6Q3AxMjUyOjE2OTcwMjkzMDcxMzI6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Oct 2023 18:31:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM


SUBROUTINE REDO.APAP.SAP.GL.EXT.REP.SEL(GIT.SEL.BUILD,GIT.PGM.RECORD.LIST,NEW.ID.COMPANY,GIT.FUTURE1,GIT.FUTURE2,GIT.FUTURE3,GIT.ERR)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.SAP.GL.EXT.REP.SEL
*--------------------------------------------------------------------------------------------------------
*Description  :This routine is used to select the RE.STAT.LINE.BAL records for processing based on the extract/report selected
*Linked With  : GIT.INTERFACE.OUT id SAP.NORMAL.EXTRACT,SAP.REVAL.EXTRACT,SAP.DETAIL.REPORT
*In Parameter : GIT.SEL.BUILD,NEW.ID.COMPANY
*Out Parameter: GIT.PGM.RECORD.LIST,NEW.ID.COMPANY,GIT.FUTURE1,GIT.FUTURE2,GIT.FUTURE3,GIT.ERR
*
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 19 OCT 2010    Shiva Prasad Y        ODR-2009-12-0294 C.12         Initial Creation
* 03 JUN 2011    Pradeep S             PACS00072689                  Next day calculation avoided
*                                                                    READ changed to CACHE.READ for parameter tables
*03 AUG 2011     Prabhu N              PACS00074322                  Code modified to support C22 when no record is selected
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  SM to @SM , IF STATEMENT ADDED
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_System
    $INSERT I_F.GIT.TRANSPORT.FILE
    $INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
    $INSERT I_F.REDO.GL.W.EXTRACT.ONLINE
    $INSERT I_GIT.ONLINE.VAR
    $INSERT I_GIT.COMMON
    $INSERT I_REDO.B.SAP.VAL.COMMON
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
************
    GOSUB GET.PARAM.DETAILS

    GOSUB FORM.SELECT.CMD

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.PARAM.DETAILS:
*****************

    GIT.SEL.BUILD       = ''
    GIT.PGM.RECORD.LIST = ''
    NEW.ID.LIST         = ''

    IF R.REDO.GL.W.EXTRACT.ONLINE THEN
        Y.EXT.DATE = R.REDO.GL.W.EXTRACT.ONLINE<SAP.GL.EO.ACTION.DATE>
    END

* LOCATE GIT.COM.OUT.INT.ID IN R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.GIT.ROUTINE,1> SETTING Y.REP.POS ELSE
* RETURN
*END
*!TEST

    Y.REP.POS = System.getVariable('CURRENT.COUNT')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
        Y.REP.POS = ""
    END  ;* R22 AUTO CODE CONVERSION - END

    Y.REPORT.NAME.LIST = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.REPORT.NAME,Y.REP.POS>
    Y.EXT.CCY          = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXT.CURRENCY,Y.REP.POS>

    IF RUNNING.UNDER.BATCH THEN
        Y.SYS.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    END ELSE
        IF Y.EXT.DATE THEN
            Y.SYS.DATE = Y.EXT.DATE
        END ELSE
            Y.SYS.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
        END
    END


    GOSUB GET.SEL.DATE          ;*PACS00072689 - S/E

RETURN
*--------------------------------------------------------------------------------------------------------
*************
GET.SEL.DATE:
*************
    Y.MONTH.END.DATE = Y.SYS.DATE
    Y.NEXT.DAY = Y.SYS.DATE
    Y.REGION = ''
    Y.DAYS   = '+1C'
    CALL CDT(Y.REGION,Y.NEXT.DAY,Y.DAYS)

    CALL AWD(Y.REGION,Y.NEXT.DAY,Y.RET.VAL)
    IF Y.RET.VAL EQ 'H' THEN

        Y.DAYS = '+1W'
        CALL CDT(Y.REGION,Y.SYS.DATE,Y.DAYS)
        Y.NEXT.WK.DATE=Y.SYS.DATE
*        IF Y.NEXT.DAY[5,2] NE Y.SYS.DATE[5,2] THEN
        Y.DAYS   = '-1C'
        CALL CDT(Y.REGION,Y.SYS.DATE,Y.DAYS)
*        RETURN
*        END
        Y.RE.MONTH = Y.MONTH.END.DATE[5,2]
        Y.NE.MONTH = Y.NEXT.WK.DATE[5,2]
        IF Y.NE.MONTH GT Y.RE.MONTH THEN
            GOSUB GET.MONTH.END
        END
    END

RETURN
*--------------------------------------------------------------------------------------------------------
**************
GET.MONTH.END:
**************
    Y.ME.YEAR  = Y.MONTH.END.DATE[1,4]
    Y.ME.MONTH = Y.MONTH.END.DATE[5,2]
    Y.ME.DAY   = Y.MONTH.END.DATE[2]

    IF Y.ME.MONTH EQ '01' OR Y.ME.MONTH EQ '03' OR Y.ME.MONTH EQ '05' OR Y.ME.MONTH EQ '07' OR Y.ME.MONTH EQ '08' OR Y.ME.MONTH EQ '10' OR Y.ME.MONTH EQ '12' THEN
        Y.ME.DAY = 31
    END

    IF Y.ME.MONTH EQ '04' OR Y.ME.MONTH EQ '06' OR Y.ME.MONTH EQ '09' OR Y.ME.MONTH EQ '11' THEN
        Y.ME.DAY = 30
    END

    IF Y.ME.MONTH EQ '02' THEN
        Y.MOD = MOD(Y.ME.YEAR,4)
        IF Y.MOD EQ 0 THEN
            Y.ME.DAY = 29
        END ELSE
            Y.ME.DAY = 28
        END
    END

    Y.SYS.DATE = Y.ME.YEAR:Y.ME.MONTH:Y.ME.DAY

RETURN
*--------------------------------------------------------------------------------------------------------
***************
FORM.SELECT.CMD:
***************

    Y.REP.CNT=1
    Y.SEL.LIST=''
    Y.TOT.REP.CNT=DCOUNT(Y.REPORT.NAME.LIST,@SM)
    SEL.CMD =''
    LOOP
    WHILE Y.REP.CNT LE Y.TOT.REP.CNT

        Y.REPORT.NAME=Y.REPORT.NAME.LIST<1,1,Y.REP.CNT>
        IF Y.REP.CNT GT 1 THEN
            SEL.CMD :=' OR '
        END
        IF Y.REP.CNT EQ 1 THEN
            SEL.CMD := "SELECT ":FN.RE.STAT.LINE.BAL
        END
        BEGIN CASE
            CASE Y.EXT.CCY EQ 'ALL'
                SEL.CMD := " WITH @ID LIKE ":Y.REPORT.NAME:"...":Y.SYS.DATE:"*... AND UNLIKE ...PROFIT... AND UNLIKE ...LOCAL... "

            CASE Y.EXT.CCY EQ 'LCY'
                Y.SEL.CCY = LCCY
                SEL.CMD := " WITH @ID LIKE ":Y.REPORT.NAME:"...":Y.SEL.CCY:"...":Y.SYS.DATE:"*... AND UNLIKE ...PROFIT... AND UNLIKE ...LOCAL... "

            CASE Y.EXT.CCY EQ 'FCY'
                Y.SEL.CCY = LCCY
                SEL.CMD := " WITH @ID LIKE ":Y.REPORT.NAME:"...":Y.SYS.DATE:"*... AND UNLIKE ...":Y.SEL.CCY:"... AND UNLIKE ...PROFIT... AND UNLIKE ...LOCAL... "

        END CASE

        Y.REP.CNT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT
    SEL.CMD:=" BY @ID"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)


*PACS00074322-S
*    IF NOT(NO.OF.REC) THEN
*        FN.GIT.TRANSPORT.FILE='F.GIT.TRANSPORT.FILE'
*        F.GIT.TRANSPORT.FILE=''
*        CALL OPF(FN.GIT.TRANSPORT.FILE,F.GIT.TRANSPORT.FILE)
*        Y.TRANSPORT.FILE.ID=GIT.COM.OUT.INT.ID:'-1'
*        CALL F.READ(FN.GIT.TRANSPORT.FILE,Y.TRANSPORT.FILE.ID,R.GIT.TRANSPORT.FILE,F.GIT.TRANSPORT.FILE,ERR)
*        Y.FILE.NAME=R.GIT.TRANSPORT.FILE<GIT.TRA.FIL.OUT.FILE.NAME>
*        Y.RESP.ERR =SEL.ERR
*        INT.CODE = 'SAP002'
*        IF RUNNING.UNDER.BATCH THEN
*            INT.TYPE ='BATCH'
*        END
*        ELSE
*            INT.TYPE = 'ONLINE'
*        END
*        BAT.NO  = ''
*        BAT.TOT = ''
*        INFO.OR = ''
*        INFO.DE = ''
*        ID.PROC = 'REDO.H.GL.EXTRACT.PARAMETER'
*        MON.TP  = '04'
*        DESC    = Y.FILE.NAME :' File not generated'
*        REC.CON = Y.FILE.NAME :' File not generated'
*        EX.USER = ''
*        EX.PC   = ''
*        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*    END
*PACS00074322-e
    GIT.PGM.RECORD.LIST =  SEL.LIST

RETURN
*--------------------------------------------------------------------------------------------------------
END
