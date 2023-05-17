*-----------------------------------------------------------------------------
* <Rating>-57</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AUTH.TD.LASTID
*--------------------------------------------------------------------------------------------------------------------------------
*   DESCRIPTION :
*
*   LAUNCHES NEXT VERSION
*
*--------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JOAQUIN COSTA
*
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------------------------------
* Date             Author              Reference         Description
* APR-30-2012      J COSTA             GRUPO 8           Initial creation
* 30-APR-2013      Vignesh Kumaar R    PACS00273332      Deal slip not to be generated while reversing
*-----------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
*
$INSERT I_F.TELLER
$INSERT I_F.TELLER.DEFAULT
*
  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

* Fix for PACS00273332 [Deal slip not to be generated while reversing]

*    IF V$FUNCTION EQ 'A' THEN
*        GOSUB CHECK.AUTH.DEAL.SLIP
*    END
* End of Fix
  RETURN
*
* ============
REVE.AUTH.EVAL:
* ============
*
  IF R.NEW(TT.TE.RECORD.STATUS) EQ 'RNAU' AND V$FUNCTION EQ 'A' THEN
    Y.FLG.REV = 1
  END
*
  RETURN
*
* ======
PROCESS:
* ======
*
  Y.NARR.1                            = R.NEW(TT.TE.NARRATIVE.1)<1,1>
  Y.NARR.2                            = R.NEW(TT.TE.NARRATIVE.2)<1,1>
*
  R.TELLER.DEFAULT<TT.DEF.CURRENCY.1>        = R.NEW(TT.TE.CURRENCY.1)
  R.TELLER.DEFAULT<TT.DEF.ACCOUNT.1>         = R.NEW(TT.TE.ACCOUNT.1)
  R.TELLER.DEFAULT<TT.DEF.CUSTOMER.1>        = R.NEW(TT.TE.CUSTOMER.1)
  R.TELLER.DEFAULT<TT.DEF.AMOUNT.LOCAL.1>    = R.NEW(TT.TE.AMOUNT.LOCAL.1)
  R.TELLER.DEFAULT<TT.DEF.AMOUNT.FCY.1>      = R.NEW(TT.TE.AMOUNT.FCY.1)
  R.TELLER.DEFAULT<TT.DEF.VALUE.DATE.1>      = R.NEW(TT.TE.VALUE.DATE.1)
  R.TELLER.DEFAULT<TT.DEF.EXPOSURE.DATE.1>   = R.NEW(TT.TE.EXPOSURE.DATE.1)
  R.TELLER.DEFAULT<TT.DEF.CURR.MARKET.1>     = R.NEW(TT.TE.CURR.MARKET.1)
  R.TELLER.DEFAULT<TT.DEF.NARRATIVE.1>       = Y.NARR.1
  R.TELLER.DEFAULT<TT.DEF.DEAL.RATE>         = R.NEW(TT.TE.DEAL.RATE)
  R.TELLER.DEFAULT<TT.DEF.CURRENCY.2>        = R.NEW(TT.TE.CURRENCY.2)
  R.TELLER.DEFAULT<TT.DEF.TELLER.ID.1>       = ''
  R.TELLER.DEFAULT<TT.DEF.TELLER.ID.2>       = R.NEW(TT.TE.NARRATIVE.1)
  R.TELLER.DEFAULT<TT.DEF.ACCOUNT.2>         = ''
  R.TELLER.DEFAULT<TT.DEF.CUSTOMER.2>        = R.NEW(TT.TE.CUSTOMER.2)
  R.TELLER.DEFAULT<TT.DEF.AMOUNT.LOCAL.2>    = ''
  R.TELLER.DEFAULT<TT.DEF.RATE.2>            = R.NEW(TT.TE.RATE.2)
  R.TELLER.DEFAULT<TT.DEF.AMOUNT.FCY.2>      = R.NEW(TT.TE.AMOUNT.FCY.2)
  R.TELLER.DEFAULT<TT.DEF.NET.AMOUNT>        = ''
  R.TELLER.DEFAULT<TT.DEF.VALUE.DATE.2>      = R.NEW(TT.TE.VALUE.DATE.2)
  R.TELLER.DEFAULT<TT.DEF.EXPOSURE.DATE.2>   = R.NEW(TT.TE.EXPOSURE.DATE.2)
  R.TELLER.DEFAULT<TT.DEF.CURR.MARKET.2>     = R.NEW(TT.TE.CURR.MARKET.2)
  R.TELLER.DEFAULT<TT.DEF.NARRATIVE.2>       = R.NEW(TT.TE.TELLER.ID.2)         ;*** Modifed from null to value on 27/jun
  R.TELLER.DEFAULT<TT.DEF.WAIVE.CHARGES>     = R.NEW(TT.TE.WAIVE.CHARGES)
  R.TELLER.DEFAULT<TT.DEF.PROCESS.DATE>      = ''
*
* PACS00273068 - S
  GOSUB REVE.AUTH.EVAL
*
  IF Y.FLG.REV NE "" THEN
    R.TELLER.DEFAULT<TT.DEF.PROCESS.DATE>   = TODAY
  END
* PACS00273068 - E
*
  IF R.TELLER.DEFAULT THEN
    CALL F.WRITE("F.TELLER.DEFAULT",Y.NARR.2,R.TELLER.DEFAULT)
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
  R.TELLER.DEFAULT = ""
*
  Y.NARR.1  = ''
  Y.NARR.2  = ''
*
  Y.FLG.REV = ''
*
  RETURN
*
* =========
OPEN.FILES:
* =========
*
  RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
  LOOP.CNT  = 1   ;   MAX.LOOPS = 1
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1

    END CASE
*       Increase
    LOOP.CNT += 1
*
  REPEAT
*
  RETURN
*
END
