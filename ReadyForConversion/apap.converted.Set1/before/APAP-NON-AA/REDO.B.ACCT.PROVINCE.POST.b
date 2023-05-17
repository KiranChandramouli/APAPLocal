*-----------------------------------------------------------------------------
* <Rating>-291</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.ACCT.PROVINCE.POST
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      :
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description: This is a .POST Subroutine
*
*-------------------------------------------------------------------------------
* Modification History
* Defect Reference       Modified By                    Date of Change        Change Details
*
*-----------------------------------------------------------------------------------------------------------------
* PACS00365442          Ashokkumar.V.P                  12/12/2014           Corrected the header section and format. Added the footer section.
*-------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.DATES
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT TAM.BP I_REDO.B.ACCT.PROVINCE.COMMON

    GOSUB PROCESS.PARA
    GOSUB FORMAT.HDR.FTR

    RETURN
*-------------------------------------------------------------------------------
PROCESS.PARA:
*------------

    Y.121.ARR = ''; Y.122.ARR = ''; Y.123.ARR = ''; Y.124.ARR = ''; Y.125.ARR = ''; Y.128.ARR = ''
    Y.211.ARR = ''; Y.212.ARR = ''; Y.213.ARR = ''; Y.221.ARR = ''; Y.222.ARR = ''; Y.223.ARR = ''
    Y.REG.1.ROW.ARR = ''; Y.REG.2.ROW.ARR = ''; Y.REG.3.ROW.ARR = ''
    Y.121.REG1.TOT = ''; Y.122.REG1.TOT = ''; Y.123.REG1.TOT = ''; Y.124.REG1.TOT = ''; Y.125.REG1.TOT = ''; Y.128.REG1.TOT = ''
    Y.211.REG1.TOT = ''; Y.212.REG1.TOT = ''; Y.213.REG1.TOT = ''; Y.221.REG1.TOT = ''; Y.222.REG1.TOT = ''; Y.223.REG1.TOT = ''

    Y.121.REG2.TOT = ''; Y.122.REG2.TOT = ''; Y.123.REG2.TOT = ''; Y.124.REG2.TOT = ''; Y.125.REG2.TOT = ''; Y.128.REG2.TOT = ''
    Y.211.REG2.TOT = ''; Y.212.REG2.TOT = ''; Y.213.REG2.TOT = ''; Y.221.REG2.TOT = ''; Y.222.REG2.TOT = ''; Y.223.REG2.TOT = ''

    Y.121.REG3.TOT = ''; Y.122.REG3.TOT = ''; Y.123.REG3.TOT = ''; Y.124.REG3.TOT = ''; Y.125.REG3.TOT = ''; Y.128.REG3.TOT = ''
    Y.211.REG3.TOT = ''; Y.212.REG3.TOT = ''; Y.213.REG3.TOT = ''; Y.221.REG3.TOT = ''; Y.222.REG3.TOT = ''; Y.223.REG3.TOT = ''

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    REDO.H.REPORTS.PARAM.ID = BATCH.DETAILS<3,1,1>

    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)

    IF R.REDO.H.REPORTS.PARAM THEN
        FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        FIELD.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
    END

    LOCATE 'COLUMN' IN Y.FIELD.NAME<1,1> SETTING COL.POS THEN
        Y.COLUMN.ID = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,COL.POS>
        CHANGE SM TO FM IN Y.COLUMN.ID
    END

    LOCATE 'ROW' IN Y.FIELD.NAME<1,1> SETTING ROW.POS THEN
        Y.ROW.ID = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,ROW.POS>
        CHANGE SM TO FM IN Y.ROW.ID
    END

    GOSUB LOCATE.VALUES
    GOSUB SELECT.VALUES
    RETURN
*-------------------------------------------------------------------------------
SELECT.VALUES:
*-------------

    SEL.CMD = "SELECT ":TEMP.PATH:" WITH @ID LIKE ":FILE.NAME:"... AND F1 NE '' SAVING UNIQUE F1"
    SEL.LIST = ''; NO.OF.RECS = ''; SEL.ERR = ''
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)
    Y.ROW = SEL.LIST

    SEL.CMD1 = "SELECT ":TEMP.PATH:" WITH @ID LIKE ":FILE.NAME:"..."
    SEL.LIST1 = ''; NO.OF.RECS1 = ''; SEL.ERR1 = ''
    CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',NO.OF.RECS1,SEL.ERR1)

    Y.TOT.CNT = DCOUNT(SEL.LIST1,@FM)
    FOR Y.CNT = 1 TO Y.TOT.CNT

        Y.PROV.ID.LIST = SEL.LIST1<Y.CNT>

        OPEN TEMP.PATH TO SEQ.PTR.READ THEN
        END
        READ Y.REC FROM SEQ.PTR.READ,Y.PROV.ID.LIST THEN

            Y.FST.FIELD = Y.REC<1>
            Y.SEC.FIELD = Y.REC<2>
            Y.FST.PART = FIELD(Y.SEC.FIELD,"|",1)
            Y.SEC.PART = FIELD(Y.SEC.FIELD,"|",2)
        END

        LOCATE Y.FST.FIELD IN Y.ROW SETTING PROV.POS1 THEN
            BEGIN CASE
            CASE Y.FST.PART EQ '121'
                Y.121.ARR<PROV.POS1> += Y.SEC.PART
            CASE Y.FST.PART EQ '122'
                Y.122.ARR<PROV.POS1> += Y.SEC.PART
            CASE Y.FST.PART EQ '123'
                Y.123.ARR<PROV.POS1> += Y.SEC.PART
            CASE Y.FST.PART EQ '124'
                Y.124.ARR<PROV.POS1> += Y.SEC.PART
            CASE Y.FST.PART EQ '125'
                Y.125.ARR<PROV.POS1> += Y.SEC.PART
            CASE Y.FST.PART EQ '128'
                Y.128.ARR<PROV.POS1> += Y.SEC.PART
            CASE Y.FST.PART EQ '211'
                Y.211.ARR<PROV.POS1> += Y.SEC.PART
            CASE Y.FST.PART EQ '212'
                Y.212.ARR<PROV.POS1> += Y.SEC.PART
            CASE Y.FST.PART EQ '213'
                Y.213.ARR<PROV.POS1> += Y.SEC.PART
            CASE Y.FST.PART EQ '221'
                Y.221.ARR<PROV.POS1> += Y.SEC.PART
            CASE Y.FST.PART EQ '222'
                Y.222.ARR<PROV.POS1> += Y.SEC.PART
            CASE Y.FST.PART EQ '223'
                Y.223.ARR<PROV.POS1> += Y.SEC.PART
            END CASE
        END

    NEXT Y.CNT
    GOSUB REGION1.ARRAY.ROW.COLUMN.TOTAL
    GOSUB REGION2.ARRAY.ROW.COLUMN.TOTAL
    GOSUB REGION3.ARRAY.ROW.COLUMN.TOTAL
    RETURN

*-------------------------------------------------------------------------------
REGION1.ARRAY.ROW.COLUMN.TOTAL:
*------------------------------
    Y.ZERO1 = '0.00'
    Y.ROW1.CNT = DCOUNT(Y.ROW.1,FM)
    Y.CNT1 = 1
    LOOP WHILE Y.CNT1 LE Y.ROW1.CNT
        Y.ROW.1.VAL = Y.ROW.1<Y.CNT1>
        Y.ROW1.TITL = Y.ROW1.TITLE<Y.CNT1>
        LOCATE Y.ROW.1.VAL IN Y.ROW SETTING ROW1.POS THEN
            Y.PESTO.ROW.TOT = Y.121.ARR<ROW1.POS> + Y.122.ARR<ROW1.POS> + Y.123.ARR<ROW1.POS> + Y.124.ARR<ROW1.POS> + Y.125.ARR<ROW1.POS> + Y.128.ARR<ROW1.POS>
            Y.DEPOS.ROW.TOT = Y.211.ARR<ROW1.POS> + Y.212.ARR<ROW1.POS> + Y.213.ARR<ROW1.POS> + Y.221.ARR<ROW1.POS> + Y.222.ARR<ROW1.POS> + Y.223.ARR<ROW1.POS>
            Y.REG.1.ARR  = Y.ROW.1.VAL:'|':Y.ROW1.TITL:'|':FMT(ABS(Y.121.ARR<ROW1.POS>),"R2,"):'|':FMT(ABS(Y.122.ARR<ROW1.POS>),"R2,"):'|':FMT(ABS(Y.123.ARR<ROW1.POS>),"R2,"):'|':
            Y.REG.1.ARR := FMT(ABS(Y.124.ARR<ROW1.POS>),"R2,"):'|':FMT(ABS(Y.125.ARR<ROW1.POS>),"R2,"):'|':FMT(ABS(Y.128.ARR<ROW1.POS>),"R2,"):'|':FMT(Y.ZERO1,"R2,"):'|':FMT(ABS(Y.PESTO.ROW.TOT),"R2,"):'|':
            Y.REG.1.ARR := FMT(ABS(Y.211.ARR<ROW1.POS>),"R2,"):'|':FMT(ABS(Y.212.ARR<ROW1.POS>),"R2,"):'|':FMT(ABS(Y.213.ARR<ROW1.POS>),"R2,"):'|':FMT(ABS(Y.221.ARR<ROW1.POS>),"R2,"):'|':FMT(ABS(Y.222.ARR<ROW1.POS>),"R2,"):'|':
            Y.REG.1.ARR := FMT(ABS(Y.223.ARR<ROW1.POS>),"R2,"):'|':FMT(Y.ZERO1,"R2,"):'|':FMT(ABS(Y.DEPOS.ROW.TOT),"R2,")
            Y.REG.1.ROW.ARR<-1> = Y.REG.1.ARR
        END
        Y.121.REG1.TOT += Y.121.ARR<ROW1.POS>
        Y.122.REG1.TOT += Y.122.ARR<ROW1.POS>
        Y.123.REG1.TOT += Y.123.ARR<ROW1.POS>
        Y.124.REG1.TOT += Y.124.ARR<ROW1.POS>
        Y.125.REG1.TOT += Y.125.ARR<ROW1.POS>
        Y.128.REG1.TOT += Y.128.ARR<ROW1.POS>
        Y.211.REG1.TOT += Y.211.ARR<ROW1.POS>
        Y.212.REG1.TOT += Y.212.ARR<ROW1.POS>
        Y.213.REG1.TOT += Y.213.ARR<ROW1.POS>
        Y.221.REG1.TOT += Y.221.ARR<ROW1.POS>
        Y.222.REG1.TOT += Y.222.ARR<ROW1.POS>
        Y.223.REG1.TOT += Y.223.ARR<ROW1.POS>

        Y.CNT1 += 1
    REPEAT

    Y.PREST.REG1.TOT  = Y.121.REG1.TOT+Y.122.REG1.TOT+Y.123.REG1.TOT+Y.124.REG1.TOT+Y.125.REG1.TOT+Y.128.REG1.TOT
    Y.DEPOS.REG1.TOT  = Y.211.REG1.TOT+Y.212.REG1.TOT+Y.213.REG1.TOT+Y.221.REG1.TOT+Y.222.REG1.TOT+Y.223.REG1.TOT

    RETURN

*-------------------------------------------------------------------------------
REGION2.ARRAY.ROW.COLUMN.TOTAL:
*------------------------------
    Y.ZERO2 = '0.00'
    Y.ROW2.CNT = DCOUNT(Y.ROW.2,FM)
    Y.CNT2 = 1
    LOOP WHILE Y.CNT2 LE Y.ROW2.CNT
        Y.ROW.2.VAL = Y.ROW.2<Y.CNT2>
        Y.ROW2.TITL = Y.ROW2.TITLE<Y.CNT2>
        LOCATE Y.ROW.2.VAL IN Y.ROW SETTING ROW2.POS THEN
            Y.PESTO.ROW.TOT = Y.121.ARR<ROW2.POS> + Y.122.ARR<ROW2.POS> + Y.123.ARR<ROW2.POS> + Y.124.ARR<ROW2.POS> + Y.125.ARR<ROW2.POS> + Y.128.ARR<ROW2.POS>
            Y.DEPOS.ROW.TOT = Y.211.ARR<ROW2.POS> + Y.212.ARR<ROW2.POS> + Y.213.ARR<ROW2.POS> + Y.221.ARR<ROW2.POS> + Y.222.ARR<ROW2.POS> + Y.223.ARR<ROW2.POS>
            Y.REG.2.ARR  = Y.ROW.2.VAL:'|':Y.ROW2.TITL:'|':FMT(ABS(Y.121.ARR<ROW2.POS>),"R2,"):'|':FMT(ABS(Y.122.ARR<ROW2.POS>),"R2,"):'|':FMT(ABS(Y.123.ARR<ROW2.POS>),"R2,"):'|':
            Y.REG.2.ARR := FMT(ABS(Y.124.ARR<ROW2.POS>),"R2,"):'|':FMT(ABS(Y.125.ARR<ROW2.POS>),"R2,"):'|':FMT(ABS(Y.128.ARR<ROW2.POS>),"R2,"):'|':FMT(Y.ZERO2,"R2,"):'|':FMT(ABS(Y.PESTO.ROW.TOT),"R2,"):'|':
            Y.REG.2.ARR := FMT(ABS(Y.211.ARR<ROW2.POS>),"R2,"):'|':FMT(ABS(Y.212.ARR<ROW2.POS>),"R2,"):'|':FMT(ABS(Y.213.ARR<ROW2.POS>),"R2,"):'|':FMT(ABS(Y.221.ARR<ROW2.POS>),"R2,"):'|':FMT(ABS(Y.222.ARR<ROW2.POS>),"R2,"):'|':
            Y.REG.2.ARR := FMT(ABS(Y.223.ARR<ROW2.POS>),"R2,"):'|':FMT(Y.ZERO2,"R2,"):'|':FMT(ABS(Y.DEPOS.ROW.TOT),"R2,")
            Y.REG.2.ROW.ARR<-1> = Y.REG.2.ARR
        END
        Y.121.REG2.TOT += Y.121.ARR<ROW2.POS>
        Y.122.REG2.TOT += Y.122.ARR<ROW2.POS>
        Y.123.REG2.TOT += Y.123.ARR<ROW2.POS>
        Y.124.REG2.TOT += Y.124.ARR<ROW2.POS>
        Y.125.REG2.TOT += Y.125.ARR<ROW2.POS>
        Y.128.REG2.TOT += Y.128.ARR<ROW2.POS>
        Y.211.REG2.TOT += Y.211.ARR<ROW2.POS>
        Y.212.REG2.TOT += Y.212.ARR<ROW2.POS>
        Y.213.REG2.TOT += Y.213.ARR<ROW2.POS>
        Y.221.REG2.TOT += Y.221.ARR<ROW2.POS>
        Y.222.REG2.TOT += Y.222.ARR<ROW2.POS>
        Y.223.REG2.TOT += Y.223.ARR<ROW2.POS>

        Y.CNT2 += 1
    REPEAT

    Y.PREST.REG2.TOT  = Y.121.REG2.TOT+Y.122.REG2.TOT+Y.123.REG2.TOT+Y.124.REG2.TOT+Y.125.REG2.TOT+Y.128.REG2.TOT
    Y.DEPOS.REG2.TOT  = Y.211.REG2.TOT+Y.212.REG2.TOT+Y.213.REG2.TOT+Y.221.REG2.TOT+Y.222.REG2.TOT+Y.223.REG2.TOT

    RETURN

*-------------------------------------------------------------------------------
REGION3.ARRAY.ROW.COLUMN.TOTAL:
*------------------------------
    Y.ZERO3 = '0.00'
    Y.ROW3.CNT = DCOUNT(Y.ROW.3,FM)
    Y.CNT3 = 1
    LOOP WHILE Y.CNT3 LE Y.ROW3.CNT
        Y.ROW.3.VAL = Y.ROW.3<Y.CNT3>
        Y.ROW3.TITL = Y.ROW3.TITLE<Y.CNT3>
        LOCATE Y.ROW.3.VAL IN Y.ROW SETTING ROW3.POS THEN
            Y.PESTO.ROW.TOT = Y.121.ARR<ROW3.POS> + Y.122.ARR<ROW3.POS> + Y.123.ARR<ROW3.POS> + Y.124.ARR<ROW3.POS> + Y.125.ARR<ROW3.POS> + Y.128.ARR<ROW3.POS>
            Y.DEPOS.ROW.TOT = Y.211.ARR<ROW3.POS> + Y.212.ARR<ROW3.POS> + Y.213.ARR<ROW3.POS> + Y.221.ARR<ROW3.POS> + Y.222.ARR<ROW3.POS> + Y.223.ARR<ROW3.POS>
            Y.REG.3.ARR  = Y.ROW.3.VAL:'|':Y.ROW3.TITL:'|':FMT(ABS(Y.121.ARR<ROW3.POS>),"R2,"):'|':FMT(ABS(Y.122.ARR<ROW3.POS>),"R2,"):'|':FMT(ABS(Y.123.ARR<ROW3.POS>),"R2,"):'|':
            Y.REG.3.ARR := FMT(ABS(Y.124.ARR<ROW3.POS>),"R2,"):'|':FMT(ABS(Y.125.ARR<ROW3.POS>),"R2,"):'|':FMT(ABS(Y.128.ARR<ROW3.POS>),"R2,"):'|':FMT(Y.ZERO3,"R2,"):'|':FMT(ABS(Y.PESTO.ROW.TOT),"R2,"):'|':
            Y.REG.3.ARR := FMT(ABS(Y.211.ARR<ROW3.POS>),"R2,"):'|':FMT(ABS(Y.212.ARR<ROW3.POS>),"R2,"):'|':FMT(ABS(Y.213.ARR<ROW3.POS>),"R2,"):'|':FMT(ABS(Y.221.ARR<ROW3.POS>),"R2,"):'|':FMT(ABS(Y.222.ARR<ROW3.POS>),"R2,"):'|':
            Y.REG.3.ARR := FMT(ABS(Y.223.ARR<ROW3.POS>),"R2,"):'|':FMT(Y.ZERO3,"R2,"):'|':FMT(ABS(Y.DEPOS.ROW.TOT),"R2,")
            Y.REG.3.ROW.ARR<-1> = Y.REG.3.ARR
        END
        Y.121.REG3.TOT += Y.121.ARR<ROW3.POS>
        Y.122.REG3.TOT += Y.122.ARR<ROW3.POS>
        Y.123.REG3.TOT += Y.123.ARR<ROW3.POS>
        Y.124.REG3.TOT += Y.124.ARR<ROW3.POS>
        Y.125.REG3.TOT += Y.125.ARR<ROW3.POS>
        Y.128.REG3.TOT += Y.128.ARR<ROW3.POS>
        Y.211.REG3.TOT += Y.211.ARR<ROW3.POS>
        Y.212.REG3.TOT += Y.212.ARR<ROW3.POS>
        Y.213.REG3.TOT += Y.213.ARR<ROW3.POS>
        Y.221.REG3.TOT += Y.221.ARR<ROW3.POS>
        Y.222.REG3.TOT += Y.222.ARR<ROW3.POS>
        Y.223.REG3.TOT += Y.223.ARR<ROW3.POS>

        Y.CNT3 += 1
    REPEAT

    Y.PREST.REG3.TOT  = Y.121.REG3.TOT+Y.122.REG3.TOT+Y.123.REG3.TOT+Y.124.REG3.TOT+Y.125.REG3.TOT+Y.128.REG3.TOT
    Y.DEPOS.REG3.TOT  = Y.211.REG3.TOT+Y.212.REG3.TOT+Y.213.REG3.TOT+Y.221.REG3.TOT+Y.222.REG3.TOT+Y.223.REG3.TOT

    RETURN

*-------------------------------------------------------------------------------
LOCATE.VALUES:
*-------------
*
    LOCATE 'HEADER.LOAN' IN Y.FIELD.NAME<1,1> SETTING LOAN.POS THEN
        HEAD.LOAN = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,LOAN.POS>
        HEAD.CODE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,LOAN.POS>
        CHANGE SM TO FM IN HEAD.LOAN
        CHANGE SM TO FM IN HEAD.CODE
        Y.HEAD.LN = HEAD.LOAN<1>
        Y.HEAD.TL.1 = HEAD.CODE<1>
        Y.HEAD.TL.2 = HEAD.CODE<2>
        Y.HEAD.TL.3 = HEAD.CODE<3>
        Y.HEAD.TL.4 = HEAD.CODE<4>
        Y.HEAD.TL.5 = HEAD.CODE<5>
        Y.HEAD.TL.6 = HEAD.CODE<6>
    END
    LOCATE 'HEADER.DEPO' IN Y.FIELD.NAME<1,1> SETTING DEPO.POS THEN
        HEAD.DEPO = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,DEPO.POS>
        HEAD.COD1 = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,DEPO.POS>
        CHANGE SM TO FM IN HEAD.DEPO
        CHANGE SM TO FM IN HEAD.COD1
        Y.HEAD.DE = HEAD.DEPO<1>
        Y.HEAD.TD.1 = HEAD.COD1<1>
        Y.HEAD.TD.2 = HEAD.COD1<2>
        Y.HEAD.TD.3 = HEAD.COD1<3>
        Y.HEAD.TD.4 = HEAD.COD1<4>
        Y.HEAD.TD.5 = HEAD.COD1<5>
        Y.HEAD.TD.6 = HEAD.COD1<6>
    END
    LOCATE 'REGION' IN Y.FIELD.NAME<1,1> SETTING REG.POS THEN
        REGION.NO = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,REG.POS>
        REGION.TITLE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,REG.POS>
        CHANGE SM TO FM IN REGION.NO
        CHANGE SM TO FM IN REGION.TITLE
        Y.REGION.NO.1 = REGION.NO<1>
        Y.REGION.NO.2 = REGION.NO<2>
        Y.REGION.NO.3 = REGION.NO<3>
        Y.REGION.TL.1 = REGION.TITLE<1>
        Y.REGION.TL.2 = REGION.TITLE<2>
        Y.REGION.TL.3 = REGION.TITLE<3>
    END
    LOCATE 'REGION1' IN Y.FIELD.NAME<1,1> SETTING REG1.POS THEN
        REG1.PROV  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,REG1.POS>
        REG1.TITLE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,REG1.POS>
        CHANGE SM TO FM IN REG1.PROV
        CHANGE SM TO FM IN REG1.TITLE
        Y.ROW.1 = REG1.PROV
        Y.ROW1.TITLE = REG1.TITLE
    END
    LOCATE 'REGION2' IN Y.FIELD.NAME<1,1> SETTING REG2.POS THEN
        REG2.PROV  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,REG2.POS>
        REG2.TITLE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,REG2.POS>
        CHANGE SM TO FM IN REG2.PROV
        CHANGE SM TO FM IN REG2.TITLE
        Y.ROW.2 = REG2.PROV
        Y.ROW2.TITLE = REG2.TITLE
    END
    LOCATE 'REGION3' IN Y.FIELD.NAME<1,1> SETTING REG3.POS THEN
        REG3.PROV  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,REG3.POS>
        REG3.TITLE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,REG3.POS>
        CHANGE SM TO FM IN REG3.PROV
        CHANGE SM TO FM IN REG3.TITLE
        Y.ROW.3 = REG3.PROV
        Y.ROW3.TITLE = REG3.TITLE
    END

    RETURN
*-------------------------------------------------------------------------------
FORMAT.HDR.FTR:
*--------------
    Y.TODAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YACT.DATE = Y.TODAY[7,2]:"-":Y.TODAY[5,2]:"-":Y.TODAY[1,4]

    Y.ZERO = '0.00'
    Y.REP.HDR = ''

    Y.REP.HDR<-1> = '|                  Banco Central de la Republica Dominicana'
    Y.REP.HDR<-1> = '|        Departamento de Programacion Monetaria y Estudios Economicos'
    Y.REP.HDR<-1> = '|            Division de Consolidacion de Estadasticas Monetarias'
    Y.REP.HDR<-1> = 'Entidad Financiera:| Asociacion Popular de Ahorros y Prestamos'
    Y.REP.HDR<-1> = 'Fecha:| ':YACT.DATE


    Y.HDR1  = 'Detalles':'|':'':'|':'':'|':'':'|':Y.HEAD.LN:'|':'':'|':'':'|':'':'|':'':'|':
    Y.HDR1 := '':'|':'':'|':'':'|':Y.HEAD.DE:'|':'':'|':'':'|':'':'|':''
    Y.HDR2  = '':'|':Y.HEAD.TL.1:'|':Y.HEAD.TL.2:'|':Y.HEAD.TL.3:'|':Y.HEAD.TL.4:'|':Y.HEAD.TL.5:'|':Y.HEAD.TL.6:'|':
    Y.HDR2 := 'De No Residente':'|':'Total':'|':Y.HEAD.TD.1:'|':Y.HEAD.TD.2:'|':Y.HEAD.TD.3:'|':Y.HEAD.TD.4:'|':Y.HEAD.TD.5:'|':
    Y.HDR2 := Y.HEAD.TD.6:'|':'De No Residente':'|':'Total'
    Y.HDR.REG1  = Y.REGION.TL.1:'|':FMT(ABS(Y.121.REG1.TOT),"R2,"):'|':FMT(ABS(Y.122.REG1.TOT),"R2,"):'|':FMT(ABS(Y.123.REG1.TOT),"R2,"):'|':FMT(ABS(Y.124.REG1.TOT),"R2,"):'|':FMT(ABS(Y.125.REG1.TOT),"R2,"):'|':
    Y.HDR.REG1 := FMT(ABS(Y.128.REG1.TOT),"R2,"):'|':FMT(Y.ZERO,"R2,"):'|':FMT(ABS(Y.PREST.REG1.TOT),"R2,"):'|':FMT(ABS(Y.211.REG1.TOT),"R2,"):'|':FMT(ABS(Y.212.REG1.TOT),"R2,"):'|':FMT(ABS(Y.213.REG1.TOT),"R2,"):'|':
    Y.HDR.REG1 := FMT(ABS(Y.221.REG1.TOT),"R2,"):'|':FMT(ABS(Y.222.REG1.TOT),"R2,"):'|':FMT(ABS(Y.223.REG1.TOT),"R2,"):'|':FMT(Y.ZERO,"R2,"):'|':FMT(ABS(Y.DEPOS.REG1.TOT),"R2,")

    Y.HDR.REG2  = Y.REGION.TL.2:'|':FMT(ABS(Y.121.REG2.TOT),"R2,"):'|':FMT(ABS(Y.122.REG2.TOT),"R2,"):'|':FMT(ABS(Y.123.REG2.TOT),"R2,"):'|':FMT(Y.124.REG2.TOT,"R2,"):'|':FMT(Y.125.REG2.TOT,"R2,"):'|':
    Y.HDR.REG2 := FMT(ABS(Y.128.REG2.TOT),"R2,"):'|':FMT(Y.ZERO,"R2,"):'|':FMT(ABS(Y.PREST.REG2.TOT),"R2,"):'|':FMT(ABS(Y.211.REG2.TOT),"R2,"):'|':FMT(ABS(Y.212.REG2.TOT),"R2,"):'|':FMT(ABS(Y.213.REG2.TOT),"R2,"):'|':
    Y.HDR.REG2 := FMT(ABS(Y.221.REG2.TOT),"R2,"):'|':FMT(ABS(Y.222.REG2.TOT),"R2,"):'|':FMT(ABS(Y.223.REG2.TOT),"R2,"):'|':FMT(Y.ZERO,"R2,"):'|':FMT(ABS(Y.DEPOS.REG2.TOT),"R2,")

    Y.HDR.REG3  = Y.REGION.TL.3:'|':FMT(ABS(Y.121.REG3.TOT),"R2,"):'|':FMT(ABS(Y.122.REG3.TOT),"R2,"):'|':FMT(ABS(Y.123.REG3.TOT),"R2,"):'|':FMT(ABS(Y.124.REG3.TOT),"R2,"):'|':FMT(ABS(Y.125.REG3.TOT),"R2,"):'|':
    Y.HDR.REG3 := FMT(ABS(Y.128.REG3.TOT),"R2,"):'|':FMT(Y.ZERO,"R2,"):'|':FMT(ABS(Y.PREST.REG3.TOT),"R2,"):'|':FMT(ABS(Y.211.REG3.TOT),"R2,"):'|':FMT(ABS(Y.212.REG3.TOT),"R2,"):'|':FMT(ABS(Y.213.REG3.TOT),"R2,"):'|':
    Y.HDR.REG3 := FMT(ABS(Y.221.REG3.TOT),"R2,"):'|':FMT(ABS(Y.222.REG3.TOT),"R2,"):'|':FMT(ABS(Y.223.REG3.TOT),"R2,"):'|':FMT(Y.ZERO,"R2,"):'|':FMT(ABS(Y.DEPOS.REG3.TOT),"R2,")

    Y.FTR.PREST.TOTAL = Y.PREST.REG1.TOT + Y.PREST.REG2.TOT + Y.PREST.REG3.TOT
    Y.FTR.DEPOS.TOTAL = Y.DEPOS.REG1.TOT + Y.DEPOS.REG2.TOT + Y.DEPOS.REG3.TOT

    Y.FTR.SUM.121 = Y.121.REG1.TOT + Y.121.REG2.TOT + Y.121.REG3.TOT
    Y.FTR.SUM.122 = Y.122.REG1.TOT + Y.122.REG2.TOT + Y.122.REG3.TOT
    Y.FTR.SUM.123 = Y.123.REG1.TOT + Y.123.REG2.TOT + Y.123.REG3.TOT
    Y.FTR.SUM.124 = Y.124.REG1.TOT + Y.124.REG2.TOT + Y.124.REG3.TOT
    Y.FTR.SUM.125 = Y.125.REG1.TOT + Y.125.REG2.TOT + Y.125.REG3.TOT
    Y.FTR.SUM.128 = Y.128.REG1.TOT + Y.128.REG2.TOT + Y.128.REG3.TOT

    Y.FTR.SUM.211 = Y.211.REG1.TOT + Y.211.REG2.TOT + Y.211.REG3.TOT
    Y.FTR.SUM.212 = Y.212.REG1.TOT + Y.212.REG2.TOT + Y.212.REG3.TOT
    Y.FTR.SUM.213 = Y.213.REG1.TOT + Y.213.REG2.TOT + Y.213.REG3.TOT
    Y.FTR.SUM.221 = Y.221.REG1.TOT + Y.221.REG2.TOT + Y.221.REG3.TOT
    Y.FTR.SUM.222 = Y.222.REG1.TOT + Y.222.REG2.TOT + Y.222.REG3.TOT
    Y.FTR.SUM.223 = Y.223.REG1.TOT + Y.223.REG2.TOT + Y.223.REG3.TOT

    Y.FTR.TOTAL  = '':'|':'TOTAL GENERAL':'|':FMT(ABS(Y.FTR.SUM.121),"R2,"):'|':FMT(ABS(Y.FTR.SUM.122),"R2,"):'|':FMT(ABS(Y.FTR.SUM.123),"R2,"):'|':FMT(ABS(Y.FTR.SUM.124),"R2,"):'|':FMT(ABS(Y.FTR.SUM.125),"R2,"):'|':
    Y.FTR.TOTAL := FMT(ABS(Y.FTR.SUM.128),"R2,"):'|':FMT(Y.ZERO,"R2,"):'|':FMT(ABS(Y.FTR.PREST.TOTAL),"R2,"):'|':FMT(ABS(Y.FTR.SUM.211),"R2,"):'|':FMT(ABS(Y.FTR.SUM.212),"R2,"):'|':FMT(ABS(Y.FTR.SUM.213),"R2,"):'|':
    Y.FTR.TOTAL := FMT(ABS(Y.FTR.SUM.221),"R2,"):'|':FMT(ABS(Y.FTR.SUM.222),"R2,"):'|':FMT(ABS(Y.FTR.SUM.223),"R2,"):'|':FMT(Y.ZERO,"R2,"):'|':FMT(ABS(Y.FTR.DEPOS.TOTAL),"R2,")

    Y.FOOTER  = 'ANALITICO MENSUAL ENVIADO A BANCARIO EN LINEAS':'|':'':'|':'':'|':'':'|':'':'|':'':'|':'':'|':'':'|':'':'|':
    Y.FOOTER := '':'|':'':'|':'':'|':'':'|':'':'|':'':'|':'':'|':''

    Y.FINAL  = Y.REP.HDR:FM:' ':FM:Y.HDR1:FM:Y.HDR2:FM:Y.HDR.REG1:FM:' ':FM:Y.REG.1.ROW.ARR:FM:' ':FM:Y.HDR.REG2:FM:' ':FM:Y.REG.2.ROW.ARR:FM:' ':FM:
    Y.FINAL := Y.HDR.REG3:FM:' ':FM:Y.REG.3.ROW.ARR:FM:' ':FM:Y.FTR.TOTAL:FM:' ':FM:Y.FOOTER

    OPEN OUT.PATH TO OUT.PATH1 THEN
        WRITE Y.FINAL ON OUT.PATH1, FILE.NAME
    END

    LOOP
        REMOVE REC.ID2 FROM SEL.LIST1 SETTING SEL.POS2
    WHILE REC.ID2:SEL.POS2
        OPEN TEMP.PATH TO DEL.TEMP.PATH THEN
        END
        DELETE DEL.TEMP.PATH,REC.ID2
    REPEAT

    RETURN
END
