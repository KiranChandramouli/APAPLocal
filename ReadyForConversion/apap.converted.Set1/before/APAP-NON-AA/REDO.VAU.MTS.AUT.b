*-----------------------------------------------------------------------------
* <Rating>-100</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAU.MTS.AUT
*
*   Actualiza el registro de REDO.TRANSACTION.CHAIN si se trata de una
*   transaccion que forma parte de una cadena de transacciones
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.TELLER.ID
*
$INSERT I_REDO.NV.COMMON
$INSERT I_F.REDO.TRANSACTION.CHAIN
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
PROCESS:
*


  BEGIN CASE
  CASE APPLICATION EQ "TELLER"
    IF R.NEW(TT.TE.LOCAL.REF)<1,WPOSTA> NE "A" THEN
      R.NEW(TT.TE.LOCAL.REF)<1,WPOSTA> = "A"
    END ELSE
      R.NEW(TT.TE.LOCAL.REF)<1,WPOSTA> = "X"
    END

  CASE APPLICATION EQ "FUNDS.TRANSFER"
    IF R.NEW(FT.LOCAL.REF)<1,WPOS.FT.TA> NE "A" THEN
      R.NEW(FT.LOCAL.REF)<1,WPOS.FT.TA> = "A"
    END ELSE
      R.NEW(FT.LOCAL.REF)<1,WPOS.FT.TA> = "X"
    END
  END CASE


*
  GOSUB UPDATE.REDO.TRANSACTION.CHAIN
  Y.TLL.ID = R.REDO.TRANSACTION.CHAIN<RTC.TELLER.ID>

  CALL F.READ(FN.REDO.INIT.ID.NV,Y.TLL.ID,R.REDO.INIT.ID.NV,F.REDO.INIT.ID.NV,NV.ERR)
  IF R.REDO.INIT.ID.NV THEN
    CALL F.DELETE(FN.REDO.INIT.ID.NV,Y.TLL.ID)
  END
*
  RETURN
*
* ============================
UPDATE.REDO.TRANSACTION.CHAIN:
* ============================
*
  RTR = ""
  CALL F.READU(FN.REDO.TRANSACTION.CHAIN,WINITIAL.ID,R.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN,ERR.MSJ,RTR)
  IF NOT(ERR.MSJ) THEN
    GOSUB WRITE.RTC
  END
*
  RETURN
*
* ========
WRITE.RTC:
* ========
*
  LOCATE ID.NEW IN R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID,1> SETTING Y.POS THEN
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.STATUS,Y.POS> = ""
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AUTH>         = "AP"
    IF R.REDO.TRANSACTION.CHAIN<RTC.TRANS.STATUS> EQ "" THEN
      R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AUTH>   = "A"
      NV.AUTOR.PROCESS = ""
      NV.LAST.ID       = ""
    END ELSE
      GOSUB UPDATE.STATUS.RTC
    END
  END
*
  CALL F.WRITE(FN.REDO.TRANSACTION.CHAIN,WINITIAL.ID,R.REDO.TRANSACTION.CHAIN)
*
  RETURN
*
* ================
UPDATE.STATUS.RTC:
* ================
*
  WTID.NUMBER = DCOUNT(R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID>,VM)
  LOOP.CNT        = 1
  PROCESS.GOAHEAD = 1
*
  LOOP
  WHILE LOOP.CNT LE WTID.NUMBER AND PROCESS.GOAHEAD
    W.STATUS = R.REDO.TRANSACTION.CHAIN<RTC.TRANS.STATUS,LOOP.CNT>
    IF W.STATUS  NE "" AND W.STATUS NE "DEL" THEN
      PROCESS.GOAHEAD = ""
    END
*
    LOOP.CNT += 1
*
  REPEAT
*
  IF PROCESS.GOAHEAD THEN
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AUTH>   = "A"
    NV.AUTOR.PROCESS = ""
    NV.LAST.ID       = ""
  END
*
  RETURN
*
* =========
INITIALISE:
* =========
*
  PROCESS.GOAHEAD = 1
*
  FN.REDO.TRANSACTION.CHAIN = "F.REDO.TRANSACTION.CHAIN"
  F.REDO.TRANSACTION.CHAIN  = ""

  FN.REDO.INIT.ID.NV = 'F.REDO.INIT.ID.NV'
  F.REDO.INIT.ID.NV = ''
  CALL OPF(FN.REDO.INIT.ID.NV,F.REDO.INIT.ID.NV)
*
*    WCAMPO    = "L.TRAN.AUTH"
*    WCAMPO<2> = "L.INITIAL.ID"
*    WCAMPO    = CHANGE(WCAMPO,FM,VM)
*    CALL MULTI.GET.LOC.REF("TELLER",WCAMPO,YPOS)
*    WPOSTA  = YPOS<1,1>
*    WPOS.LI = YPOS<1,2>
*
*    WCAMPO = "L.TRAN.AUTH"
*    WCAMPO = CHANGE(WCAMPO,FM,VM)
*    CALL MULTI.GET.LOC.REF("FUNDS.TRANSFER",WCAMPO,YPOS)
*    WPOS.FT.TA = YPOS<1,1>
*
  Y.APLS = 'TELLER':FM:'FUNDS.TRANSFER'
  WCAMPO = 'L.TRAN.AUTH':VM:'L.INITIAL.ID':FM:'L.TRAN.AUTH':VM:'L.INITIAL.ID'
  CALL MULTI.GET.LOC.REF(Y.APLS,WCAMPO,YPOS)

  WPOSTA  = YPOS<1,1>
  WPOS.LI = YPOS<1,2>

  WPOS.FT.TA = YPOS<2,1>
  WPOS.FT.IN = YPOS<2,2>

  IF APPLICATION EQ 'TELLER' THEN
    WINITIAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,WPOS.LI>
  END

  IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
    WINITIAL.ID = R.NEW(FT.LOCAL.REF)<1,WPOS.FT.IN>
  END
*
  RETURN
*
OPEN.FILES:
*
*
  RETURN
*
CHECK.PRELIM.CONDITIONS:
*
  LOOP.CNT  = 1
  MAX.LOOPS = 1
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD
    BEGIN CASE
*
    CASE LOOP.CNT EQ 1
      IF WINITIAL.ID EQ "" THEN
        PROCESS.GOAHEAD = ""
      END

    END CASE
*
    LOOP.CNT += 1
*
  REPEAT
*
  RETURN
*
END
