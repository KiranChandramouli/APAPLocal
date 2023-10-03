* @ValidationCode : Mjo4MjEzNDMyNjI6Q3AxMjUyOjE2OTI4Nzg4MTM4MjY6SVRTUzotMTotMToyNTMxOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Aug 2023 17:36:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 2531
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.Repgens
*-----------------------------------------------------------------------------
* <Rating>355</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*21-08-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE folder name removed,FM TO @FM,SM TO @SM,VM TO @VM
*----------------------------------------------------------------------------------------
SUBROUTINE RE.MISMATCH.RUN.RUN
*
*---- Common INSERT routines

    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.LIMIT
    $INSERT I_F.DATES
    $INSERT I_F.COMPANY
    $INSERT I_F.RE.STAT.MISMATCH
    $INSERT I_F.RE.STAT.LINE.CONT
    $INSERT I_F.RE.STAT.REPORT.HEAD
    $INSERT I_F.CONSOLIDATE.ASST.LIAB
    $INSERT I_F.SPF
    $INSERT I_BATCH.FILES ;*R22 MANUAL CONVERSION END
*
*----------------------------------------------------------------------------

    IF BATCH.DETAILS<3,1,1> THEN
        ID.NEW = BATCH.DETAILS<3,1,1>
        V = RE.SMM.AUDIT.DATE.TIME
        F.RE.STAT.MISMATCH = ''
        CALL OPF("F.RE.STAT.MISMATCH", F.RE.STAT.MISMATCH)
*
        MATREAD R.NEW FROM F.RE.STAT.MISMATCH, ID.NEW THEN
            GOSUB INITIALISE
            GOSUB MAIN.CONTROL.PARA
        END
    END
*
RETURN
*
*----
INITIALISE:
*----
    PRT.UNIT = 0
*
    YERROR = ""
    YASSET.CONSOL.KEYS = ""
    YASSET.CONSOL.TYPES = ""
    LOCAL7 = ""
    Y.DECIMAL.ARRAY = ""
    Y.TOT.BAL = 0
**
** Any new applications which use RE.CONTRACT.BALANCES should be added
** to this list so that the correct generic routine RE.EXTRACT.GEN.INFO
** is called
**
    GEN.APPS.LIST = 'SW':@VM:'PD':@VM:'DX':@VM:'BL':@VM:'SL':@VM:'ND':@VM:'AZ':@VM:'IA' ;*R22 MANUAL CONVERSION
**
    CALL FIND.CCY.MKT("AC","1","","","","","")
*
    YFN.DATES = "F.DATES"
    F.DATES = ""
    CALL OPF(YFN.DATES,F.DATES)

*---- Find the number of reports to be produced

    Y.CCY.LOCAL = LCCY
    Y.LOCAL.CCY.DECIMALS = "NO.OF.DECIMALS"
    CALL UPD.CCY(Y.CCY.LOCAL,Y.LOCAL.CCY.DECIMALS)

    Y.LOCAL.CCY.NAME = "CCY.NAME"
    CALL UPD.CCY(Y.CCY.LOCAL,Y.LOCAL.CCY.NAME)

    YCOUNT.RPT.NAME = COUNT(R.NEW(RE.SMM.REPORT.NAME),@VM)+1 ;*R22 MANUAL CONVERSION

    F.CONSOLIDATE.ASST.LIAB = ""
    CALL OPF("F.CONSOLIDATE.ASST.LIAB",F.CONSOLIDATE.ASST.LIAB)


    IF RUNNING.UNDER.BATCH THEN
        FX.PROC.DATE = TODAY
    END ELSE
        FX.PROC.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    END

RETURN

*----
MAIN.CONTROL.PARA:
*----

    FOR YY = 1 TO YCOUNT.RPT.NAME
        Y.CURR.REPORT = R.NEW(RE.SMM.REPORT.NAME)<1,YY>
        REPORT.ID = 'CRD.':Y.CURR.REPORT
        YCOUNT.RPT.LINE.NO = COUNT(R.NEW(RE.SMM.LINE.NO.ST)<1,YY>,@SM)+1 ;*R22 MANUAL CONVERSION

        CALL PRINTER.ON(REPORT.ID,PRT.UNIT)

*---- Set up report header lines

        GOSUB SET.UP.HEADING.DETAILS
        IF YERROR THEN
            GOSUB MAIN.PARA.EXIT
            RETURN
        END

        GOSUB LIST.REP.LINES:

*---- Read each report line and print according to the specifications

        GOSUB READ.REPORT.LINES
        IF YERROR THEN
            GOSUB MAIN.PARA.EXIT
            RETURN
        END

        CALL PRINTER.CLOSE(REPORT.ID,PRT.UNIT,'')
    NEXT

*---- Successful run of the program

    CALL PRINTER.OFF
    BATCH.DETAILS<1> = 2
RETURN

MAIN.PARA.EXIT:
*--------------

    IF YERROR THEN
        CALL PRINTER.CLOSE(REPORT.ID,PRT.UNIT,'')
        CALL PRINTER.OFF
        E = BATCH.DETAILS<2>
    END
RETURN

*----
*     END OF MAIN ROUTINE ****************************
*

SET.UP.HEADING.DETAILS:
*----
*     Module sets up Report header line
    Y.REPORT = Y.CURR.REPORT
    Y1.FILE = "F.RE.STAT.REPORT.HEAD" ; F.RE.STAT.REPORT.HEAD = ""
    Y.FILE.INP = Y1.FILE:@FM:"NO.FATAL.ERROR" ;*R22 MANUAL CONVERSION
    CALL OPF(Y.FILE.INP,F.RE.STAT.REPORT.HEAD)
    Y1.FILE = Y.FILE.INP<1>

    IF ETEXT THEN

*---- File Open Error

        BATCH.DETAILS<1> = 0
        BATCH.DETAILS<2> = Y1.FILE:" OPEN ERROR"
        YERROR = 1
        RETURN
    END

    READ Y1.REC FROM F.RE.STAT.REPORT.HEAD,Y.REPORT ELSE
        Y1.REC = ""
        BATCH.DETAILS<1> = 0
        BATCH.DETAILS<2> = Y.REPORT:" MISSING"
        YERROR = 1
        RETURN
    END

*---- Store Heading according to the Language used

    IF Y1.REC<RE.SRH.HEADING,LNGG> <> "" THEN
        YP.TITLE = Y1.REC<RE.SRH.HEADING,LNGG>
    END ELSE
        YP.TITLE = Y1.REC<RE.SRH.HEADING,1>
    END

*----

*---- Fetch Line Narrative heads and size,if Report header contains a type
*     Component

    IF FIELD(Y.REPORT,".",2) <> "" THEN
        Y.BASE.REPORT = FIELD(Y.REPORT,".",1)
        READ Y1.RECA FROM F.RE.STAT.REPORT.HEAD,Y.BASE.REPORT
        ELSE
            BATCH.DETAILS<1> = 0
            BATCH.DETAILS<2> = Y.BASE.REPORT:" MISSING"
            YERROR = 1
            RETURN
        END

        IF Y1.RECA<RE.SRH.LINE.NARR.SIZE> <> "" THEN
            Y1.REC<RE.SRH.LINE.NARR.SIZE> = Y1.RECA<RE.SRH.LINE.NARR.SIZE>
            Y1.REC<RE.SRH.NARR.HD.1> = Y1.RECA<RE.SRH.NARR.HD.1>
            Y1.REC<RE.SRH.NARR.HD.2> = Y1.RECA<RE.SRH.NARR.HD.2>
        END
        Y.REPORT = Y.BASE.REPORT
    END

*----

*---- Store Company Name and other details

    YP.COMPANY.NAME = R.COMPANY(EB.COM.COMPANY.NAME)
    YP.UNIT.NAME = R.COMPANY(EB.COM.STAT.REP.NAME)
    YP.UNIT.AREA = R.COMPANY(EB.COM.STAT.REP.AREA)
    YP.DELIVERY = R.COMPANY(EB.COM.STAT.REP.DELIV)

*---- Initialise report date and page counts

    YP.PAGE.COUNT = 0
    YP.LINES.PER.PAGE = 60

*---- Number of lines per page is now set to 60

    YP.LINE.COUNT = YP.LINES.PER.PAGE + 1
    YP.DATE = TIMEDATE()
    YP.DATE[6,3] = " ON"

*---- As SECS. are not required to be printed

*---- set print date depending on whether on-line or batch
*     for on-line print use last working day

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
*****
        END ELSE
            YPROC.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
        END
    END
    YP.TODAY = YPROC.DATE
    YP.TODAY = ICONV((YP.TODAY[7,2]:"/":YP.TODAY[5,2]:"/":YP.TODAY[1,4]),"DE")
    YP.TODAY = OCONV(YP.TODAY,"D")

    IF Y1.REC<RE.SRH.MAT.INCLUSIVE> NE 'Y' THEN
        CALL CDT("",YPROC.DATE,"-1C")
    END

*---- Build up Heading line formats

    YP.RHEAD1 = "  RE000025 ":FMT(YP.COMPANY.NAME,"22L"):SPACE(17):"BALANCE DETAILS":SPACE(13)
    YP.RHEAD1 := " AS AT CLOSE OF ":YP.TODAY:SPACE(15):"PAGE NO "
    YP.RHEAD1 := SPACE(4)

*---- Page Count will be moved at print time

    YP.RHEAD2 = "  AREA NAME ":FMT(YP.UNIT.AREA,"35L"):SPACE(3):FMT(YP.TITLE,"35L"):SPACE(14)
    YP.RHEAD2 := "PRINTED AT ":YP.DATE

    YP.RHEAD3 = SPACE(8):"TO: ":FMT(YP.UNIT.NAME,"38L"):FMT(YP.DELIVERY,"12L")
    YP.RHEAD3 := SPACE(70)

*---- Currency and Amount Units will be moved at Print time

    YP.CHEAD1 = "LINE NARRATIVE / CRF KEY AND TYPE":SPACE(21):"CONTRACT CCY AMOUNT":SPACE(6):"CRF CCY AMOUNT":SPACE(7):"DIFFERENCE"
    YP.CHEAD2 = "---------------------------------":SPACE(21):"-------------------":SPACE(6):"--------------":SPACE(7):"----------"

RETURN

*----
LIST.REP.LINES:
*----
*     Module collects all line numbers for this report

*---- Get correct report line file name for the company
    Y7.FILE = "F.RE.STAT.LINE.CONT" ; F.RE.STAT.LINE.CONT = ""
    Y.FILE.INP = Y7.FILE:@FM:"NO.FATAL.ERROR" ;*R22 MANUAL CONVERSION
    CALL OPF(Y.FILE.INP,F.RE.STAT.LINE.CONT)
*
    FN.RE.MISMATCH.RUN = 'F.RE.MISMATCH.RUN'
    F.RE.MISMATCH.RUN = ''
    CALL OPF(FN.RE.MISMATCH.RUN, F.RE.MISMATCH.RUN)

*---- Store line numbers used in the report

    Y.REP.LINE.COUNT = 0
    Y.REP.LINE.LIST = ""
    CLEARSELECT
	
	IF BATCH.DETAILS<3,1,2> THEN
		SEL.CMD = 'SSELECT ':FN.RE.MISMATCH.RUN:' LIKE ':Y.REPORT:'... AND WITH ':BATCH.DETAILS<3,1,2>
	END ELSE
		SEL.CMD = 'SSELECT ':FN.RE.MISMATCH.RUN:' LIKE ':Y.REPORT:'...'
	END
    CALL EB.READLIST(SEL.CMD, Y.REP.LINE.LIST, '',Y.REP.LINE.COUNT, '')

RETURN
*----
READ.REPORT.LINES:
*----
*---- Record selections and parameters initialisation

    Y.FOREIGN.CURRENCIES = "" ;! Dynamic array of Foreign Currency Codes used
    YCON.KEY = ""   ;! Variable used TO store consol KEY IN CASE of detailed PRINT
    Y.FIRST.RUN = 1 ;! Indicator used TO build up A TABLE of Foreign Currencies used

*---- for CURRENCY wise reporting

    IF Y1.REC<RE.SRH.SPLIT> = "ALL" OR Y1.REC<RE.SRH.SPLIT> = "TOTAL.FOREIGN" THEN
        Y.RPT.CCY = ""
    END ELSE
        Y.RPT.CCY = LCCY
    END

*---- Find number of decimals used in the report currency

    GOSUB GET.CCY.DECIMALS
    IF YERROR THEN
        RETURN
    END

*---- Process each report line and print

    Y.END = ""
    LOOP UNTIL Y.END = "END"

*---- clear work file used for profit loss sign processing


        FOR Y.LIN.NO = 1 TO Y.REP.LINE.COUNT
            Y.TOT.REP.LINE.BAL = 0
            Y.TOT.BAL = 0
            YKEY = Y.REP.LINE.LIST<Y.LIN.NO>

            READ Y.REC FROM F.RE.MISMATCH.RUN, YKEY ELSE CRT "UNABLE TO READ THE RECORD:":YKEY

            CONVERT '!' TO @FM IN Y.REC
            YP.SPACE.BEFORE = 1
            YP.SPACE.AFTER = ""
            CNT.LINE = DCOUNT(Y.REC,@FM)
            FOR LINE.CNT = 1 TO CNT.LINE
                YP.DATA.LINE = Y.REC<LINE.CNT>
                GOSUB CHECK.PRINT.LINE:
            NEXT LINE.CNT
        NEXT Y.LIN.NO

*---- Now print END OF REPORT line


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
            GOSUB PRINT.END.OF.REPORT
        END


*---- Now check if reports have to be generated for other Currencies

        IF Y1.REC<RE.SRH.SPLIT> = "CURRENCY" OR Y1.REC<RE.SRH.SPLIT> = "BY.FOREIGN" THEN
            IF Y.FOREIGN.CURRENCIES <> "" THEN
                IF Y.FIRST.RUN THEN
                    Y.NO.OF.REPORTS = COUNT(Y.FOREIGN.CURRENCIES,@FM)+1 ;*R22 MANUAL CONVERSION
                    Y.FIRST.RUN = 0 ; Y.REPORT.NO = 0
                END
                Y.REPORT.NO += 1
                IF Y.REPORT.NO > Y.NO.OF.REPORTS THEN
                    Y.END = "END"
                END ELSE

*---- Initialise variables for next run

                    Y.RPT.CCY = Y.FOREIGN.CURRENCIES<Y.REPORT.NO>
                    GOSUB GET.CCY.DECIMALS
                    IF YERROR THEN
                        RETURN
                    END

                    YP.PAGE.COUNT = 0
                    YP.LINE.COUNT = YP.LINES.PER.PAGE + 1
                END
            END ELSE
                Y.END = "END"
            END
        END ELSE
            Y.END = "END"
        END
    REPEAT
RETURN

*----

CHECK.PRINT.LINE:
*================

*---- Check page end conditions

    YP.LINE.COUNT = YP.LINE.COUNT + 1
    IF YP.LINE.COUNT > YP.LINES.PER.PAGE THEN
        GOSUB PRINT.REPORT.HEADER
        YP.LINE.COUNT = 0
    END

    PRINT YP.DATA.LINE

RETURN

*----
PRINT.REPORT.HEADER:
*----
*     Print report heading after incrementing page number

    YP.PAGE.COUNT += 1
    IF YP.PAGE.COUNT = 1 THEN
        Y.TEMP.NARR = ""
        IF Y.RPT.CCY <> "" THEN
            Y.TEMP.NARR = "( IN ":YP.CCY.NAME
        END
        IF Y.TEMP.NARR THEN
            Y.TEMP.NARR := " )"
        END
        YP.RHEAD3[63,67] = FMT(TRIM(Y.TEMP.NARR),"67L")
    END

    YP.LINE.COUNT = 8
    YP.RHEAD1[129,4] = FMT(YP.PAGE.COUNT,"4RZ")
    HEADING YP.RHEAD1
    PRINT YP.RHEAD2
    PRINT YP.RHEAD3
    PRINT
    PRINT YP.CHEAD1
    PRINT YP.CHEAD2
    PRINT
RETURN

*----

PRINT.END.OF.REPORT:
*----

*---- if last line of the report is provided as heading

    PRINT
    PRINT "   ******  END OF REPORT  ******"
RETURN

*----
GET.CCY.DECIMALS:
*----
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
RETURN


LAST.MONTH.DAY:
*----
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
RETURN

*----
ERROR.9999:
*==========

    ERROR.MESSAGE = TRIM(ERROR.MESSAGE)

    CALL.ARG = ''
    CALL.ARG<1> = "RE.STAT.MISMATCH.RUN"
    CALL.ARG<2> = "RE"
    CALL.ARG<3> = ERROR.KEY
    CALL.ARG<4> = LOWER(ERROR.MESSAGE)
    CALL.ARG<5> = ""
    CALL.ARG<6> = "656"

    CALL FATAL.ERROR(CALL.ARG)

RETURN
*----
*     end of program --------------

END



