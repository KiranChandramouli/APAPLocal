SUBROUTINE REDO.VAL.AC.MONTH.DURATION
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.VAL.AC.MONTH.DURATION
*---------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*22 JUN 2012     Prabhu             CR12-PACS00202727  Routine to check alpha numeric check
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.LOOKUP


    GOSUB PROCESS

RETURN

**********
PROCESS:
**********
*checking the suffix

    IF NOT(COMI) THEN
        RETURN
    END
    Y.AC.DAY.MONTH = COMI
    Y.COUNT.DM = LEN(Y.AC.DAY.MONTH)
    Y.SUFFIX.DM = Y.AC.DAY.MONTH[Y.COUNT.DM,-1]
    IF Y.SUFFIX.DM EQ 'M' OR Y.SUFFIX.DM EQ 'D' THEN
    END ELSE
        AF = EB.LU.LOCAL.REF
        ETEXT = 'EB-SUFFIX.DAY.OR.MONTH'
        CALL STORE.END.ERROR
    END

*checking alphapets inside the word

    Y.TOTAL.LEN = Y.COUNT.DM - 1
    Y.DM.POSITION = Y.AC.DAY.MONTH[1,Y.TOTAL.LEN]
    Y.CHK.VALUE = ISDIGIT(Y.DM.POSITION)
    IF Y.CHK.VALUE  EQ 1 THEN
    END ELSE
        AF = EB.LU.LOCAL.REF
        ETEXT = 'EB-SUFFIX.DAY.OR.MONTH'
        CALL STORE.END.ERROR
    END
RETURN

END
