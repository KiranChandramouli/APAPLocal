*-----------------------------------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.B.EIR.LOAD
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This is load routine
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.B.EIR
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference           Description
* 23 Oct 2010      Naveen Kumar N     ODR-2010-07-0081    Initial creation
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.SECURITY.MASTER
$INSERT I_F.SEC.TRADE
$INSERT I_F.SC.TRADING.POSITION
$INSERT I_F.CATEG.ENTRY
$INSERT I_F.REDO.H.ST.SUB.ASSET.TYPE
$INSERT I_F.REDO.APAP.L.AMORT.BALANCES
$INSERT I_REDO.B.EIR.COMMON
$INSERT I_F.REDO.CALL.LIST.CATEG
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  GOSUB INIT
  RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*****
INIT:
*****
*
  FN.REDO.H.ST.SUB.ASSET.TYPE      = "F.REDO.H.ST.SUB.ASSET.TYPE"            ; FN.SC.TRADING.POSITION = "F.SC.TRADING.POSITION"
  F.REDO.H.ST.SUB.ASSET.TYPE       = ""                                      ; F.SC.TRADING.POSITION  = ""
  R.REDO.H.ST.SUB.ASSET.TYPE       = ""                                      ; R.SC.TRADING.POSITION  = ""
  E.REDO.H.ST.SUB.ASSET.TYPE       = ""                                      ; E.SC.TRADING.POSITION  = ""
  CALL OPF(FN.REDO.H.ST.SUB.ASSET.TYPE,F.REDO.H.ST.SUB.ASSET.TYPE)           ; CALL OPF(FN.SC.TRADING.POSITION,F.SC.TRADING.POSITION)
*
  FN.SECURITY.MASTER               = "F.SECURITY.MASTER"                     ; FN.CATEG.ENTRY         = "F.CATEG.ENTRY"
  F.SECURITY.MASTER                = ""                                      ; F.CATEG.ENTRY          = ""
  R.SECURITY.MASTER                = ""                                      ; R.CATEG.ENTRY          = ""
  E.SECURITY.MASTER                = ""                                      ; E.CATEG.ENTRY          = ""
  CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)                             ; CALL OPF(FN.CATEG.ENTRY,F.CATEG.ENTRY)
*
  FN.REDO.APAP.L.AMORT.BALANCES    = "F.REDO.APAP.L.AMORT.BALANCES"          ; FN.SEC.TRADE           = "F.SEC.TRADE"
  F.REDO.APAP.L.AMORT.BALANCES     = ""                                      ; F.SEC.TRADE            = ""
  R.REDO.APAP.L.AMORT.BALANCES     = ""                                      ; R.SEC.TRADE            = ""
  E.REDO.APAP.L.AMORT.BALANCES     = ""                                      ; E.SEC.TRADE            = ""
  CALL OPF(FN.REDO.APAP.L.AMORT.BALANCES,F.REDO.APAP.L.AMORT.BALANCES)       ; CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)
*
  FN.SEC.TRADE                     = "F.SEC.TRADE"                           ; R.SEC.TRADE                      = ""
  F.SEC.TRADE                      = ""                                      ;
  CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)                                         ;
*
  FN.REDO.CALL.LIST.CATEG = 'F.REDO.CALL.LIST.CATEG'                         ; R.REDO.CALL.LIST.CATEG = ""
  F.REDO.CALL.LIST.CATEG = ''                                                ; ERR.RCLC = ""
  CALL OPF(FN.REDO.CALL.LIST.CATEG,F.REDO.CALL.LIST.CATEG)
*
  FN.REDO.AMORT.SEC.TRADE = 'F.REDO.AMORT.SEC.TRADE'                         ; R.REDO.AMORT.SEC.TRADE = ""
  F.REDO.AMORT.SEC.TRADE = ''                                                ; ERR.RAST = ""
  CALL OPF(FN.REDO.AMORT.SEC.TRADE,F.REDO.AMORT.SEC.TRADE)
*
  FN.REDO.APAP.L.AMORT.BALANCES = 'F.REDO.APAP.L.AMORT.BALANCES'             ; R.REDO.APAP.L.AMORT.BALANCES = ""
  F.REDO.APAP.L.AMORT.BALANCES  = ''                                         ; E.REDO.APAP.L.AMORT.BALANCES =""
  CALL OPF(FN.REDO.APAP.L.AMORT.BALANCES,F.REDO.APAP.L.AMORT.BALANCES)
*
  CALL MULTI.GET.LOC.REF('SEC.TRADE','L.DISC.AMOUNT',L.DISC.AMOUNT.POS)
*
  RETURN
END
