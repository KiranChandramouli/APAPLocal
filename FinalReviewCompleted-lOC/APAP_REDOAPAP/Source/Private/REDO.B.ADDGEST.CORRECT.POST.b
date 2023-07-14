* @ValidationCode : MjoxODU4MTE1MDk4OkNwMTI1MjoxNjg1MDkwNTMyMDkxOklUU1M6LTE6LTE6Njk5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 May 2023 14:12:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 699
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.B.ADDGEST.CORRECT.POST
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                DESCRIPTION
*25-05-2023           Conversion Tool          R22 Auto Code conversion           No Changes
*25-05-2023           Harish vikaram C         Manual R22 Code Conversion         No Changes
*-----------------------------------------------------------------------------

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


    FILE.NAME = "CORRECTION_LOG_REPORT"
    SEQ.CNT = ''
    SEL.CMD = "SELECT ":FN.EXP.FILE.PATH
    CALL EB.READLIST(SEL.CMD,Y.ID.LIST,'',NO.OF.REC,RET.CODE)
    Y.SEQ.NO = '.V':NO.OF.REC+1
    Y.FILE.NAME = FILE.NAME:Y.SEQ.NO:".csv"
    FINAL.ARRAY.LIST = '' ; TEMP.ARRAY.LIST = ''
    Y.SEQ.NO = 1
    SEL.CMD = "SELECT ":FN.TEMP.FILE.PATH
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    TEMP.ARRAY.LIST = ''
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING SEL.POS
    WHILE Y.TEMP.ID:SEL.POS
        R.TEMP.FILE.PATH = ''; TEMP.ERR = ''
        CALL F.READ(FN.TEMP.FILE.PATH,Y.TEMP.ID,R.TEMP.FILE.PATH, F.TEMP.FILE.PATH,TEMP.ERR)
        Y.SEQ.NO = FMT(Y.SEQ.NO,"R%7")
        TEMP.ARRAY.LIST<-1> = R.TEMP.FILE.PATH
        DELETE F.TEMP.FILE.PATH,Y.TEMP.ID
    REPEAT

    FINAL.ARRAY.LIST<1> = 'ARRANGEMENT':'|':'STATUS'
    FINAL.ARRAY.LIST<-1> = TEMP.ARRAY.LIST
    WRITE FINAL.ARRAY.LIST ON F.EXP.FILE.PATH, Y.FILE.NAME ON ERROR
        Y.ERR.MSG = "Unable to Write '":F.EXP.FILE.PATH:"'"
    END
