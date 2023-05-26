SUBROUTINE REDO.PREVALANCE.STATUS.PROCESS
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.PREVALANCE.STATUS.PROCESS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is a authorization routine for attaching the template REDO.PREVALANCE.STATUS.VALIDATE
*In Parameter      :
*Out Parameter     :
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                            Reference                      Description
*   ------         ------                         -------------                    -------------
*  21/09/2011      Riyas                         ODR-2010-08-0490                Initial Creation
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
    PARAM.STATUS = R.NEW(REDO.PRE.STATUS)
    Y.AC.TYPE = R.NEW(REDO.PRE.ACCT.TYPE)
    Y.AC.TYPE.ARRAY = DCOUNT(Y.AC.TYPE,@VM)
    Y.VM.ARRAY = DCOUNT(PARAM.STATUS,@VM)
    Y.SM.ARRAY = DCOUNT(PARAM.STATUS,@SM)

    Y.CNT = 1
    Y.FLAG1 = ''
    LOOP
    WHILE Y.CNT LE Y.VM.ARRAY
        Y.LIST.VAL = ''
        Y.ACCT.TYPE1 = Y.AC.TYPE<1,Y.CNT>
        Y.CHECK.VAL = PARAM.STATUS<1,Y.CNT>

        GOSUB INNNER.LOOP

        IF  Y.FLAG AND Y.FLAG1 THEN
            IF Y.ACCT.TYPE1 EQ Y.ACCT.TYPE2 THEN
                AV =Y.CNT
                AF = REDO.PRE.STATUS
                ETEXT = "EB-AC.STATUS.DUPICATE"
                CALL STORE.END.ERROR
                Y.CNT += Y.VM.ARRAY
            END
        END
        Y.CNT += 1
    REPEAT
RETURN
*-----------
INNNER.LOOP:
*-----------
    Y.IN.CNT = Y.CNT + 1
    LOOP
    WHILE Y.IN.CNT LE Y.VM.ARRAY
        Y.ACCT.TYPE2 = Y.AC.TYPE<1,Y.IN.CNT>
        Y.LIST.VAL = PARAM.STATUS<1,Y.IN.CNT>
        Y.MY.CNT = DCOUNT(Y.LIST.VAL,@SM)

        GOSUB CHEC.DUP

        Y.IN.CNT += 1
    REPEAT
RETURN
*-----------
CHEC.DUP:
*-----------
*    CHANGE VM TO FM IN Y.LIST.VAL
*   CHANGE SM TO FM IN Y.LIST.VAL
    Y.COUNT = DCOUNT(Y.CHECK.VAL,@SM)
    IF Y.COUNT EQ Y.MY.CNT THEN
        Y.FLAG1 = 1
    END ELSE
        Y.FLAG1 = ''
    END
*    Y.CNT.SM = 1
*    LOOP
*    WHILE Y.CNT.SM LE Y.COUNT
*        LOCATE Y.CHECK.VAL<1,1,Y.CNT.SM> IN Y.LIST.VAL SETTING POS THEN
*            Y.FLAG = '1'
*        END ELSE
*            Y.FLAG = ''
*            Y.CNT.SM = Y.CNT.SM + Y.COUNT
*        END
*        Y.CNT.SM = Y.CNT.SM + 1
*    REPEAT
* The above code is replace for ACCOUNTING CR change as below IF condition
    IF Y.CHECK.VAL EQ Y.LIST.VAL THEN

        Y.FLAG = '1'
    END ELSE
        Y.FLAG = ''
    END
    IF  Y.FLAG AND Y.FLAG1 THEN

        IF  Y.ACCT.TYPE1 EQ Y.ACCT.TYPE2 THEN
            AV =Y.CNT
            AF = REDO.PRE.STATUS
            ETEXT = "EB-AC.STATUS.DUPICATE"
            CALL STORE.END.ERROR
            GOSUB GOEND
        END
    END
RETURN
*----------------
GOEND:
*---------------_
END
