* @ValidationCode : MjotNDc0OTAwNzk1OkNwMTI1MjoxNjkyODc3ODk2NTQzOklUU1M6LTE6LTE6NTk5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Aug 2023 17:21:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 599
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.Repgens
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*21-08-2023    VICTORIA S          R22 MANUAL CONVERSION   VM TO @VM
*----------------------------------------------------------------------------------------
SUBROUTINE RE.MISMATCH.APP.INFO.LOAD
*
*-----------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RE.STAT.MISMATCH
    $INSERT I_RE.MISMATCH.APP.INFO.COMMON
*
*-----------------------------------------------------------------------------
*

    FN.RE.STAT.MISMATCH = 'F.RE.STAT.MISMATCH'
    F.RE.STAT.MISMATCH = ''
    CALL OPF(FN.RE.STAT.MISMATCH, F.RE.STAT.MISMATCH)

    FN.RE.STAT.LINE.CONT = 'F.RE.STAT.LINE.CONT'
    F.RE.STAT.LINE.CONT = ''
    CALL OPF(FN.RE.STAT.LINE.CONT, F.RE.STAT.LINE.CONT)

    FN.MISMATCH.CONT.FILE = 'F.MISMATCH.CONTRACT.FILE'
    F.MISMATCH.CONT.FILE = ''
    CALL OPF(FN.MISMATCH.CONT.FILE, F.MISMATCH.CONT.FILE)

    FN.RE.STAT.REPORT.HEAD = 'F.RE.STAT.REPORT.HEAD'
    F.RE.STAT.REPORT.HEAD = ''
    CALL OPF(FN.RE.STAT.REPORT.HEAD, F.RE.STAT.REPORT.HEAD)

    ID.NEW = BATCH.DETAILS<3,1,1>
    V = RE.SMM.AUDIT.DATE.TIME

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

RETURN
