*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.VAL.INAC
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.AZ.ACCOUNT
    $INSERT T24.BP I_F.ACCOUNT


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


    VAR.ID =  R.NEW(AZ.NOMINATED.ACCOUNT)

    CALL F.READ(FN.ACCOUNT,VAR.ID,R.ACCOUNT,F.ACCOUNT,YERR)

    CALL GET.LOC.REF("ACCOUNT","L.AC.STATUS1",ACC.POS)

    VAR.AZ.STATUS = R.ACCOUNT<AC.LOCAL.REF,ACC.POS>

    IF VAR.AZ.STATUS EQ "3YINACTIVE" THEN

        TEXT='REDO.AC.CHECK.ACTIVE':FM:VAR.ID:VM:' INACTIVA 3 ANOS'

        CURR.NO=1

        CALL STORE.OVERRIDE(CURR.NO)

    END

    RETURN

    IF VAR.AZ.STATUS EQ "ABANDONED" THEN
        TEXT='REDO.AC.CHECK.ACTIVE':FM:VAR.ID:VM:' ABANDONADA'

        CURR.NO=1

        CALL STORE.OVERRIDE(CURR.NO)

    END

    RETURN

    IF VAR.AZ.STATUS EQ "6MINACTIVE" THEN

        TEXT='REDO.AC.CHECK.ACTIVE':FM:VAR.ID:VM:' INACTIVIDAD INTERNA'

        CURR.NO=1

        CALL STORE.OVERRIDE(CURR.NO)

    END

    RETURN

END