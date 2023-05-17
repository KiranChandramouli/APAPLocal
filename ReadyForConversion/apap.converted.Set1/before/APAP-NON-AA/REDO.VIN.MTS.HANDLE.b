*-----------------------------------------------------------------------------
* <Rating>-54</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.VIN.MTS.HANDLE
*
* =======================================================================
*
*    First Release : Nelson Salgado
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2011/Apr/06
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_F.VERSION
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.ID
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.TRANSACTION
*
    $INSERT I_F.REDO.MULTITXN.PARAMETER
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_REDO.NV.COMMON
    $INSERT I_GTS.COMMON
*

    IF OFS$SOURCE.ID EQ 'FASTPATH' THEN
        R.VERSION(EB.VER.GTS.CONTROL) = 1
    END

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
    RETURN
*--------
PROCESS:
*--------
*
* Following lines commented as per code review process

    IF R.NEW(TT.TE.RECORD.STATUS) NE "IHLD" THEN
        CALL REDO.NV.DELETE.PROC
    END
*
    RETURN
*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
*   Paragraph that control the error in the subroutine
*
    IF Y.ERR.MSG THEN
        ETEXT           = Y.ERR.MSG
        CALL STORE.END.ERROR
        ETEXT           = ""
    END
*
    RETURN
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD    = 1
*
    Y.ERR.MSG = ""
*
    WAPP.LST = "TELLER.ID" : FM : "TELLER"
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO    = CHANGE(WCAMPO,FM,VM)
    WFLD.LST  = WCAMPO
    WCAMPO    = "L.NEXT.VERSION"
    WCAMPO    = CHANGE(WCAMPO,FM,VM)
    WFLD.LST := FM : WCAMPO

    YPOS = ''
    CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
    WPOSLI    = YPOS<1,1>
*
    WPOSNV    = YPOS<2,1>
*
    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID  = ""
*
    WVAR.NAMES    = "CURRENT.AUTOR.PROCESS"
    WVAR.NAMES<2> = "CURRENT.PROC.AUTOR"
    WVAR.NAMES<3> = "CURRENT.WTM.RESULT"
    WVAR.VAL      = ""
    WPOS.X        = 0
*
    WTT.ID            = R.NEW(TT.TE.TELLER.ID.1)
    CALL System.getUserVariables( U.VARNAMES, U.VARVALS )
*
    LOOP
        REMOVE WWVAR FROM WVAR.NAMES SETTING WVAR.POS
    WHILE WWVAR : WVAR.POS DO
        WPOS.X += 1
        LOCATE WWVAR IN U.VARNAMES SETTING YPOS.VAR THEN
            WVAR.VAL<WPOS.X> = U.VARVALS<YPOS.VAR>
        END ELSE
            WVAR.VAL<WPOS.X> = WWVAR
        END
    REPEAT
*
    WTM.AUTOR.PROCESS = WVAR.VAL<1>
    WTM.PROC.AUTOR    = WVAR.VAL<2>
*
    RETURN
*
* =========
OPEN.FILES:
* =========
*
*
    RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1
    MAX.LOOPS = 3
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
        CASE LOOP.CNT EQ 1

            CALL F.READ(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ)
            IF R.TELLER.ID THEN
                WINITIAL.ID  = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI>
            END
            IF (WINITIAL.ID EQ "" AND R.NEW(TT.TE.LOCAL.REF)<1,WPOSNV> EQ "") OR ((WTM.AUTOR.PROCESS = "A" OR WTM.PROC.AUTOR = "A") AND V$FUNCTION NE "D") THEN
                PROCESS.GOAHEAD              = ""
            END

        CASE LOOP.CNT EQ 2

            WTM.RESULT = WVAR.VAL<3>
            IF WTM.RESULT EQ "CURRENT.WTM.RESULT" OR WTM.RESULT EQ "" THEN
                WTM.RESULT = 0
            END
            WTM.RESULT = 0
            IF R.NEW(TT.TE.LOCAL.REF)<1,WPOSNV> EQ "" AND WTM.RESULT NE 0 THEN
                Y.ERR.MSG = "EB-TRAN.VALUE.NE.BALANCE:&":FM:WTM.RESULT
                AF = TT.TE.AMOUNT.LOCAL.1
                PROCESS.GOAHEAD = ""
            END

        CASE LOOP.CNT EQ 3
            IF R.VERSION(EB.VER.NO.OF.AUTH) EQ 0 AND OFS$SOURCE.ID NE 'FASTPATH' THEN
                R.VERSION(EB.VER.NO.OF.AUTH) = 1
            END

            IF V$FUNCTION NE "D" THEN
                PROCESS.GOAHEAD = ""
            END

        END CASE
*       Message Error
        GOSUB CONTROL.MSG.ERROR
*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
    RETURN
*
END
