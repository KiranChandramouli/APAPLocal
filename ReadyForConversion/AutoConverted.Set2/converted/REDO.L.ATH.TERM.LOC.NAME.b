*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.L.ATH.TERM.LOC.NAME(Y.ATH.ID)

    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_BATCH.FILES
    $INCLUDE TAM.BP I_F.REDO.ATH.SETTLMENT
    $INCLUDE TAM.BP I_REDO.L.ATH.TERM.LOC.NAME.COMMON


    GOSUB INIT
    GOSUB PROCESS
    RETURN

INIT:
*****
    R.REDO.ATH.SETTLEMENT=''; Y.ERR = ''; Y.ATM.CITY.STATE = ''
    Y.TERM.LOC.VAL = ''; Y.TERM.OWN.NAME = ''; Y.TERM.ID = ''
    RETURN

PROCESS:
********
    CALL F.READ(FN.REDO.ATH.SETTLMENT,Y.ATH.ID,R.REDO.ATH.SETTLEMENT,F.REDO.ATH.SETTLMENT,Y.ERR)
    IF NOT(R.REDO.ATH.SETTLEMENT) THEN
        RETURN
    END

    Y.TERM.LOC.VAL = R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.LOC.NAME>
    IF Y.TERM.LOC.VAL THEN
        R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.LOC.NAME>=UTF8(Y.TERM.LOC.VAL)
    END

    Y.TERM.OWN.NAME = R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.OWNER.NAME>
    IF Y.TERM.OWN.NAME THEN
        R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.OWNER.NAME>=UTF8(Y.TERM.OWN.NAME)
    END

    Y.TERM.ID = R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.FIID>
    IF Y.TERM.ID THEN
        R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.FIID>=UTF8(Y.TERM.ID)
    END

    Y.ATM.CITY.STATE = R.REDO.ATH.SETTLEMENT<ATH.SETT.ATM.CITY.STATE>
    IF Y.ATM.CITY.STATE THEN
        R.REDO.ATH.SETTLEMENT<ATH.SETT.ATM.CITY.STATE>=UTF8(Y.ATM.CITY.STATE)
    END
    CALL F.WRITE(FN.REDO.ATH.SETTLMENT,Y.ATH.ID,R.REDO.ATH.SETTLEMENT)

    RETURN
END