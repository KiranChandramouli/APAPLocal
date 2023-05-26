* @ValidationCode : MjotODQ3MzQ5ODk0OkNwMTI1MjoxNjg1MDc5NzY1MzQ2OklUU1M6LTE6LTE6Njk3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 May 2023 11:12:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 697
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*25/05/2023      CONVERSION TOOL         AUTO R22 CODE CONVERSION                ++ TO +=
*25/05/2023      HARISH VIKRAM              MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.B.ADDGEST.CHARGE.POST
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

***PICKUP_POINT***
    FN.TEMP.FILE.PATH = '&TEMP&'
    OPEN FN.TEMP.FILE.PATH TO F.TEMP.FILE.PATH ELSE
    END
****WRITING_LOCATION****
    FN.EXP.FILE.PATH = '../EXTRACT/MASSIVE.BP/FINAL'
    OPEN FN.EXP.FILE.PATH TO F.EXP.FILE.PATH ELSE
        Y.MK.CMD = "mkdir ../EXTRACT/MASSIVE.BP/FINAL"
        EXECUTE Y.MK.CMD
        OPEN FN.EXP.FILE.PATH TO F.EXP.FILE.PATH ELSE
        END
    END


    FILE.NAME = "CONSOLIDATE_LOG_REPORT"
    SEQ.CNT = ''
    SEL.CMD = "SELECT ":FN.EXP.FILE.PATH
    CALL EB.READLIST(SEL.CMD,Y.ID.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.ID FROM Y.ID.LIST SETTING ID.POS
    WHILE Y.ID:ID.POS
        IF FILE.NAME EQ Y.ID[1,22] THEN
            SEQ.CNT += 1 ;*AUTO R22 CODE CONVERSION
        END
    REPEAT
    SEQ.CNT += 1 ;*AUTO R22 CODE CONVERSION
    SEQ.CNT = FMT(SEQ.CNT,'R0%3')
    Y.FILE.NAME = FILE.NAME:SEQ.CNT:".csv"
    FINAL.ARRAY.LIST = ''
    Y.SEQ.NO = 1
    SEL.CMD = "SELECT ":FN.TEMP.FILE.PATH
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING SEL.POS
    WHILE Y.TEMP.ID:SEL.POS
        R.TEMP.FILE.PATH = ''; TEMP.ERR = ''
        CALL F.READ(FN.TEMP.FILE.PATH,Y.TEMP.ID,R.TEMP.FILE.PATH, F.TEMP.FILE.PATH,TEMP.ERR)
        Y.SEQ.NO = FMT(Y.SEQ.NO,"R%7")
        FINAL.ARRAY.LIST<-1> = R.TEMP.FILE.PATH
        DELETE F.TEMP.FILE.PATH,Y.TEMP.ID
    REPEAT
    TOT.REC.CNT = DCOUNT(FINAL.ARRAY.LIST,@FM)
    TOT.REC.CNT = FMT(TOT.REC.CNT,'R0%5')
    FINAL.ARRAY.LIST<1> = 'ARRANGEMENT':'|':'STATUS'
    WRITE FINAL.ARRAY.LIST ON F.EXP.FILE.PATH, Y.FILE.NAME ON ERROR
        Y.ERR.MSG = "Unable to Write '":F.EXP.FILE.PATH:"'"
    END
