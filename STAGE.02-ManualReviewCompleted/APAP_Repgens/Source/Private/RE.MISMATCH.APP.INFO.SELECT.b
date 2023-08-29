* @ValidationCode : MjotMTAxNDUyNzQ0NzpDcDEyNTI6MTY5Mjg3Nzg5NjY4NTpJVFNTOi0xOi0xOjM2NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Aug 2023 17:21:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 365
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
*21-08-2023    VICTORIA S          R22 MANUAL CONVERSION   VM TO @VM,FM TO @FM,SM TO @SM
*----------------------------------------------------------------------------------------
SUBROUTINE RE.MISMATCH.APP.INFO.SELECT
*
*-----------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PGM.FILE
    $INSERT I_BATCH.FILES
    $INSERT I_F.RE.STAT.LINE.CONT
    $INSERT I_F.RE.STAT.MISMATCH
    $INSERT I_DAS.RE.STAT.LINE.CONT
    $INSERT I_RE.MISMATCH.APP.INFO.COMMON
    $INSERT I_F.SPF
*
*----------------------------------------------------------------------------
*

    IF BATCH.DETAILS<3,1,1> THEN
        IF NOT(CONTROL.LIST) THEN
            IF BATCH.DETAILS<3,1,2> THEN
                SEL.CMD = 'WITH ':BATCH.DETAILS<3,1,2>
                CRT '***** CLEARING MISMATCH.CONT.FILE *****'
                CALL EB.CLEAR.FILE(FN.MISMATCH.CONT.FILE:@FM:SEL.CMD, F.MISMATCH.CONT.FILE) ;*R22 MANUAL CONVERSION
            END ELSE
                CRT '***** CLEARING MISMATCH.CONT.FILE *****'
                CALL EB.CLEAR.FILE(FN.MISMATCH.CONT.FILE, F.MISMATCH.CONT.FILE)
            END
            YCOUNT.RPT.NAME = COUNT(R.NEW(RE.SMM.REPORT.NAME),@VM)+1 ;*R22 MANUAL CONVERSION
            FOR YY = 1 TO YCOUNT.RPT.NAME
                CONTROL.LIST<-1> = R.NEW(RE.SMM.REPORT.NAME)<1,YY>
            NEXT

        END
        IF CONTROL.LIST THEN
            Y.REPORT = CONTROL.LIST<1,1>
            GOSUB LIST.REP.LINES
        END
    END
*
RETURN
*
*----------------------------------------------------------------------------
LIST.REP.LINES:
*--------------
*
    Y.REP.LINE.LIST = ""

    IF BATCH.DETAILS<3,1,2> THEN
        EXECUTE 'SSELECT ':FN.RE.STAT.LINE.CONT:' WITH @ID LIKE ':Y.REPORT:'... AND WITH ':BATCH.DETAILS<3,1,2> ;* R22 Manual conversion - SELECT changed to SSELECT
    END ELSE
        EXECUTE 'SSELECT ':FN.RE.STAT.LINE.CONT:' WITH @ID LIKE ':Y.REPORT:'...' ;* R22 Manual conversion - SELECT changed to SSELECT
    END
    READLIST ID.LIST ELSE ID.LIST = ''

    IF ID.LIST = '' THEN
        NULL
    END ELSE
        LOCATE Y.REPORT IN R.NEW(RE.SMM.REPORT.NAME)<1,1> SETTING YY THEN
            YCOUNT.RPT.LINE.NO = COUNT(R.NEW(RE.SMM.LINE.NO.ST)<1,YY>,@SM)+1 ;*R22 MANUAL CONVERSION
        END
        LOOP
            REMOVE YID FROM ID.LIST SETTING YD
        WHILE YID DO
            Y.SEL.REP.NAME = FIELD(YID,".",1)
            IF Y.SEL.REP.NAME = Y.REPORT THEN
                Y.COMPARE.REP.LINE.NO = FIELD(YID,".",2)
                Y.LINE.MATCH = ""
                FOR YYY = 1 TO YCOUNT.RPT.LINE.NO UNTIL Y.LINE.MATCH
                    IF R.NEW(RE.SMM.LINE.NO.END)<1,YY,YYY> = "" THEN
                        IF Y.COMPARE.REP.LINE.NO = R.NEW(RE.SMM.LINE.NO.ST)<1,YY,YYY> THEN
                            Y.LINE.MATCH = 1
                            NO.OF.REC +=1
                            GOSUB EXT.APP.KEYS
                        END
                    END ELSE
                        IF Y.COMPARE.REP.LINE.NO > = R.NEW(RE.SMM.LINE.NO.ST)<1,YY,YYY> AND Y.COMPARE.REP.LINE.NO <= R.NEW(RE.SMM.LINE.NO.END)<1,YY,YYY> THEN
                            Y.LINE.MATCH = 1
                            NO.OF.REC +=1
                            GOSUB EXT.APP.KEYS
                        END
                    END
                NEXT YYY
            END
        REPEAT
*
* BATCH.BUILD.LIST doesnot have option to specify the number of IDS in a job.list.
* We might end up with huge transactions lines ending up in a single job list and the job takes too long to finish.
* Its parameterised temporarily in SELECT ROUTINE. A paramter within BATCH.BUILD.LIST for certain jobs would help
* improving the performance.
*
*        TEMP.BATCH.INFO = BATCH.INFO<3>
*        BATCH.INFO<3> = 'EB.EOD.REPORT.PRINT'
        CALL BATCH.BUILD.LIST('', Y.REP.LINE.LIST)
*        BATCH.INFO<3> = TEMP.BATCH.INFO
    END
RETURN

*
*-----------------------------------------------------------------------------
EXT.APP.KEYS:
*------------
*
    YTEMP = ''
    READ Y7.REC FROM F.RE.STAT.LINE.CONT, YID THEN
        CONS.KEY = RAISE(Y7.REC<RE.SLC.ASST.CONSOL.KEY>)
        CONS.KEY.ASST = RAISE(Y7.REC<RE.SLC.ASSET.TYPE>)
        CK.CNT = DCOUNT(CONS.KEY,@FM) ;*R22 MANUAL CONVERSION
        IF CONS.KEY THEN
            FOR I = 1 TO CK.CNT
                IF CONS.KEY<I>['.', 1, 1] NE 'RE' THEN
                    YASSET.KEY = CONS.KEY<I>
                    YTEMP.ASST = CONS.KEY.ASST<I>
                    CHANGE @VM TO '-' IN YTEMP.ASST ;*R22 MANUAL CONVERSION
                    YTEMP = YID:'*':CONS.KEY<I>:'*':YTEMP.ASST:'*'
                    APP.KEYS = "" ; Y.CURR.TYPE = ''
                    CALL RE.EXTRACT.APP.KEYS(YASSET.KEY, Y.CURR.TYPE, APP.KEYS)
                    YTEMP.LIST = SPLICE('',YTEMP,APP.KEYS)
                    Y.REP.LINE.LIST<-1> = YTEMP.LIST
                END
            NEXT I
        END
    END

RETURN

END
