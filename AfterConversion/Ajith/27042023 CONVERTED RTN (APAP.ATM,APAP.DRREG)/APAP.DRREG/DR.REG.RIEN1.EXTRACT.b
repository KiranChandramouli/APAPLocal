* @ValidationCode : MjotNTczMzg4Njk2OkNwMTI1MjoxNjgyNTcxOTAxNDY2OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Apr 2023 10:35:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
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
*--------------------------------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN1.EXTRACT
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
*
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*06-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*06-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION CALL RTN FORMAT MODIFIED
*----------------------------------------------------------------------------------------





*
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INSERT I_F.DR.REG.RIEN1.PARAM
    $INSERT I_F.DR.REG.RIEN1.CONCAT
    $USING APAP.REDOENQ
*
    GOSUB OPEN.FILES
    GOSUB INIT.PARA
    GOSUB PROCESS.PARA
*
RETURN

*----------------------------------------------------------
OPEN.FILES:
***********

    FN.DR.REG.RIEN1.PARAM = 'F.DR.REG.RIEN1.PARAM'
    F.DR.REG.RIEN1.PARAM = ''
    CALL OPF(FN.DR.REG.RIEN1.PARAM,F.DR.REG.RIEN1.PARAM)

    FN.DR.REG.RIEN1.CONCAT = 'F.DR.REG.RIEN1.CONCAT'
    F.DR.REG.RIEN1.CONCAT = ''
    CALL OPF(FN.DR.REG.RIEN1.CONCAT,F.DR.REG.RIEN1.CONCAT)
*
RETURN
*-------------------------------------------------------------------
INIT.PARA:
**********

*  CALL F.READ(FN.DR.REG.RIEN1.PARAM,'SYSTEM',R.DR.REG.RIEN1.PARAM,F.DR.REG.RIEN1.PARAM,DR.REG.RIEN1.PARAM.ERR) ;*Tus Start
    CALL CACHE.READ(FN.DR.REG.RIEN1.PARAM,'SYSTEM',R.DR.REG.RIEN1.PARAM,DR.REG.RIEN1.PARAM.ERR) ; *Tus End
    FN.CHK.DIR = R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.OUT.PATH>

RETURN

*-------------------------------------------------------------------
OPEN.EXTRACT.FILE:
******************
    OPEN.ERR = ''
    EXTRACT.FILE.ID = R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FILE.NAME>:'_':REC.ID:'.csv'
    OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE THEN
        DELETESEQ FN.CHK.DIR,EXTRACT.FILE.ID ELSE NULL          ;* In case if it exisit DELETE, for Safer side
        OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE ELSE        ;* After DELETE file pointer will be closed, hence reopen the file
            CREATE FV.EXTRACT.FILE ELSE OPEN.ERR = 1
        END
    END ELSE
        CREATE FV.EXTRACT.FILE ELSE OPEN.ERR = 1
    END

    IF OPEN.ERR THEN
        TEXT = "Unable to Create a File -> ":EXTRACT.FILE.ID
        CALL FATAL.ERROR("DR.REG.RIEN1.EXTRACT")
    END

RETURN

*-------------------------------------------------------------------
OPEN.EXTRACT.FILE.APAP:
***********************
    OPEN.ERR = ''
    FV.EXTRACT.FILE = ''
    EXTRACT.FILE.ID = R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FILE.NAME>:'_':REC.ID:'_APAP.csv'
    OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE THEN
        DELETESEQ FN.CHK.DIR,EXTRACT.FILE.ID ELSE NULL          ;* In case if it exisit DELETE, for Safer side
        OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE ELSE        ;* After DELETE file pointer will be closed, hence reopen the file
            CREATE FV.EXTRACT.FILE ELSE OPEN.ERR = 1
        END
    END ELSE
        CREATE FV.EXTRACT.FILE ELSE OPEN.ERR = 1
    END

    IF OPEN.ERR THEN
        TEXT = "Unable to Create a File -> ":EXTRACT.FILE.ID
        CALL FATAL.ERROR("DR.REG.RIEN1.EXTRACT")
    END

RETURN
*---------------------------------------------------------------------
PROCESS.PARA:
*************

    SEL.CMD = "SELECT ":FN.DR.REG.RIEN1.CONCAT
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    LOOP
        REMOVE REC.ID FROM ID.LIST SETTING ID.POS
    WHILE REC.ID:ID.POS
        CALL F.READ(FN.DR.REG.RIEN1.CONCAT, REC.ID, R.REC, FV.DR.REG.RIEN1.CONCAT, RD.ERR)
        GOSUB CALC.STDEV
        GOSUB OPEN.EXTRACT.FILE
        GOSUB WRITE.HEADER
        GOSUB OPEN.EXTRACT.FILE.APAP
        GOSUB WRITE.HEADER.APAP
    REPEAT
*
RETURN
*-------------------------------------------------------------------
WRITE.HEADER.APAP:
*----------------*
*
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.HEAD.NAME,1> TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.HEAD.NAME,2> TO FV.EXTRACT.FILE ELSE NULL
    LAST.WORK.VAL = R.DATES(EB.DAT.LAST.WORKING.DAY)
    LAST.DATE = LAST.WORK.VAL[7,2]:"/":LAST.WORK.VAL[5,2]:"/":LAST.WORK.VAL[1,4]
    REP.DATE = R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.HEAD.NAME,3>:' ':LAST.DATE
    WRITESEQ REP.DATE TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.REP.NAME,2> TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.HEAD.NAME,4>:'(':REC.ID:')' TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,1>:':':P.N TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,2>:':':STDEV TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,3>:':':R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.TRUST.LEVEL> TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,4>:':':F.E TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,5>:':':R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.TIME.COVER> TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,6>:':':MIN.SELL TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.HEAD.NAME,5> TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,7> TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,8>:':':P.N TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,9>:':':TOTAL.VAL1 TO FV.EXTRACT.FILE ELSE NULL

RETURN
*-------------------------------------------------------------------
WRITE.HEADER:
*-----------*
*
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.HEAD.NAME,1> TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.HEAD.NAME,2> TO FV.EXTRACT.FILE ELSE NULL
    LAST.WORK.VAL = R.DATES(EB.DAT.LAST.WORKING.DAY)
    LAST.DATE = LAST.WORK.VAL[7,2]:"/":LAST.WORK.VAL[5,2]:"/":LAST.WORK.VAL[1,4]
    REP.DATE = R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.HEAD.NAME,3>:' ':LAST.DATE
    WRITESEQ REP.DATE TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.REP.NAME,1> TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.HEAD.NAME,4>:'(':REC.ID:')' TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,1>:':':P.N TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,2>:':':STDEV TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,3>:':':R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.TRUST.LEVEL> TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,4>:':':F.E TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,5>:':':R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.TIME.COVER> TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,6>:':':MAX.SELL TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.HEAD.NAME,5> TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,7> TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,8>:':':P.N TO FV.EXTRACT.FILE ELSE NULL
    WRITESEQ R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.FLD.NAME,9>:':':TOTAL.VAL TO FV.EXTRACT.FILE ELSE NULL
*
RETURN
*-------------------------------------------------------------------
CALC.STDEV:
***********
*
    SELL.VAL = R.REC<DR.RIEN1.CONCAT.SELL.RATE>
    CNT.SELL.VAL = DCOUNT(SELL.VAL,@VM)
    LN.SELL = R.REC<DR.RIEN1.CONCAT.LN.SELL>
    SAVE.LN.SELL = LN.SELL
    CNT.LN.SELL = DCOUNT(LN.SELL,@VM)
    CHANGE @VM TO '+' IN LN.SELL
*
    SUM.LN.SELL = LN.SELL/CNT.LN.SELL
    CTR.LN.SELL = 1
    SUM1 = ''
* To calculate the standard deviation, first compute the difference of each data point from the mean, and square the result of each:
    LOOP
    WHILE CTR.LN.SELL LE CNT.LN.SELL
        LN.SELL1 = ''
        LN.SELL1 = R.REC<DR.RIEN1.CONCAT.LN.SELL,CTR.LN.SELL>
        SUM1 += (LN.SELL1 - SUM.LN.SELL)*(LN.SELL1 - SUM.LN.SELL)
        CTR.LN.SELL += 1
    REPEAT
*
    AVG.SUM1 = SUM1/CNT.LN.SELL
    STDEV = DROUND(SQRT(AVG.SUM1))
    TRUST.LEVEL = R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.TRUST.LEVEL>
    F.E = STDEV * TRUST.LEVEL
    T.D = R.DR.REG.RIEN1.PARAM<RIEN1.PARAM.TIME.COVER>
    LAST.SELL = R.REC<DR.RIEN1.CONCAT.SELL.RATE,CNT.SELL.VAL>
    VAR.INT = F.E * LAST.SELL
    MAX.SELL = LAST.SELL + VAR.INT
    MIN.SELL = LAST.SELL - VAR.INT
*CURRENCY = REC.ID
*CALL APAP.REDOENQ.redoNofEnqFxBlotPosn(Y.ARR) ;*R22 MANUAL CODE CONVERSION
    CALL APAP.REDOENQ.redoNofEnqFxBlotPosn(Y.ARR)
  
    P.N = FIELD(Y.ARR,'*',6)
    TOTAL.VAL = (P.N * F.E) * (T.D * 0.5) * MAX.SELL
    TOTAL.VAL1 = (P.N * F.E) * (T.D * 0.5) * MIN.SELL
*
RETURN
*-------------------------------------------------------------------
END
