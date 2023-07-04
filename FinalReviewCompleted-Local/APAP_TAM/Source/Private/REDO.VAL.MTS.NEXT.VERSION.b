* @ValidationCode : Mjo2MDEyNjI4NDQ6Q3AxMjUyOjE2ODM3Mjg4Njk1ODc6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 May 2023 19:57:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.MTS.NEXT.VERSION
******************************************************************************
* =============================================================================
*
*=======================================================================
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2011/Apr/06
*
** 18-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 18-04-2023 Skanda R22 Manual Conversion - added APAP.TAM
*=======================================================================
*
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.TELLER ;* R22 Auto conversion
    $INSERT I_System ;* R22 Auto conversion
	$USING APAP.TAM
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
    IF COMI EQ "TELLER,LAST" THEN
        COMI = ""
    END
*
RETURN
*
*--------
PROCESS:
*--------
*
    WACCT     = ""
*
    IF WSIDE EQ "1" THEN
        R.NEW(TT.TE.ACCOUNT.1) = CHANGE(R.NEW(TT.TE.ACCOUNT.1),WCATINI,WCATNEW)
        WCCT = R.NEW(TT.TE.ACCOUNT.1)
    END ELSE
        R.NEW(TT.TE.ACCOUNT.2) = CHANGE(R.NEW(TT.TE.ACCOUNT.2),WCATINI,WCATNEW)
        WACCT = R.NEW(TT.TE.ACCOUNT.2)
    END
*
    CALL System.setVariable("CURRENT.CHANGED","YES")
    CALL System.setVariable("CURRENT.CATEGORI",WCATINI)
    CALL System.setVariable("CURRENT.CATEGNEW",WCATINI)
*
RETURN
*
* ===================
GET.SYSTEM.VARIABLES:
* ===================
*
***
*
    WVAR.NAMES    = "CURRENT.SIDE"
    WVAR.NAMES<2> = "CURRENT.CATEGORI"
    WVAR.NAMES<3> = "CURRENT.CATEGNEW"
    WVAR.NAMES<4> = "CURRENT.CHANGED"
    WVAR.VAL      = ""
    WPOS.X        = 0
*
    CALL System.getUserVariables( U.VARNAMES, U.VARVALS )
*
    LOOP
        REMOVE WWVAR FROM WVAR.NAMES SETTING WVAR.POS
    WHILE WWVAR : WVAR.POS DO
        WPOS.X += 1
        LOCATE WWVAR IN U.VARNAMES SETTING YPOS.VAR THEN
            WVAR.VAL<WPOS.X> = U.VARVALS<YPOS.VAR>
        END
    REPEAT
*
    WSIDE       = WVAR.VAL<1>
    WCATINI     = WVAR.VAL<2>
    WCATNEW     = WVAR.VAL<3>
    WTT.CHANGED = WVAR.VAL<4>
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
    PROCESS.GOAHEAD   = 1
*
    WVAR.NAMES    = "CURRENT.AUTOR.PROCESS"
    WVAR.NAMES<2> = "CURRENT.PROC.AUTOR"
    WVAR.NAMES<3> = "CURRENT.WTM.FIRST.ID"
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
        END
    REPEAT
*
    WTM.AUTOR.PROCESS = WVAR.VAL<1>
    WTM.PROC.AUTOR    = WVAR.VAL<2>
    WTM.FIRST.ID      = WVAR.VAL<3>
*
    WCAMPO    = "L.NEXT.VERSION"
    WCAMPO<2> = "L.ACTUAL.VERSIO"
    WCAMPO<3> = "L.TRAN.AMOUNT"
    WCAMPO<4> = "L.INITIAL.ID"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)

    YPOS = ''

    CALL MULTI.GET.LOC.REF("TELLER",WCAMPO,YPOS)
    WPOSNV    = YPOS<1,1>
    WPOSACV   = YPOS<1,2>
    WPOSAMT   = YPOS<1,3>
    WPOS.LI   = YPOS<1,4>
*
    Y.ERR.MSG = ""
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
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*
    IF WTM.PROC.AUTOR EQ "A" OR V$FUNCTION EQ "D" OR V$FUNCTION EQ "A" OR (MESSAGE EQ "VAL" AND R.NEW(TT.TE.LOCAL.REF)<1,WPOSNV> NE "") THEN ;* R22 Auto conversion
        PROCESS.GOAHEAD = ""
    END
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF COMI EQ "" AND WTM.FIRST.ID EQ "" THEN
                    R.NEW(TT.TE.LOCAL.REF)<1,WPOSNV>  = ""
                    R.NEW(TT.TE.LOCAL.REF)<1,WPOS.LI> = ""
                    PROCESS.GOAHEAD                   = ""
                END

            CASE LOOP.CNT EQ 2
                IF (R.NEW(TT.TE.AMOUNT.LOCAL.1) EQ "" OR R.NEW(TT.TE.AMOUNT.LOCAL.1) EQ 0) AND (R.NEW(TT.TE.AMOUNT.FCY.1) EQ 0 OR R.NEW(TT.TE.AMOUNT.FCY.1) EQ "") THEN
                    Y.ERR.MSG       = "EB-SHOULD.INPUT.AMOUNT"
                    COMI            = ""
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 3
                R.NEW(TT.TE.LOCAL.REF)<1,WPOS.LI> = WTM.FIRST.ID
*
                IF WCATINI EQ "CURRENT.CATEGORI" OR WCATINI EQ "" AND COMI NE "" THEN
*CALL REDO.GET.MTS.TRANS.INFO
                    CALL APAP.TAM.redoGetMtsTransInfo() ;* R22 Manual conversion
                    GOSUB GET.SYSTEM.VARIABLES
                END
                IF WTT.CHANGED EQ "YES" THEN
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
