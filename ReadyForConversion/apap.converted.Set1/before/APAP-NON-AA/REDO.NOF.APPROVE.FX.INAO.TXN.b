*-----------------------------------------------------------------------------
* <Rating>-93</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOF.APPROVE.FX.INAO.TXN(FINAL.ARRAY)

*----------------------------------------------------------------------------------------------------------------------
* DESCRIPTION
* -----------
* This Rtn is attached in a Nofile Enquiry REDO.APPROVE.FX.INAO.TXN to display the list of TT/FT INAO transactions
*
*----------------------------------------------------------------------------------------------------------------------
* Input / Output
*-----------------------------------------------------------------------------
* IN     : NA
* OUT    : FINAL.ARRAY
*----------------------------------------------------------------------------------------------------------------------
* Dependencies
*----------------------------------------------------------------------------------------------------------------------
* CALLS     :
* CALLED BY :
*
* CHANGE REQUEST / DEVELOPMENT REF:
*----------------------------------------------------------------------------------------------------------------------
* Revision History
*----------------------------------------------------------------------------------------------------------------------
* Date          Developed By          Reference        Description
* 16/05/2013    Vignesh Kumaar M R    PACS00289072     Initial Version
*----------------------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.TELLER
$INSERT I_F.REDO.H.APAP.PARAMETER

  GOSUB INITIALISE

  LOCATE "CO.CODE" IN D.FIELDS<1> SETTING FX.POS THEN
    GET.CO.CODE = D.RANGE.AND.VALUE<FX.POS>
  END

  GOSUB PROCESS
  FINAL.ARRAY = SORT(STORE.ARRAY)

  RETURN

*----------------------------------------------------------------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------------------------------------------------------------

  STORE.ARRAY = ''
  FINAL.ARRAY = ''
  SEL.CMD.FT = ''
  SEL.CMD.TT = ''

  FN.FUNDS.TRANSFER.NAU = 'F.FUNDS.TRANSFER$NAU'
  F.FUNDS.TRANSFER.NAU = ''
  CALL OPF(FN.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU)

  FN.TELLER.NAU = 'F.TELLER$NAU'
  F.TELLER.NAU = ''
  CALL OPF(FN.TELLER.NAU,F.TELLER.NAU)

  FN.REDO.H.APAP.PARAMETER = 'F.REDO.H.APAP.PARAMETER'
  F.REDO.H.APAP.PARAMETER = ''
  CALL OPF(FN.REDO.H.APAP.PARAMETER,F.REDO.H.APAP.PARAMETER)

  GET.APPL = 'TELLER':FM:'FUNDS.TRANSFER'
  GET.FIELD = 'L.ACTUAL.VERSIO':FM:'L.ACTUAL.VERSIO'
  GET.FIELD.POS = ''
  CALL MULTI.GET.LOC.REF(GET.APPL,GET.FIELD,GET.FIELD.POS)
  TT.FIELD.POS = GET.FIELD.POS<1,1>
  FT.FIELD.POS = GET.FIELD.POS<2,1>

  RETURN

*----------------------------------------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------------------------------------

  SEL.CMD.TT = "SELECT ":FN.TELLER.NAU:" WITH RECORD.STATUS EQ INAO"
  SEL.CMD.FT = "SELECT ":FN.FUNDS.TRANSFER.NAU:" WITH RECORD.STATUS EQ INAO"

  IF GET.CO.CODE THEN
    SEL.CMD.TT := " AND CO.CODE EQ ":GET.CO.CODE
    SEL.CMD.FT := " AND CO.CODE EQ ":GET.CO.CODE
  END


*  CALL F.READ(FN.REDO.H.APAP.PARAMETER,'SYSTEM',R.REDO.H.APAP.PARAMETER,F.REDO.H.APAP.PARAMETER,ERR.OVER) ;*Tus Start 
CALL CACHE.READ(FN.REDO.H.APAP.PARAMETER,'SYSTEM',R.REDO.H.APAP.PARAMETER,ERR.OVER) ; * Tus End
  LIST.OF.OVERRIDE.CLASS = R.REDO.H.APAP.PARAMETER<APAP.INAO.OVR.CLS>

  SEL.CMD.TT := " AND ("
  SEL.CMD.FT := " AND ("

  LOOP
    REMOVE OVER.ID FROM LIST.OF.OVERRIDE.CLASS SETTING OVER.POS
  WHILE OVER.ID:OVER.POS
    SEL.CMD <-1> = " OVERRIDE LIKE '...":OVER.ID:"...' "
  REPEAT

  CHANGE FM TO 'OR' IN SEL.CMD
  SEL.CMD.TT := SEL.CMD:')'
  SEL.CMD.FT := SEL.CMD:')'

  CALL EB.READLIST(SEL.CMD.FT,SEL.LIST.FT,'','',ERR.DET)
  CALL EB.READLIST(SEL.CMD.TT,SEL.LIST.TT,'','',ERR.DET)

  LOOP
    REMOVE FT.ID FROM SEL.LIST.FT SETTING FT.POS
  WHILE FT.ID:FT.POS
    CALL F.READ(FN.FUNDS.TRANSFER.NAU,FT.ID,R.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU,FT.ERR)
    IF R.FUNDS.TRANSFER.NAU THEN
      GET.AGENCY.CODE = R.FUNDS.TRANSFER.NAU<FT.CO.CODE>
      GET.PROCESS.TIME = R.FUNDS.TRANSFER.NAU<FT.DATE.TIME>
      GET.VERSION.NAME = R.FUNDS.TRANSFER.NAU<FT.LOCAL.REF,FT.FIELD.POS>
      STORE.ARRAY <-1> = GET.PROCESS.TIME:'*':FT.ID:'*':GET.AGENCY.CODE:'*':GET.VERSION.NAME
    END
  REPEAT

  LOOP
    REMOVE TT.ID FROM SEL.LIST.TT SETTING TT.POS
  WHILE TT.ID:TT.POS
    CALL F.READ(FN.TELLER.NAU,TT.ID,R.TELLER.NAU,F.TELLER.NAU,TT.ERR)
    IF R.TELLER.NAU THEN
      GET.AGENCY.CODE = R.TELLER.NAU<TT.TE.CO.CODE>
      GET.PROCESS.TIME = R.TELLER.NAU<TT.TE.DATE.TIME>
      GET.VERSION.NAME = R.TELLER.NAU<TT.TE.LOCAL.REF,TT.FIELD.POS>
      STORE.ARRAY <-1> = GET.PROCESS.TIME:'*':TT.ID:'*':GET.AGENCY.CODE:'*':GET.VERSION.NAME
    END
  REPEAT
  RETURN
