*-----------------------------------------------------------------------------------------------------
* <Rating>-52</Rating>
*-----------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.E.NOF.RTE.COB.RTN(TXN.ARRAY)
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This is a no file enquiry routine for the enquiry REDO.RTE.COB.REPORT
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.E.NOF.RTE.COB.RTN
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE                DESCRIPTION
*28.04.2011      SUDHARSANAN s     PACS00023990          INITIAL CREATION
*04.01.2013  Nava V.    PACS00233570   Reading RTE generated TODAY (Temp file) before COB.
* -----------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.TELLER
$INSERT I_F.DATES
$INSERT I_F.T24.FUND.SERVICES
*
  GOSUB INIT
  GOSUB PROCESS
*
  RETURN
*
INIT:
******
*
  FN.FUNDS.TRANSFER.HIS='F.FUNDS.TRANSFER$HIS'
  F.FUNDS.TRANSFER.HIS=''
  CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)
*
  FN.TELLER.HIS='F.TELLER$HIS'
  F.TELLER.HIS=''
  CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)
*
  FN.T24.FUND.SERVICES.HIS='F.T24.FUND.SERVICES$HIS'
  F.T24.FUND.SERVICES.HIS=''
  CALL OPF(FN.T24.FUND.SERVICES.HIS,F.T24.FUND.SERVICES.HIS)

  FN.REDO.FT.TT.LIVE.REC='F.REDO.FT.TT.LIVE.REC'
  F.REDO.FT.TT.LIVE.REC=''
  CALL OPF(FN.REDO.FT.TT.LIVE.REC,F.REDO.FT.TT.LIVE.REC)
*
  RETURN
*
**********
PROCESS:
*********
*   Reads temp table Last working day where RTE forms were generated (FT,TT & T24FS).
  R.REDO.FT.TT.LIVE.REC = "" ; LIVE.ERR = ""
  CALL F.READ(FN.REDO.FT.TT.LIVE.REC,TODAY,R.REDO.FT.TT.LIVE.REC,F.REDO.FT.TT.LIVE.REC,LIVE.ERR)
  IF NOT(R.REDO.FT.TT.LIVE.REC) THEN
    RETURN
  END
  LOOP
    REMOVE Y.FT.TT.ID FROM R.REDO.FT.TT.LIVE.REC SETTING FT.TT.POS
  WHILE Y.FT.TT.ID:FT.TT.POS
    Y.FT.TT.ID1=Y.FT.TT.ID[1,2]
    BEGIN CASE
    CASE Y.FT.TT.ID1 EQ 'FT'
      GOSUB FTSELECTION
    CASE Y.FT.TT.ID1 EQ 'TT'
      GOSUB TTSELECTION
    CASE Y.FT.TT.ID1 EQ 'T2'
      GOSUB TFSSELECTION
    END CASE
  REPEAT
*
  RETURN
*
************
FTSELECTION:
************
*
  R.FUNDS.TRANSFER = '' ; ERR.FT = ''
  CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,Y.FT.TT.ID,R.FUNDS.TRANSFER,ERR.FT)
  IF R.FUNDS.TRANSFER THEN
    TRANS.REFERENCE=FIELD(Y.FT.TT.ID,";",1)
    Y.DBT.AMT=R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>
    IF Y.DBT.AMT NE '' THEN
      AMOUNT.EXCEED=Y.DBT.AMT
    END ELSE
      AMOUNT.EXCEED=R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>
    END
    Y.DB.VAL.DTE=R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE>
    IF Y.DB.VAL.DTE NE '' THEN
      TXN.DATE=Y.DB.VAL.DTE
    END ELSE
      TXN.DATE=R.FUNDS.TRANSFER<FT.CREDIT.VALUE.DATE>
    END
    REC.STATUS='LIVE'
    TXN.ARRAY<-1>=TRANS.REFERENCE:'*':AMOUNT.EXCEED:'*':TXN.DATE:'*':REC.STATUS
  END
*
  RETURN
*
************
TTSELECTION:
*************
*
  R.TELLER = ''
  ERR.TELLER = ''
  CALL EB.READ.HISTORY.REC(F.TELLER.HIS,Y.FT.TT.ID,R.TELLER,ERR.TELLER)
  IF R.TELLER THEN
    TRANS.REFERENCE=FIELD(Y.FT.TT.ID,";",1)
    AMOUNT.EXCEED=R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
    VALUE.DTE2=R.TELLER<TT.TE.VALUE.DATE.2>
    IF VALUE.DTE2 THEN
      TXN.DATE=VALUE.DTE2
    END ELSE
      TXN.DATE=R.TELLER<TT.TE.VALUE.DATE.1>
    END
    REC.STATUS='LIVE'
    TXN.ARRAY<-1>=TRANS.REFERENCE:'*':AMOUNT.EXCEED:'*':TXN.DATE:'*':REC.STATUS
  END
*
  RETURN
*
*************
TFSSELECTION:
*************
*
  R.T24.FUND.SERVICES  = ''
  T24.FUND.SERVICES.ER = ''
  CALL EB.READ.HISTORY.REC(F.T24.FUND.SERVICES.HIS,Y.FT.TT.ID,R.T24.FUND.SERVICES,T24.FUND.SERVICES.ER)
  IF R.T24.FUND.SERVICES THEN
    TRANS.REFERENCE = FIELD(Y.FT.TT.ID,";",1)
    AMOUNT.EXCEED   = R.T24.FUND.SERVICES<TFS.AMOUNT,1>
    TXN.DATE        = R.T24.FUND.SERVICES<TFS.BOOKING.DATE>
    REC.STATUS      = 'LIVE'
    TXN.ARRAY<-1>=TRANS.REFERENCE:'*':AMOUNT.EXCEED:'*':TXN.DATE:'*':REC.STATUS
  END
*
  RETURN
*
END
