*-----------------------------------------------------------------------------
* <Rating>-74</Rating>
*----------------------------------------------------------------------------------
  SUBROUTINE REDO.V.CHK.TAX.CHRG
*-----------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at check Record Routine for TELLER VERSIONS.
*------------------------------------------------------------------------------------------
*
* COMPANY NAME : APAP
* DEVELOPED BY : VICTOR NAVA
* PROGRAM NAME : REDO.V.CHK.TAX.CHRG
*
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE          WHO                     REFERENCE       DESCRIPTION
* 16.03.2010    NAVA V                                  INITIAL CREATION
* 21/2/2013     Vignesh Kumaar M R      PACS00251025    Tax Excemption to be set to YES by default
* 10/4/2013     Vignesh Kumaar M R      PACS00251345    Tax Excemption Shouldn't change to NO during validate
* -----------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_System
*
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.TELLER.TRANSACTION
$INSERT I_F.FT.COMMISSION.TYPE
$INSERT I_F.FT.TXN.TYPE.CONDITION
*
  IF V$FUNCTION EQ 'I' THEN
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
      GOSUB PROCESS
    END
  END
*
  RETURN
*
*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------
*
  WCHG.CODE = CHANGE(WCHG.CODE,VM,FM)
*
  WX = 0
  WY = 0
*
  LOOP
    REMOVE TR.CODE FROM WCHG.CODE SETTING TR.POS
  WHILE TR.CODE : TR.POS DO
    GOSUB GET.CHARGE.TYPE

    IF WTAX.FLAG EQ "C" THEN
      WX += 1
      R.NEW(WLOCAL.REF)<1,COMM.COD.POS,WX> = TR.CODE
      R.NEW(WLOCAL.REF)<1,WV.COMM.POS,WX>  = "NO"
      R.NEW(WLOCAL.REF)<1,COMM.AMT.POS,WX> = "0.00"
    END ELSE
      WY += 1
      R.NEW(WLOCAL.REF)<1,TAX.CODE.POS,WY>   = TR.CODE

* Fix for PACS00251025/PACS00251345 [Tax Excemption to be set to YES by default]

      IF PGM.VERSION EQ ',CHQ.GOVT.WITH.TAX' OR PGM.VERSION EQ ',CHQ.TRANS.INTERNAL' OR PGM.VERSION EQ ',CHQ.OTHERS.DEPOSIT' THEN

        R.NEW(WLOCAL.REF)<1,WV.TAX.POS,WY>     = "YES"

      END ELSE
        R.NEW(WLOCAL.REF)<1,WV.TAX.POS,WY>     = "NO"
      END

* End of Fix

      R.NEW(WLOCAL.REF)<1,TAX.AMT.POS,WY>    = "0.00"
    END
  REPEAT
*
  RETURN
*
* ==============
GET.CHARGE.TYPE:
* ==============
*
  WTAX.FLAG = ""
*
  CALL F.READ(FN.FT.COMMISSION.TYPE,TR.CODE,R.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE,ERR.CT)
  IF R.FT.COMMISSION.TYPE THEN
    WTAX.FLAG = R.FT.COMMISSION.TYPE<FT4.LOCAL.REF,FTCT.TX.POS>
  END
*
  RETURN
*
* ===============
GET.ACCOUNT.INFO:
* ===============
*
  IF APPLICATION EQ "TELLER" THEN
    WLOCAL.REF = TT.TE.LOCAL.REF
    TT.CODE    = R.NEW(TT.TE.TRANSACTION.CODE)
    CALL CACHE.READ(FN.TELLER.TRANSACTION,TT.CODE,R.TELLER.TRANSACTION,TT.ERR)
    IF R.TELLER.TRANSACTION NE "" THEN
      WCHG.CODE = R.TELLER.TRANSACTION<TT.TR.CHARGE.CODE>
      Y.ACCOUNT = R.NEW(TT.TE.ACCOUNT.2)
      IF WCHG.CODE EQ "" THEN
        T.LOCREF<WLOCAL.REF,WV.COMM.POS> = 'NOINPUT'
        T.LOCREF<WLOCAL.REF,WV.TAX.POS>  = 'NOINPUT'
        PROCESS.GOAHEAD = ""
      END
    END
  END ELSE

    WLOCAL.REF = FT.LOCAL.REF
    FT.CODE    = R.NEW(FT.TRANSACTION.TYPE)
    CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION,FT.CODE,R.FT.TXN.TYPE.CONDITION,TT.ERR)
    IF R.FT.TXN.TYPE.CONDITION NE "" THEN
      WCHG.CODE = R.FT.TXN.TYPE.CONDITION<FT6.COMM.TYPES>
      Y.ACCOUNT = R.NEW(FT.CREDIT.ACCT.NO)
      IF WCHG.CODE EQ "" THEN
        PROCESS.GOAHEAD = ""
      END
    END
  END
*
  RETURN
*
*----------------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------------
*
  PROCESS.GOAHEAD = "1"
*
  IF RUNNING.UNDER.BATCH THEN
    APPLICATION = 'FUNDS.TRANSFER'
  END
  WAPP.LST  = APPLICATION : FM : "TELLER.TRANSACTION" : FM : "FT.COMMISSION.TYPE"
  WCAMPO    = "L.TT.COMM.CODE"
  WCAMPO<2> = "L.TT.TAX.CODE"
  WCAMPO<3> = "L.TT.WV.TX.AMT"
  WCAMPO<4> = "L.TT.WV.COMM"
  WCAMPO<5> = "L.TT.COMM.AMT"
  WCAMPO<6> = "L.TT.WV.TAX"
  WCAMPO<7> = "L.TT.TAX.AMT"
  WCAMPO<8> = "L.FT.COMM.CODE"          ;* Added by Vignesh

  WCAMPO    = CHANGE(WCAMPO,FM,VM)
  WFLD.LST  = WCAMPO

  WCAMPO    = "L.TT.GOV.TYPE"
  WCAMPO    = CHANGE(WCAMPO,FM,VM)
  WFLD.LST := FM : WCAMPO

  WCAMPO    = "L.FT4.TX.CMM.FL"
  WCAMPO    = CHANGE(WCAMPO,FM,VM)
  WFLD.LST := FM : WCAMPO
*
  YPOS=''
  CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
*
  COMM.COD.POS   = YPOS<1,1>
  TAX.CODE.POS   = YPOS<1,2>
  WV.TAX.AMT.POS = YPOS<1,3>
  WV.COMM.POS    = YPOS<1,4>
  COMM.AMT.POS   = YPOS<1,5>
  WV.TAX.POS     = YPOS<1,6>
  TAX.AMT.POS    = YPOS<1,7>
  L.FT.COMM.CODE.POS = YPOS<1,8>
*
  COMMT.POS      = YPOS<2,1>
*
  FTCT.TX.POS    = YPOS<3,1>
*
  FN.TELLER.TRANSACTION = "F.TELLER.TRANSACTION"
  F.TELLER.TRANSACTION  = ""
*
  FN.FT.COMMISSION.TYPE = "F.FT.COMMISSION.TYPE"
  F.FT.COMMISSION.TYPE  = ""
*
  FN.FT.TXN.TYPE.CONDITION = "F.FT.TXN.TYPE.CONDITION"
  F.FT.TXN.TYPE.CONDITION  = ""
*
  R.TELLER.TRANSACTION = ""
*
  R.FT.COMMISSION.TYPE = ""
*
  IF APPLICATION EQ "TELLER" THEN
    WLOCAL.REF = TT.TE.LOCAL.REF
  END
  ELSE
    WLOCAL.REF = FT.LOCAL.REF
  END
*
  RETURN
*
*----------
OPEN.FILES:
*----------
*
  CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)
*
  CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
*
  CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)
*
  RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
  LOOP.CNT  = 1   ;   MAX.LOOPS = 2
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1

      IF R.NEW(WLOCAL.REF)<1,COMM.COD.POS> NE "" OR R.NEW(WLOCAL.REF)<1,TAX.CODE.POS> NE "" THEN
        PROCESS.GOAHEAD = ""
      END

    CASE LOOP.CNT EQ 2
      GOSUB GET.ACCOUNT.INFO

    END CASE
*
*       Increase
*
    LOOP.CNT += 1
*
  REPEAT
*
  RETURN
*
END
