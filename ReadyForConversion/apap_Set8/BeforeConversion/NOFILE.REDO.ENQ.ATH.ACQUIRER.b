*-----------------------------------------------------------------------------
* <Rating>-62</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  NOFILE.REDO.ENQ.ATH.ACQUIRER(Y.ARRAY)
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : NOFILE.REDO.ENQ.ATH.ACQUIRER
*Date              : 20.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A/--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*20/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ATM.REVERSAL
$INSERT I_F.REDO.CARD.BIN
$INSERT I_F.REDO.ATH.TRANS.TYPE
$INSERT I_F.REDO.APAP.H.PARAMETER


  GOSUB INIT
  GOSUB OPEN.FILES
  GOSUB PROCESS.VARIABLES

  RETURN

*------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------
  Y.FT.ID='' ; Y.FT.UNQ.ID='' ; Y.ATM.UNQ.ID='' ; Y.ISS.BANK='' ; Y.CARD.NO='' ; Y.TRANS.CODE=''
  Y.SRC.CCY='' ; Y.SRC.AMT=0 ; Y.DEST.CCY='' ; Y.DEST.AMT=0 ; Y.LOCAL.DATE='' ; Y.AUTH.CODE=''
  Y.SEQ.NO='' ; Y.TERM.ID=''; Y.LOCAL.TIME=''; Y.CARD.BIN=''; Y.CARD.TYPE=''; Y.TRANS.DESC='';Y.ARRAY=''
  Y.CREDIT='' ; Y.CR='' ; Y.DR ='' ; Y.DEBIT='' ; Y.CR.CARD=0 ; Y.DR.CARD=0
  Y.TOT.LOCL.CR='' ; Y.TOT.LOCL.DR='' ; Y.TOT.INTL.CR='' ; Y.TOT.INTL.DR='' ; Y.TOT.L.I.CR='' ; Y.TOT.L.I.DR=''
  Y.TOT.CR.DB.AMT=''

  RETURN
*------------------------------------------------------------------------------------
OPEN.FILES:
*------------------------------------------------------------------------------------
  FN.REDO.APAP.H.PARAMETER='F.REDO.APAP.H.PARAMETER'
  CALL OPF(FN.REDO.APAP.H.PARAMETER,F.REDO.APAP.H.PARAMETER)

  FN.REDO.VISA.FT.LOG='F.REDO.VISA.FT.LOG'
  F.REDO.VISA.FT.LOG=''
  CALL OPF(FN.REDO.VISA.FT.LOG,F.REDO.VISA.FT.LOG)

  FN.ATM.REVERSAL='F.ATM.REVERSAL'
  F.ATM.REVERSAL=''
  CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

  FN.REDO.CARD.BIN='F.REDO.CARD.BIN'
  F.REDO.CARD.BIN=''
  CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

  FN.REDO.ATH.TRANS.TYPE='F.REDO.ATH.TRANS.TYPE'
  F.REDO.ATH.TRANS.TYPE=''
  CALL OPF(FN.REDO.ATH.TRANS.TYPE,F.REDO.ATH.TRANS.TYPE)

  RETURN

*------------------------------------------------------------------------------------
PROCESS.VARIABLES:
*------------------------------------------------------------------------------------

  R.REDO.VISA.FT.LOG='' ; LOG.ERR='' ; R.FUNDS.TRANSFER='' ; Y.FT.ERR='' ; Y.ATM.ERR='' ; R.ATM.REVERSAL=''
  R.REDO.CARD.BIN='' ; Y.CARD.ERR=''; R.REDO.ATH.TRANS.TYPE='' ; Y.ATH.ERR='' ; Y.L.CR.CRD='';Y.L.DR.CRD=''
  Y.I.CR.CRD='' ; Y.I.DR.CRD='' ;Y.FTTC.IDS='';Y.FT.ID='' ; Y.CARD.MARK =''
  Y.ATM.DUP=''

  CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,'SYSTEM',R.REDO.APAP.H.PARAMETER,Y.APAP.ERR)

  Y.L.CR.CRD=R.REDO.APAP.H.PARAMETER<PARAM.FTTC.ATHL.CR.CRD>
  Y.L.DR.CRD=R.REDO.APAP.H.PARAMETER<PARAM.FTTC.ATHL.DR.CRD>
  Y.I.CR.CRD=R.REDO.APAP.H.PARAMETER<PARAM.FTTC.ATHI.CR.CRD>
  Y.I.DR.CRD=R.REDO.APAP.H.PARAMETER<PARAM.FTTC.ATHI.DR.CRD>

!Local Credit Card
  IF Y.L.CR.CRD THEN
    Y.FTTC.IDS<-1>=Y.L.CR.CRD
  END

!Local Debit Card
  IF Y.L.DR.CRD THEN
    Y.FTTC.IDS<-1>=Y.L.DR.CRD
  END

!International Credit Card
  IF Y.I.CR.CRD THEN
    Y.FTTC.IDS<-1>=Y.I.CR.CRD
  END

!International Debit Card
  IF Y.I.DR.CRD THEN
    Y.FTTC.IDS<-1>=Y.I.DR.CRD
  END

  LOOP
    REMOVE Y.CARD.IDS FROM Y.FTTC.IDS SETTING CARD.POS
  WHILE Y.CARD.IDS:CARD.POS
    CALL F.READ(FN.REDO.VISA.FT.LOG,Y.CARD.IDS,R.REDO.VISA.FT.LOG,F.REDO.VISA.FT.LOG,LOG.ERR)
    Y.REDO.IDS=Y.CARD.IDS
    Y.FT.ID = R.REDO.VISA.FT.LOG
    IF Y.FT.ID THEN
      LOOP
        REMOVE Y.FTTC.ID FROM Y.FT.ID  SETTING Y.FT.POS
      WHILE Y.FTTC.ID:Y.FT.POS
        Y.ATM.UNQ.ID=FIELD(Y.FTTC.ID,"*",2)
        GOSUB PROCESS.ATM.REVERSAL
        GOSUB FINAL.ARRAY
      REPEAT
    END
  REPEAT


  Y.ARRAY:='*':Y.TOT.LOCL.CR:'*':Y.TOT.LOCL.DR:'*':Y.TOT.INTL.CR:'*':Y.TOT.INTL.DR:'*':Y.TOT.L.I.CR:'*':Y.TOT.L.I.DR:'*':Y.TOT.CR.DB.AMT
!                     16                17               18                 19                 20               21               22
  RETURN

*------------------------------------------------------------------------------------
PROCESS.ATM.REVERSAL:
*------------------------------------------------------------------------------------

  R.ATM.REVERSAL='' ;Y.ATM.ERR = '' ;R.REDO.CARD.BIN='' ;Y.CARD.ERR='' ; R.REDO.ATH.TRANS.TYPE=''
  Y.ATH.ERR='' ;

  CALL F.READ(FN.ATM.REVERSAL,Y.ATM.UNQ.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,Y.ATM.ERR)

  IF R.ATM.REVERSAL THEN
    Y.ISS.BANK=R.ATM.REVERSAL<AT.REV.ISSUER>
    Y.CARD.NO=R.ATM.REVERSAL<AT.REV.CARD.NUMBER>
    Y.TRANS.CODE=R.ATM.REVERSAL<AT.REV.PROCESS.CODE>
    Y.SRC.CCY=R.ATM.REVERSAL<AT.REV.CURRENCY.CODE>
    Y.SRC.AMT=R.ATM.REVERSAL<AT.REV.TRANSACTION.AMOUNT>
    Y.DEST.CCY=R.ATM.REVERSAL<AT.REV.DEST.CCY>
    Y.DEST.AMT=R.ATM.REVERSAL<AT.REV.DEST.AMT>
    Y.LOCAL.DATE=R.ATM.REVERSAL<AT.REV.LOCAL.DATE>
    Y.AUTH.CODE=R.ATM.REVERSAL<AT.REV.AUTH.CODE>
    Y.SEQ.NO=R.ATM.REVERSAL<AT.REV.TRACE>
    Y.TERM.ID=R.ATM.REVERSAL<AT.REV.TERM.ID>
    Y.LOCAL.TIME=R.ATM.REVERSAL<AT.REV.LOCAL.TIME>
  END


  Y.CARD.BIN=Y.CARD.NO[1,6]

  CALL F.READ(FN.REDO.CARD.BIN,Y.CARD.BIN,R.REDO.CARD.BIN,F.REDO.CARD.BIN,Y.CARD.ERR)

  IF R.REDO.CARD.BIN THEN
    Y.CARD.TYPE=R.REDO.CARD.BIN<REDO.CARD.BIN.BIN.TYPE>
    Y.CARD.POS=R.REDO.CARD.BIN<REDO.CARD.BIN.NATIONAL.MARK>

    IF Y.CARD.POS EQ 'NO' THEN
      Y.CARD.MARK=R.REDO.CARD.BIN<REDO.CARD.BIN.NATIONAL.MARK>
    END ELSE
      Y.CARD.MARK=R.REDO.CARD.BIN<REDO.CARD.BIN.NATIONAL.MARK>
    END


    BEGIN CASE

    CASE Y.CARD.TYPE EQ 'CREDIT'

      IF Y.CARD.MARK EQ 'YES' THEN      ;* Local cards
        Y.TOT.LOCL.CR += Y.SRC.AMT
      END ELSE      ;* International cards
        Y.TOT.INTL.CR += Y.SRC.AMT
      END
      Y.TOT.L.I.CR += Y.SRC.AMT

    CASE Y.CARD.TYPE EQ 'DEBIT'

      IF Y.CARD.MARK EQ 'YES' THEN      ;* Local cards
        Y.TOT.LOCL.DR += Y.SRC.AMT
      END ELSE      ;* International cards
        Y.TOT.INTL.DR += Y.SRC.AMT
      END
      Y.TOT.L.I.DR += Y.SRC.AMT

    END CASE

    Y.TOT.CR.DB.AMT += Y.SRC.AMT

  END

  CALL F.READ(FN.REDO.ATH.TRANS.TYPE,Y.TRANS.CODE,R.REDO.ATH.TRANS.TYPE,F.REDO.ATH.TRANS.TYPE,Y.ATH.ERR)

  IF R.REDO.ATH.TRANS.TYPE THEN
    Y.TRANS.DESC=R.REDO.ATH.TRANS.TYPE<ATH.TRANS.DESCRIPTION>
  END

  RETURN

*------------------------------------------------------------------------------------
FINAL.ARRAY:
*------------------------------------------------------------------------------------

  Y.ARRAY<-1>=Y.ISS.BANK:"*":Y.CARD.NO:"*":Y.CARD.TYPE:"*":Y.TRANS.CODE:"*":Y.TRANS.DESC:"*":Y.SRC.CCY:"*":Y.SRC.AMT:"*":Y.DEST.CCY:"*":Y.REDO.IDS:"*":Y.DEST.AMT:"*":Y.LOCAL.DATE:"*":Y.AUTH.CODE:"*":Y.SEQ.NO:"*":Y.TERM.ID:"*":Y.LOCAL.TIME
!                1               2               3              4                 5               6            7             8               9          10                11               12             13            14             15
  RETURN
END
