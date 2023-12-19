* @ValidationCode : MjoxNzI3MzYwNDI2OkNwMTI1MjoxNzAyOTYzOTg5NzkzOjMzM3N1Oi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 11:03:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN4.REP5
*----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN4.REP5
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


*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.DATES
*
    $INSERT I_F.DR.REG.RIEN4.PARAM
    $INSERT I_F.DR.REG.RIEN4.AC.REP1
    
    
*
    GOSUB OPEN.FILES
    GOSUB SELECT.PROCESS
*
RETURN
*----------------------------------------------------------------------------
OPEN.FILES:
*---------*
*
    FN.DR.REG.RIEN4.AZ.REP.OUT = 'F.DR.REG.RIEN4.AC.REP1'
    F.DR.REG.RIEN4.AZ.REP.OUT = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP.OUT,F.DR.REG.RIEN4.AZ.REP.OUT)

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
    EXTRACT.FILE.ID = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.FILE.NAME>:'_':R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.REP.NAME,5>:'_':Y.DATE:'.csv'
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
        CALL FATAL.ERROR("DR.REG.RIEN4.AZ.REP1.POST")
    END
*
    REP.HEADER = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.REP.HEADER,1>
    WRITESEQ REP.HEADER TO FV.EXTRACT.FILE ELSE NULL
    REP.NAME = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.REP.NAME,5>
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
    REP.FIELDS = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.AC.REP.FIELDS>
    CHANGE @VM TO '|' IN REP.FIELDS
    WRITESEQ REP.FIELDS TO FV.EXTRACT.FILE ELSE NULL
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
    SEL.CMD1 = "SELECT ":FN.DR.REG.RIEN4.AZ.REP.OUT:" WITH TOTAL NE '' BY INT.RATE"
    CALL EB.READLIST(SEL.CMD1, ID.LIST1, "", ID.CNT1, ERR.SEL1)
    COL.TOTAL = ''
    ID.CTR1 = 1
    LOOP
    WHILE ID.CTR1 LE ID.CNT1
        REC.ID = ID.LIST1<ID.CTR1>
        GOSUB PROCESS
        ID.CTR1 += 1
    REPEAT
    TOT.TEXT = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.AC.REP.FIELDS,14>
**    LAST.LINE = TOT.TEXT:'|':RANGE1:'|':RANGE2:'|':RANGE3:'|':RANGE4:'|':RANGE5:'|':RANGE6:'|':RANGE7:'|':RANGE8:'|':RANGE9:'|':RANGE10:'|':RANGE11:'|':COL.TOTAL:'|':COL.TOTAL
    LAST.LINE = TOT.TEXT:'|':COL.TOTAL:'|':RANGE2:'|':RANGE3:'|':RANGE4:'|':RANGE5:'|':RANGE6:'|':RANGE7:'|':RANGE8:'|':RANGE9:'|':RANGE10:'|':RANGE11:'|':UNDEFINE:'|':COL.TOTAL
    WRITESEQ LAST.LINE TO FV.EXTRACT.FILE ELSE NULL
*
RETURN
*----------------------------------------------------------------------------
PROCESS:
*------*
*
    CALL F.READ(FN.DR.REG.RIEN4.AZ.REP.OUT,REC.ID,R.DR.REG.RIEN4.AZ.REP.OUT,F.DR.REG.RIEN4.AZ.REP.OUT,DR.REG.RIEN4.AZ.REP.OUT.ERR)
    IF R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.AC1.INT.RATE> THEN
**        RANGE1 = '0.00'
        RANGE1 = R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.AC1.TOTAL>
        RANGE2 = '0.00'
        RANGE3 = '0.00'
        RANGE4 = '0.00'
        RANGE5 = '0.00'
        RANGE6 = '0.00'
        RANGE7 = '0.00'
        RANGE8 = '0.00'
        RANGE9 = '0.00'
        RANGE10 = '0.00'
        RANGE11 = '0.00'
        UNDEFINE = '0.00'
**        UNDEFINE = R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.AC1.TOTAL>
        RATE = R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.AC1.INT.RATE,1>:'%'
**        RETURN.MSG = RATE:'|':RANGE1:'|':RANGE2:'|':RANGE3:'|':RANGE4:'|':RANGE5:'|':RANGE6:'|':RANGE7:'|':RANGE8:'|':RANGE9:'|':RANGE10:'|':RANGE11:'|':UNDEFINE:'|':UNDEFINE
        RETURN.MSG = RATE:'|':RANGE1:'|':RANGE2:'|':RANGE3:'|':RANGE4:'|':RANGE5:'|':RANGE6:'|':RANGE7:'|':RANGE8:'|':RANGE9:'|':RANGE10:'|':RANGE11:'|':UNDEFINE:'|':RANGE1
        WRITESEQ RETURN.MSG TO FV.EXTRACT.FILE ELSE NULL
**        COL.TOTAL += UNDEFINE
        COL.TOTAL += RANGE1
    END
*
RETURN
*----------------------------------------------------------------------------
END
