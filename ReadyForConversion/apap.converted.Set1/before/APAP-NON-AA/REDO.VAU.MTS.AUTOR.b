*-----------------------------------------------------------------------------
* <Rating>-158</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAU.MTS.AUTOR
******************************************************************************
* =============================================================================
*    Routine that Authorisation routine
*    Parameters:
*
*=======================================================================
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2011/Apr/06
*
*=======================================================================
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_ENQUIRY.COMMON
$INSERT I_System
*
$INSERT I_F.VERSION
$INSERT I_F.TELLER
$INSERT I_F.USER
$INSERT I_F.TELLER.ID
$INSERT I_F.TELLER.TRANSACTION
*
$INSERT I_F.REDO.MULTITXN.PARAMETER
$INSERT I_F.REDO.TRANSACTION.CHAIN
$INSERT I_REDO.NV.COMMON
*
*
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
*---------------
PROCESS:
*--------------
*
  BEGIN CASE
  CASE WINITIAL.ID EQ "" AND NEXT.VERSION NE ""
    GOSUB FIRST.TXN

  CASE WINITIAL.ID NE "" AND NEXT.VERSION NE ""
    GOSUB TXN.MIDDLE

  CASE WINITIAL.ID NE "" AND NEXT.VERSION EQ ""
    GOSUB LAST.TXN

  END CASE
*

  WTRAN.AMOUNT = 0
  IF NEXT.VERSION NE "" THEN
    WNEXT.VERSION = NEXT.VERSION:" ":"I":" ":"F3"
    CALL EB.SET.NEW.TASK(WNEXT.VERSION)
  END

*
  RETURN
*
* ---------------
FIRST.TXN:
*  --------------
*
* For FIRST TRANSACTION in a set of related transactions
*
  WINITIAL.ID = ID.NEW
  WTM.FIRST.ID = ID.NEW
*
  RTR= ""
*
  CALL F.READU(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ,RTR)
  R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI>    = ID.NEW
  R.TELLER.ID<TT.TID.LOCAL.REF,WCCY>      = WTM.CCY
  IF WTM.TYPE EQ "CHECK" THEN
    R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK> = WTRAN.AMOUNT
  END ELSE
    R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>  = WTRAN.AMOUNT
  END
*
  CALL F.WRITE(FN.TELLER.ID,WTT.ID,R.TELLER.ID)
  R.REDO.INIT.ID.NV = ID.NEW
  CALL F.WRITE(FN.REDO.INIT.ID.NV,WTT.ID,R.REDO.INIT.ID.NV)

  CALL System.setVariable("CURRENT.INDA.ID",R.REDO.INIT.ID.NV)

*
  TRANSID     = R.NEW(TT.TE.TRANSACTION.CODE)
  CALL F.READ(FN.TELLER.TRANSACTION,TRANSID,R.TELLER.TRANSACTION,F.TELLER.TRANSACTION,ERR.MSJ)
  IF R.TELLER.TRANSACTION THEN
    TRANSDESC = R.TELLER.TRANSACTION<TT.TR.DESC,1,WLANG>
  END
  R.REDO.TRANSACTION.CHAIN                     = ""
  R.REDO.TRANSACTION.CHAIN<RTC.TELLER.ID>      = R.NEW(TT.TE.TELLER.ID.1)
  R.REDO.TRANSACTION.CHAIN<RTC.BRANCH.CODE>    = R.NEW(TT.TE.CO.CODE)
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.DATE>     = TODAY
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID>       = WINITIAL.ID
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.DESC>     = TRANSDESC
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.CCY>      = WTM.CCY
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.TYPE>     = WTM.TYPE
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.VERS>     = APPLICATION:PGM.VERSION
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AMOUNT>   = WTRAN.AMOUNT
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.STATUS>   = R.NEW(TT.TE.RECORD.STATUS)
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AUTH>     = "P"
  GOSUB UPDATE.CHAIN.BALANCE

  CALL F.WRITE(FN.REDO.TRANSACTION.CHAIN,WINITIAL.ID,R.REDO.TRANSACTION.CHAIN)
*
  RETURN
*
* ---------
TXN.MIDDLE:
* ---------
*
* For transactions in the middle of a set of transactions
*
  RTR = ""
  CALL F.READU(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ,RTR)
  LOCATE WTM.CCY IN WVCCY<1> SETTING YPOS THEN
    IF WTM.TYPE EQ "CHECK" THEN
      WVALCHECK<YPOS> += WTRAN.AMOUNT
      IF WVALCHECK<YPOS> LT 0 THEN
        WVALCASH<YPOS> +=  WVALCHECK<YPOS>
        WVALCHECK<YPOS> = 0
      END
    END ELSE
      WVALCASH<YPOS> += WTRAN.AMOUNT
    END
  END ELSE
    WVCCY<-1> = WTM.CCY
    IF WTM.TYPE EQ "CHECK" THEN
      WVALCHECK<-1> = WTRAN.AMOUNT
    END ELSE
      WVALCASH<-1> = WTRAN.AMOUNT
    END
  END
  R.TELLER.ID<TT.TID.LOCAL.REF,WCCY>   = LOWER(LOWER(WVCCY))
  R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>  = LOWER(LOWER(WVALCASH))
  R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK> = LOWER(LOWER(WVALCHECK))

  CALL F.WRITE(FN.TELLER.ID,WTT.ID,R.TELLER.ID)
*
  GOSUB UPDATE.REDO.TRANSACTION.CHAIN
*
  RETURN
*
* ---------------
LAST.TXN:
*  --------------
*
* LAST transaction in a set of related transactions
*
  WTM.LAST.ID = ID.NEW
*
  CALL F.READU(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ,YNN)
*
* Operator control fields should be initialized
*
  R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI> = ""
  R.TELLER.ID<TT.TID.LOCAL.REF,WCCY>   = ""
  R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK> = ""
  R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>  = ""
  CALL F.WRITE(FN.TELLER.ID,WTT.ID,R.TELLER.ID)
*
  GOSUB UPDATE.REDO.TRANSACTION.CHAIN
*
  Y.STR           = "ENQ NOFILE.REDO.NV.E.AUTHOR @ID EQ " : WTM.FIRST.ID        ;* Changed
  OFS$NEW.COMMAND = Y.STR
*
  RETURN
*
* ----------------------------
UPDATE.REDO.TRANSACTION.CHAIN:
* ----------------------------
*
* Local table REDO.TRANSACTION.CHAIN is updated with transaction information
*
  RTR         = ""
  TRANSID     = R.NEW(TT.TE.TRANSACTION.CODE)
  CALL F.READ(FN.TELLER.TRANSACTION,TRANSID,R.TELLER.TRANSACTION,F.TELLER.TRANSACTION,ERR.MSJ)
  IF R.TELLER.TRANSACTION THEN
    TRANSDESC = R.TELLER.TRANSACTION<TT.TR.DESC,1,WLANG>
  END
  CALL F.READU(FN.REDO.TRANSACTION.CHAIN,WINITIAL.ID,R.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN,ERR.MSJ,RTR)
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID,-1>       = ID.NEW
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.DESC,-1>     = TRANSDESC
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.VERS,-1>     = APPLICATION:PGM.VERSION
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.CCY,-1>      = WTM.CCY
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.TYPE,-1>     = WTM.TYPE
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AMOUNT,-1>   = WTRAN.AMOUNT
  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.STATUS,-1>   = R.NEW(TT.TE.RECORD.STATUS)
  IF NEXT.VERSION EQ "" THEN
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AUTH>   = "U"
  END

  GOSUB UPDATE.CHAIN.BALANCE
  WTM.FIRST.ID = R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID,1>
  CALL F.WRITE(FN.REDO.TRANSACTION.CHAIN,WINITIAL.ID,R.REDO.TRANSACTION.CHAIN)
*
  RETURN
*
*--------------------
UPDATE.CHAIN.BALANCE:
* -------------------
*
* Updates BALANCE control fields in REDO.TRANSACTION.CHAIN table
*
  IF WTM.TYPE NE "" THEN
*
    IF WTRAN.AMOUNT GT 0 THEN
      IF WTM.TYPE EQ "CASH" THEN
        R.REDO.TRANSACTION.CHAIN<RTC.TOTAL.CASH>   += WTRAN.AMOUNT
      END ELSE
        R.REDO.TRANSACTION.CHAIN<RTC.TOTAL.CHECK>  += WTRAN.AMOUNT
      END
    END
*
    IF WTM.TYPE EQ "CASH" THEN
      R.REDO.TRANSACTION.CHAIN<RTC.CASH.BALANCE>  += WTRAN.AMOUNT
    END ELSE
      R.REDO.TRANSACTION.CHAIN<RTC.CHECK.BALANCE> += WTRAN.AMOUNT
      IF R.REDO.TRANSACTION.CHAIN<RTC.CHECK.BALANCE> LT 0 THEN
        R.REDO.TRANSACTION.CHAIN<RTC.CASH.BALANCE> += R.REDO.TRANSACTION.CHAIN<RTC.CHECK.BALANCE>
        R.REDO.TRANSACTION.CHAIN<RTC.CHECK.BALANCE> = 0
      END
    END
*
  END

  GOSUB UPDATE.CASHIER.BALANCES
*
  RETURN
*
* ======================
UPDATE.CASHIER.BALANCES:
* ======================
*
* Updates REDO.TRANSACTION.CHAIN with OPERATOR balances after each transaction
*
  WVCCY     = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCCY>)
  WVALCASH  = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>)
  WVALCHECK = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK>)
*
  R.REDO.TRANSACTION.CHAIN<RTC.CCY.INFO>   = WVCCY
  R.REDO.TRANSACTION.CHAIN<RTC.CASH.INFO>  = WVALCASH
  R.REDO.TRANSACTION.CHAIN<RTC.CHECK.INFO> = WVALCHECK
*
  CCY.BALANCE   = WVCCY
  CASH.BALANCE  = WVALCASH
  CHECK.BALANCE = WVALCHECK
*
  RETURN
*
* =======
GET.SIDE:
* =======
*
  WTT.TRANS          = R.NEW(TT.TE.TRANSACTION.CODE)
*
  CALL F.READ(FN.TELLER.TRANSACTION,WTT.TRANS,R.TELLER.TRANSACTION,F.TELLER.TRANSACTION,ERR.MSJ)
  IF R.TELLER.TRANSACTION THEN
    WCATEG1  = R.TELLER.TRANSACTION<TT.TR.CAT.DEPT.CODE.1>
    WCATEG2  = R.TELLER.TRANSACTION<TT.TR.CAT.DEPT.CODE.2>
    WTRCODE1 = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1>
    WTRCODE2 = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2>
  END

  WRMP.ID      = "SYSTEM"
*
  CALL CACHE.READ(FN.REDO.MULTITXN.PARAMETER,WRMP.ID,R.REDO.MULTITXN.PARAMETER,F.REDO.MULTITXN.PARAMETER)
  WCATEG.CHECK = R.REDO.MULTITXN.PARAMETER<RMP.CATEG.CHECK>
  WCATEG.CASH  = R.REDO.MULTITXN.PARAMETER<RMP.CATEG.CASH>
  WCHECK.TRAN  = R.REDO.MULTITXN.PARAMETER<RMP.CHECK.TRANSACT>
*
  WTM.SIDE   = ""
  IF WTRCODE1 EQ WCHECK.TRAN THEN
    WTM.SIDE   = "1"
  END ELSE
    IF WTRCODE2 EQ WCHECK.TRAN THEN
      WTM.SIDE   = "2"
    END
  END
*
  LOCATE WCATEG1 IN R.REDO.MULTITXN.PARAMETER<RMP.NEW.CATEG,1> SETTING YPOS THEN
    WTM.SIDE       = "1"
  END ELSE
    LOCATE WCATEG2 IN R.REDO.MULTITXN.PARAMETER<RMP.NEW.CATEG,1> SETTING YPOS THEN
      WTM.SIDE       = "2"
    END
  END
*
  RETURN
*
* =========
INITIALISE:
* =========
*
  PROCESS.GOAHEAD    = 1
*
  Y.ERR.MSG          = ""
*
  WLANG = R.USER<EB.USE.LANGUAGE>
*
  WTT.TRANS  = R.NEW(TT.TE.TRANSACTION.CODE)
  WTT.ID     = R.NEW(TT.TE.TELLER.ID.1)
*
  WVAR.NAMES    = "CURRENT.AUTOR.PROCESS"
  WVAR.NAMES<2> = "CURRENT.PROC.AUTOR"
  WVAR.NAMES<3> = "CURRENT.SIDE"
  WVAR.NAMES<4> = "CURRENT.WTM.TYPE"    ;* PACS00249338 - S/E
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
  WTM.SIDE          = WVAR.VAL<3>
*
  FN.TELLER.TRANSACTION = "F.TELLER.TRANSACTION"
  F.TELLER.TRANSACTION  = ""

  FN.REDO.TRANSACTION.CHAIN = "F.REDO.TRANSACTION.CHAIN"
  F.REDO.TRANSACTION.CHAIN  = ""

  FN.TELLER.ID = "F.TELLER.ID"
  F.TELLER.ID  = ""

  FN.REDO.MULTITXN.PARAMETER = "F.REDO.MULTITXN.PARAMETER"
  F.REDO.MULTITXN.PARAMETER  = ""

  FN.TELLER = "F.TELLER"
  F.TELLER  = ""

  FN.REDO.INIT.ID.NV = 'F.REDO.INIT.ID.NV'
  F.REDO.INIT.ID.NV = ''
  CALL OPF(FN.REDO.INIT.ID.NV,F.REDO.INIT.ID.NV)

*
  WAPP.LST = "TELLER.ID" : FM : "TELLER"
  WCAMPO    = "L.INITIAL.ID"
  WCAMPO<2> = "L.CH.CASH"
  WCAMPO<3> = "L.CH.CHECK"
  WCAMPO<4> = "L.CH.CCY"
  WCAMPO    = CHANGE(WCAMPO,FM,VM)
  WFLD.LST  = WCAMPO
*
  WCAMPO    = "L.NEXT.VERSION"
  WCAMPO<2> = "L.ACTUAL.VERSIO"
  WCAMPO<3> = "L.TRAN.AMOUNT"
  WCAMPO<4> = "L.INITIAL.ID"
  WCAMPO<5> = "L.DEBIT.AMOUNT"
  WCAMPO<6> = "L.CREDIT.AMOUNT"
  WCAMPO    = CHANGE(WCAMPO,FM,VM)
  WFLD.LST := FM : WCAMPO

  YPOS = ''
  CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
  WPOSLI    = YPOS<1,1>
  WCASH     = YPOS<1,2>
  WCHECK    = YPOS<1,3>
  WCCY      = YPOS<1,4>
*
  WPOSNV    = YPOS<2,1>
  WPOSACV   = YPOS<2,2>
  WPOSAMT   = YPOS<2,3>
  WPOS.LI   = YPOS<2,4>
  WPOS.DB   = YPOS<2,5>
  WPOS.CR   = YPOS<2,6>
*
  WAMOUNT.DB   = R.NEW(TT.TE.LOCAL.REF)<1,WPOS.DB>
  WAMOUNT.CR   = R.NEW(TT.TE.LOCAL.REF)<1,WPOS.CR>
  WTM.SIGN     = R.NEW(TT.TE.DR.CR.MARKER)
  NEXT.VERSION = R.NEW(TT.TE.LOCAL.REF)<1,WPOSNV>
*
  IF WTM.SIDE EQ "" THEN
    GOSUB GET.SIDE
  END
*
  IF WTM.SIGN EQ "DEBIT" THEN
    IF WTM.SIDE EQ "1" THEN
      WTRAN.AMOUNT = WAMOUNT.DB * -1
    END ELSE
      WTRAN.AMOUNT = WAMOUNT.CR
    END
  END ELSE
    IF WTM.SIDE EQ "1" THEN
      WTRAN.AMOUNT = WAMOUNT.CR
    END ELSE
      WTRAN.AMOUNT = WAMOUNT.DB * -1
    END
  END
*
  IF V$FUNCTION EQ "D" THEN
    WTRAN.AMOUNT = WTRAN.AMOUNT * -1
  END
*
  R.NEW(TT.TE.LOCAL.REF)<1,WPOSAMT> = WTRAN.AMOUNT
*
  RETURN
*
*================
CONTROL.MSG.ERROR:
*================
* Commented below code for code review process
* Paragraph that control the error in the subroutine
*
*    IF Y.ERR.MSG THEN
*        ETEXT           = Y.ERR.MSG
*        AF              = TT.TE.AMOUNT.LOCAL.1
*        CALL STORE.END.ERROR
*        ETEXT           = ""
*    END
*
  RETURN
*
*---------------
OPEN.FILES:
*---------------
*
  CALL OPF(FN.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN)
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
      CALL F.READ(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ)
      IF R.TELLER.ID THEN
        WINITIAL.ID  = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI>
      END
      IF (WINITIAL.ID EQ "" AND NEXT.VERSION EQ "") OR WTM.AUTOR.PROCESS EQ "A" OR WTM.PROC.AUTOR EQ "A" THEN
        PROCESS.GOAHEAD = ""
      END

    CASE LOOP.CNT EQ 2
      WVCCY     = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCCY>))
      WVALCASH  = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>))
      WVALCHECK = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK>))
      IF WTM.SIDE EQ 1 THEN
        WTM.CCY = R.NEW(TT.TE.CURRENCY.1)
      END ELSE
        WTM.CCY = R.NEW(TT.TE.CURRENCY.2)
      END

      WTM.TYPE          = WVAR.VAL<4>   ;* PACS00249338 - S/E

    END CASE
*       Message Error

*       Increase
    LOOP.CNT += 1
*
  REPEAT
*
  RETURN
*
END
