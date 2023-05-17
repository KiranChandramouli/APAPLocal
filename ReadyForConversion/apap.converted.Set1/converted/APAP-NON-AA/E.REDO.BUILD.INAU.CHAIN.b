SUBROUTINE E.REDO.BUILD.INAU.CHAIN(ENQ.DATA)
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type : BUILD.ROUTINE
* Attached to     : REDO.NV.E.AUTHOR
* Attached as     : BUILD.ROUTINE
* Primary Purpose :
*
*
* Incoming:
* ---------
*
*
*
* Outgoing:

* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : Joaquín Costa C.
* Date            : 2011-04-14
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
*
    $INSERT I_REDO.NV.COMMON
    $INSERT I_F.REDO.TRANSACTION.CHAIN
*
*************************************************************************
*
* DEBUG
*
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
    TRAN.IDS = R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID>
*
    TRAN.IDS = CHANGE(TRAN.IDS,@VM," ")
*
    ENQ.DATA<4,1>    = TRAN.IDS
*
RETURN
*
*
*===================
CONTROL.MSG.ERROR:
*===================
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

*===================
SELECT.FILES:
*===================
*
    RTC.LIST   = ''
    LIST.NAME  = ''
    SELECTED   = ''
    ERR.CODE   = ''
*
    SEL.CMD  = 'SELECT ':FN.REDO.TRANSACTION.CHAIN
    SEL.CMD := " WITH TRANS.AUTH EQ 'U' AND TRANS.DATE EQ "
    SEL.CMD := TODAY : " AND BRANCH.CODE EQ " : ID.COMPANY : " BY.DSND TRANS.DATE"
    CALL EB.READLIST(SEL.CMD,RTC.LIST,LIST.NAME,SELECTED,ERR.CODE)
    REMOVE REDO.TRANSACTION.CHAIN.ID FROM RTC.LIST SETTING REDO.TRANSACTION.CHAIN.MARK
    CALL F.READ(FN.REDO.TRANSACTION.CHAIN,REDO.TRANSACTION.CHAIN.ID,R.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN,ERR.MSJ)
    IF Y.ERR.MSG THEN
        PROCESS.GOAHEAD    = 0
    END

RETURN
*
* =========
INITIALISE:
* =========
*
    FN.REDO.TRANSACTION.CHAIN = "F.REDO.TRANSACTION.CHAIN"
    F.REDO.TRANSACTION.CHAIN  = ""
*
    PROCESS.GOAHEAD = 1
    WRTC.ID         = ""
    ENQ.DATA<2,1>   = "@ID"
    ENQ.DATA<3,1>   = "EQ"

*
    IF ENQ.DATA<4,1> NE "" THEN
        WRTC.ID = ENQ.DATA<4,1>
        ENQ.DATA<4,1> = ""
    END
*
    R.REDO.TRANSACTION.CHAIN = ""
    Y.ERR.MSG                = ""
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1;    MAX.LOOPS = 1
*
* CAMBIOS DE CONDICION
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                IF WRTC.ID NE "" THEN
                    CALL F.READ(FN.REDO.TRANSACTION.CHAIN,WRTC.ID,R.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN,ERR.MSJ)
                    IF NOT(R.REDO.TRANSACTION.CHAIN) THEN
                        GOSUB SELECT.FILES
                    END
                END ELSE
                    GOSUB SELECT.FILES
                END
* -----

        END CASE

        LOOP.CNT +=1
    REPEAT

*
RETURN
*

END
