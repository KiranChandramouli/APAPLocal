SUBROUTINE REDO.CARD.DAMAGE.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.DAMAGE.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a validation routine
*Linked With  : Application REDO.CARD.DAMAGE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 29 Jul  2010    Mohammed Anies K      ODR-2010-03-0400         Initial Creation
* 6 Apr 2011      Kavitha               PACS00052984             Logic changed for multiple damage entry
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.DAMAGE
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.REDO.CARD.NUMBERS
    $INSERT I_F.REDO.STOCK.ENTRY
    $INSERT I_F.REDO.STOCK.REGISTER
    $INSERT I_REDO.CARD.DAMAGE.COMMON

*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

    PREV.CARD.NUMBER = ''

    FN.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
    F.CARD.REQUEST = ''
    CALL OPF(FN.CARD.REQUEST,F.CARD.REQUEST)

    FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
    F.REDO.CARD.NUMBERS = ''
    CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section

    CARD.SERIES = R.NEW(REDO.CARD.DAM.CARD.SERIES)

    CHANGE @VM TO @FM IN CARD.SERIES

    CARD.SERIES.CNT = DCOUNT(CARD.SERIES,@FM)

    Y.INIT.SS.ID = 1
    LOOP
    WHILE Y.INIT.SS.ID LE CARD.SERIES.CNT

        EXISTING.CARD = ''
        DAM.CARD.NUMBER = ''
        DUP.FLAG = ''

        GOSUB DAMAGE.CARD

*PACS00052984-S

*   Y.DAMAGE.REASON = R.NEW(REDO.CARD.DAM.REASON)<1,Y.INIT.SS.ID>
*   Y.DAMAGE = COUNT(Y.DAMAGE.REASON,"DAMAGE")
*   Y.LOST =   COUNT(Y.DAMAGE.REASON,"LOST")
*Y.RETURN =  COUNT(Y.DAMAGE.REASON,"RETURN")
*   R.NEW(REDO.CARD.DAM.TOT.DAMAGES)<1,Y.INIT.SS.ID> = Y.DAMAGE + R.NEW(REDO.CARD.DAM.TOT.DAMAGES.OLD)<1,Y.INIT.SS.ID>
*   R.NEW(REDO.CARD.DAM.TOT.LOST)<1,Y.INIT.SS.ID>    = Y.LOST + R.NEW(REDO.CARD.DAM.TOT.LOST.OLD)<1,Y.INIT.SS.ID>
*R.NEW(REDO.CARD.DAM.TOT.RETURN)<1,Y.INIT.SS.ID>  = Y.RETURN + R.NEW(REDO.CARD.DAM.TOT.RETURN.OLD)<1,Y.INIT.SS.ID>

*PACS00052984 -E

        Y.INIT.SS.ID +=1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
************
DAMAGE.CARD:
************

    Y.TOT.CARD.NOS = ''
    TOT.CARD.NOS = ''
    TOT.CARD.REASON = ''

    Y.REDO.CARD.NUMBERS.ID = R.NEW(REDO.CARD.DAM.CARD.TYPE)<1,Y.INIT.SS.ID>:'.':ID.COMPANY
    CALL F.READ(FN.REDO.CARD.NUMBERS,Y.REDO.CARD.NUMBERS.ID,R.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS,REDO.CARD.NUMBERS.ERR)
    Y.CARD.NUMBERS = R.NEW(REDO.CARD.DAM.CARD.NUMBER)<1,Y.INIT.SS.ID>
    Y.CARD.REASON = R.NEW(REDO.CARD.DAM.REASON)<1,Y.INIT.SS.ID>

    TOT.CARD.NOS = DCOUNT(Y.CARD.NUMBERS,@SM)
    TOT.CARD.REASON = DCOUNT(Y.CARD.REASON,@SM)

    IF TOT.CARD.NOS GT TOT.CARD.REASON THEN
        Y.TOT.CARD.NOS = TOT.CARD.NOS
    END ELSE
        Y.TOT.CARD.NOS = TOT.CARD.REASON
    END

    Y.INT.SM.COUNT = 1
    LOOP
    WHILE Y.INT.SM.COUNT LE Y.TOT.CARD.NOS


        Y.IND.CARD.NO = ''
        Y.IND.CARD.REASON = ''
        DUP.FLAG = ''
        CARD.REQ.TYPE = R.NEW(REDO.CARD.DAM.CARD.TYPE)<1,Y.INIT.SS.ID>

        IF CARD.REQ.TYPE EQ REDO.CARD.TYPE THEN
            R.NEW(REDO.CARD.DAM.CARD.NUMBER)<1,Y.INIT.SS.ID,1>= REDO.CARD.NO
        END


        Y.IND.CARD.NO = R.NEW(REDO.CARD.DAM.CARD.NUMBER)<1,Y.INIT.SS.ID,Y.INT.SM.COUNT>
        Y.IND.CARD.REASON = R.NEW(REDO.CARD.DAM.REASON)<1,Y.INIT.SS.ID,Y.INT.SM.COUNT>

        REDO.CARD.NUMBERS = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER>
        CHANGE @VM TO @FM IN REDO.CARD.NUMBERS

        IF Y.IND.CARD.NO AND NOT(Y.IND.CARD.REASON) THEN
            AF = REDO.CARD.DAM.CARD.NUMBER
            AV = Y.INIT.SS.ID
            AS = Y.INT.SM.COUNT

            ETEXT= "EB-CARD.REASON.MISSING"
            CALL STORE.END.ERROR

        END
        IF Y.IND.CARD.REASON AND NOT(Y.IND.CARD.NO) THEN
            AF = REDO.CARD.DAM.REASON
            AV = Y.INIT.SS.ID
            AS = Y.INT.SM.COUNT

            ETEXT= "EB-CARD.NUMBER.MISSING"
            CALL STORE.END.ERROR

        END

        IF Y.IND.CARD.NO THEN
            LOCATE Y.IND.CARD.NO IN PREV.CARD.NUMBER SETTING EXIST.POS THEN

                AF = REDO.CARD.DAM.CARD.NUMBER
                AV = Y.INIT.SS.ID
                AS = Y.INT.SM.COUNT

                ETEXT= "EB-DUP"
                CALL STORE.END.ERROR
                RETURN
            END

            LOCATE Y.IND.CARD.NO IN REDO.CARD.NUMBERS SETTING Y.CARD.POS ELSE

                AF = REDO.CARD.DAM.CARD.NUMBER
                AV = Y.INIT.SS.ID
                AS = Y.INT.SM.COUNT

                ETEXT= "EB-CARD.NUMBER"
                CALL STORE.END.ERROR

            END

            GET.OLD.NUMBER = R.NEW(REDO.CARD.DAM.CARD.NUMBER.OLD)<1,Y.INIT.SS.ID>
            CHANGE @SM TO @FM IN GET.OLD.NUMBER

            LOCATE Y.IND.CARD.NO IN GET.OLD.NUMBER SETTING CARD.DAM.POS THEN
                AF = REDO.CARD.DAM.CARD.NUMBER
                AV = Y.INIT.SS.ID
                AS = Y.INT.SM.COUNT

                ETEXT= "EB-CARD.NUMBER.DAMAGE"
                CALL STORE.END.ERROR

            END
        END

        PREV.CARD.NUMBER<-1> = Y.IND.CARD.NO
        Y.INT.SM.COUNT+=1

    REPEAT


RETURN
*----------------------------------------------------------------------------------------------------------
END
