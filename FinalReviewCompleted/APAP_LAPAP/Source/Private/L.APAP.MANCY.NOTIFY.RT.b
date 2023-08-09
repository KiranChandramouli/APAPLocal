* @ValidationCode : MjotMjA0OTgzMzE6Q3AxMjUyOjE2OTE0MDA5Mzg0MTU6SVRTUzotMTotMTo3OToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Aug 2023 15:05:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 79
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion      BP Removed
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.MANCY.NOTIFY.RT
    
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.DATES

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
