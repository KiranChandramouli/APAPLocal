* @ValidationCode : Mjo3MTY0OTAxOTg6VVRGLTg6MTcwMzEzNjY1OTE0MDpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Dec 2023 11:00:59
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE E.REDO.BUILD.DISB.PROC(ENQ.DATA)
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type : BUILD.ROUTINE
* Attached to     : REDO.E.DESEMBOLSO
* Attached as     : BUILD.ROUTINE
* Primary Purpose :
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : JoaquCosta C
* Date            : 2011-11-29
*  DATE             WHO                   REFERENCE
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 21-12-2023         Narmadha V            Manual R22 Conversion- CALL OPF Added
*------------------------------------------------------------------------
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
*
    $INSERT I_F.ACCOUNT
*
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
*
*************************************************************************
*
*  DEBUG
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
    TRAN.IDS = CHANGE(RDC.LIST,@FM," ")
*
    ENQ.DATA<4,1>    = TRAN.IDS
*
RETURN
*
* ===========
GET.ACC.DATA:
* ===========
*
    LOOP.ACC    = 1
    MAX.ACC     = 2
    ACC.GOAHEAD = 1
*
    LOOP WHILE LOOP.ACC LE MAX.ACC AND ACC.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.ACC EQ 1
                CALL F.READ(FN.ACCOUNT,W.ID.AC,R.ACCOUNT,F.ACCOUNT,ERR.ACC)
                IF NOT(R.ACCOUNT) THEN
                    PROCESS.GOAHEAD = ""
                    ACC.GOAHEAD     = ""
                    ENQ.DATA<4,1>   = "ZZZZZZZZZZZZ"
                END

            CASE LOOP.ACC EQ 2
                W.ID.AA = R.ACCOUNT<AC.ARRANGEMENT.ID>
                GOSUB GET.RCA.BY.AA.ID

        END CASE
*
        LOOP.ACC += 1
*
    REPEAT
*
RETURN
*
* ===============
GET.RCA.BY.AA.ID:
* ===============
*
    CALL F.READ(FN.AA.ARR,W.ID.AA,R.AA.ARR,F.AA.ARR,ARR.ERR)
    IF NOT(R.AA.ARR) THEN
        PROCESS.GOAHEAD = ""
        ACC.GOAHEAD     = ""
        ENQ.DATA<4,1>   = "ZZZZZZZZZZZZ"
        RETURN
    END
    CALL F.READ(FN.RCA.ID.ARRANGEMENT,W.ID.AA,R.RCA.ID.ARRANGEMENT,F.RCA.ID.ARRANGEMENT,ERR.RCA.AA)
    IF R.RCA.ID.ARRANGEMENT THEN
        RDC.LIST = FIELD(R.RCA.ID.ARRANGEMENT,"*",2)
    END ELSE
        PROCESS.GOAHEAD = ""
        ENQ.DATA<4,1>   = "ZZZZZZZZZZZZ"
    END
*
RETURN
*
*==============
SELECT.RCA.IDS:
*==============
*
    RDC.LIST   = ''
    LIST.NAME  = ''
    SELECTED   = ''
    ERR.CODE   = ''
*
    SEL.CMD  = 'SELECT ':FN.REDO.CREATE.ARRANGEMENT
    SEL.CMD := " WITH (DISB.STATUS EQ 'U' OR DISB.STATUS EQ 'AP') AND DATE EQ "
    SEL.CMD := TODAY : " AND BRANCH.ID EQ " : ID.COMPANY
    CALL EB.READLIST(SEL.CMD,RDC.LIST,LIST.NAME,SELECTED,ERR.CODE)
    IF NOT(RDC.LIST) THEN
        PROCESS.GOAHEAD = ""
        ENQ.DATA<4,1>   = "ZZZZZZZZZZZZ"
    END
*
RETURN
*
* ===========
ANALYSE.DATA:
* ===========
*
    IF ENQ.DATA<2,1> NE "" THEN
        PROCESS.GOAHEAD = ""
    END ELSE
        GOSUB SELECT.RCA.IDS
        SEARCH.GOAHEAD = ""
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    FN.REDO.CREATE.ARRANGEMENT = "F.REDO.CREATE.ARRANGEMENT"
    F.REDO.CREATE.ARRANGEMENT  = ""
*
    FN.RCA.ID.ARRANGEMENT = "F.REDO.CREATE.ARRANGEMENT.ID.ARRANGEMENT"
    F.RCA.ID.ARRANGEMENT  = ""
    CALL OPF(FN.RCA.ID.ARRANGEMENT,F.RCA.ID.ARRANGEMENT) ;*Manual R22 Conversion- CALL OPF Added
*
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT) ;*Manual R22 Conversion- CALL OPF Added

    FN.AA.ARR = 'F.AA.ARRANGEMENT'
    F.AA.ARR = ''
    CALL OPF(FN.AA.ARR,F.AA.ARR)
*
    PROCESS.GOAHEAD = 1
    SEARCH.GOAHEAD  = 1
    WRDC.ID         = ""
*
    R.REDO.CREATE.ARRANGEMENT = ""
    Y.ERR.MSG                 = ""
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1;    MAX.LOOPS = 3

*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD AND SEARCH.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                LOCATE '@ID' IN ENQ.DATA<2,1> SETTING Y.POS THEN
                    WRDC.ID       = ENQ.DATA<4,1>
                END ELSE
                    GOSUB ANALYSE.DATA
                END

            CASE LOOP.CNT EQ 2
                RDC.LIST = ""
                IF WRDC.ID[1,3] EQ "ARR" THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 3
                IF WRDC.ID[1,2] NE "AA" THEN
                    W.ID.AC = WRDC.ID
                    GOSUB GET.ACC.DATA
                END ELSE
                    W.ID.AA = WRDC.ID
                    GOSUB GET.RCA.BY.AA.ID
                END
* -----

        END CASE

        LOOP.CNT +=1
    REPEAT

*
RETURN
*

END
