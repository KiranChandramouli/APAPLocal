*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.MANCY.NOTIFY.RT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.DATES

    GOSUB INI
    GOSUB INITIAL_PROCESS



INI:
**---------------------------------------
**ABRIR LA TABLA FBNK.ACCOUNT
**---------------------------------------
    FN.ACC = "F.ACCOUNT"
    F.ACC = ""
    R.ACC = ""
    ACC.ERR = ""
    CALL OPF(FN.ACC,F.ACC)

    RETURN

    INITIAL_PROCESS:
    Y.RELATION.CODE = R.NEW(AC.RELATION.CODE)
     IF (Y.RELATION.CODE = 500) THEN
        GOSUB PROCESS
    END

    RETURN

    PROCESS:

    CALL GET.LOC.REF("ACCOUNT", "L.AC.NOTIFY.1",AC.POS.1)
    *R.NEW(AC.LOCAL.REF)<1,AC.POS.1> = "MANCOMUNADA.Y"

     Y.APP.NAME = "ACCOUNT";
     Y.VER.NAME = "ACCOUNT,MB.DM.LOAD";
     Y.PRO.VAL = "PROCESS";
     Y.FUNC = "I"; Y.GTS.CONTROL = "";
     Y.NO.OF.AUTH = 0;
     FINAL.OFS = "";
     OPTIONS = "";
     R.ACC = "";
     VAR.ID = ID.NEW

    *R.ACC<AC.RELATION.CODE,1> = R.NEW(AC.RELATION.CODE)
     R.ACC<AC.LOCAL.REF,AC.POS.1> = "MANCOMUNADA.Y"

     CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,VAR.ID,R.ACC,FINAL.OFS)
     CALL OFS.POST.MESSAGE(FINAL.OFS,'',"DM.OFS.SRC.VAL",'')
     *CALL JOURNAL.UPDATE('')

    RETURN


END
