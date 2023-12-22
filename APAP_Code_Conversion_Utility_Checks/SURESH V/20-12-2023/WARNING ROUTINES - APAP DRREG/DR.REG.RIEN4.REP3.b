
* @ValidationCode : MjotMTMxNTAwNTg5NDpDcDEyNTI6MTcwMjUzMTU3MTUxNTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Dec 2023 10:56:11
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

*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN4.REP3
*----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN4.REP3
* Date           : 27-May-2013
*----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the AZ.ACCOUNT/ACCOUNT Details Product wise.
*----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
*DATE               WHO                       REFERENCE                 DESCRIPTION
*10-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*10-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*14/12/2023       Suresh                      R22 Manual Conversion      Change Hardcoding the value to IDVAR
*----------------------------------------------------------------------------------------


*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.DATES
*
    $INSERT I_F.DR.REG.RIEN4.PARAM
    $INSERT I_F.DR.REG.RIEN4.AZ.REP.OUT3
*
    GOSUB OPEN.FILES
    GOSUB SELECT.PROCESS
*
RETURN
*----------------------------------------------------------------------------
OPEN.FILES:
*---------*
*
    FN.DR.REG.RIEN4.AZ.REP.OUT3 = 'F.DR.REG.RIEN4.AZ.REP.OUT3'
    F.DR.REG.RIEN4.AZ.REP.OUT3 = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP.OUT3,F.DR.REG.RIEN4.AZ.REP.OUT3)

    FN.DR.REG.RIEN4.PARAM = 'F.DR.REG.RIEN4.PARAM'
    F.DR.REG.RIEN4.PARAM = ''
    CALL OPF(FN.DR.REG.RIEN4.PARAM,F.DR.REG.RIEN4.PARAM)

*  CALL F.READ(FN.DR.REG.RIEN4.PARAM,'SYSTEM',R.DR.REG.RIEN4.PARAM,F.DR.REG.RIEN4.PARAM,DR.REG.RIEN4.PARAM.ERR) ;*Tus Start
    IDVAR='SYSTEM' ;*R22 Manual Conversion
    CALL CACHE.READ(FN.DR.REG.RIEN4.PARAM,IDVAR,R.DR.REG.RIEN4.PARAM,DR.REG.RIEN4.PARAM.ERR) ; * Tus End ;*R22 Manual Conversion
    FN.CHK.DIR = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.OUT.PATH>
*
    OPEN.ERR = ''
    Y.DATE = TODAY
    EXTRACT.FILE.ID = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.FILE.NAME>:'_':R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.REP.NAME,3>:'_':Y.DATE:'.csv'
    OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE THEN
        DELETESEQ FN.CHK.DIR,EXTRACT.FILE.ID ELSE NULL          ;* In case if it exisit DELETE, for Safer side
        OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE ELSE        ;* After DELETE file pointer will be closed, hence reopen the file
            CREATE FV.EXTRACT.FILE ELSE OPEN.ERR = 1
        END
    END ELSE
        CREATE FV.EXTRACT.FILE ELSE OPEN.ERR = 1
    END
*
    IF OPEN.ERR THEN
        TEXT = "Unable to Create a File -> ":EXTRACT.FILE.ID
        CALL FATAL.ERROR("DR.REG.RIEN4.REP3")
    END
*
    REP.HEADER = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.REP.HEADER,1>
    WRITESEQ REP.HEADER TO FV.EXTRACT.FILE ELSE NULL
    REP.NAME = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.REP.NAME,3>
    WRITESEQ REP.NAME TO FV.EXTRACT.FILE ELSE NULL
*    REP.DATE = 'FECHA Y HORA : ':TIMEDATE()
    TIME1 = FIELD(TIMEDATE(),' ',1)
    TIME.H = FIELD(TIME1,':',1)
    IF TIME.H LT 12 THEN
        AM.PM = 'am'
    END ELSE
        AM.PM = 'pm'
    END
    TIME.PART = TIME1:' ':AM.PM
    DATE.TIME1 = Y.DATE
    DATE.VAL = DATE.TIME1[7,2]:'/':DATE.TIME1[5,2]:'/':DATE.TIME1[1,4]
    DATE.TIME.VAL = TIME.PART:' ':DATE.VAL
    REP.DATE = 'FECHA Y HORA : ':DATE.TIME.VAL

    WRITESEQ REP.DATE TO FV.EXTRACT.FILE ELSE NULL
    REP.FIELDS = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.REP.FIELDS>
    CHANGE @VM TO '|' IN REP.FIELDS
    WRITESEQ REP.FIELDS TO FV.EXTRACT.FILE ELSE NULL
*
RETURN
*----------------------------------------------------------------------------
SELECT.PROCESS:
*-------------*
*
    TOT.RANGE1 = 0
    TOT.RANGE2 = 0
    TOT.RANGE3 = 0
    TOT.RANGE4 = 0
    TOT.RANGE5 = 0
    TOT.RANGE6 = 0
    TOT.RANGE7 = 0
    TOT.RANGE8 = 0
    TOT.RANGE9 = 0
    TOT.RANGE10 = 0
    TOT.RANGE11 = 0
*
    SEL.CMD1 = ''
    ID.LIST1 = ''
    ID.CNT1 = ''
    ERR.SEL1 = ''
**    SEL.CMD1 = "SELECT ":FN.DR.REG.RIEN4.AZ.REP.OUT3:" BY RATE"
    SEL.CMD1 = "SELECT ":FN.DR.REG.RIEN4.AZ.REP.OUT3:" BY @ID"
    CALL EB.READLIST(SEL.CMD1, ID.LIST1, "", ID.CNT1, ERR.SEL1)
    ID.CTR1 = 1
    LOOP
    WHILE ID.CTR1 LE ID.CNT1
        REC.ID = ID.LIST1<ID.CTR1>
        GOSUB PROCESS
        ID.CTR1 += 1
    REPEAT
*
    CNT.REP.FLD = DCOUNT(REP.FIELDS,'|')
    TOT.TEXT = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.REP.FIELDS,CNT.REP.FLD>
    UNDEFINE = 0
    TOT.TOT = TOT.RANGE1 + TOT.RANGE2 + TOT.RANGE3 + TOT.RANGE4 + TOT.RANGE5 + TOT.RANGE6 + TOT.RANGE7 + TOT.RANGE8 + TOT.RANGE9 + TOT.RANGE10 + TOT.RANGE11
    TOT.VALUE = TOT.TEXT:'|':TOT.RANGE1:'|':TOT.RANGE2:'|':TOT.RANGE3:'|':TOT.RANGE4:'|':TOT.RANGE5:'|':TOT.RANGE6:'|':TOT.RANGE7:'|':TOT.RANGE8:'|':TOT.RANGE9:'|':TOT.RANGE10:'|':TOT.RANGE11:'|':UNDEFINE:'|':TOT.TOT
    WRITESEQ TOT.VALUE TO FV.EXTRACT.FILE ELSE NULL
*
RETURN
*----------------------------------------------------------------------------
PROCESS:
*------*
*
    RANGE1 = ''
    RANGE2 = ''
    RANGE3 = ''
    RANGE4 = ''
    RANGE5 = ''
    RANGE6 = ''
    RANGE7 = ''
    RANGE8 = ''
    RANGE9 = ''
    RANGE10 = ''
    RANGE11 = ''
*
    CALL F.READ(FN.DR.REG.RIEN4.AZ.REP.OUT3,REC.ID,R.DR.REG.RIEN4.AZ.REP.OUT3,F.DR.REG.RIEN4.AZ.REP.OUT3,DR.REG.RIEN4.AZ.REP.OUT3.ERR)
    IF R.DR.REG.RIEN4.AZ.REP.OUT3 THEN
        RANGE1 = R.DR.REG.RIEN4.AZ.REP.OUT3<DR.RIEN4.OUT3.RANGE.0.15>
        IF RANGE1 THEN
            RANGE1 = RANGE1
            TOT.RANGE1 += RANGE1
        END ELSE
            RANGE1 = '0.00'
        END
        RANGE2 = R.DR.REG.RIEN4.AZ.REP.OUT3<DR.RIEN4.OUT3.RANGE.16.30>
        IF RANGE2 THEN
            RANGE2 = RANGE2
            TOT.RANGE2 += RANGE2
        END ELSE
            RANGE2 = '0.00'
        END
        RANGE3 = R.DR.REG.RIEN4.AZ.REP.OUT3<DR.RIEN4.OUT3.RANGE.31.60>
        IF RANGE3 THEN
            RANGE3 = RANGE3
            TOT.RANGE3 += RANGE3
        END ELSE
            RANGE3 = '0.00'
        END
        RANGE4 = R.DR.REG.RIEN4.AZ.REP.OUT3<DR.RIEN4.OUT3.RANGE.61.90>
        IF RANGE4 THEN
            RANGE4 = RANGE4
            TOT.RANGE4 += RANGE4
        END ELSE
            RANGE4 = '0.00'
        END
        RANGE5 = R.DR.REG.RIEN4.AZ.REP.OUT3<DR.RIEN4.OUT3.RANGE.91.180>
        IF RANGE5 THEN
            RANGE5 = RANGE5
            TOT.RANGE5 += RANGE5
        END ELSE
            RANGE5 = '0.00'
        END
        RANGE6 = R.DR.REG.RIEN4.AZ.REP.OUT3<DR.RIEN4.OUT3.RANGE.181.360>
        IF RANGE6 THEN
            RANGE6 = RANGE6
            TOT.RANGE6 += RANGE6
        END ELSE
            RANGE6 = '0.00'
        END
        RANGE7 = R.DR.REG.RIEN4.AZ.REP.OUT3<DR.RIEN4.OUT3.RANGE.361.720>
        IF RANGE7 THEN
            RANGE7 = RANGE7
            TOT.RANGE7 += RANGE7
        END ELSE
            RANGE7 = '0.00'
        END
        RANGE8 = R.DR.REG.RIEN4.AZ.REP.OUT3<DR.RIEN4.OUT3.RANGE.721.1080>
        IF RANGE8 THEN
            RANGE8 = RANGE8
            TOT.RANGE8 += RANGE8
        END ELSE
            RANGE8 = '0.00'
        END
        RANGE9 = R.DR.REG.RIEN4.AZ.REP.OUT3<DR.RIEN4.OUT3.RANGE.1081.1440>
        IF RANGE9 THEN
            RANGE9 = RANGE9
            TOT.RANGE9 += RANGE9
        END ELSE
            RANGE9 = '0.00'
        END
        RANGE10 = R.DR.REG.RIEN4.AZ.REP.OUT3<DR.RIEN4.OUT3.RANGE.1441.1800>
        IF RANGE10 THEN
            RANGE10 = RANGE10
            TOT.RANGE10 += RANGE10
        END ELSE
            RANGE10 = '0.00'
        END
        RANGE11 = R.DR.REG.RIEN4.AZ.REP.OUT3<DR.RIEN4.OUT3.RANGE.1881>
        IF RANGE11 THEN
            RANGE11 = RANGE11
            TOT.RANGE11 += RANGE11
        END ELSE
            RANGE11 = '0.00'
        END
        TOTAL = ''
        UNDEFINE = 0
        TOTAL = RANGE1 + RANGE2 + RANGE3 + RANGE4 + RANGE5 + RANGE6 + RANGE7 + RANGE8 + RANGE9 + RANGE10 + RANGE11
*        RETURN.MSG = REC.ID:'|':RANGE1:'|':RANGE2:'|':RANGE3:'|':RANGE4:'|':RANGE5:'|':RANGE6:'|':RANGE7:'|':RANGE8:'|':RANGE9:'|':RANGE10:'|':RANGE11:'|':TOTAL
        RATE.PER = REC.ID:'%'
        RETURN.MSG = RATE.PER:'|':RANGE1:'|':RANGE2:'|':RANGE3:'|':RANGE4:'|':RANGE5:'|':RANGE6:'|':RANGE7:'|':RANGE8:'|':RANGE9:'|':RANGE10:'|':RANGE11:'|':UNDEFINE:'|':TOTAL
        WRITESEQ RETURN.MSG TO FV.EXTRACT.FILE ELSE NULL
    END
*
RETURN
*----------------------------------------------------------------------------
END
