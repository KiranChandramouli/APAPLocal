* @ValidationCode : MjotMTk5NTI1MDk4MjpDcDEyNTI6MTcwMjYyNDY0MjA5NTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 15 Dec 2023 12:47:22
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
$PACKAGE APAP.DRREG
SUBROUTINE DR.REG.RIEN5.EXTRACT3
*----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN5.EXTRACT1
* Date           : 27-May-2013
*----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the AZ.ACCOUNT/ACCOUNT Details Product wise.
*----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date       Author              Modification Description
* 24/07/2014  Ashokkumar           PACS00309203 - Fixed �Indeterminado� column and removed value with
* 26/02/2015  Ashokkumar.V.P       PACS00309203 - Just for compilatio
*DATE               WHO                       REFERENCE                 DESCRIPTION
*10-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM , IF CONDITION MODIFY
*10-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*14/12/2023         Suresh             R22 Manual Conversion        Change Hardcoding the value to IDVAR

*----------------------------------------------------------------------------------------
 

*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.DATES
*
    $INSERT I_F.DR.REG.RIEN5.PARAM
    $INSERT I_F.DR.REG.RIEN5.OUT3
*
    GOSUB OPEN.FILES
    GOSUB SELECT.PROCESS
*
RETURN
*----------------------------------------------------------------------------
OPEN.FILES:
*---------*
*
    FN.DR.REG.RIEN5.OUT3 = 'F.DR.REG.RIEN5.OUT3'
    F.DR.REG.RIEN5.OUT3 = ''
    CALL OPF(FN.DR.REG.RIEN5.OUT3,F.DR.REG.RIEN5.OUT3)

    FN.DR.REG.RIEN5.PARAM = 'F.DR.REG.RIEN5.PARAM'
    F.DR.REG.RIEN5.PARAM = ''
    CALL OPF(FN.DR.REG.RIEN5.PARAM,F.DR.REG.RIEN5.PARAM)

    IDVAR='SYSTEM';*R22 Manual Conversion
    CALL CACHE.READ(FN.DR.REG.RIEN5.PARAM,IDVAR,R.DR.REG.RIEN5.PARAM,DR.REG.RIEN5.PARAM.ERR) ;*R22 Manual Conversion
    FN.CHK.DIR = R.DR.REG.RIEN5.PARAM<RIEN5.PARAM.OUT.PATH>
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
*
    Y.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    EXTRACT.FILE.ID = R.DR.REG.RIEN5.PARAM<RIEN5.PARAM.FILE.NAME>:'_':R.DR.REG.RIEN5.PARAM<RIEN5.PARAM.REP.NAME,3>:'_':Y.DATE:'.csv'
*
    R.FILE.DATA = ''
    REP.HEADER = R.DR.REG.RIEN5.PARAM<RIEN5.PARAM.REP.HEADER,1>
    R.FILE.DATA<-1> = REP.HEADER
*    WRITESEQ REP.HEADER TO FV.EXTRACT.FILE ELSE NULL
    REP.NAME = R.DR.REG.RIEN5.PARAM<RIEN5.PARAM.REP.NAME,3>
    R.FILE.DATA<-1> = REP.NAME
*    WRITESEQ REP.NAME TO FV.EXTRACT.FILE ELSE NULL
    REP.DATE = 'FECHA Y HORA : ':TIMEDATE()
    R.FILE.DATA<-1> = REP.DATE
*    WRITESEQ REP.DATE TO FV.EXTRACT.FILE ELSE NULL
    REP.FIELDS = R.DR.REG.RIEN5.PARAM<RIEN5.PARAM.REP.FIELDS>
    CHANGE @VM TO '|' IN REP.FIELDS
    R.FILE.DATA<-1> = REP.FIELDS
*    WRITESEQ REP.FIELDS TO FV.EXTRACT.FILE ELSE NULL
*
RETURN
*----------------------------------------------------------------------------
SELECT.PROCESS:
*-------------*
*
    SEL.CMD1 = ''
    ID.LIST1 = ''
    ID.CNT1 = ''
    ERR.SEL1 = ''
    SEL.CMD1 = "SELECT ":FN.DR.REG.RIEN5.OUT3:" BY @ID"
    CALL EB.READLIST(SEL.CMD1, ID.LIST1, "", ID.CNT1, ERR.SEL1)
    ID.CTR1 = 1
    LOOP
    WHILE ID.CTR1 LE ID.CNT1
        REC.ID = ID.LIST1<ID.CTR1>
        GOSUB PROCESS
        ID.CTR1 += 1
    REPEAT
*
* Sum columns, Added by Mauricio M.
    RETURN.MSG = "TOTAL":'|':TOTRANGE1:'|':TOTRANGE2:'|':TOTRANGE3:'|':TOTRANGE4:'|':TOTRANGE5:'|':TOTRANGE6:'|':TOTRANGE7:'|':TOTRANGE8:'|':TOTRANGE9:'|':TOTRANGE10:'|':TOTRANGE11:'|':TOTINDET:'|':""
*    WRITESEQ RETURN.MSG TO FV.EXTRACT.FILE ELSE NULL
    R.FILE.DATA<-1> = RETURN.MSG
    WRITE R.FILE.DATA ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END
* Sum columns, Added by Mauricio M.

RETURN
*----------------------------------------------------------------------------
PROCESS:
*------*
*
    CALL F.READ(FN.DR.REG.RIEN5.OUT3,REC.ID,R.DR.REG.RIEN5.OUT3,F.DR.REG.RIEN5.OUT3,DR.REG.RIEN5.OUT3.ERR)
    IF R.DR.REG.RIEN5.OUT3 THEN
        RANGE1 = R.DR.REG.RIEN5.OUT3<DR.RIEN5.OUT3.RANGE.0.15>
        RANGE2 = R.DR.REG.RIEN5.OUT3<DR.RIEN5.OUT3.RANGE.16.30>
        RANGE3 = R.DR.REG.RIEN5.OUT3<DR.RIEN5.OUT3.RANGE.31.60>
        RANGE4 = R.DR.REG.RIEN5.OUT3<DR.RIEN5.OUT3.RANGE.61.90>
        RANGE5 = R.DR.REG.RIEN5.OUT3<DR.RIEN5.OUT3.RANGE.91.180>
        RANGE6 = R.DR.REG.RIEN5.OUT3<DR.RIEN5.OUT3.RANGE.181.360>
        RANGE7 = R.DR.REG.RIEN5.OUT3<DR.RIEN5.OUT3.RANGE.361.720>
        RANGE8 = R.DR.REG.RIEN5.OUT3<DR.RIEN5.OUT3.RANGE.721.1080>
        RANGE9 = R.DR.REG.RIEN5.OUT3<DR.RIEN5.OUT3.RANGE.1081.1440>
        RANGE10 = R.DR.REG.RIEN5.OUT3<DR.RIEN5.OUT3.RANGE.1441.1800>
        RANGE11 = R.DR.REG.RIEN5.OUT3<DR.RIEN5.OUT3.RANGE.1881>
        INDET = R.DR.REG.RIEN5.OUT3<DR.RIEN5.OUT3.INDETERMINATE>          ;* PACS00309203 - Indeterminado field
        TOTAL = R.DR.REG.RIEN5.OUT3<DR.RIEN5.OUT3.TOTAL>
        IF TOTAL EQ 0 THEN ;* R22 AUTO CODE CONVERSION - START
            RETURN ;* PACS00309203 S/E
        END         ;*R22 AUTO CODE CONVERSION - END
*        RETURN.MSG = REC.ID:'|':RANGE1:'|':RANGE2:'|':RANGE3:'|':RANGE4:'|':RANGE5:'|':RANGE6:'|':RANGE7:'|':RANGE8:'|':RANGE9:'|':RANGE10:'|':RANGE11:'|':TOTAL
        RETURN.MSG = REC.ID:'|':RANGE1:'|':RANGE2:'|':RANGE3:'|':RANGE4:'|':RANGE5:'|':RANGE6:'|':RANGE7:'|':RANGE8:'|':RANGE9:'|':RANGE10:'|':RANGE11:'|':INDET:'|':TOTAL    ;* PACS00309203 - Indeterminado field
*        WRITESEQ RETURN.MSG TO FV.EXTRACT.FILE ELSE NULL
        R.FILE.DATA<-1> = RETURN.MSG
        GOSUB SUM.RANGE ;* Sum columns, Added by Mauricio M.
    END
*
RETURN
*----------------------------------------------------------------------------
SUM.RANGE:*start - Sum columns, Added by Mauricio M.
*--------*
*
TOTRANGE1 += RANGE1
TOTRANGE2 += RANGE2
TOTRANGE3 += RANGE3
TOTRANGE4 += RANGE4
TOTRANGE5 += RANGE5
TOTRANGE6 += RANGE6
TOTRANGE7 += RANGE7
TOTRANGE8 += RANGE8
TOTRANGE9 += RANGE9
TOTRANGE10 += RANGE10
TOTRANGE11 += RANGE11
TOTINDET += INDET

RETURN
*end - Sum columns, Added by Mauricio M.
*----------------------------------------------------------------------------

END
