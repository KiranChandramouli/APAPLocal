SUBROUTINE REDO.APAP.SAP.GL.DETAIL.RPT(GIT.MAP.VALUE,CONV.ERR)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.SAP.GL.DETAIL.RPT
*--------------------------------------------------------------------------------------------------------
*Description  :This routine is used to get detail report of all the transactions for the given day
*Linked With  : GIT.INTERFACE.OUT id SAP.DETAIL.RPT
*In Parameter : GIT.MAP.VALUE -- contains the RE.STAT.LINE.BAL id
*Out Parameter: GIT.MAP.VALUE -- contains the list of values which are to be passsed to the out file
*               CONV.ERR      -- contains the error message
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 19 OCT  2010    Mohammed Anies K      ODR-2009-12-0294 C.12         Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RE.STAT.LINE.CONT
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.RE.CONSOL.SPEC.ENTRY
    $INSERT I_F.COMPANY
    $INSERT I_F.DATES
    $INSERT I_GIT.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.TRANSACTION
    $INSERT I_F.RE.TXN.CODE
    $INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
    $INSERT I_F.REDO.GL.W.EXTRACT.ONLINE
    $INSERT I_F.REDO.INTRF.REP.LINE
    $INSERT I_F.REDO.CAPL.L.RE.STAT.LINE.CONT
    $INSERT I_GIT.ONLINE.VAR
    $INSERT I_REDO.B.SAP.VAL.COMMON
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB INIT.PARA
    GOSUB GET.PARAM.DETAILS
    GOSUB PROCESS.PARA

    GIT.MAP.VALUE = Y.FT.OUT.LIST
RETURN
*--------------------------------------------------------------------------------------------------------
***********
INIT.PARA:
***********

    Y.FLD.DELIM = '*'
    Y.REC.DELIM = '#'
    Y.RE.STAT.LINE.BAL.ID = GIT.MAP.VALUE
    Y.FT.OUT.LIST = ''
    R.REDO.GL.H.EXTRACT.PARAMETER = ''
    R.RE.STAT.REP.LINE = ''
    R.RE.CONSOL.STMT.ENT.KEY = ''
    R.RE.CONSOL.SPEC.ENT.KEY = ''
    R.RE.CONSOL.PROFIT = ''
    R.RE.STAT.LINE.CONT  = ''
RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.PARAM.DETAILS:
*****************

    IF R.REDO.GL.H.EXTRACT.PARAMETER THEN

        Y.GIT.NAME.LIST = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.GIT.ROUTINE>
        LOCATE GIT.COM.OUT.INT.ID IN Y.GIT.NAME.LIST<1,1> SETTING Y.GIT.NAME.POS THEN

            REPORT.AL = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.REPORT.AL,Y.GIT.NAME.POS>
            REPORT.PL = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.REPORT.PL,Y.GIT.NAME.POS>
            DESCRIPTION.POS = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.GL.DESCRIPTION,Y.GIT.NAME.POS>
            N.GL.IND.POS = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.N.GL.IND,Y.GIT.NAME.POS>
            Y.PARAM.CREDIT.FORMAT = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.CREDIT.FORMAT,Y.GIT.NAME.POS>
            Y.PARAM.DEBIT.FORMAT =  R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.DEBIT.FORMAT,Y.GIT.NAME.POS>

            Y.IGN.STMT.TXN.CODES = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.STMT.TXN.CODE,Y.GIT.NAME.POS>
            Y.IGN.SPEC.TXN.CODES = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.RECSLE.TXN.CODE,Y.GIT.NAME.POS>
            Y.IGN.CATEG.TXN.CODES = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.CATEG.TXN.CODE,Y.GIT.NAME.POS>
        END
    END

    IF R.REDO.GL.W.EXTRACT.ONLINE THEN
        EXT.DATE = R.REDO.GL.W.EXTRACT.ONLINE<SAP.GL.EO.ACTION.DATE>
    END

    GOSUB GET.SAP.ACCOUNT.NUMBER

RETURN
*--------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
************

    IF RUNNING.UNDER.BATCH THEN
        PROCESS.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    END ELSE
        PROCESS.DATE = EXT.DATE
        IF PROCESS.DATE EQ "" THEN
            PROCESS.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
        END
    END

    Y.CLOSE.DATE = PROCESS.DATE

    Y.RE.STAT.LINE.BAL.REPORT = FIELD(Y.RE.STAT.LINE.BAL.ID, "-", 1)
    Y.RE.STAT.LINE.BAL.ACCT = FIELD(Y.RE.STAT.LINE.BAL.ID, "-", 2)
    Y.RE.STAT.LINE.BAL.CUR = FIELD(Y.RE.STAT.LINE.BAL.ID,"-",3)
    Y.RE.STAT.LINE.BAL.DATE = FIELD(Y.RE.STAT.LINE.BAL.ID,"-",4)
    Y.RE.STAT.LINE.BAL.DATE = FIELD(Y.RE.STAT.LINE.BAL.DATE,"*",1)
    Y.LINE.CONT.COM = FIELD(Y.RE.STAT.LINE.BAL.ID,"*",2,1)

    Y.RE.STAT.LINE.CONT.ID = Y.RE.STAT.LINE.BAL.REPORT:'.':Y.RE.STAT.LINE.BAL.ACCT:'.':Y.LINE.CONT.COM
    Y.RE.STAT.LINE.CONT.ID = Y.RE.STAT.LINE.CONT.ID :'-':PROCESS.DATE

    CALL F.READ(FN.RE.STAT.LINE.CONT,Y.RE.STAT.LINE.CONT.ID,R.RE.STAT.LINE.CONT,F.RE.STAT.LINE.CONT,RE.STAT.LINE.CONT.ER)
    IF NOT(R.RE.STAT.LINE.CONT) THEN

        Y.ASST.CONSOL.KEY='RE.1.TR.':Y.RE.STAT.LINE.BAL.CUR:'.':Y.RE.STAT.LINE.BAL.REPORT:'.':Y.RE.STAT.LINE.BAL.ACCT:'...........':Y.LINE.CONT.COM
        Y.ASSET.TYPE.LIST='LINEMVMT'
        GOSUB PROCESS.ASSET.TYPE

        RETURN
    END
    Y.ASST.CONSOL.KEY.LIST = R.RE.STAT.LINE.CONT<CAPL.L.RE.CONT.ASST.CONSOL.KEY>
    Y.PRFT.CONSOL.KEY.LIST = R.RE.STAT.LINE.CONT<CAPL.L.RE.CONT.PRFT.CONSOL.KEY>


    GOSUB PROCESS.ASST.CONSOL.KEYS
    GOSUB PROCESS.PRFT.CONSOL.KEYS

RETURN
*--------------------------------------------------------------------------------------------------------
************************
PROCESS.ASST.CONSOL.KEYS:
************************

    Y.TOT.ASST.KEYS = DCOUNT(Y.ASST.CONSOL.KEY.LIST,@VM)
    Y.INT.ASST.KEY = 1

    LOOP
    WHILE Y.INT.ASST.KEY LE Y.TOT.ASST.KEYS

        Y.ASST.CONSOL.KEY = Y.ASST.CONSOL.KEY.LIST<1,Y.INT.ASST.KEY>
        Y.ASST.CONSOL.KEY.CUR = FIELD(Y.ASST.CONSOL.KEY,".",4)

*        IF Y.ASST.CONSOL.KEY[1,2] NE 'RE'  AND Y.ASST.CONSOL.KEY.CUR EQ Y.RE.STAT.LINE.BAL.CUR THEN
        IF Y.ASST.CONSOL.KEY.CUR EQ Y.RE.STAT.LINE.BAL.CUR THEN
            Y.ASSET.TYPE.LIST = R.RE.STAT.LINE.CONT<CAPL.L.RE.CONT.ASSET.TYPE,Y.INT.ASST.KEY>
            GOSUB PROCESS.ASSET.TYPE
        END
        Y.INT.ASST.KEY += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
******************
PROCESS.ASSET.TYPE:
******************
    Y.TOT.ASSET.TYPES = DCOUNT(Y.ASSET.TYPE.LIST,@SM)
    Y.INT.ASSET.TYPE = 1

    LOOP
    WHILE Y.INT.ASSET.TYPE LE Y.TOT.ASSET.TYPES
        Y.ASSET.TYPE = Y.ASSET.TYPE.LIST<1,1,Y.INT.ASSET.TYPE>

        Y.ENT.KEY.ID = Y.ASST.CONSOL.KEY:'.':Y.ASSET.TYPE:'.':PROCESS.DATE

        GOSUB PROCESS.STMT.ENT.KEY
        GOSUB PROCESS.SPEC.ENT.KEY

        Y.INT.ASSET.TYPE +=1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
********************
PROCESS.STMT.ENT.KEY:
********************
    CALL F.READ(FN.RE.CONSOL.STMT.ENT.KEY,Y.ENT.KEY.ID,R.RE.CONSOL.STMT.ENT.KEY,F.RE.CONSOL.STMT.ENT.KEY,RE.CONSOL.STMT.ENT.KEY.ERR)


    IF NOT(R.RE.CONSOL.STMT.ENT.KEY) THEN
        RETURN
    END
    GOSUB PROCESS.ALL.STMT.ENT.KEYS

    IF R.RE.CONSOL.STMT.ENT.KEY<1> GT 0 THEN
        Y.FIRST.FIELD.VALUE = R.RE.CONSOL.STMT.ENT.KEY<1>
        Y.INT.FIELD.VALUE = 1
        LOOP
        WHILE Y.INT.FIELD.VALUE LE Y.FIRST.FIELD.VALUE
            Y.NEW.ENT.KEY.ID = Y.ENT.KEY.ID:'.':Y.INT.FIELD.VALUE
            CALL F.READ(FN.RE.CONSOL.STMT.ENT.KEY,Y.NEW.ENT.KEY.ID,R.RE.CONSOL.STMT.ENT.KEY,F.RE.CONSOL.STMT.ENT.KEY,RE.CONSOL.STMT.ENT.KEY.ERR)
            GOSUB PROCESS.ALL.STMT.ENT.KEYS
            Y.INT.FIELD.VALUE +=1
        REPEAT
    END
RETURN
*--------------------------------------------------------------------------------------------------------
************************
PROCESS.ALL.STMT.ENT.KEYS:
************************
    LOOP
        REMOVE Y.STMT.ENTRY.ID FROM R.RE.CONSOL.STMT.ENT.KEY SETTING Y.STMT.ENTRY.ID.POS
    WHILE Y.STMT.ENTRY.ID:Y.STMT.ENTRY.ID.POS
        GOSUB GET.STMT.DETAILS
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
****************
GET.STMT.DETAILS:
****************

    Y.ENTRY.INDICATOR = 'STMT.ENTRY'
    Y.PARAM.DETAILS.LIST = Y.IGN.STMT.TXN.CODES :@FM: Y.PARAM.DEBIT.FORMAT :@FM: Y.PARAM.CREDIT.FORMAT :@FM: Y.SAP.ACC.NO :@FM: Y.SIB.ACC.NO :@FM: Y.CLOSE.DATE :@FM: Y.FLD.DELIM :@FM: Y.REC.DELIM
    CALL REDO.APAP.SAP.GL.DETAIL.RPT.SPLIT.1(Y.STMT.ENTRY.ID,Y.ENTRY.INDICATOR,Y.PARAM.DETAILS.LIST,Y.FT.OUT.LIST)

RETURN
*--------------------------------------------------------------------------------------------------------
********************
PROCESS.SPEC.ENT.KEY:
********************

    CALL F.READ(FN.RE.CONSOL.SPEC.ENT.KEY,Y.ENT.KEY.ID,R.RE.CONSOL.SPEC.ENT.KEY,F.RE.CONSOL.SPEC.ENT.KEY,RE.CONSOL.SPEC.ENT.KEY.ERR)

    IF NOT(R.RE.CONSOL.SPEC.ENT.KEY) THEN
        RETURN
    END
    GOSUB PROCESS.ALL.SPEC.ENT.KEYS

*  IF R.RE.CONSOL.SPEC.ENT.KEY<1> GT 0 THEN ;*Tus Start
    IF R.RE.CONSOL.SPEC.ENT.KEY<RE.CSEK.RE.SPEC.ENT.KEY> GT 0 THEN
*  Y.FIRST.FIELD.VALUE = R.RE.CONSOL.SPEC.ENT.KEY<1>
        Y.FIRST.FIELD.VALUE = R.RE.CONSOL.SPEC.ENT.KEY<RE.CSEK.RE.SPEC.ENT.KEY> ;*Tus End
        Y.INT.FIELD.VALUE = 1
        LOOP
        WHILE Y.INT.FIELD.VALUE LE Y.FIRST.FIELD.VALUE
            Y.NEW.ENT.KEY.ID = Y.ENT.KEY.ID:'.':Y.INT.FIELD.VALUE
            CALL F.READ(FN.RE.CONSOL.SPEC.ENT.KEY,Y.NEW.ENT.KEY.ID,R.RE.CONSOL.SPEC.ENT.KEY,F.RE.CONSOL.SPEC.ENT.KEY,RE.CONSOL.SPEC.ENT.KEY.ERR)
            GOSUB PROCESS.ALL.SPEC.ENT.KEYS
            Y.INT.FIELD.VALUE +=1
        REPEAT
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*************************
PROCESS.ALL.SPEC.ENT.KEYS:
*************************
    LOOP
        REMOVE Y.RE.CONSOL.SPEC.ENTRY.ID FROM R.RE.CONSOL.SPEC.ENT.KEY SETTING Y.SPEC.ENTRY.ID.POS
    WHILE Y.RE.CONSOL.SPEC.ENTRY.ID:Y.SPEC.ENTRY.ID.POS
        GOSUB GET.SPEC.DETAILS
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
****************
GET.SPEC.DETAILS:
****************

    Y.ENTRY.INDICATOR = 'SPEC.ENTRY'
    Y.PARAM.DETAILS.LIST = Y.IGN.SPEC.TXN.CODES :@FM: Y.PARAM.DEBIT.FORMAT :@FM: Y.PARAM.CREDIT.FORMAT :@FM: Y.SAP.ACC.NO :@FM: Y.SIB.ACC.NO :@FM: Y.CLOSE.DATE :@FM: Y.FLD.DELIM :@FM: Y.REC.DELIM
    CALL REDO.APAP.SAP.GL.DETAIL.RPT.SPLIT.1(Y.RE.CONSOL.SPEC.ENTRY.ID,Y.ENTRY.INDICATOR,Y.PARAM.DETAILS.LIST,Y.FT.OUT.LIST)

RETURN
*--------------------------------------------------------------------------------------------------------
************************
PROCESS.PRFT.CONSOL.KEYS:
************************
    Y.TOT.PRFT.KEYS = DCOUNT(Y.PRFT.CONSOL.KEY.LIST,@VM)
    Y.INT.PRFT.KEY = 1

    LOOP
    WHILE Y.INT.PRFT.KEY LE Y.TOT.PRFT.KEYS

        Y.PRFT.CONSOL.KEY = Y.PRFT.CONSOL.KEY.LIST<1,Y.INT.PRFT.KEY>

        IF Y.PRFT.CONSOL.KEY[1,2] NE 'RE'  THEN
            Y.PROFIT.CCY.LIST = R.RE.STAT.LINE.CONT<CAPL.L.RE.CONT.PROFIT.CCY,Y.INT.PRFT.KEY>
            GOSUB PROCESS.PROFIT.CCY
        END
        Y.INT.PRFT.KEY += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
******************
PROCESS.PROFIT.CCY:
******************

    Y.TOT.PROFIT.CCY = DCOUNT(Y.PROFIT.CCY.LIST,@SM)
    Y.INT.PROFIT.CCY = 1

    LOOP
    WHILE Y.INT.PROFIT.CCY LE Y.TOT.PROFIT.CCY
        Y.PROFIT.CCY = Y.PROFIT.CCY.LIST<1,1,Y.INT.PROFIT.CCY>

        IF Y.PROFIT.CCY NE Y.RE.STAT.LINE.BAL.CUR THEN
            RETURN
        END

        Y.PRFT.CONSOL.ID = Y.PRFT.CONSOL.KEY:'.':Y.PROFIT.CCY:'.':PROCESS.DATE

        GOSUB PROCESS.CATEG.ENT.KEY

        Y.INT.PROFIT.CCY +=1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
PROCESS.CATEG.ENT.KEY:
*********************
    CALL F.READ(FN.RE.CONSOL.PROFIT,Y.PRFT.CONSOL.ID,R.RE.CONSOL.PROFIT,F.RE.CONSOL.PROFIT,RE.CONSOL.PROFIT.ERR)

    IF NOT(R.RE.CONSOL.PROFIT) THEN
        RETURN
    END

    GOSUB PROCESS.ALL.CATEG.ENT.KEYS

    IF R.RE.CONSOL.PROFIT<1> GT 0 THEN
        Y.FIRST.FIELD.VALUE = R.RE.CONSOL.PROFIT<1>
        Y.INT.FIELD.VALUE = 1
        LOOP
        WHILE Y.INT.FIELD.VALUE LE Y.FIRST.FIELD.VALUE
            Y.NEW.PRFT.CONSOL.ID = Y.PRFT.CONSOL.ID:';':Y.INT.FIELD.VALUE
            CALL F.READ(FN.RE.CONSOL.PROFIT,Y.NEW.PRFT.CONSOL.ID,R.RE.CONSOL.PROFIT,F.RE.CONSOL.PROFIT,RE.CONSOL.PROFIT.ERR)
            GOSUB PROCESS.ALL.CATEG.ENT.KEYS
            Y.INT.FIELD.VALUE +=1
        REPEAT
    END
RETURN
*--------------------------------------------------------------------------------------------------------
**************************
PROCESS.ALL.CATEG.ENT.KEYS:
**************************

    LOOP
        REMOVE Y.CATEG.ENTRY.ID FROM R.RE.CONSOL.PROFIT SETTING Y.CATEG.ENTRY.ID.POS
    WHILE Y.CATEG.ENTRY.ID:Y.CATEG.ENTRY.ID.POS
        GOSUB GET.CATEG.DETAILS
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.CATEG.DETAILS:
*****************
    Y.ENTRY.INDICATOR = 'CATEG.ENTRY'
    Y.PARAM.DETAILS.LIST = Y.IGN.CATEG.TXN.CODES :@FM: Y.PARAM.DEBIT.FORMAT :@FM: Y.PARAM.CREDIT.FORMAT :@FM: Y.SAP.ACC.NO :@FM: Y.SIB.ACC.NO :@FM: Y.CLOSE.DATE :@FM: Y.FLD.DELIM :@FM: Y.REC.DELIM
    CALL REDO.APAP.SAP.GL.DETAIL.RPT.SPLIT.1(Y.CATEG.ENTRY.ID,Y.ENTRY.INDICATOR,Y.PARAM.DETAILS.LIST,Y.FT.OUT.LIST)


RETURN
*--------------------------------------------------------------------------------------------------------
**********************
GET.SAP.ACCOUNT.NUMBER:
**********************
    ADDRESS.ID = Y.RE.STAT.LINE.BAL.ID
    ANS = INDEX(ADDRESS.ID, "-", 2)
    RE.STAT.REP.LINE.ID = ADDRESS.ID[1,ANS-1]
    SOL2 = INDEX(RE.STAT.REP.LINE.ID, "-", 1)
    SOL3 = RE.STAT.REP.LINE.ID[SOL2,1]
    SOL3 = "."
    RE.STAT.REP.LINE.ID[SOL2,1] = SOL3
    RE.STAT.REP.ID = RE.STAT.REP.LINE.ID

    CALL F.READ(FN.RE.STAT.REP.LINE,RE.STAT.REP.ID,R.STAT.REP.LINE,F.RE.STAT.REP.LINE,STAT.REP.LINE.ERR)
    Y.SAP.ACC.NO = R.STAT.REP.LINE<RE.SRL.DESC,3,1>
    Y.SIB.ACC.NO = R.STAT.REP.LINE<RE.SRL.DESC,1,1>

RETURN
*--------------------------------------------------------------------------------------------------------

END
