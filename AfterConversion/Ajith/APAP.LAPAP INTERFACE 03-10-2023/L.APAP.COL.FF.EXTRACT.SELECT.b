$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.COL.FF.EXTRACT.SELECT
**-----------------------------------------------------------------------------
* REDO COLLECTOR EXTRACT PRE-Process Load routine
* Service : REDO.COL.EXTRACT.PRE
*-----------------------------------------------------------------------------
* Modification Details:
*=====================
* performance creation- collector performance issue creation
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     TAM.BP is Removed,I to I.VAR,++ to +=,<> to NE
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*---------------------------------------------------------------------------------------	-
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.COL.FF.EXTRACT.PRE.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM ;*R22 Auto code conversion
    $INSERT I_L.APAP.COL.CUSTOMER.COMMON
    $INSERT I_F.DATES
    $INSERT I_BATCH.FILES
*-----------------------------------------------------------------------------
    
    IF NOT(CONTROL.LIST) THEN
        GOSUB REMOVE.FILES
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

    LIST.PARAMETERS = '' ; ID.LIST = ''
    
    GOSUB CRITERIA.VALUE

    Y.SELECT.CMD='SELECT ':FN.AA.ARRANGEMENT :' WITH ':CRITERIA

    CALL EB.READLIST(Y.SELECT.CMD,Y.LIST,'',NO.OF.REC,ERR)
* SJ start

*R22 interface Unit testing changes - START
*    Y.LIST=SORT(Y.LIST)
*    Y.REC.CNT=1
*    LOOP
*    WHILE Y.REC.CNT LE NO.OF.REC
*        IF Y.LIST<Y.REC.CNT> EQ Y.LIST<Y.REC.CNT-1> THEN
*            DEL Y.LIST<Y.REC.CNT>
*            NO.OF.REC-=1
*            Y.REC.CNT -= 1 ;*R22 Auto code conversion
*        END
*        Y.REC.CNT += 1 ;*R22 Auto code conversion
*    REPEAT
*
*    Y.LIST.CNT=DCOUNT(Y.LIST,@FM)
*R22 interface Unit testing changes - END
* SJ end
    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,Y.LIST)

RETURN
*-------------------------------------------------------------
CRITERIA.VALUE:
*-------------------------------------------------------------
    CHANGE  ',' TO @VM IN NUM.PRODUCT
    CHANGE  ',' TO @VM IN NUM.STATUS
    NUM.PRODUCT =DCOUNT(C.AA.PRODUCT.GROUP<1>,@VM)
    NUM.STATUS  =DCOUNT(C.AA.STATUS<1>,@VM)

    IF NUM.STATUS THEN
        CRITERIA = '('
    END
    FOR I.VAR=1 TO NUM.STATUS ;*R22 Auto code conversion
        CRITERIA   :='ARR.STATUS EQ '
        CRITERIA   := DQUOTE(C.AA.STATUS<1,I.VAR>)
        IF I.VAR NE NUM.STATUS THEN
            CRITERIA   :=' OR '
        END
    NEXT I.VAR ;*R22 Auto code conversion
    IF NUM.STATUS THEN
        CRITERIA := ')'
    END
*   CRITERIA   :='CUSTOMER' ;*SJ
    CRITERIA   :=' BY CUSTOMER' ;*R22 interface Unit testing changes - START
    
RETURN

*************
SEL.AP.CARDS:
*************
    LIST.PARAMETERS = '' ; Y.LIST = ''
    Y.SELECT.CMD='SELECT ':FN.CUSTOMER
    CALL EB.READLIST(Y.SELECT.CMD,Y.LIST,'',NO.OF.REC,ERR)
    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,Y.LIST)
RETURN

BUILD.CONTROL.LIST:
*******************
    CONTROL.LIST<-1> = "Y.AP.LOANS"
    CONTROL.LIST<-1> = "Y.AP.CARDS"
RETURN

REMOVE.FILES:
*************
    Y.EXTRACT.OUT.PATH=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.AUTO.PATH>
    Y.EXTRACT.HIST.PATH=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.HISTORY.PATH>
    SHELL.CMD ='SH -c '
    EXE.MV="mv ":Y.EXTRACT.OUT.PATH:"/*":" ":Y.EXTRACT.HIST.PATH
    DAEMON.CMD = SHELL.CMD:EXE.MV
    EXECUTE DAEMON.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.CAT.VALUE
RETURN

END
