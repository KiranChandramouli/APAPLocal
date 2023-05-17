SUBROUTINE E.REDO.BUILD.VERSIONS(ENQ.DATA)
*
* ====================================================================================
*
*     RETURNS POSSIBLE VERSIONS TO BE USED FOR NEXT TRANSACTION BASED IN
*
*     AVAILABLE BALANCE AND TYPE OF BALANCE (CASH, CHECK)
*
* ====================================================================================
*
*   PACS00136782 - 20110930 - SHOW POSSIBLE VERSIONS FOR CASH RECEIPT AS FIRST TRANSACTION
*   PACS00136782 - 20111010 - UPDATE ROUTINE IN SVN - NO CHANGES
*
* ====================================================================================
*
* Subroutine Type : BUILD.ROUTINE
* Attached to     : REDO.NV.E.VERSIONS
* Attached as     :
* Primary Purpose :
*
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : pgarzongavilanes
* Date            : 2011-04-12
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.VERSION
    $INSERT I_F.ABBREVIATION
*
    $INSERT I_F.REDO.MULTITXN.VERSIONS

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
    PRINT " SEL.CMD =================================================== " :SEL.CMD

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,Y.ERR)
    IF SEL.LIST THEN
        SEL.LIST = CHANGE(SEL.LIST,@FM," ")
        ENQ.DATA<2,1> = "@ID"
        ENQ.DATA<3,1> = "EQ"
        ENQ.DATA<4,1> = SEL.LIST
    END
*
RETURN
*
* ==============
COMPLETE.SELECT:
* ==============
*
    IF WPR.TYPE EQ "E" THEN
        IF W.VERSION.TYPE EQ 'AA.PAYMENT' THEN
            SEL.CMD := " WITH PROC.TYPE EQ 'I' AND RECEP.METHOD EQ '":WRC.METH:"'":" OR VERSION.TYPE EQ 'AA.PAYMENT' AND RECEP.METHOD EQ '":WRC.METH:"'"
        END ELSE
            SEL.CMD := " WITH PROC.TYPE EQ 'I'"
            IF WRC.METH NE "M" THEN
                SEL.CMD : = " AND RECEP.METHOD EQ '" : WRC.METH : "'"
            END
        END
    END ELSE
        IF WRC.METH NE "M" THEN
            SEL.CMD := " WITH (PROC.TYPE EQ 'E'"
            SEL.CMD := " AND RECEP.METHOD EQ '" : WRC.METH : "')"
            SEL.CMD := " OR (PROC.TYPE EQ 'I')"
        END
        SEL.CMD := " BY PROC.TYPE"
    END
*
RETURN
*
* =======
READ.RMV:
* =======
*
    CALL F.READ(FN.RMV,SEL.LIST,R.RMV,F.RMV,ERR.RMV)
    IF R.RMV THEN
        WPR.TYPE       = R.RMV<RMV.PROC.TYPE>
        WRC.METH       = R.RMV<RMV.RECEP.METHOD>
        W.VERSION.TYPE = R.RMV<RMV.VERSION.TYPE>
        GOSUB COMPLETE.SELECT
    END
*
RETURN
*
* ==================
GET.FILTER.TO.APPLY:
* ==================
*
    SEL.ABB  = "SELECT " : FN.ABB : " WITH ORIGINAL.TEXT EQ '"
    SEL.ABB := WVERS.NAME : "'"
*
    CALL EB.READLIST(SEL.ABB,SEL.LIST,'',NO.OF.REC,Y.ERR)
    IF NO.OF.REC EQ 1 THEN
        SEL.CMD  = "SELECT ": FN.RMV
        GOSUB READ.RMV
    END
*
RETURN
*
* =============
CHECK.BALANCES:
* =============
*
    WCOUNT = DCOUNT(UV.CHECK,@VM)
    FOR WX = 1 TO WCOUNT
        IF UV.CHECK<1,WX> LT 0 AND UV.CHECK<1,WX> NE ""  THEN
            W.CHECK = -100
            WX = WCOUNT + 1
        END
    NEXT WX
*
    WCOUNT = DCOUNT(UV.CASH,@VM)
    FOR WX = 1 TO WCOUNT
        IF UV.CASH<1,WX> LT 0 AND UV.CASH<1,WX> NE "" THEN
            W.CASH = -100
            WX = WCOUNT + 1
        END
    NEXT WX
*
RETURN
*
* =========
INITIALISE:
* =========
*
    FN.RMV    = 'F.REDO.MULTITXN.VERSIONS'
    F.RMV     = ''
    R.RMV     = ''
*
    FN.ABB    = 'F.ABBREVIATION'
    F.ABB     = ''
    R.ABB     = ''
*
    Y.RMV.ID  = ''
    Y.RMV.ERR = ''
    ID.LIST   = ''
    Y.POS     = ""
*
    LOOP.CNT  = 1
    MAX.LOOPS = 3
*
    WVAR.NAMES    = "CURRENT.TID.CCY"
    WVAR.NAMES<2> = "CURRENT.TID.CASH"
    WVAR.NAMES<3> = "CURRENT.TID.CHECK"
    WVAR.NAMES<4> = "CURRENT.FLOW"
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
        END ELSE
            WVAR.VAL<WPOS.X> = WWVAR
        END
    REPEAT
*
    UV.CCY     = WVAR.VAL<1>
    UV.CASH    = WVAR.VAL<2>
    UV.CHECK   = WVAR.VAL<3>
    WVERS.NAME = WVAR.VAL<4>
*
    SEL.CMD   = ''
    SEL.LIST  = ''
    Y.ERR     = ''
    NO.OF.REC = 0
    W.CASH    = 0
    W.CHECK   = 0
*
    W.CHECK   = SUM(UV.CHECK)
    W.CASH    = SUM(UV.CASH)
    GOSUB CHECK.BALANCES
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.RMV,F.RMV)
    CALL OPF(FN.ABB,F.ABB)
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*

    PROCESS.GOAHEAD = 1
    SEL.CMD  = "SELECT ": FN.RMV
*
    PRINT "W.CASH ========================================================== " :W.CASH: " - " :W.CHECK
*

    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1 AND W.CHECK NE 0

                IF W.CHECK GT 0 THEN
                    SEL.CMD := " (WITH PROC.TYPE EQ 'E' AND WITH RECEP.METHOD EQ 'C') OR WITH PROC.TYPE EQ 'I'"
                    LOOP.CNT = MAX.LOOPS + 1
                END ELSE
                    GOSUB GET.RMV.TYPE
                    IF W.VERSION.TYPE EQ 'AA.PAYMENT' THEN

                        SEL.CMD := " WITH PROC.TYPE EQ 'I' AND RECEP.METHOD EQ '":WRC.METH:"'":" OR VERSION.TYPE EQ 'AA.PAYMENT' AND RECEP.METHOD EQ '":WRC.METH:"'"
                    END ELSE
                        SEL.CMD := " WITH PROC.TYPE EQ 'I' AND WITH (RECEP.METHOD EQ 'C' OR RECEP.METHOD EQ 'M')"
                    END
                    LOOP.CNT = MAX.LOOPS + 1
                END

            CASE LOOP.CNT EQ 2 AND W.CASH NE 0

                IF W.CASH GT 0 THEN
                    SEL.CMD := " (WITH PROC.TYPE EQ 'E' AND WITH RECEP.METHOD EQ 'E') OR WITH PROC.TYPE EQ 'I'"
                    LOOP.CNT = MAX.LOOPS + 1
                END ELSE
*                SEL.CMD := " WITH PROC.TYPE EQ 'I' AND WITH (RECEP.METHOD EQ 'E' OR RECEP.METHOD EQ 'M')"
                    GOSUB GET.RMV.TYPE
                    IF W.VERSION.TYPE EQ 'AA.PAYMENT' THEN
                        SEL.CMD := " WITH PROC.TYPE EQ 'I' AND RECEP.METHOD EQ '":WRC.METH:"'":" OR VERSION.TYPE EQ 'AA.PAYMENT' AND RECEP.METHOD EQ '":WRC.METH:"'"

                    END ELSE
                        SEL.CMD := " WITH PROC.TYPE EQ 'I' AND WITH (RECEP.METHOD EQ 'E' OR RECEP.METHOD EQ 'C' OR RECEP.METHOD EQ 'M')"        ;* PACS00263984 - S/E
                    END
                    LOOP.CNT = MAX.LOOPS + 1
                END


            CASE LOOP.CNT EQ 3
                SEL.CMD := " WITH PROC.TYPE EQ 'I'"
                GOSUB GET.FILTER.TO.APPLY

        END CASE

        LOOP.CNT +=1
    REPEAT
RETURN
*---------------------------------------------------------
GET.RMV.TYPE:
*---------------------------------------------------------

    SEL.ABB  = "SELECT " : FN.ABB : " WITH ORIGINAL.TEXT EQ '"
    SEL.ABB := WVERS.NAME : "'"
*
    CALL EB.READLIST(SEL.ABB,SEL.LIST,'',NO.OF.REC,Y.ERR)
    IF NO.OF.REC EQ 1 THEN

        CALL F.READ(FN.RMV,SEL.LIST,R.RMV,F.RMV,ERR.RMV)
        IF R.RMV THEN
            WPR.TYPE        = R.RMV<RMV.PROC.TYPE>
            WRC.METH        = R.RMV<RMV.RECEP.METHOD>
            W.VERSION.TYPE  = R.RMV<RMV.VERSION.TYPE>
        END
    END
*

RETURN
*

END
