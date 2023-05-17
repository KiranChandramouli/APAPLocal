*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.COL.FF.EXTRACT.SELECT
**-----------------------------------------------------------------------------
* REDO COLLECTOR EXTRACT PRE-Process Load routine
* Service : REDO.COL.EXTRACT.PRE
*-----------------------------------------------------------------------------
* Modification Details:
*=====================
* performance creation- collector performance issue creation
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.COL.FF.EXTRACT.PRE.COMMON
    $INSERT I_REDO.COL.CUSTOMER.COMMON
    $INSERT I_F.DATES
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.INTERFACE.PARAM
*-----------------------------------------------------------------------------

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END
    BEGIN CASE
    CASE CONTROL.LIST<1,1> EQ 'Y.AP.LOANS'
        GOSUB SEL.AP.LOANS
    CASE CONTROL.LIST<1,1> EQ 'Y.AP.CARDS'
        GOSUB SEL.AP.CARDS
    END CASE
    RETURN
*************
SEL.AP.LOANS:
*************

    Y.RID.ID = "COL001"
    R.REDO.INTERFACE.PARAM = ''; Y.ERR = ''; Y.OUT.FILE.AUTO = ''; Y.OUT.FILE.HIST = ''
    CALL CACHE.READ('F.REDO.INTERFACE.PARAM', Y.RID.ID, R.REDO.INTERFACE.PARAM, Y.ERR)
    IF R.REDO.INTERFACE.PARAM THEN
        Y.OUT.FILE.AUTO=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.AUTO.PATH>
        Y.OUT.FILE.HIST=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.HISTORY.PATH>
        SHELL.CMD ='SH -c '
        EXE.MV="mv ":Y.OUT.FILE.AUTO:"/*":" ":Y.OUT.FILE.HIST
        DAEMON.CMD = SHELL.CMD:EXE.MV
        EXECUTE DAEMON.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.CAT.VALUE

    END

    LIST.PARAMETERS = '' ; ID.LIST = ''
    GOSUB CRITERIA.VALUE

    Y.SELECT.CMD='SELECT ':FN.AA.ARRANGEMENT :' WITH ':CRITERIA

    CALL EB.READLIST(Y.SELECT.CMD,Y.LIST,'',NO.OF.REC,ERR)
    Y.LIST=SORT(Y.LIST)
    Y.REC.CNT=1
    LOOP
    WHILE Y.REC.CNT LE NO.OF.REC
        IF Y.LIST<Y.REC.CNT> EQ Y.LIST<Y.REC.CNT-1> THEN
            DEL Y.LIST<Y.REC.CNT>
            NO.OF.REC-=1
            Y.REC.CNT--
        END
        Y.REC.CNT++
    REPEAT

    Y.LIST.CNT=DCOUNT(Y.LIST,FM)
    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,Y.LIST)

    RETURN
*-------------------------------------------------------------
CRITERIA.VALUE:
*-------------------------------------------------------------
    CHANGE  ',' TO VM IN NUM.PRODUCT
    CHANGE  ',' TO VM IN NUM.STATUS
    NUM.PRODUCT =DCOUNT(C.AA.PRODUCT.GROUP<1>,VM)
    NUM.STATUS  =DCOUNT(C.AA.STATUS<1>,VM)
****PACS00523653****
    IF NUM.STATUS THEN
        CRITERIA = '('
    END
    FOR I=1 TO NUM.STATUS
        CRITERIA   :='ARR.STATUS EQ '
        CRITERIA   := DQUOTE(C.AA.STATUS<1,I>)
        IF I <> NUM.STATUS THEN
            CRITERIA   :=' OR '
        END
    NEXT I
    IF NUM.STATUS THEN
        CRITERIA := ')'
    END
    IF NUM.PRODUCT THEN
        IF CRITERIA THEN
            CRITERIA := ' AND '
        END
        CRITERIA   :='('
    END
    FOR I=1 TO NUM.PRODUCT
        CRITERIA   :='PRODUCT.GROUP EQ '
        CRITERIA   :=DQUOTE(C.AA.PRODUCT.GROUP<1,I>)
        IF I <> NUM.PRODUCT THEN
            CRITERIA   :=' OR '
        END
    NEXT I
    IF NUM.PRODUCT THEN
        CRITERIA   :=')'
    END
    CRITERIA   :=' CUSTOMER'
****PACS00523653****
    RETURN
*************
SEL.AP.CARDS:
*************
    LIST.PARAMETERS = '' ; Y.LIST = ''
****PACS00523653****
* Change for now.. we may have to use concat table in future...
*    Y.SELECT.CMD='SELECT ':FN.CUSTOMER:' WITH L.CU.TARJ.CR EQ YES'
    Y.SELECT.CMD='SELECT ':FN.CUSTOMER
****PACS00523653****
    CALL EB.READLIST(Y.SELECT.CMD,Y.LIST,'',NO.OF.REC,ERR)
    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,Y.LIST)
    RETURN
BUILD.CONTROL.LIST:
*******************
    CONTROL.LIST<-1> = "Y.AP.LOANS"
    CONTROL.LIST<-1> = "Y.AP.CARDS"
    RETURN

END
