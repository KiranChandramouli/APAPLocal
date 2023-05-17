*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE E.REDO.BUILD.INAU.ARR(ENQ.DATA)
* ====================================================================================
* Subroutine Type : BUILD.ROUTINE
* Attached to     : REDO.NV.E.AUTHOR.ARR
* Attached as     : BUILD.ROUTINE
* Primary Purpose :
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : JoaquCosta C
* Date            : 2011-10-28
*=======================================================================
* Date                 Who              Reference       Details
*
* 09-06-2017        Edwin Charles D  R15 Upgrade       Update
*=======================================================================
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
*
    $INSERT I_F.REDO.DISB.CHAIN
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
    TRAN.IDS = R.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF>
    TRAN.IDS = CHANGE(TRAN.IDS,VM," ")
*
    ENQ.DATA<4,1>    = TRAN.IDS
*
    RETURN
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
* =========
INITIALISE:
* =========
*
    FN.REDO.DISB.CHAIN = "F.REDO.DISB.CHAIN"
    F.REDO.DISB.CHAIN  = ""
    CALL OPF(FN.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN)
*
    PROCESS.GOAHEAD = 1
    WRDC.ID         = ""
*
    ENQ.DATA<2,1> = "@ID"
    ENQ.DATA<3,1> = "EQ"
*
    IF ENQ.DATA<4,1> NE "" THEN
        WRDC.ID       = ENQ.DATA<4,1>
        ENQ.DATA<4,1> = ""
    END
*
    R.REDO.DISB.CHAIN = ""
    Y.ERR.MSG         = ""
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
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

        CASE LOOP.CNT EQ 1
            IF WRDC.ID NE "" THEN
                CALL F.READ(FN.REDO.DISB.CHAIN,WRDC.ID,R.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN,ERR.MSJ)
                IF NOT(R.REDO.DISB.CHAIN) THEN
                    PROCESS.GOAHEAD = ""
                    ENQ.DATA<4,1>   = "ZZZZZZZZZZZZ"
                END
            END ELSE
                PROCESS.GOAHEAD = ""
                ENQ.DATA<4,1>   = "ZZZZZZZZZZZZ"
            END
* -----

        END CASE

        LOOP.CNT +=1
    REPEAT

*
    RETURN
*

END
