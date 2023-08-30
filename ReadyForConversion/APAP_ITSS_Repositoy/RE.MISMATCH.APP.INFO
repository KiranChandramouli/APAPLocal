*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE RE.MISMATCH.APP.INFO(YID)
*
*-----------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_BATCH.FILES
    $INSERT I_F.RE.STAT.LINE.CONT
    $INSERT I_F.RE.STAT.MISMATCH
    $INSERT I_F.RE.STAT.REPORT.HEAD
    $INSERT I_DAS.RE.STAT.LINE.CONT
    $INSERT I_RE.MISMATCH.APP.INFO.COMMON

*-----------------------------------------------------------------------

    Y.REPORT = CONTROL.LIST<1,1>
    IF PREV.REPORT.NAME NE Y.REPORT THEN
        LOCATE Y.REPORT IN LOC.REPORT.NAMES<1,1> SETTING REP.POS THEN
            CURR.STAT.HEAD.REC = LOC.REPORT.RECS(REP.POS)
            Y1.REC = LOC.REPORT.RECS(REP.POS)
            GOSUB SET.PROC.DATE
            PREV.REPORT.NAME = Y.REPORT
        END
    END ELSE
        Y1.REC = CURR.STAT.HEAD.REC
    END

    GOSUB INITIALISE

    IF NOT(CONS.ERR) THEN
        GOSUB PROCESS.APP.RECORDS
    END

    RETURN

*----------------------------------------------------------------------------
SET.PROC.DATE:
*-------------

    MONTH.END.FLAG = 0
    YPROC.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YNEXT.RUN.DATE = TODAY

    IF RUNNING.UNDER.BATCH THEN

        IF Y1.REC<RE.SRH.MAT.TO.MONTH.END> EQ 'Y' THEN
            YPROC.DATE = R.DATES(EB.DAT.PERIOD.END)
            IF YPROC.DATE[5,2] NE R.DATES(EB.DAT.NEXT.WORKING.DAY)[5,2] THEN
                MONTH.END.FLAG = 1
            END
        END ELSE
            YPROC.DATE = TODAY
        END
        YNEXT.RUN.DATE = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    END ELSE
        IF Y1.REC<RE.SRH.MAT.TO.MONTH.END> EQ 'Y' THEN
            IF R.DATES(EB.DAT.LAST.WORKING.DAY)[5,2] NE TODAY[5,2] THEN
                MONTH.END.FLAG = 1
                YYR = R.DATES(EB.DAT.LAST.WORKING.DAY)[1,4]
                YMM = R.DATES(EB.DAT.LAST.WORKING.DAY)[5,2]
                GOSUB LAST.MONTH.DAY
                YPROC.DATE = YYR:YMM:YLAST.DAY
            END ELSE
                YPROC.DATE = TODAY
                CALL CDT("",YPROC.DATE,"-1C")
            END
        END ELSE
            YPROC.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
        END
    END

    IF Y1.REC<RE.SRH.MAT.INCLUSIVE> NE 'Y' THEN
        CALL CDT("",YPROC.DATE,"-1C")
    END

    RETURN

*-----------------------------------------------------------------------
INITIALISE:
*----------

    CONS.ERR = 0
    LINE.CONT = YID['*',1,1]
    YASSET.KEY = YID['*',2,1]
    ASSET.TYPE = YID['*',3,1]
    CONTRACT.ID = YID['*',4,1]

    READ Y7.REC FROM F.RE.STAT.LINE.CONT, LINE.CONT ELSE
        CONS.ERR = 1
    END

    RETURN

*-----------------------------------------------------------------------
PROCESS.APP.RECORDS:
*-------------------
*
*    APP.KEYS = ""

*    CALL RE.EXTRACT.APP.KEYS(YASSET.KEY, Y.CURR.TYPE, APP.KEYS)

    Y.BAL = 0
    ASSET.CNT = DCOUNT(ASSET.TYPE,'-')
*    LOOP
*        REMOVE CONTRACT.ID FROM APP.KEYS SETTING YD
*    WHILE CONTRACT.ID
    FOR I=1 TO ASSET.CNT
        Y.BAL = 0
        Y.CURR.TYPE = ASSET.TYPE['-',I,1]

        YCON.KEY = YASSET.KEY:".":Y.CURR.TYPE
        YWIDTH = 50
        YLEN = LEN(YCON.KEY)
        Y.EXT.INDIC = ""
        IF YLEN > YWIDTH THEN
            YPRINT.KEY = YCON.KEY[1,YWIDTH]
            Y.EXT.INDIC = 1
        END ELSE
            YPRINT.KEY = FMT(YCON.KEY,YWIDTH:"L")
        END

        LOCATE YASSET.KEY IN Y7.REC<RE.SLC.ASST.CONSOL.KEY, 1> SETTING CONS.KEY.POS THEN
            LOCATE Y.CURR.TYPE IN Y7.REC<RE.SLC.ASSET.TYPE, CONS.KEY.POS, 1> SETTING CONS.KEY.ASST.POS THEN
                YP.MISMATCH = ''
                YMATURITY.DATE.RANGE = Y7.REC<RE.SLC.MAT.RANGE,CONS.KEY.POS,CONS.KEY.ASST.POS>
                IF YMATURITY.DATE.RANGE THEN
                    GOSUB BUILD.MATURITY.DATE.RANGES:
                END ELSE
                    YSTART.MAT.DATE.RANGE = ""
                    YEND.MAT.DATE.RANGE = ""
                END
                CALL RE.EXTRACT.APP.INFO(CONTRACT.ID,Y.CURR.TYPE,YASSET.KEY,Y.BAL,'',YSTART.MAT.DATE.RANGE,YEND.MAT.DATE.RANGE,'','',YERROR)

                MIS.CONT.ID = YASSET.KEY:'.':Y.CURR.TYPE
                READU R.MIS.CONT FROM F.MISMATCH.CONT.FILE, MIS.CONT.ID ELSE R.MIS.CONT<1> = 0
                Y.BAL = Y.BAL<1>        ;* Y.BAL<2> - For local balance
                IF YERROR THEN
                    IF YKEY.TOPRINT THEN
                        YKEY.TOPRINT = ""
                        YP.DATA.LINE = SPACE(3):YPRINT.KEY
                        YP.SPACE.BEFORE = "1"
                        YP.SPACE.AFTER = ""
                        GOSUB CHECK.PRINT.LINE:
                        YP.MISMATCH <-1>= YP.DATA.LINE
                        IF Y.EXT.INDIC THEN
                            YX.KEY = YCON.KEY[YWIDTH+1,YLEN-YWIDTH]
                            YX.LEN = LEN(YX.KEY)
                            YP.DATA.LINE = SPACE(03):FMT(YX.KEY,YX.LEN:"L")
                            YP.SPACE.BEFORE = ""
                            YP.SPACE.AFTER = ""
                            GOSUB CHECK.PRINT.LINE:
                            YP.MISMATCH<-1>= YP.DATA.LINE
                        END
                    END
                    YERROR = ""
                    YP.DATA.LINE = SPACE(6):CONTRACT.ID:SPACE(6):"MISSING IN BASE FILE"
                    YP.SPACE.BEFORE = ""
                    YP.SPACE.AFTER = ""
                    GOSUB CHECK.PRINT.LINE
                    YP.MISMATCH<-1> = YP.DATA.LINE
                    R.MIS.CONT<-1> = YP.MISMATCH
                END ELSE

*                   CALL F.READU(FN.MISMATCH.CONTRACT.FILE, MIS.CONT.ID, R.MIS.CONT, F.MISMATCH.CONT.FILE, Y.ERR, '')
                    Y.TOT.BAL = R.MIS.CONT<1>
                    Y.TOT.BAL += Y.BAL
                    R.MIS.CONT<1> = Y.TOT.BAL
                END
                CALL F.WRITE(FN.MISMATCH.CONT.FILE, MIS.CONT.ID, R.MIS.CONT)
            END
        END

    NEXT I
*    REPEAT

    RETURN
*

*-----------------------------------------------------------------------
BUILD.MATURITY.DATE.RANGES:
*--------------------------
*
*     derives the start and end dates for the date range specified
*     range can be in the format nnnS\nnnE where,
*     nnnS can be null,nnnD(days),nnnM(months),nnnY(years)
*     nnnE can be nnnD(days),nnnM(months),nnnY(years)
*
    YREF.DATE = YPROC.DATE
    YSTART.MAT.DATE.RANGE = ""
    YEND.MAT.DATE.RANGE = ""
    YSTART.RANGE.SPEC = FIELD(YMATURITY.DATE.RANGE,'\',1)
    YEND.RANGE.SPEC = FIELD(YMATURITY.DATE.RANGE,'\',2)

    FOR YD.NO = 1 TO 2
        IF YD.NO = 1 THEN
            YCHECK.RANGE = YSTART.RANGE.SPEC
        END ELSE
            YCHECK.RANGE = YEND.RANGE.SPEC
        END
        YEND.DATE = ""
        BEGIN CASE

        CASE YCHECK.RANGE MATCHES "0N'D'"
            YDAYS = MATCHFIELD(YCHECK.RANGE,"0N'D'",1)
            GOSUB GET.DATE.ADDING.DAYS

        CASE YCHECK.RANGE MATCHES "0N'M'"
            YMONTHS = MATCHFIELD(YCHECK.RANGE,"0N'M'",1)
            GOSUB GET.DATE.ADDING.MONTHS

        CASE YCHECK.RANGE MATCHES "0N'Y'"
            YYEARS = MATCHFIELD(YCHECK.RANGE,"0N'Y'",1)
            GOSUB GET.DATE.ADDING.YEARS

        CASE YCHECK.RANGE = "1B"
            YEND.DATE = YNEXT.RUN.DATE

        CASE YCHECK.RANGE = ""
            YEND.DATE = 0

        CASE YCHECK.RANGE = "REST"
            YEND.DATE = YCHECK.RANGE

        END CASE

        IF YD.NO = 1 THEN
            YSTART.MAT.DATE.RANGE = YEND.DATE
        END ELSE
            YEND.MAT.DATE.RANGE = YEND.DATE
        END
    NEXT YD.NO
*
    RETURN
*
*-----------------------------------------------------------------------
GET.DATE.ADDING.DAYS:
*--------------------
*
    YSYS.DATE = ""
    YSYS.DATE = YREF.DATE[7,2]:"/":YREF.DATE[5,2]:"/":YREF.DATE[1,4]
    YSYS.DATE = ICONV(YSYS.DATE,"D4/E")

*---- To arrive at end date

    YSYS.DATE = YSYS.DATE + YDAYS
    YEND.DATE = ""
    YEND.DATE = OCONV(YSYS.DATE,"D4/E")
    YEND.DATE = YEND.DATE[7,4]:YEND.DATE[4,2]:YEND.DATE[1,2]
*
    RETURN
*
*-----------------------------------------------------------------------
GET.DATE.ADDING.MONTHS:
*----------------------
*
    YEND.DATE = YREF.DATE
    YYR = YEND.DATE[1,4]
    YMM = YEND.DATE[5,2]
    YDD = YEND.DATE[7,2]
    YMM = YMM + YMONTHS
    IF YMM > 12 THEN
        YYY = INT(YMM/12)
        YMM = YMM - YYY * 12
        IF YMM = 0 THEN
            YMM = 12
            YYY = YYY - 1
        END
        YYR = YYR + YYY
    END

    GOSUB LAST.MONTH.DAY
    IF MONTH.END.FLAG THEN
        YDD = YLAST.DAY
        IF Y1.REC<RE.SRH.MAT.INCLUSIVE> NE "Y" THEN
            YDD -= 1
        END
    END ELSE
        IF YDD > YLAST.DAY THEN
            YDD = YLAST.DAY
        END
    END
    IF LEN(YMM) = 1 THEN
        YMM = "0":YMM
    END
    YEND.DATE = YYR:YMM:YDD
*
    RETURN
*
*-----------------------------------------------------------------------
GET.DATE.ADDING.YEARS:
*---------------------
*
    YYR = YREF.DATE[1,4]
    YYR = YYR + YYEARS
    YEND.DATE = YYR:YREF.DATE[5,4]
*
    RETURN
*
*-----------------------------------------------------------------------
LAST.MONTH.DAY:
***************
*     YMM  and YYR are set to month and year respectively

    IF LEN(YMM) = 1 THEN
        YMM = "0":YMM
    END

    IF YMM = 2 OR YMM = "02" THEN
        IF MOD(YYR,4) = 0 THEN
            YLAST.DAY = "29"
        END ELSE
            YLAST.DAY = "28"
        END
    END ELSE
        IF INDEX("04 06 09 11",YMM,1) > 0 THEN
            YLAST.DAY = "30"
        END ELSE
            YLAST.DAY = "31"
        END
    END
*
    RETURN
*
*-----------------------------------------------------------------------
CHECK.PRINT.LINE:
*----------------
*
*---- Check page end conditions

    IF YP.SPACE.BEFORE > 0 THEN
        FOR YPI = 1 TO YP.SPACE.BEFORE
            YP.DATA.LINE = '!':YP.DATA.LINE
        NEXT
    END

    IF YP.SPACE.AFTER > 0 THEN
        FOR YPI = 1 TO YP.SPACE.AFTER
            YP.DATA.LINE := '!'
        NEXT
    END
*
    RETURN
*
*-----------------------------------------------------------------------

END
