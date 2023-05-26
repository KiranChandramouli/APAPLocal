*-----------------------------------------------------------------------------
* <Rating>-343</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.APAP.SAP.GL.DETAIL(RE.STAT.LINE.BAL.ID)

*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.SAP.GL.DETAILS
*--------------------------------------------------------------------------------------------------------
*Description  : This routine is used to get detail report of all the transactions for the given day
*In Parameter : GIT.MAP.VALUE -- contains the RE.STAT.LINE.BAL id
*Out Parameter: GIT.MAP.VALUE -- contains the list of values which are to be passsed to the out file
*               CONV.ERR      -- contains the error message
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference                   Description
*   ------         ------               -------------                -------------
* 19 OCT  2010    Mohammed Anies K      ODR-2009-12-0294 C.12         Initial Creation
* 24 MAY  2017    Edwin Charles D       PACS00575005                  SAPRPT mismatched during upgrade
*
* 31 JAN 2023    Edwin Charles D               ACCOUNTING-CR                             TSR479892
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.RE.STAT.LINE.CONT
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.RE.CONSOL.SPEC.ENTRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_F.DATES
    $INSERT I_F.CUSTOMER
    $INSERT I_F.TRANSACTION
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT TAM.BP/I_F.REDO.INTRF.REP.LINE
    $INSERT TAM.BP/I_F.REDO.CAPL.L.RE.STAT.LINE.CONT
    $INSERT I_REDO.APAP.SAP.GL.DETAIL.COMMON
    $INSERT I_F.RE.CONSOL.SPEC.ENT.KEY
    $INSERT I_REDO.PREVAL.STATUS.COMMON
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    CALL OCOMO("Processing Id ":RE.STAT.LINE.BAL.ID)
    Y.NOR.AMT=''
    Y.REV.AMT=''
    Y.SP.COMPANY.LIST=''
    GOSUB INIT.PARA
    GOSUB GET.SAP.ACCOUNT.NUMBER
    IF NOT(LOCK.STATUS) THEN
        GOSUB PROCESS.PARA
    END
    GOSUB NORMAL.PROCESS
    IF NOT(LOCK.STATUS) THEN
        GOSUB REVAL.PROCESS
    END
    GIT.MAP.VALUE = Y.FT.OUT.LIST

    RETURN
*--------------------------------------------------------------------------------------------------------
***********
INIT.PARA:
***********
    FN.RE.STAT.LINE.CONT = 'F.RE.STAT.LINE.CONT'
    F.RE.STAT.LINE.CONT = ''
    CALL OPF(FN.RE.STAT.LINE.CONT, F.RE.STAT.LINE.CONT)

    Y.ASST.CONSOL.KEY=''
    Y.FT.OUT.LIST = ''
    R.RE.CONSOL.STMT.ENT.KEY = ''
    R.RE.CONSOL.SPEC.ENT.KEY = ''
    R.RE.CONSOL.PROFIT = ''
    R.RE.STAT.LINE.CONT  = ''

    Y.LINE.CONT.COM           = FIELD(RE.STAT.LINE.BAL.ID,"*",2,1)
    Y.RE.STAT.LINE.BAL.CUR    = FIELD(RE.STAT.LINE.BAL.ID,"-",3)

    LOCATE Y.LINE.CONT.COM IN Y.COMPANY.LIST SETTING Y.COMPANY.LINE.POS THEN
        Y.SAP.COST.CENTER=Y.SAP.COST.CENTER.LIST<Y.COMPANY.LINE.POS>
    END

    LF = CHARX(010)
    RETURN
*--------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
************

    Y.CLOSE.DATE = PROCESS.DATE


    Y.ID.MVMT.FIRST=RE.STAT.LINE.BAL.ID:"-A-"
    GOSUB READ.MVMT
    IF R.RE.STAT.LINE.MVMT.LIST THEN

        GOSUB PROCESS.STMT.TYPE
    END

    Y.ID.MVMT.FIRST=RE.STAT.LINE.BAL.ID:"-R-"
    GOSUB READ.MVMT
    IF R.RE.STAT.LINE.MVMT.LIST THEN
        GOSUB PROCESS.ASST.TYPE
    END

    Y.ID.MVMT.FIRST=RE.STAT.LINE.BAL.ID:"-P-"
    GOSUB READ.MVMT
    IF R.RE.STAT.LINE.MVMT.LIST THEN

        GOSUB PROCESS.PRFT.TYPE
    END
    RETURN

*-----------------------
PROCESS.STMT.TYPE:
*------------------------
    Y.STMT.ENT.ID.TOT = DCOUNT(R.RE.STAT.LINE.MVMT.LIST,FM)
    Y.STMT.ENT.ID.CNT= 1
    Y.ENT.ID = ''
    Y.ENT.ID = R.RE.STAT.LINE.MVMT.LIST<Y.STMT.ENT.ID.CNT>
    Y.D.ENT.KEY = FIELD(Y.ENT.ID,'.',1,17)
    Y.FILE.ID = 'SFI' :'.':Y.LINE.CONT.COM:'.':Y.D.ENT.KEY
    Y.LINE.1=FIELD(Y.FILE.ID,'.',1,4)
    Y.FILE.ID=Y.LINE.1:'.':Y.RE.STAT.LINE.BAL.CUR:'.':SESSION.NO

    OPENSEQ Y.EXTRACT.OUT.PATH, Y.FILE.ID TO Y.FILE.PATH ELSE
        CREATE Y.FILE.PATH ELSE
            CALL OCOMO("CANNOT OPEN SESSION FILE PATH")
            REC.CON ="CANNOT OPEN SESSION FILE PATH":Y.EXTRACT.OUT.PATH
            DESC    = Y.FILE.ID
            GOSUB LOG.ERROR.C22
        END
    END

    LOOP
    WHILE Y.STMT.ENT.ID.CNT LE Y.STMT.ENT.ID.TOT
        Y.ENT.KEY.ID = R.RE.STAT.LINE.MVMT.LIST<Y.STMT.ENT.ID.CNT>
        Y.DET.ENT.KEY=FIELD(Y.ENT.KEY.ID,'.',1,17)
        GOSUB PROCESS.STMT.ENT.KEY
        Y.STMT.ENT.ID.CNT+=1
    REPEAT
    CLOSESEQ Y.FILE.PATH
    RETURN
*-----------------
PROCESS.ASST.TYPE:
*-----------------
    Y.SPEC.ENT.ID.TOT = DCOUNT(R.RE.STAT.LINE.MVMT.LIST,FM)
    Y.SPEC.ENT.ID.CNT= 1
    Y.ENT.ID = ''
    Y.ENT.ID = R.RE.STAT.LINE.MVMT.LIST<Y.STMT.ENT.ID.CNT>
    Y.D.ENT.KEY = FIELD(Y.ENT.ID,'.',1,17)
    Y.FILE.ID = 'SFI' :'.':Y.LINE.CONT.COM:'.':Y.D.ENT.KEY
    Y.LINE.1=FIELD(Y.FILE.ID,'.',1,4)
    Y.FILE.ID=Y.LINE.1:'.':Y.RE.STAT.LINE.BAL.CUR:'.':SESSION.NO

    OPENSEQ Y.EXTRACT.OUT.PATH, Y.FILE.ID TO Y.FILE.PATH ELSE
        CREATE Y.FILE.PATH ELSE
            CALL OCOMO("CANNOT OPEN SESSION FILE PATH")
            REC.CON ="CANNOT OPEN SESSION FILE PATH":Y.EXTRACT.OUT.PATH
            DESC    = Y.FILE.ID
            GOSUB LOG.ERROR.C22
        END
    END

    LOOP
    WHILE Y.SPEC.ENT.ID.CNT LE Y.SPEC.ENT.ID.TOT
        Y.ENT.KEY.ID=R.RE.STAT.LINE.MVMT.LIST<Y.SPEC.ENT.ID.CNT>
        Y.DET.ENT.KEY=FIELD(Y.ENT.KEY.ID,'.',1,17)
        GOSUB PROCESS.SPEC.ENT.KEY
        Y.SPEC.ENT.ID.CNT+=1
    REPEAT
    CLOSESEQ Y.FILE.PATH

    RETURN
*------------------
PROCESS.PRFT.TYPE:
*------------------
    Y.PRFT.ENT.ID.TOT = DCOUNT(R.RE.STAT.LINE.MVMT.LIST,FM)
    Y.PRFT.ENT.ID.CNT= 1

    Y.ENT.ID = ''
    Y.ENT.ID = R.RE.STAT.LINE.MVMT.LIST<Y.PRFT.ENT.ID.CNT>
    Y.D.ENT.KEY = FIELD(Y.ENT.ID,'.',1,17)
    Y.FILE.ID = 'SFI' :'.':Y.LINE.CONT.COM:'.':Y.D.ENT.KEY
    Y.LINE.1=FIELD(Y.FILE.ID,'.',1,4)
    Y.FILE.ID=Y.LINE.1:'.':Y.RE.STAT.LINE.BAL.CUR:'.':SESSION.NO

    OPENSEQ Y.EXTRACT.OUT.PATH, Y.FILE.ID TO Y.FILE.PATH ELSE
        CREATE Y.FILE.PATH ELSE
            CALL OCOMO("CANNOT OPEN SESSION FILE PATH")
            REC.CON ="CANNOT OPEN SESSION FILE PATH":Y.EXTRACT.OUT.PATH
            DESC    = Y.FILE.ID
            GOSUB LOG.ERROR.C22
        END
    END



    LOOP
    WHILE Y.PRFT.ENT.ID.CNT LE Y.PRFT.ENT.ID.TOT
        Y.ENT.KEY.ID=R.RE.STAT.LINE.MVMT.LIST<Y.PRFT.ENT.ID.CNT>
        Y.DET.ENT.KEY=FIELD(Y.ENT.KEY.ID,'.',1,17)
        GOSUB PROCESS.PRFT.CONSOL.KEYS
        Y.PRFT.ENT.ID.CNT+=1
    REPEAT

    CLOSESEQ Y.FILE.PATH

    RETURN
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
    Y.PARAM.DETAILS.LIST = Y.IGN.STMT.TXN.CODES :FM: Y.PARAM.DEBIT.FORMAT :FM: Y.PARAM.CREDIT.FORMAT :FM: Y.SAP.ACC.NO :FM: Y.SIB.ACC.NO :FM: Y.CLOSE.DATE :FM: Y.FLD.DELIM
    Y.FT.OUT.LIST=''
    CALL REDO.APAP.SAP.GL.DETAIL.RPT.SPLIT.1(Y.STMT.ENTRY.ID,Y.ENTRY.INDICATOR,Y.PARAM.DETAILS.LIST,Y.FT.OUT.LIST)
    GOSUB WRITE.DATA.TO.SESSION.FILES

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

*IF R.RE.CONSOL.SPEC.ENT.KEY<1> GT 0 THEN ;*Tus Start
    IF R.RE.CONSOL.SPEC.ENT.KEY<RE.CSEK.RE.SPEC.ENT.KEY> GT 0 THEN
*Y.FIRST.FIELD.VALUE = R.RE.CONSOL.SPEC.ENT.KEY<1>
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
    Y.PARAM.DETAILS.LIST = Y.IGN.SPEC.TXN.CODES :FM: Y.PARAM.DEBIT.FORMAT :FM: Y.PARAM.CREDIT.FORMAT :FM: Y.SAP.ACC.NO :FM: Y.SIB.ACC.NO :FM: Y.CLOSE.DATE :FM: Y.FLD.DELIM
    Y.FT.OUT.LIST=''
    CALL REDO.APAP.SAP.GL.DETAIL.RPT.SPLIT.1(Y.RE.CONSOL.SPEC.ENTRY.ID,Y.ENTRY.INDICATOR,Y.PARAM.DETAILS.LIST,Y.FT.OUT.LIST)
    GOSUB WRITE.DATA.TO.SESSION.FILES

    RETURN
*--------------------------------------------------------------------------------------------------------
************************
PROCESS.PRFT.CONSOL.KEYS:
************************

    Y.PRFT.CONSOL.KEY = Y.ENT.KEY.ID

    IF Y.PRFT.CONSOL.KEY[1,2] NE 'RE'  THEN
        Y.PRFT.CONSOL.ID = Y.PRFT.CONSOL.KEY
        GOSUB PROCESS.CATEG.ENT.KEY
    END

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
    Y.PARAM.DETAILS.LIST = Y.IGN.CATEG.TXN.CODES :FM: Y.PARAM.DEBIT.FORMAT :FM: Y.PARAM.CREDIT.FORMAT :FM: Y.SAP.ACC.NO :FM: Y.SIB.ACC.NO :FM: Y.CLOSE.DATE :FM: Y.FLD.DELIM
    Y.FT.OUT.LIST=''
    CALL REDO.APAP.SAP.GL.DETAIL.RPT.SPLIT.1(Y.CATEG.ENTRY.ID,Y.ENTRY.INDICATOR,Y.PARAM.DETAILS.LIST,Y.FT.OUT.LIST)
    GOSUB WRITE.DATA.TO.SESSION.FILES

    RETURN
*--------------------------------------------------------------------------------------------------------

********************
CHECK.ACCOUNT.STATUS:
*********************
*-------------------------------------------------Accoiunting CR changes updated------------------------
    R.EB.CONTRACT.BALANCES = '' ; EB.CONT.ERROR = '' ; ACCT.STATUS = ''
    BAL.CR.AMT = ''; BAL.DR.AMT = '' ; INT.CR.AMT = '' ; INT.DR.AMT = '' ; Y.BAL.DET = '' ; Y.INT.DET = ''
    Y.ACT.ACCOUNT = RE.STAT.LINE.BAL.ID
    CALL F.READ(FN.EB.CONTRACT.BALANCES,Y.ACT.ACCOUNT,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES,EB.CONT.ERROR)
    IF R.EB.CONTRACT.BALANCES THEN
        CONSOL.KEY.TEMP = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>
        ACCT.STATUS = FIELD(CONSOL.KEY.TEMP,".",11)
        CALL REDO.V.CHECK.BAL.INT.ENTRIES(Y.ACT.ACCOUNT,BAL.CR.AMT,BAL.DR.AMT,INT.CR.AMT,INT.DR.AMT,Y.BAL.DET,Y.INT.DET)
        Y.SAP.TXN.COMP = FIELD(CONSOL.KEY.TEMP,".",17)
        Y.RE.STAT.LINE.BAL.CUR = FIELD(CONSOL.KEY.TEMP,".",4)
        RE.STAT.REP.ID = ''
        SEL.CMD  = "SELECT ":FN.RE.STAT.LINE.CONT:" WITH ASST.CONSOL.KEY EQ ":CONSOL.KEY.TEMP
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
        RE.STAT.REP.ID = SEL.LIST<1>
        LOCK.STATUS = '1'
        LOCATE Y.SAP.TXN.COMP IN Y.COMPANY.LIST SETTING Y.COMPANY.LINE.POS THEN
            Y.SAP.COST.CENTER=Y.SAP.COST.CENTER.LIST<Y.COMPANY.LINE.POS>
        END
    END
    RE.STAT.REP.ID = RE.STAT.REP.ID[1,9]

    RETURN
*---------------------------------------------------------------------------------------------------------

**********************
GET.SAP.ACCOUNT.NUMBER:
**********************

    ADDRESS.ID = RE.STAT.LINE.BAL.ID
    ANS = INDEX(ADDRESS.ID, "-", 2)
    RE.STAT.REP.LINE.ID = ADDRESS.ID[1,ANS-1]
    SOL2 = INDEX(RE.STAT.REP.LINE.ID, "-", 1)
    SOL3 = RE.STAT.REP.LINE.ID[SOL2,1]
    SOL3 = "."
    RE.STAT.REP.LINE.ID[SOL2,1] = SOL3
    RE.STAT.REP.ID = RE.STAT.REP.LINE.ID
*-------------------------------------------------Accoiunting CR changes updated------------------------
    LOCK.STATUS = ''
    GOSUB CHECK.ACCOUNT.STATUS
*-------------------------------------------------Accoiunting CR changes updated------------------------
    CALL F.READ(FN.RE.STAT.REP.LINE,RE.STAT.REP.ID,R.STAT.REP.LINE,F.RE.STAT.REP.LINE,STAT.REP.LINE.ERR)
    Y.SAP.ACC.NO = R.STAT.REP.LINE<RE.SRL.DESC,3,1>
    Y.SIB.ACC.NO = R.STAT.REP.LINE<RE.SRL.DESC,1,1>
    CALL F.READ(FN.REDO.INTRF.REP.LINE,RE.STAT.REP.ID,R.REDO.INTRF.REP.LINE,F.REDO.INTRF.REP.LINE,ERR)
    Y.IS.CONTINGENT=''
    IF R.REDO.INTRF.REP.LINE THEN
        Y.IS.CONTINGENT=R.REDO.INTRF.REP.LINE<SAP.INTRF.IS.CONTINGENT>
        IF Y.IS.CONTINGENT EQ 'YES' THEN
            Y.IS.CONTINGENT = 'CT'
        END ELSE
            Y.IS.CONTINGENT = 'NCT'
        END
    END

    RETURN
*---------------------------------------------------------------------------------------------------------
**********
READ.MVMT:
**********

    R.RE.STAT.LINE.MVMT.LIST=''
    Y.MVMT.SEQ.NO=1
    LOOP
        R.RE.STAT.LINE.MVMT=''
        Y.ID.MVMT=Y.ID.MVMT.FIRST:Y.MVMT.SEQ.NO
        CALL F.READ(FN.RE.STAT.LINE.MVMT,Y.ID.MVMT,R.RE.STAT.LINE.MVMT,F.RE.STAT.LINE.MVMT,ERR)
    WHILE R.RE.STAT.LINE.MVMT
        R.RE.STAT.LINE.MVMT.LIST<-1>=R.RE.STAT.LINE.MVMT
        Y.MVMT.SEQ.NO++
    REPEAT

    RETURN
*--------------------------------------------------------------------------------------------------------
****************************
WRITE.DATA.TO.SESSION.FILES:
****************************

    IF NOT(Y.FT.OUT.LIST) THEN
        RETURN
    END
    Y.AUX = DCOUNT(Y.FT.OUT.LIST,FM)
    CONVERT FM TO LF IN Y.FT.OUT.LIST
  * Y.FILE.ID = 'SFI' :'.':Y.LINE.CONT.COM:'.':Y.DET.ENT.KEY
  * Y.LINE.1=FIELD(Y.FILE.ID,'.',1,4)
  * Y.FILE.ID=Y.LINE.1:'.':Y.RE.STAT.LINE.BAL.CUR:'.':SESSION.NO

*  OPENSEQ Y.EXTRACT.OUT.PATH, Y.FILE.ID TO Y.FILE.PATH ELSE
*      CREATE Y.FILE.PATH ELSE
*          CALL OCOMO("CANNOT OPEN SESSION FILE PATH")
*          REC.CON ="CANNOT OPEN SESSION FILE PATH":Y.EXTRACT.OUT.PATH
*          DESC    = Y.FILE.ID
*          GOSUB LOG.ERROR.C22
*      END
*  END
    WRITESEQ Y.FT.OUT.LIST APPEND TO Y.FILE.PATH ELSE
        CALL OCOMO("CANNOT WRITE TO SESSION FILE OF ID ":Y.FILE.ID)

        REC.CON ="CANNOT WRITE SESSION FILE PATH":Y.EXTRACT.OUT.PATH
        DESC    = Y.FILE.ID
        GOSUB LOG.ERROR.C22
    END
    RETURN
*--------------------------------------------------------------------------------------------------------

*--------------
NORMAL.PROCESS:
*--------------

    Y.FILE.ID.NOR = 'NORMAL' :'.':SESSION.NO

    OPENSEQ Y.EXTRACT.OUT.PATH.NOR, Y.FILE.ID.NOR TO Y.FILE.PATH.NOR ELSE
        CREATE Y.FILE.PATH.NOR ELSE
            CALL OCOMO("CANNOT OPEN SESSION FILE PATH")
            REC.CON ="CANNOT OPEN SESSION FILE PATH":Y.EXTRACT.OUT.PATH.NOR
            DESC    = Y.FILE.ID.NOR
            GOSUB LOG.ERROR.C22
        END
    END

    IF NOT(LOCK.STATUS) THEN
        Y.SP.COMPANY.LIST.TOT=DCOUNT(Y.NOR.AMT,FM)

    Y.SP.COMPANY.LIST.CNT=1
    LOOP
    WHILE Y.SP.COMPANY.LIST.CNT LE Y.SP.COMPANY.LIST.TOT

        Y.CR.MOVEMENT = 0
        Y.DB.MOVEMENT = 0
        Y.CR.MVT.LCY  = 0
        Y.DB.MVT.LCY  = 0
        Y.FT.OUT.LIST =''
        Y.CR.MOVEMENT = Y.NOR.AMT<Y.SP.COMPANY.LIST.CNT,3> + 0
        Y.DB.MOVEMENT = Y.NOR.AMT<Y.SP.COMPANY.LIST.CNT,4> + 0
        Y.CR.MVT.LCY  = Y.NOR.AMT<Y.SP.COMPANY.LIST.CNT,1> + 0
        Y.DB.MVT.LCY  = Y.NOR.AMT<Y.SP.COMPANY.LIST.CNT,2> + 0
        Y.SAP.TXN.COMP= Y.NOR.AMT<Y.SP.COMPANY.LIST.CNT,5>
        IF Y.CR.MVT.LCY NE 0 THEN

            GOSUB CR.MOVEMENT.AL
            GOSUB WRITE.NORMAL.PROCESS
        END
        IF  Y.DB.MVT.LCY NE 0 THEN

            GOSUB  DB.MOVEMENT.AL
            GOSUB WRITE.NORMAL.PROCESS
        END

        Y.SP.COMPANY.LIST.CNT++

        REPEAT
    END ELSE
*-----------------------------Accounting changes added
        GOSUB GET.LOCK.AMT.DETAILS
*-----------------------------Accounting changes added
    END

    RETURN

GET.LOCK.AMT.DETAILS:
*------------------- This is added for accounting CR
    Y.BAL.ACC.NO = '' ; Y.INT.ACC.NO = '' ; Y.FT.OUT.LIST = ''

    Y.BAL.ACC.NO = FIELD(Y.BAL.DET, '*', 1)
    Y.BAL.NAME = FIELD(Y.BAL.DET, '*', 2)
    Y.INT.ACC.NO = FIELD(Y.INT.DET, '*', 1)
    Y.INT.NAME = FIELD(Y.INT.DET, '*', 2)

    IF NOT(Y.BAL.ACC.NO) THEN
        Y.BAL.ACC.NO = Y.SAP.ACC.NO
        Y.INT.ACC.NO = Y.SAP.ACC.NO
    END

    IF BAL.CR.AMT AND Y.BAL.ACC.NO THEN
        Y.CR.TYPE.OF.TXN = '50'
        Y.CR.MOVEMENT = 0
        Y.CR.MVT.LCY  = BAL.CR.AMT
        Y.FT.OUT.LIST := Y.CR.TYPE.OF.TXN:'*':Y.BAL.ACC.NO:'*':Y.SAP.TXN.COMP:'*':Y.RE.STAT.LINE.BAL.CUR:'*':Y.CR.MVT.LCY:'*':Y.CR.MOVEMENT:'*':Y.IS.CONTINGENT:'*':Y.SAP.COST.CENTER
        GOSUB WRITE.NORMAL.PROCESS
    END

    IF BAL.DR.AMT AND Y.BAL.ACC.NO THEN
        Y.DB.TYPE.OF.TXN = '40'
        Y.DB.MOVEMENT = 0
        Y.DB.MVT.LCY  = BAL.DR.AMT
        Y.FT.OUT.LIST := Y.DB.TYPE.OF.TXN:'*':Y.BAL.ACC.NO:'*':Y.SAP.TXN.COMP:'*':Y.RE.STAT.LINE.BAL.CUR:'*':Y.DB.MVT.LCY:'*':Y.DB.MOVEMENT:'*':Y.IS.CONTINGENT:'*':Y.SAP.COST.CENTER
        GOSUB WRITE.NORMAL.PROCESS
    END

    IF INT.CR.AMT AND Y.INT.ACC.NO THEN
        INT.CR.AMT = TRIM(INT.CR.AMT, "", "D")
        Y.CR.TYPE.OF.TXN = '50'
        Y.CR.MOVEMENT = 0
        Y.CR.MVT.LCY = INT.CR.AMT
        Y.FT.OUT.LIST := Y.CR.TYPE.OF.TXN:'*':Y.INT.ACC.NO:'*':Y.SAP.TXN.COMP:'*':Y.RE.STAT.LINE.BAL.CUR:'*':Y.CR.MVT.LCY:'*':Y.CR.MOVEMENT:'*':Y.IS.CONTINGENT:'*':Y.SAP.COST.CENTER
        GOSUB WRITE.NORMAL.PROCESS
    END

    IF INT.DR.AMT AND Y.INT.ACC.NO THEN
        INT.DR.AMT = TRIM(INT.DR.AMT, "", "D")
        Y.DB.TYPE.OF.TXN = '40'
        Y.DB.MOVEMENT = 0
        Y.DB.MVT.LCY = INT.DR.AMT
        Y.FT.OUT.LIST := Y.DB.TYPE.OF.TXN:'*':Y.INT.ACC.NO:'*':Y.SAP.TXN.COMP:'*':Y.RE.STAT.LINE.BAL.CUR:'*':Y.DB.MVT.LCY:'*':Y.DB.MOVEMENT:'*':Y.IS.CONTINGENT:'*':Y.SAP.COST.CENTER
        GOSUB WRITE.NORMAL.PROCESS
    END

    RETURN
*-------------------
WRITE.NORMAL.PROCESS:
*-------------------

    WRITESEQ Y.FT.OUT.LIST APPEND TO Y.FILE.PATH.NOR ELSE
        CALL OCOMO("CANNOT WRITE TO SESSION FILE OF ID ":Y.FILE.ID)
        REC.CON ="CANNOT WRITE SESSION FILE PATH":Y.EXTRACT.OUT.PATH.NOR
        DESC    = Y.FILE.ID.NOR
        GOSUB LOG.ERROR.C22
    END
    Y.FT.OUT.LIST=''
    RETURN
*---------------
CR.MOVEMENT.AL:
*---------------

    IF Y.RE.STAT.LINE.BAL.CUR EQ LCCY THEN

        GOSUB FMT.CR.MVMT.LCY

        Y.FT.OUT.LIST := Y.CR.TYPE.OF.TXN:'*':Y.SAP.ACC.NO:'*':Y.SAP.TXN.COMP:'*':Y.RE.STAT.LINE.BAL.CUR:'*':Y.CR.MVT.LCY:'*':'0':'*':Y.IS.CONTINGENT:'*':Y.SAP.COST.CENTER
    END
    ELSE

        GOSUB FMT.CR.MVMT.LCY
        GOSUB FMT.CR.MVMT

        Y.FT.OUT.LIST := Y.CR.TYPE.OF.TXN:'*':Y.SAP.ACC.NO:'*':Y.SAP.TXN.COMP:'*':Y.RE.STAT.LINE.BAL.CUR:'*':Y.CR.MVT.LCY:'*':Y.CR.MOVEMENT:'*':Y.IS.CONTINGENT:'*':Y.SAP.COST.CENTER
    END

    RETURN
*--------------
DB.MOVEMENT.AL:
*--------------
    IF Y.RE.STAT.LINE.BAL.CUR EQ LCCY THEN

        GOSUB FMT.DB.MVMT.LCY


        Y.FT.OUT.LIST := Y.DB.TYPE.OF.TXN:'*':Y.SAP.ACC.NO:'*':Y.SAP.TXN.COMP:'*':Y.RE.STAT.LINE.BAL.CUR:'*':Y.DB.MVT.LCY:'*':'0':'*':Y.IS.CONTINGENT:'*':Y.SAP.COST.CENTER
    END
    ELSE

        GOSUB FMT.DB.MVMT
        GOSUB FMT.DB.MVMT.LCY
        Y.FT.OUT.LIST := Y.DB.TYPE.OF.TXN:'*':Y.SAP.ACC.NO:'*':Y.SAP.TXN.COMP:'*':Y.RE.STAT.LINE.BAL.CUR:'*':Y.DB.MVT.LCY:'*':Y.DB.MOVEMENT:'*':Y.IS.CONTINGENT:'*':Y.SAP.COST.CENTER
    END

    RETURN
*-----------*
FMT.CR.MVMT:
*-----------*
    Y.CR.MVT.DEC.VAL=''
    Y.CR.MVT.INT.VAL=''
    FMT.CR.DEC.MVMT=''
    Y.CR.MVMT=0
    Y.CR.MVMT = Y.CR.MOVEMENT+0
    Y.CR.MVT.DEC.VAL=FIELD(Y.CR.MVMT,'.',2)
    Y.CR.MVT.INT.VAL=FIELD(Y.CR.MVMT,'.',1)
    IF NOT(Y.CR.MVT.INT.VAL) THEN
        Y.CR.MVT.INT.VAL=''
    END
    FMT.CR.DEC.MVMT=FMT(Y.CR.MVT.DEC.VAL,'L%2')
    Y.CR.MOVEMENT=Y.CR.MVT.INT.VAL:FMT.CR.DEC.MVMT
    RETURN

*---------------*
FMT.CR.MVMT.LCY:
*---------------*
    Y.CR.MVT.LCY.DEC.VAL=''
    Y.CR.MVT.LCY.INT.VAL=''
    FMT.CR.DEC.MVMT.LCY=''
    Y.CR.MVMT.LCY=0
    Y.CR.MVMT.LCY =Y.CR.MVT.LCY+0
    Y.CR.MVT.LCY.DEC.VAL=FIELD(Y.CR.MVMT.LCY,'.',2)
    Y.CR.MVT.LCY.INT.VAL=FIELD(Y.CR.MVMT.LCY,'.',1)
    IF NOT(Y.CR.MVT.LCY.INT.VAL) THEN
        Y.CR.MVT.LCY.INT.VAL=''
    END
    FMT.CR.DEC.MVMT.LCY=FMT(Y.CR.MVT.LCY.DEC.VAL,'L%2')
    Y.CR.MVT.LCY=Y.CR.MVT.LCY.INT.VAL:FMT.CR.DEC.MVMT.LCY
    RETURN

*-----------*
FMT.DB.MVMT:
*-----------*

    Y.DB.MVMT=''
    Y.DB.MVT.DEC.VAL=''
    Y.DB.MVT.INT.VAL=''
    FMT.DB.DEC.MVMT=''
    Y.DB.MVMT=0
*    Y.DB.MVMT = ABS(R.RE.STAT.LINE.BAL<RE.SLB.DB.MOVEMENT>) + 0
    Y.DB.MVMT = ABS(Y.DB.MOVEMENT)+0
    Y.DB.MVT.DEC.VAL=FIELD(Y.DB.MVMT,'.',2)
    Y.DB.MVT.INT.VAL=FIELD(Y.DB.MVMT,'.',1)
    IF NOT(Y.DB.MVT.INT.VAL) THEN
        Y.DB.MVT.INT.VAL=''
    END
    FMT.DB.DEC.MVMT=FMT(Y.DB.MVT.DEC.VAL,'L%2')
    Y.DB.MOVEMENT=Y.DB.MVT.INT.VAL:FMT.DB.DEC.MVMT
    RETURN
*---------------*
FMT.DB.MVMT.LCY:
*---------------*

    Y.DB.MVMT.LCY=''
    Y.DB.MVT.LCY.DEC.VAL=''
    Y.DB.MVT.LCY.INT.VAL=''
    FMT.DB.DEC.MVMT.LCY=''
    Y.DB.MVMT.LCY=0
    Y.DB.MVMT.LCY = ABS(Y.DB.MVT.LCY)+0
    Y.DB.MVT.LCY.DEC.VAL=FIELD(Y.DB.MVMT.LCY,'.',2)
    Y.DB.MVT.LCY.INT.VAL=FIELD(Y.DB.MVMT.LCY,'.',1)
    IF NOT(Y.DB.MVT.LCY.INT.VAL) THEN
        Y.DB.MVT.LCY.INT.VAL=''
    END
    FMT.DB.DEC.MVMT.LCY=FMT(Y.DB.MVT.LCY.DEC.VAL,'L%2')
    Y.DB.MVT.LCY=Y.DB.MVT.LCY.INT.VAL:FMT.DB.DEC.MVMT.LCY
    RETURN

*--------------
REVAL.PROCESS:
*-------------
    Y.FILE.ID.REV = 'REVAL' :'.':SESSION.NO
    OPENSEQ Y.EXTRACT.OUT.PATH.REV, Y.FILE.ID.REV TO Y.FILE.PATH.REV ELSE
        CREATE Y.FILE.PATH.REV ELSE
            CALL OCOMO("CANNOT OPEN SESSION FILE PATH")
            REC.CON ="CANNOT OPEN SESSION FILE PATH":Y.EXTRACT.OUT.PATH.REV
            DESC    = Y.FILE.ID.REV
            GOSUB LOG.ERROR.C22
        END
    END
    Y.CR.MVT.LCY  = 0
    Y.DB.MVT.LCY  = 0

    Y.CR.MVT.LCY  =Y.REV.AMT<1,1>+0
    Y.DB.MVT.LCY  =Y.REV.AMT<1,2>+0
    Y.SAP.TXN.COMP=Y.REV.AMT<1,5>
    Y.FT.OUT.LIST=''
*this code need to edited for reval
*    IF Y.PARAM.CREDIT.FORMAT EQ '-' THEN
*        Y.CR.MVT.LCY = (-1) * Y.CR.MVT.LCY
*        Y.CR.MOVEMENT = (-1) * Y.CR.MOVEMENT
*    END

*    IF Y.PARAM.DEBIT.FORMAT EQ '+' THEN

*        Y.DB.MVT.LCY.ORG  = Y.DB.MVT.LCY
*        Y.DB.MOVEMENT.ORG = Y.DB.MOVEMENT
*
*        Y.DB.MVT.LCY = (-1) * Y.DB.MVT.LCY
*        Y.DB.MOVEMENT = (-1) * Y.DB.MOVEMENT
*    END

    IF Y.CR.MVT.LCY GT 0 THEN
*        Y.REV.AMT=FMT(Y.REV.AMT,2)
*        Y.REV.AMT=Y.CR.MVT.LCY
        GOSUB PROCESS.CR.MVMNT.REV
        GOSUB WRITE.REVAL.PROCESS
    END

    IF Y.DB.MVT.LCY LT 0 THEN
*        Y.REV.AMT=Y.DB.MVT.LCY
*        Y.REV.AMT=(-1) *Y.REV.AMT
        Y.REV.AMT=FMT(Y.REV.AMT,2)
        GOSUB PROCESS.DB.MVMNT.REV
        GOSUB WRITE.REVAL.PROCESS
    END
    CLOSESEQ Y.FILE.PATH.REV
    RETURN
*-------------------
WRITE.REVAL.PROCESS:
*-------------------
    IF NOT(Y.FT.OUT.LIST) THEN
        RETURN
    END

    WRITESEQ Y.FT.OUT.LIST APPEND TO Y.FILE.PATH.REV ELSE
        CALL OCOMO("CANNOT WRITE TO SESSION FILE OF ID ":Y.FILE.ID)
        REC.CON ="CANNOT WRITE SESSION FILE PATH":Y.EXTRACT.OUT.PATH.REV
        DESC    = Y.FILE.ID.REV
        GOSUB LOG.ERROR.C22
    END
    Y.FT.OUT.LIST=''
    RETURN
*--------------------
PROCESS.DB.MVMNT.REV:
*--------------------
    Y.DB.MOVEMENT=0
    GOSUB FMT.DB.MVMT.LCY
    Y.FT.OUT.LIST := Y.DB.TYPE.OF.TXN:'*':Y.SAP.ACC.NO:'*':Y.SAP.COST.CENTER:'*':Y.RE.STAT.LINE.BAL.CUR:'*':Y.DB.MVT.LCY:'*':Y.DB.MOVEMENT:'*':Y.IS.CONTINGENT:'*':Y.SAP.COST.CENTER
    RETURN

*--------------------
PROCESS.CR.MVMNT.REV:
*--------------------
    Y.CR.MOVEMENT=0
    GOSUB FMT.CR.MVMT.LCY
    Y.FT.OUT.LIST := Y.CR.TYPE.OF.TXN:'*':Y.SAP.ACC.NO:'*':Y.SAP.COST.CENTER:'*':Y.RE.STAT.LINE.BAL.CUR:'*':Y.CR.MVT.LCY:'*':Y.CR.MOVEMENT:'*':Y.IS.CONTINGENT:'*':Y.SAP.COST.CENTER
    RETURN

*-----------------------------------------------------------------------------
LOG.ERROR.C22:
*-----------------------------------------------------------------------------
    MON.TP='04'
    INT.CODE = 'SAP002'
    INT.TYPE = 'BATCH'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    RETURN
END
