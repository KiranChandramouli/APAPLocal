*-----------------------------------------------------------------------------
* <Rating>-35</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.NOF.ST.BUY.SELL(Y.ARR)
*------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This NOFILE routine should be attached to the STANDARD.SELECTION which would accept
*               SEC.TRADE ID and return back the SEC.TRADE ID and HOLD.ID local field
*------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.E.NOF.ST.BUY.SELL
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 16-Aug-2010      Naveenkumar N     ODR-2010-07-0082            Initial creation
*----------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.SEC.TRADE
$INSERT I_ENQUIRY.COMMON
*
  GOSUB INIT
  GOSUB PROCESS
  RETURN
*****
INIT:
*****
! Initialising necessay variables
*
  FN.SEC.TRADE = "F.SEC.TRADE"
  F.SEC.TRADE = ""
  R.SEC.TRADE = ""
  E.SEC.TRADE = ""
  CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)
*
  FN.SEC.TRADE$HIS = "F.SEC.TRADE$HIS"
  F.SEC.TRADE$HIS = ""
  R.SEC.TRADE.HIS = ""
  E.SEC.TRADE.HIS = ""
  CALL OPF(FN.SEC.TRADE$HIS,F.SEC.TRADE$HIS)
*
  GOSUB MULTI.LOCAL
  Y.ARR = ""
  RETURN
********
PROCESS:
********
! Process to fetch the Local Reference field value
*
  LOCATE "SEC.TRADE.REF" IN D.FIELDS<1> SETTING POSITION THEN
    SEC.TRADE.REF = D.RANGE.AND.VALUE<POSITION>
  END
*
! Call to F.Read for fetching the Hold.Reference.Id
*
  CALL F.READ(FN.SEC.TRADE,SEC.TRADE.REF,R.SEC.TRADE,F.SEC.TRADE,E.SEC.TRADE)
  IF R.SEC.TRADE THEN
    Y.L.ST.HOLD.REF = R.SEC.TRADE<SC.SBS.LOCAL.REF><1,L.ST.HOLD.REF.POS>
  END ELSE
    CALL EB.READ.HISTORY.REC(F.SEC.TRADE$HIS,SEC.TRADE.REF,R.SEC.TRADE.HIS,E.SEC.TRADE.HIS)
    Y.L.ST.HOLD.REF = R.SEC.TRADE.HIS<SC.SBS.LOCAL.REF><1,L.ST.HOLD.REF.POS>
  END
*
! Final Array returned
  Y.ARR := SEC.TRADE.REF:"*":Y.L.ST.HOLD.REF
  RETURN
************
MULTI.LOCAL:
************
! Extracting the Local Reference Field position
*
  APPLICATION.ID = 'SEC.TRADE'
  FIELD.NAME = 'L.ST.HOLD.REF'
  FIELD.POS = ''
  CALL MULTI.GET.LOC.REF(APPLICATION.ID,FIELD.NAME,FIELD.POS)
  L.ST.HOLD.REF.POS = FIELD.POS<1,1>
  RETURN
END
