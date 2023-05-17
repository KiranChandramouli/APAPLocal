SUBROUTINE REDO.CARD.REORDER.DEST.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REORDER.DEST.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a validation routine to default value in CARD.START.NO based on the value in
*               CARD.SERIES.NO and to validate account entered in ACCOUNT field
*Linked With  : Application REDO.CARD.REORDER.DEST.VALIDATE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 16 JUN 2011     KAVITHA               PACS00082671              FIX FOR PACS00082671
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.SERIES.PARAM
    $INSERT I_F.REDO.CARD.REORDER.DEST

*--------------------------------------------------------------------------------------------------------

    FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
    F.REDO.CARD.SERIES.PARAM = ''
    CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)

    CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM','SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR)
    Y.PARAM.CARD.TYPE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.TYPE>

    Y.TOT.CARD.TYPES = DCOUNT(R.NEW(REDO.REORD.DEST.CARD.TYPE),@VM)
    Y.INIT.COUNT = 1
    LOOP
    WHILE Y.INIT.COUNT LE Y.TOT.CARD.TYPES
        CARD.TYPE.FETCH = R.NEW(REDO.REORD.DEST.CARD.TYPE)<1,Y.INIT.COUNT>

        LOCATE CARD.TYPE.FETCH IN Y.PARAM.CARD.TYPE<1,1> SETTING Y.CARD.POS THEN

            PAR.CARD.SERIES = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.SERIES,Y.CARD.POS>
            R.NEW(REDO.REORD.DEST.CARD.SERIES)<1,Y.INIT.COUNT> = PAR.CARD.SERIES
        END
        Y.INIT.COUNT += 1
    REPEAT

RETURN
*---------------
END
