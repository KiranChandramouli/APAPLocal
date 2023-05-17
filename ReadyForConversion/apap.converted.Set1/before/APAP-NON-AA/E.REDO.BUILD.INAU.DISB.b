*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE E.REDO.BUILD.INAU.DISB(ENQ.DATA)
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
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : JoaquCosta C
* Date            : 2011-09-05
*=======================================================================

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_GTS.COMMON
*
$INSERT I_F.ACCOUNT
*
$INSERT I_F.REDO.DISB.CHAIN
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
  TRAN.IDS = CHANGE(RDC.LIST,FM," ")
*
  ENQ.DATA<4,1>    = TRAN.IDS
*
  RETURN
*
* ===============
GET.RCA.BY.AA.ID:
* ===============
*
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
* =========
INITIALISE:
* =========
*
  FN.REDO.DISB.CHAIN = "F.REDO.DISB.CHAIN"
  F.REDO.DISB.CHAIN  = ""
*
  FN.RCA.ID.ARRANGEMENT = "F.REDO.CREATE.ARRANGEMENT.ID.ARRANGEMENT"
  F.RCA.ID.ARRANGEMENT  = ""
*
  FN.ACCOUNT = "F.ACCOUNT"
  F.ACCOUNT  = ""
*
  PROCESS.GOAHEAD = 1
  SEARCH.GOAHEAD  = 1
  WACC.ID         = ""
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
  LOOP.CNT  = 1;    MAX.LOOPS = 3
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD AND SEARCH.GOAHEAD DO
    BEGIN CASE

    CASE LOOP.CNT EQ 1
      LOCATE "CUSTOMER" IN ENQ.DATA<2,1> SETTING Y.POS THEN
        PROCESS.GOAHEAD = ""
      END

    CASE LOOP.CNT EQ 2
      LOCATE "ACCOUNT" IN ENQ.DATA<2,1> SETTING Y.POS THEN
        WACC.ID = ENQ.DATA<4,Y.POS>
      END

    CASE LOOP.CNT EQ 3
      IF WACC.ID[1,2] NE "AA" THEN
        W.ID.AC = WACC.ID
        GOSUB GET.ACC.DATA
      END ELSE
        W.ID.AA = WACC.ID
        GOSUB GET.RCA.BY.AA.ID
      END
*

* -----

    END CASE

    LOOP.CNT +=1
  REPEAT

*
  RETURN
*

END
