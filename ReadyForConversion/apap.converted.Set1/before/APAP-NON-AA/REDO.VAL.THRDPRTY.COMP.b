*-----------------------------------------------------------------------------
* <Rating>-52</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.THRDPRTY.COMP
*
*=======================================================================
*
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2011/Apr/06
*
*=======================================================================
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
*
$INSERT I_F.REDO.THIRDPRTY.PARAMETER
*
*     DEBUG
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
*--------
PROCESS:
*--------
*
  R.NEW(TT.TE.LOCAL.REF)<1,WPOS.BCOND> = LOWER(R.REDO.THIRDPRTY.PARAMETER<REDO.TP.BILL.COND>)
  R.NEW(TT.TE.LOCAL.REF)<1,WPOS.BTYPE> = R.REDO.THIRDPRTY.PARAMETER<REDO.TP.BILL.TYPE>
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
    ETEXT  = Y.ERR.MSG
    CALL STORE.END.ERROR
    ETEXT  = ""
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
  WCAMPO    = "L.TT.BILL.COND"
  WCAMPO<2> = "L.TT.BILL.TYPE"
  WCAMPO    = CHANGE(WCAMPO,FM,VM)
  CALL MULTI.GET.LOC.REF("TELLER",WCAMPO,YPOS)
  WPOS.BCOND   = YPOS<1,1>
  WPOS.BTYPE   = YPOS<1,2>
*
  FN.REDO.THIRDPRTY.PARAMETER = "F.REDO.THIRDPRTY.PARAMETER"
  F.REDO.THIRDPRTY.PARAMETER  = ""
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
  LOOP.CNT  = 1   ;   MAX.LOOPS = 2
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1
      IF MESSAGE EQ "VAL" THEN
        PROCESS.GOAHEAD = ""
      END

    CASE LOOP.CNT EQ 2
      CALL F.READ(FN.REDO.THIRDPRTY.PARAMETER,COMI,R.REDO.THIRDPRTY.PARAMETER,F.REDO.THIRDPRTY.PARAMETER,RTP.ERR)
      IF RTP.ERR THEN
        PROCESS.GOAHEAD = ""
        Y.ERR.MSG = "EB-RECORD.DOES.NOT.EXIST":FM:COMI
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
