SUBROUTINE REDO.PREVALANCE.STATUS.VALIDATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.PREVALANCE.STATUS.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is a authorization routine for attaching the template REDO.PREVALANCE.STATUS.VALIDATE
*In Parameter      :
*Out Parameter     :
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                            Reference                      Description
*   ------         ------                         -------------                    -------------
*  08/10/2010   Jeyachandran S                     ODR-2010-08-0490                Initial Creation
*  DATE            NAME                  REFERENCE                     DESCRIPTION
* 24 NOV  2022    Edwin Charles D       ACCOUNTING-CR                 Changes applied for Accounting reclassification CR
* 27 DEC  2022    Edwin Charles D       ACCOUNTING-CR                 Changes applied for Accounting reclassification CR
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.PREVALANCE.STATUS

    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB GOEND
RETURN

************
OPEN.FILES:
************
    FN.REDO.PREVALANCE.STATUS = 'F.REDO.PREVALANCE.STATUS'
    F.REDO.PREVALANCE.STATUS = ''
    CALL OPF(FN.REDO.PREVALANCE.STATUS,F.REDO.PREVALANCE.STATUS)
    Y.FINAL.STATUS = ''; Y.FM.STATUS='';LOOP.SM.CNTR ='' ; LOOP.FM.CNTR = '' ; STAT.FM.CNTR = ''; STAT.SM.CNTR = ''; Y.FLAG = ''; Y.ERROR = ''
RETURN
*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------
    PARAM.STATUS = CHANGE(R.NEW(REDO.PRE.STATUS),@VM,@FM)
    PREVALANCE.STATUS = CHANGE(R.NEW(REDO.PRE.PREVALANT.STATUS),@VM,@FM)
    Y.AC.TYPE.LIST = CHANGE(R.NEW(REDO.PRE.ACCT.TYPE),@VM,@FM)
    STAT.FM.CNTR = DCOUNT(PARAM.STATUS,@FM)
    IF STAT.FM.CNTR LT 1 THEN
        AF = REDO.PRE.STATUS
        AV = 1
        ETEXT = "EB-AC.STATUS.INPUT.MISSING"
        CALL STORE.END.ERROR
    END
    LOOP.FM.CNTR = 1
    LOOP
    WHILE LOOP.FM.CNTR LE STAT.FM.CNTR
        Y.FM.STATUS1 = PARAM.STATUS<LOOP.FM.CNTR>
        Y.FM.STATUS = CHANGE(Y.FM.STATUS1,@SM,@FM)
        Y.FINAL.STATUS = PREVALANCE.STATUS<LOOP.FM.CNTR>
        Y.ACCT.TYPE1 = Y.AC.TYPE.LIST<LOOP.FM.CNTR>
        Y.ERROR = ''
        GOSUB SM.COUNTER.CHECK

        IF NOT(Y.FINAL.STATUS) THEN
            AF = REDO.PRE.PREVALANT.STATUS
            AV = LOOP.FM.CNTR
            ETEXT = "EB-AC.STATUS.PREVAL.MISSING"
            CALL STORE.END.ERROR
        END
* ELSE
*   LOCATE Y.FM.STATUS1 IN PARAM.STATUS SETTING SECOND.POS THEN
*      IF SECOND.POS EQ LOOP.FM.CNTR ELSE
*         AF = REDO.PRE.STATUS
*        AV = SECOND.POS
*       ETEXT = "EB-AC.STATUS.DUPICATE"
*      CALL STORE.END.ERROR
* END
* END
* END

        LOOP.FM.CNTR + = 1
    REPEAT
RETURN
*--------------------------------------------------------------------------------------------
SM.COUNTER.CHECK:
*--------------------------------------------------------------------------------------------
    STAT.SM.CNTR = DCOUNT(Y.FM.STATUS,@FM)
    IF STAT.SM.CNTR LT 1 THEN
        AF = REDO.PRE.STATUS
        AV = LOOP.FM.CNTR
        AS = 1
        ETEXT = "EB-AC.STATUS.INPUT.MISSING"
        CALL STORE.END.ERROR
    END
    LOOP.SM.CNTR = 1
    LOOP
    WHILE LOOP.SM.CNTR LE STAT.SM.CNTR
        Y.SM.STATUS = Y.FM.STATUS<LOOP.SM.CNTR>
        IF NOT(Y.SM.STATUS) THEN
            AF = REDO.PRE.STATUS
            AV = LOOP.FM.CNTR
            AS = LOOP.SM.CNTR
            ETEXT = "EB-AC.STATUS.INPUT.MISSING"
            CALL STORE.END.ERROR
        END
        LOCATE Y.SM.STATUS IN Y.FM.STATUS SETTING FIRST.POS THEN
            IF FIRST.POS EQ LOOP.SM.CNTR ELSE
                AF = REDO.PRE.STATUS
                AV = LOOP.FM.CNTR
                AS = LOOP.SM.CNTR
                ETEXT = "EB-AC.STATUS.DUPICATE.VALUES"
                CALL STORE.END.ERROR
            END
        END
        LOOP.SM.CNTR + = 1
    REPEAT
RETURN
*-----------
GOEND:
END
