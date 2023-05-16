$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.RTE.VAL.NO.CLIENTE.RT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.AML.PARAM

    FN.REDO.AML.PARAM='F.REDO.AML.PARAM'
    F.REDO.AML.PARAM=''
    CALL OPF(FN.REDO.AML.PARAM,F.REDO.AML.PARAM)

    Y.PARAM.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.AML.PARAM,Y.PARAM.ID,R.AML.PARAM,AML.ERR)
    Y.AMT.LIMIT.LCY = R.AML.PARAM<AML.PARAM.AMT.LIMIT.LCY>
    Y.AMT.LIMIT.FCY = R.AML.PARAM<AML.PARAM.AMT.LIMIT.FCY>

    Y.ACTUAL.VERSIO = R.NEW(65)<1,136>
    Y.MONTO = ""

    IF Y.ACTUAL.VERSIO EQ 'TELLER,REDO.LCY.CASHIN.ML' THEN
        Y.MONTO = R.NEW(TT.TE.AMOUNT.LOCAL.2)

        IF Y.MONTO GE Y.AMT.LIMIT.LCY THEN
            TEXT = 'TELLER-RTE.VAL.NO.CLIENTE'
            CURR.NO = 1
            CALL STORE.OVERRIDE(CURR.NO)
        END
    END ELSE
        IF Y.ACTUAL.VERSIO EQ 'TELLER,REDO.LCY.CASHIN.ME' THEN
            Y.MONTO = R.NEW(TT.TE.AMOUNT.FCY.2)

            IF Y.MONTO GE Y.AMT.LIMIT.FCY THEN
                TEXT = 'TELLER-RTE.VAL.NO.CLIENTE'
                CURR.NO = 1
                CALL STORE.OVERRIDE(CURR.NO)
            END
        END
    END

RETURN

END
