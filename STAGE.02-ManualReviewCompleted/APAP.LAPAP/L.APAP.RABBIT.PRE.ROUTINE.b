$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.RABBIT.PRE.ROUTINE(Y.DYN.MAPPING.IN, Y.DYN.REQUEST.OFS.KEY, Y.DYN.REQUEST.VALUE, Y.DYN.REQUEST.OFS.TYPE, Y.ADDNL.INFO, Y.ERROR)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - > to GT , = to EQ , Include to Insert and T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

*CLEAR OUTPUTS VARIABLES
    Y.OFS.IN.REQUEST = ''
    Y.ERROR = ''
    Y.ERROR<3> = 'L.APAP.RABBIT.PRE.ROUTINE'

    Y.FIELD.CNT = DCOUNT(Y.DYN.REQUEST.OFS.KEY, @FM)
    Y.MASK.OUT.TRN = Y.DYN.MAPPING.IN<8>
    CHANGE @VM TO @FM IN Y.MASK.OUT.TRN
    Y.MAPPING.FIELD.CNT  = DCOUNT(Y.MASK.OUT.TRN, @FM)


    Y.OFS.TRANSACTION.ID = ''
    Y.PRE.ROUTINE = ''
    Y.PRE.ROUTINE.ITEMS = ''

    Y.PRE.ROUTINE.CNT = 0

    GOSUB CHECK.MAPPING
    IF Y.PRE.ROUTINE.CNT GT 0 THEN
        GOSUB GET.RECORD.ID
        GOSUB RUN.ROUTINE
    END

RETURN


CHECK.MAPPING:
    Y.AT.CHR = ''
    FOR V.I = 1 TO Y.MAPPING.FIELD.CNT STEP 1
        Y.AT.CHR = ''
        Y.PRE.ROUTINE.ITEMS = ''

        Y.PRE.ROUTINE.ITEMS = Y.MASK.OUT.TRN<V.I>
        Y.AT.CHR = Y.PRE.ROUTINE.ITEMS[1,1]

        IF Y.AT.CHR EQ '@' THEN
            CHANGE '@' TO '' IN Y.PRE.ROUTINE.ITEMS
            Y.PRE.ROUTINE<-1> = Y.PRE.ROUTINE.ITEMS
        END
    NEXT V.I
    Y.PRE.ROUTINE.CNT = DCOUNT(Y.PRE.ROUTINE,@FM)
RETURN


GET.RECORD.ID:
    IF Y.ERROR<1> EQ 1 THEN
        RETURN
    END

    FOR V.I = 1 TO Y.FIELD.CNT STEP 1
*DEBUG

        IF Y.DYN.REQUEST.OFS.KEY<V.I> NE '*' THEN
            IF Y.DYN.REQUEST.OFS.KEY<V.I> EQ 'ID' OR Y.DYN.REQUEST.OFS.KEY<V.I>  EQ '@ID' THEN
                Y.OFS.TRANSACTION.ID = Y.DYN.REQUEST.VALUE<V.I>
            END
        END
    NEXT V.I

*IF Y.OFS.TRANSACTION.ID = '' THEN
*    Y.ERROR<1> = 1
*    Y.ERROR<2> = "REQUEST DON'T HAVE <ID/ID> FILLED"
*END
RETURN

RUN.ROUTINE:
    IF Y.ERROR<1> EQ 1 THEN
        RETURN
    END

    Y.RUN.RTN = ''
    FOR V.I = 1 TO Y.PRE.ROUTINE.CNT STEP 1
        Y.RUN.RTN = Y.PRE.ROUTINE<V.I>
        CALL @Y.RUN.RTN(Y.OFS.TRANSACTION.ID, Y.DYN.MAPPING.IN, Y.DYN.REQUEST.OFS.KEY, Y.DYN.REQUEST.VALUE, Y.DYN.REQUEST.OFS.TYPE, Y.ADDNL.INFO, Y.ERROR)
    NEXT V.I

RETURN


RETURN
