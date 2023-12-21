* @ValidationCode : MjotMjAwNDc2NTIwODpVVEYtODoxNzAyNzQ3MzI5MjkxOkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Dec 2023 22:52:09
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*21-08-2023    VICTORIA S          R22 MANUAL CONVERSION   VM TO @VM
*16-12-2023    Narmadha V          Manual R22 Conversion   FN variable changed.
*----------------------------------------------------------------------------------------
SUBROUTINE RE.MISMATCH.CONS.RUN.LOAD

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.RE.STAT.MISMATCH
    $INSERT I_RE.MISMATCH.CONS.RUN.COMMON
*

    IF BATCH.DETAILS<3,1> THEN
        FN.RE.STAT.MISMATCH = 'F.RE.STAT.MISMATCH'
        F.RE.STAT.MISMATCH = ''
        CALL OPF(FN.RE.STAT.MISMATCH, F.RE.STAT.MISMATCH)
*
        FN.RE.STAT.LINE.CONT = 'F.RE.STAT.LINE.CONT'
        F.RE.STAT.LINE.CONT = ''
        CALL OPF(FN.RE.STAT.LINE.CONT, F.RE.STAT.LINE.CONT)
*
        FN.CONSOLIDATE.ASST.LIAB = 'F.CONSOLIDATE.ASST.LIAB'
        F.CONSOLIDATE.ASST.LIAB = ""
*CALL OPF("F.CONSOLIDATE.ASST.LIAB",F.CONSOLIDATE.ASST.LIAB)
        CALL OPF(FN.CONSOLIDATE.ASST.LIAB,F.CONSOLIDATE.ASST.LIAB) ;*Manual R22 Conversion Change FN variable
*
        FN.RE.STAT.REPORT.HEAD = 'F.RE.STAT.REPORT.HEAD'
        F.RE.STAT.REPORT.HEAD = ''
        CALL OPF(FN.RE.STAT.REPORT.HEAD, F.RE.STAT.REPORT.HEAD)
*
* NEW FILE
*
        FN.RE.MISMATCH.RUN = 'F.RE.MISMATCH.RUN'
        F.RE.MISMATCH.RUN = ''
        CALL OPF(FN.RE.MISMATCH.RUN, F.RE.MISMATCH.RUN)

*
        FN.MISMATCH.CONTRACT.FILE = 'F.MISMATCH.CONTRACT.FILE'
        F.MISMATCH.CONTRACT.FILE = ''
        CALL OPF(FN.MISMATCH.CONTRACT.FILE, F.MISMATCH.CONTRACT.FILE)

        F.CONSOL.MISMATCHES = ""

        FN.CONSOL.MISMATCHES = 'F.CONSOL.MISMATCHES'
        CALL OPF(FN.CONSOL.MISMATCHES,F.CONSOL.MISMATCHES)
*        CONSOL.MISMATCHES.KEY = 1
        CONSOL.MISMATCHES.KEYS = ''
*
        Y.CCY.LOCAL = LCCY
        Y.LOCAL.CCY.DECIMALS = "NO.OF.DECIMALS"
        CALL UPD.CCY(Y.CCY.LOCAL,Y.LOCAL.CCY.DECIMALS)

        Y.LOCAL.CCY.NAME = "CCY.NAME"
        CALL UPD.CCY(Y.CCY.LOCAL,Y.LOCAL.CCY.NAME)
*
        Y.DECIMAL.ARRAY = ''
        ID.NEW = BATCH.DETAILS<3,1,1>
        V = RE.SMM.AUDIT.DATE.TIME
*
        MATREAD R.NEW FROM F.RE.STAT.MISMATCH, ID.NEW THEN
            LOC.REPORT.NAMES = R.NEW(RE.SMM.REPORT.NAME)

            YCOUNT.RPT.NAME = COUNT(R.NEW(RE.SMM.REPORT.NAME),@VM)+1 ;*R22 MANUAL CONVERSION
            FOR YY = 1 TO YCOUNT.RPT.NAME
                Y.REPORT = LOC.REPORT.NAMES<1,YY>
                READ Y1.REC FROM F.RE.STAT.REPORT.HEAD, Y.REPORT THEN
                    LOC.REPORT.RECS(YY) = Y1.REC
                END
            NEXT
        END

*        F.CONSOL.KEY = ""
*        FN.CONSOL.KEY = 'F.CONSOL.KEY'
*        OPEN FN.CONSOL.KEY TO F.CONSOL.KEY ELSE CRT 'U T O F.CONSOL.KEY'

    END
RETURN
*
END
