* @ValidationCode : Mjo5MTc2ODEwOTE6Q3AxMjUyOjE2OTI2MDQzMDc0NDY6dmljdG86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Aug 2023 13:21:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TESTAPAP
*-----------------------------------------------------------------------------
* <Rating>1120</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*21-08-2023    VICTORIA S          R22 MANUAL CONVERSION   VM TO @VM,SM TO @SM
*----------------------------------------------------------------------------------------
SUBROUTINE RE.MISMATCH.CONS.RUN(LINE.NO)
*
*********************************************************************
*
*---- Common INSERT routines

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LIMIT
    $INSERT I_F.DATES
    $INSERT I_F.COMPANY
    $INSERT I_BATCH.FILES
    $INSERT I_F.RE.STAT.MISMATCH
    $INSERT I_F.RE.STAT.LINE.CONT
    $INSERT I_F.RE.STAT.REPORT.HEAD
    $INSERT I_DAS.RE.STAT.LINE.CONT
    $INSERT I_RE.MISMATCH.CONS.RUN.COMMON
    $INSERT I_F.CONSOLIDATE.ASST.LIAB
*
*----------------------------------------------------------------------------
*

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
*    READ Y1.REC FROM F.RE.STAT.REPORT.HEAD, Y.REPORT THEN

    GOSUB INITIALISE

    GOSUB MAIN.PARA
*    END
*
RETURN
*
*----------------------------------------------------------------------------
SET.PROC.DATE:
**************

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

    IF Y1.REC<RE.SRH.SPLIT> = "ALL" OR Y1.REC<RE.SRH.SPLIT> = "TOTAL.FOREIGN" THEN
        Y.RPT.CCY = ""
    END ELSE
        Y.RPT.CCY = LCCY
    END

    GOSUB GET.CCY.DECIMALS

RETURN

*----------------------------------------------------------------------------
INITIALISE:
***********
*
    YP.MISMATCH = ''
    YERROR = ''

    Y.DECIMAL.ARRAY = ''
    CONSOL.MISMATCHES.REC = ""
*
    Y.FOREIGN.CURRENCIES = ""
    YCON.KEY = ""
    Y.FIRST.RUN = 1
*
RETURN
*
*----------------------------------------------------------------------------
MAIN.PARA:
**********
*

    Y.TOT.REP.LINE.BAL = 0
    Y.TOT.BAL = 0
*    YKEY = Y.REPORT:".":LINE.NO
*    IF C$MULTI.BOOK THEN
*        YKEY:= '.':ID.COMPANY
*    END
*    YKEY = LINE.NO
    YKEY = LINE.NO['*',1,1]
    READ Y7.REC FROM F.RE.STAT.LINE.CONT, YKEY THEN

        IF Y7.REC<RE.SLC.TYPE> = "HEADING" THEN

*---- check if report split is BY.FOREIGN and if its first run then skip
*     printing of report lines as Y.RPT.CCY is set to LCCY for building
*     an array of foreign currencies

            YPRINT.LINES = 1
            IF Y.FIRST.RUN THEN
                IF Y1.REC<RE.SRH.SPLIT> = "BY.FOREIGN" THEN
                    YPRINT.LINES = 0
                END
            END

            IF YPRINT.LINES THEN
                GOSUB FORMAT.LINE.NARRATIVE
                YP.SPACE.BEFORE = 1
                YP.SPACE.AFTER = ""
                YP.DATA.LINE = Y.NARRATIVE

                GOSUB CHECK.PRINT.LINE

                YP.MISMATCH<-1> = YP.DATA.LINE
            END

        END ELSE
            IF Y7.REC<RE.SLC.TYPE> <> "TOTAL" THEN
                YPRINT.LINES = 1
                IF Y.FIRST.RUN THEN
                    IF Y1.REC<RE.SRH.SPLIT> = "BY.FOREIGN" THEN
                        YPRINT.LINES = 0
                    END
                END

                IF YPRINT.LINES THEN
                    GOSUB FORMAT.LINE.NARRATIVE
                    YP.SPACE.BEFORE = 1
                    YP.SPACE.AFTER = ""
                    YP.DATA.LINE = Y.NARRATIVE
                    GOSUB CHECK.PRINT.LINE
                    YP.MISMATCH<-1> = YP.DATA.LINE
                END

                GOSUB ACCUM.DETAIL.LINE

                IF YERROR THEN
                    RETURN
                END

            END
        END
        IF YERROR THEN
            RETURN
        END

    END
	READU DUMMY.REC FROM F.RE.MISMATCH.RUN, YKEY ELSE DUMMY.REC = ''
	DUMMY.REC<-1> = YP.MISMATCH
    WRITE YP.MISMATCH TO F.RE.MISMATCH.RUN, YKEY ON ERROR  CRT 'Unable to Write ':YKEY
*
RETURN
*
*-----------------------------------------------------------------------
ACCUM.DETAIL.LINE:
******************
*
*    YTEMP = Y7.REC<RE.SLC.ASST.CONSOL.KEY>
    YTEMP = LINE.NO['*',2,1]
*    Y.ASSET.COUNTS = COUNT(YTEMP,VM) + (YTEMP # '')
    Y.CHECK = Y1.REC<RE.SRH.SPLIT>

*---- Temporary variable defined to carry the SPLIT value as it will be used often

    LOCATE YTEMP IN Y7.REC<RE.SLC.ASST.CONSOL.KEY,1> SETTING YI THEN
*    FOR YI = 1 TO Y.ASSET.COUNTS
*        YCON.KEY = Y7.REC<RE.SLC.ASST.CONSOL.KEY,YI>
        YCON.KEY = YTEMP
        Y.CURR.CCY = FIELD(YCON.KEY,".",4)

*---- Processing depends on SPLIT and CURRENCY

        BEGIN CASE
            CASE Y.CHECK = "ALL"
                GOSUB PROCESS.ASSET.RECORDS

            CASE Y.CHECK = "LOCAL"
                IF Y.CURR.CCY = LCCY THEN
                    GOSUB PROCESS.ASSET.RECORDS
                END

            CASE Y.CHECK = "CURRENCY"
                IF Y.FIRST.RUN THEN
                    IF Y.CURR.CCY = LCCY THEN
                        GOSUB PROCESS.ASSET.RECORDS
                    END ELSE
                        LOCATE Y.CURR.CCY IN Y.FOREIGN.CURRENCIES<1> BY "AL" SETTING X ELSE
                            INS Y.CURR.CCY BEFORE Y.FOREIGN.CURRENCIES<X>
                        END
                    END
                END ELSE
                    IF Y.CURR.CCY = Y.RPT.CCY THEN
                        GOSUB PROCESS.ASSET.RECORDS
                    END
                END

            CASE Y.CHECK = "TOTAL.FOREIGN"
                IF Y.CURR.CCY <> LCCY THEN
                    GOSUB PROCESS.ASSET.RECORDS
                END

            CASE Y.CHECK = "BY.FOREIGN"
                IF Y.FIRST.RUN THEN
                    IF Y.CURR.CCY <> LCCY THEN
                        LOCATE Y.CURR.CCY IN Y.FOREIGN.CURRENCIES<1> BY "AL" SETTING X ELSE
                            INS Y.CURR.CCY BEFORE Y.FOREIGN.CURRENCIES<X>
                        END
                    END
                END ELSE
                    IF Y.CURR.CCY = Y.RPT.CCY THEN
                        GOSUB PROCESS.ASSET.RECORDS
                    END
                END

        END CASE

        IF YERROR THEN
            RETURN
        END

*    NEXT
    END
*
RETURN
*
*-----------------------------------------------------------------------
PROCESS.ASSET.RECORDS:
**********************
*
    YASSET.KEY = Y7.REC<RE.SLC.ASST.CONSOL.KEY,YI>
    YTEMP = Y7.REC<RE.SLC.ASSET.TYPE,YI>
    Y.COUNT.AS = COUNT(YTEMP,@SM) + (YTEMP # '') ;*R22 MANUAL CONVERSION
    Y.APPLICATION = FIELD(YASSET.KEY,'.',1)
    FOR Y.TYPE.NO = 1 TO Y.COUNT.AS
        Y.CURR.TYPE = Y7.REC<RE.SLC.ASSET.TYPE,YI,Y.TYPE.NO>
        YMATURITY.DATE.RANGE = Y7.REC<RE.SLC.MAT.RANGE,YI,Y.TYPE.NO>

        IF YMATURITY.DATE.RANGE THEN
            GOSUB BUILD.MATURITY.DATE.RANGES:
        END ELSE
            YSTART.MAT.DATE.RANGE = ""
            YEND.MAT.DATE.RANGE = ""
        END

        GOSUB CONSOL.KEY.PRINT:
        IF ERROR.MESSAGE THEN
            CONTINUE
        END
*
        IF YERROR THEN
            RETURN
        END

        GOSUB PROCESS.APP.RECORDS
        IF YERROR THEN
            RETURN
        END
*
        Y.TOT.BAL = Y.TOT.BAL + 0
        Y.BALANCE.FILE = Y.BALANCE.FILE + 0
        IF Y.TOT.BAL <> Y.BALANCE.FILE THEN
            Y.FMT.BAL = FMT(OCONV(ICONV(Y.TOT.BAL,"MD":Y.KEY.CCY.DECIMALS),"MD":Y.KEY.CCY.DECIMALS:","),"18R")
            YR.DIFFERENCE = Y.TOT.BAL - Y.BALANCE.FILE
            Y.FMT.BAL.FILE = FMT(OCONV(ICONV(Y.BALANCE.FILE,"MD":Y.KEY.CCY.DECIMALS),"MD":Y.KEY.CCY.DECIMALS:","),"18R")
            Y.FMT.DIFF = FMT(OCONV(ICONV(YR.DIFFERENCE,"MD":Y.KEY.CCY.DECIMALS),"MD":Y.KEY.CCY.DECIMALS:","),"18R")
            YP.DATA.LINE = SPACE(03):YPRINT.KEY:SPACE(02):Y.FMT.BAL:SPACE(02):Y.FMT.BAL.FILE:SPACE(02):Y.FMT.DIFF
            YP.SPACE.BEFORE = "1"
            YP.SPACE.AFTER = ""

            GOSUB CHECK.PRINT.LINE:
            YP.MISMATCH<-1>= YP.DATA.LINE
            CONSOL.MISMATCHES.REC<1> = YCON.KEY
            CONSOL.MISMATCHES.REC<2> = Y.TOT.BAL
            CONSOL.MISMATCHES.REC<3> = Y.BALANCE.FILE
            CONSOL.MISMATCHES.REC<4> = YR.DIFFERENCE
            CONSOL.MISMATCHES.REC<5> = YKEY

*            READU YCONSKEY.VAL FROM F.CONSOL.KEY, YCON.KEY THEN
*                MYLIST.ID = BATCH.THREAD.KEY[' ',2,1]
*                CRT YKEY:'|':YCON.KEY:'|':MYLIST.ID:'|':LINE.NO
*                CRT 'BLACK SHEEP - MAAAAAAAH ... DUPLICATE GOING TO BE UPDATED IN CONSOL.MISMATCHES'
*            END ELSE
*                CRT YKEY:'|':YCON.KEY:'|':MYLIST.ID:'|':LINE.NO
*                WRITE YKEY TO F.CONSOL.KEY, YCON.KEY ON ERROR CRT 'U T W ':YCON.KEY
*            END
*
* Add company code to key to CONSOL.MISMATCH
*
            MISMTCH.KEY = ""
            LOC.ID.COMPANY = LINE.NO['.',3,1]['*',1,1]
            IF C$MULTI.BOOK THEN
                LOCATE LOC.ID.COMPANY IN CONSOL.MISMATCHES.KEYS<1,1> SETTING COMP.POS THEN
                    CONSOL.MISMATCHES.KEY = CONSOL.MISMATCHES.KEYS<2,COMP.POS>
                END ELSE
                    CONSOL.MISMATCHES.KEYS<1,COMP.POS> = LOC.ID.COMPANY
                    CONSOL.MISMATCHES.KEYS<2,COMP.POS> = 1
                    CONSOL.MISMATCHES.KEY = 1
                END

*                MISMTCH.KEY = SESSION.NO:'.':CONSOL.MISMATCHES.KEY:'.':ID.COMPANY
                MISMTCH.KEY = SESSION.NO:'.':CONSOL.MISMATCHES.KEY:'.':LOC.ID.COMPANY
            END ELSE
                IF NOT(CONSOL.MISMATCHES.KEYS) THEN
                    CONSOL.MISMATCHES.KEYS = 1
                    CONSOL.MISMATCHES.KEY = 1
                END ELSE
                    CONSOL.MISMATCHES.KEY = CONSOL.MISMATCHES.KEYS
                END
                MISMTCH.KEY = SESSION.NO:'.':CONSOL.MISMATCHES.KEY
            END
*
            WRITE CONSOL.MISMATCHES.REC TO F.CONSOL.MISMATCHES, MISMTCH.KEY

            CONSOL.MISMATCHES.KEY += 1
            IF C$MULTI.BOOK THEN
                CONSOL.MISMATCHES.KEYS<2,COMP.POS> = CONSOL.MISMATCHES.KEY
            END ELSE
                CONSOL.MISMATCHES.KEYS = CONSOL.MISMATCHES.KEY
            END
            IF Y.EXT.INDIC THEN
                YX.KEY = YCON.KEY[YWIDTH+1,YLEN-YWIDTH]
                YX.LEN = LEN(YX.KEY)
                YP.DATA.LINE = SPACE(03):FMT(YX.KEY,YX.LEN:"L")
                YP.SPACE.BEFORE = ""
                YP.SPACE.AFTER = ""
                GOSUB CHECK.PRINT.LINE:
                YP.MISMATCH <-1>= YP.DATA.LINE
            END
        END

        Y.TOT.BAL = 0
    NEXT Y.TYPE.NO
*
RETURN
*
*-----------------------------------------------------------------------
CONSOL.KEY.PRINT:
*****************
*
*---- Consolidation key & Balances printed here

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
    YKEY.TOPRINT = "Y"
    ERROR.MESSAGE = ''

    READ Y.CAL.REC FROM F.CONSOLIDATE.ASST.LIAB , YASSET.KEY ELSE
*
        ERROR.KEY = YASSET.KEY
        ERROR.MESSAGE = YASSET.KEY:" MISSING IN CRF FILE"
        GOSUB ERROR.9999
        RETURN
    END

    LOCATE Y.CURR.TYPE IN Y.CAL.REC<RE.ASL.TYPE,1> SETTING Y.TYPE.POS ELSE
        NULL
    END

    IF YMATURITY.DATE.RANGE THEN
        GOSUB GET.MATURITY.BALANCES:
    END ELSE
        Y.CCY.BAL = Y.CAL.REC<RE.ASL.BALANCE,Y.TYPE.POS> + Y.CAL.REC<RE.ASL.CREDIT.MOVEMENT,Y.TYPE.POS> + Y.CAL.REC<RE.ASL.DEBIT.MOVEMENT,Y.TYPE.POS>
        Y.LOCAL.BAL = Y.CAL.REC<RE.ASL.LOCAL.BALANCE,Y.TYPE.POS> + Y.CAL.REC<RE.ASL.LOCAL.CREDT.MVE,Y.TYPE.POS> + Y.CAL.REC<RE.ASL.LOCAL.DEBIT.MVE,Y.TYPE.POS>
    END

    Y.BALANCE.FILE = Y.CCY.BAL
    Y.BAL.FILE.LOCAL = Y.LOCAL.BAL

    IF Y.BALANCE.FILE = "" THEN
        Y.BALANCE.FILE = 0
    END
*
    Y.CCY.IN.KEY = FIELD(YASSET.KEY,".",4)
    GOSUB GET.KEY.CCY.DECIMALS
*
RETURN
*
*-----------------------------------------------------------------------
GET.MATURITY.BALANCES:
**********************
*
* checks whether the maturity date is within the range spec if so adds
* to the balance
*------------------------------------------------------------------------
*
    Y.CCY.BAL = ""
    Y.LOCAL.BAL = ""
    IF Y.CAL.REC<RE.ASL.SCHD.AMOUNT,Y.TYPE.POS> = "" THEN
        IF YMATURITY.DATE.RANGE[1,1] = '\' THEN
            Y.CCY.BAL = Y.CAL.REC<RE.ASL.BALANCE,Y.TYPE.POS> + Y.CAL.REC<RE.ASL.CREDIT.MOVEMENT,Y.TYPE.POS> + Y.CAL.REC<RE.ASL.DEBIT.MOVEMENT,Y.TYPE.POS>
            Y.LOCAL.BAL = Y.CAL.REC<RE.ASL.LOCAL.BALANCE,Y.TYPE.POS> + Y.CAL.REC<RE.ASL.LOCAL.CREDT.MVE,Y.TYPE.POS> + Y.CAL.REC<RE.ASL.LOCAL.DEBIT.MVE,Y.TYPE.POS>
        END
        RETURN
    END
    YNO.OF.SCHD.AMOUNTS = COUNT(Y.CAL.REC<RE.ASL.SCHD.AMOUNT,Y.TYPE.POS>,@SM) + 1 ;*R22 MANUAL CONVERSION
    FOR YAMT.NO = 1 TO YNO.OF.SCHD.AMOUNTS
        YSCHD.MAT.DATE = Y.CAL.REC<RE.ASL.MAT.DATE,Y.TYPE.POS,YAMT.NO>
        IF YSCHD.MAT.DATE <> '' THEN
            IF YSCHD.MAT.DATE = 0 THEN
* call type contracts
                YSCHD.MAT.DATE = YPROC.DATE
            END ELSE
                IF LEN(YSCHD.MAT.DATE) < 4 THEN
* notice type contracts
                    YREF.DATE = YNEXT.RUN.DATE
                    YDAYS = YSCHD.MAT.DATE
                    GOSUB GET.DATE.ADDING.DAYS
                    YSCHD.MAT.DATE = YEND.DATE
                END
            END
        END
*
* check whether schd.date falls in the maturity range specified for the
* line
*
        IF YSCHD.MAT.DATE > YSTART.MAT.DATE.RANGE THEN
            IF YEND.MAT.DATE.RANGE = "REST" OR YSCHD.MAT.DATE <= YEND.MAT.DATE.RANGE THEN
                Y.LOCAL.BAL = Y.LOCAL.BAL + Y.CAL.REC<RE.ASL.SCHD.LCL.AMT,Y.TYPE.POS,YAMT.NO>
                Y.CCY.BAL = Y.CCY.BAL + Y.CAL.REC<RE.ASL.SCHD.AMOUNT,Y.TYPE.POS,YAMT.NO>
            END
        END
*
    NEXT YAMT.NO
*
RETURN
*
*------------------------------------------------------------------------
GET.KEY.CCY.DECIMALS:
*********************
*
    Y.KEY.CCY.DECIMALS = ""
    LOCATE Y.CCY.IN.KEY IN Y.DECIMAL.ARRAY<1,1> SETTING YPOS
    ELSE
        Y.TEMP.DECIMALS = "NO.OF.DECIMALS"
        CALL UPD.CCY(Y.CCY.IN.KEY,Y.TEMP.DECIMALS)
        INS Y.CCY.IN.KEY BEFORE Y.DECIMAL.ARRAY<1,YPOS>
        INS Y.TEMP.DECIMALS BEFORE Y.DECIMAL.ARRAY<2,YPOS>
    END
    Y.KEY.CCY.DECIMALS = Y.DECIMAL.ARRAY<2,YPOS>
*
RETURN
*
*-----------------------------------------------------------------------
PROCESS.APP.RECORDS:
********************
*
*    APP.KEYS = ""
*
*    CALL RE.EXTRACT.APP.KEYS(YASSET.KEY, Y.CURR.TYPE, APP.KEYS)
*
*    Y.BAL = 0
*    LOOP
*        REMOVE CONTRACT.ID FROM APP.KEYS SETTING YD
*    WHILE CONTRACT.ID
*
*        CALL RE.EXTRACT.APP.INFO(CONTRACT.ID,Y.CURR.TYPE,YASSET.KEY,Y.BAL,'',YSTART.MAT.DATE.RANGE,YEND.MAT.DATE.RANGE,'','',YERROR)
*
*        Y.BAL = Y.BAL<1>      ;* Y.BAL<2> - For local balance
*        IF YERROR THEN
*            IF YKEY.TOPRINT THEN
*                YKEY.TOPRINT = ""
*                YP.DATA.LINE = SPACE(3):YPRINT.KEY
*                YP.SPACE.BEFORE = "1"
*                YP.SPACE.AFTER = ""
*                GOSUB CHECK.PRINT.LINE:
*                YP.MISMATCH <-1>= YP.DATA.LINE
*                IF Y.EXT.INDIC THEN
*                    YX.KEY = YCON.KEY[YWIDTH+1,YLEN-YWIDTH]
*                    YX.LEN = LEN(YX.KEY)
*                    YP.DATA.LINE = SPACE(03):FMT(YX.KEY,YX.LEN:"L")
*                    YP.SPACE.BEFORE = ""
*                    YP.SPACE.AFTER = ""
*                    GOSUB CHECK.PRINT.LINE:
*                    YP.MISMATCH<-1>= YP.DATA.LINE
*                END
*            END
*            YERROR = ""
*            YP.DATA.LINE = SPACE(6):CONTRACT.ID:SPACE(6):"MISSING IN BASE FILE"
*            YP.SPACE.BEFORE = ""
*            YP.SPACE.AFTER = ""
*            GOSUB CHECK.PRINT.LINE
*            YP.MISMATCH<-1> = YP.DATA.LINE
*        END ELSE
*            Y.TOT.BAL += Y.BAL
*        END
*
*    REPEAT
    READ R.MIS.CONT FROM F.MISMATCH.CONTRACT.FILE, YASSET.KEY:'.':Y.CURR.TYPE THEN
        Y.TOT.BAL = R.MIS.CONT<1>
        DEL R.MIS.CONT<1>
        IF R.MIS.CONT THEN
            YP.MISMATCH<-1> = R.MIS.CONT
        END
    END

*
RETURN
*
*-----------------------------------------------------------------------
FORMAT.LINE.NARRATIVE:
**********************
*
*---- Format line Narratives

    Y.NO.OF.DESCS = COUNT(Y1.REC<RE.SRH.LINE.NARR.SIZE>,@VM) + 1 ;*R22 MANUAL CONVERSION

    Y.NARRATIVE = ""
    FOR Y.DESC.NO = 1 TO Y.NO.OF.DESCS
        IF Y7.REC<RE.SLC.DESC,Y.DESC.NO,LNGG> <> "" THEN
            Y.DESC.LINE = Y7.REC<RE.SLC.DESC,Y.DESC.NO,LNGG>
            Y.DESC.LINE = FMT(Y.DESC.LINE,"35L")[1,Y1.REC<RE.SRH.LINE.NARR.SIZE,Y.DESC.NO>]
            Y.NARRATIVE := Y.DESC.LINE
        END ELSE
            Y.DESC.LINE = Y7.REC<RE.SLC.DESC,Y.DESC.NO,1>
            Y.DESC.LINE = FMT(Y.DESC.LINE,"35L")[1,Y1.REC<RE.SRH.LINE.NARR.SIZE,Y.DESC.NO>]
            Y.NARRATIVE := Y.DESC.LINE
        END
    NEXT Y.DESC.NO
*
RETURN
*
*-----------------------------------------------------------------------
CHECK.PRINT.LINE:
*****************
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
GET.CCY.DECIMALS:
*****************
*
*     Number of decimals used in the report currency and the currency name
*     will be stored

    IF Y.RPT.CCY = "" THEN
        YYCCY = LCCY
    END ELSE
        YYCCY = Y.RPT.CCY
    END
    Y.CCY.DECIMALS = "NO.OF.DECIMALS"
    CALL UPD.CCY(YYCCY,Y.CCY.DECIMALS)
    IF ETEXT <> "" THEN
*
        ERROR.KEY = YYCCY
        ERROR.MESSAGE = "WRONG CCY CODES IN CONSOLIDATE FILES"
        GOSUB ERROR.9999
        Y.CCY.DECIMALS = 2
        YP.CCY.NAME = "CCY CODE NOT FOUND"
        RETURN
    END
    YP.CCY.NAME = "CCY.NAME"
    CALL UPD.CCY(YYCCY,YP.CCY.NAME)
*
RETURN
*
*-----------------------------------------------------------------------
GET.DATE.ADDING.DAYS:
*********************
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
***********************
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
**********************
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
BUILD.MATURITY.DATE.RANGES:
***************************
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
ERROR.9999:
***********
*
    ERROR.MESSAGE = TRIM(ERROR.MESSAGE)
    CALL.ARG = ''
    CALL.ARG<1> = "RE.MISMATCH.RUN"
    CALL.ARG<2> = "RE"
    CALL.ARG<3> = ERROR.KEY
    CALL.ARG<4> = LOWER(ERROR.MESSAGE)
    CALL.ARG<5> = ""
    CALL.ARG<6> = "656"

    CALL FATAL.ERROR(CALL.ARG)
*
RETURN
*
*     end of program --------------
END
