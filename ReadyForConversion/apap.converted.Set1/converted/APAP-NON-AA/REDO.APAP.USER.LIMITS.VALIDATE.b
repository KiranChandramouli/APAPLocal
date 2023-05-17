SUBROUTINE REDO.APAP.USER.LIMITS.VALIDATE
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: .VALIDATE routine
*------------
*DESCRIPTION:
*------------
* This is the .VALIDATE routine to avaoid the duplication of values entered at the
* field level
*---------------------------------------------------------------------------
* Input / Output
*----------------
*
* Input / Output
* IN     : -na-
* OUT    : -na-
*
*---------------------------------------------------------------------------
* Revision History
* Date           Who                Reference              Description
* 09-NOV-2010   A.SabariKumar     ODR-2010-07-0075       Initial Creation
* 08-APR-2011   Pradeep S         PACS00036002           Removed the validation for
*                                                        MM.LIMIT.DATE & SC.LIMIT.DATE
*---------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.USER.LIMITS

    Y.TODAY = TODAY
    Y.SIN.TXN.DATE.COUNT = DCOUNT(R.NEW(REDO.USR.LIM.SIN.TXN.LIM.DATE),@VM)
    Y.TOT.TXN.DATE.COUNT = DCOUNT(R.NEW(REDO.USR.LIM.TOT.TXN.LIM.DATE),@VM)
    Y.TRA.LIM.DATE.COUNT = DCOUNT(R.NEW(REDO.USR.LIM.TRA.LIM.VALID.DATE),@VM)
    Y.BPS.LIM.DATE = R.NEW(REDO.USR.LIM.BPS.LIM.VALID.DATE)
    Y.MM.LIMIT.DATE = R.NEW(REDO.USR.LIM.MM.LIMIT.DATE)
    Y.SC.LIMIT.DATE = R.NEW(REDO.USR.LIM.SC.LIMIT.DATE)

    AF = REDO.USR.LIM.APPLICATION
    CALL DUP

    AF = REDO.USR.LIM.SIN.TXN.LIM.DATE
    INIT = 1
    LOOP
    WHILE INIT LE Y.SIN.TXN.DATE.COUNT
        Y.SIN.TXN.DATE = R.NEW(REDO.USR.LIM.SIN.TXN.LIM.DATE)<1,INIT>
        IF Y.SIN.TXN.DATE LT Y.TODAY AND Y.SIN.TXN.DATE NE '' THEN
            AV = INIT
            ETEXT = 'EB-DATE.NOTLT.TODAY'
            CALL STORE.END.ERROR
        END
        INIT += 1
    REPEAT

    AF = REDO.USR.LIM.TOT.TXN.LIM.DATE
    INIT = 1
    LOOP
    WHILE INIT LE Y.TRA.LIM.DATE.COUNT
        AV = INIT
        Y.TOT.TXN.DATE = R.NEW(REDO.USR.LIM.TOT.TXN.LIM.DATE)<1,INIT>
        IF Y.TOT.TXN.DATE LT Y.TODAY AND Y.TOT.TXN.DATE NE '' THEN
            ETEXT = 'EB-DATE.NOTLT.TODAY'
            CALL STORE.END.ERROR
        END
        INIT += 1
    REPEAT

    AF = REDO.USR.LIM.TRA.LIM.VALID.DATE
    INIT = 1
    LOOP
    WHILE INIT LE Y.TRA.LIM.DATE.COUNT
        AV = INIT
        Y.TRA.LIM.DATE = R.NEW(REDO.USR.LIM.TRA.LIM.VALID.DATE)<1,INIT>
        IF Y.TRA.LIM.DATE LT Y.TODAY AND Y.TRA.LIM.DATE NE '' THEN
            ETEXT = 'EB-DATE.NOTLT.TODAY'
            CALL STORE.END.ERROR
        END
        INIT += 1
    REPEAT

    AF = REDO.USR.LIM.BPS.LIM.VALID.DATE
    IF Y.BPS.LIM.DATE LT Y.TODAY AND Y.BPS.LIM.DATE NE '' THEN
        ETEXT = 'EB-DATE.NOTLT.TODAY'
        CALL STORE.END.ERROR
    END

*PACS00036002 - S
* AF = REDO.USR.LIM.MM.LIMIT.DATE
* IF Y.MM.LIMIT.DATE LT Y.TODAY AND Y.MM.LIMIT.DATE NE '' THEN
*     ETEXT = 'EB-DATE.NOTLT.TODAY'
*     CALL STORE.END.ERROR
* END


* AF = REDO.USR.LIM.SC.LIMIT.DATE
* IF Y.SC.LIMIT.DATE LT Y.TODAY AND Y.SC.LIMIT.DATE NE '' THEN
*     ETEXT = 'EB-DATE.NOTLT.TODAY'
*     CALL STORE.END.ERROR
* END
*PACS00036002 - E

RETURN
*---------------------------------------------------------------------------
END
