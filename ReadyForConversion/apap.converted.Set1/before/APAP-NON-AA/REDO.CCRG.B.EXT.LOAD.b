* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
* <Rating>-59</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CCRG.B.EXT.LOAD
*-----------------------------------------------------------------------------
*
* Load routine to setup the common area for the multi-threaded Close of Business
* job REDO.CCRG.EXT
*
*-----------------------------------------------------------------------------
* Modification History:
*                      2011.04.06 - APAP B5 : ODR-2011-03-0154
*                                   First Version
*REM Just for compile
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
*
$INSERT I_REDO.CCRG.B.EXT.COMMON
$INSERT I_REDO.CCRG.CONSTANT.COMMON
*-----------------------------------------------------------------------------

* Open files to be used in the XX routine as well as standard variables.

* Main process queue - Job List
  FN.REDO.CCRG.EXT.QUEUE = 'F.REDO.CCRG.EXT.QUEUE'
  F.REDO.CCRG.EXT.QUEUE  = ''
  CALL OPF(FN.REDO.CCRG.EXT.QUEUE,F.REDO.CCRG.EXT.QUEUE)

* Populate process queue - to populate at the end of the file
  FN.REDO.CCRG.POP.QUEUE = 'F.REDO.CCRG.POP.QUEUE'
  F.REDO.CCRG.POP.QUEUE  = ''
  CALL OPF(FN.REDO.CCRG.POP.QUEUE,F.REDO.CCRG.POP.QUEUE)

* Contracts list for each Customer
  FN.REDO.CUS.TXN.CONCAT = 'F.REDO.CUS.TXN.CONCAT'
  F.REDO.CUS.TXN.CONCAT  = ''
  CALL OPF(FN.REDO.CUS.TXN.CONCAT,F.REDO.CUS.TXN.CONCAT)

* Balance Type Parameters
  FN.REDO.CCRG.BALANCE.TYPE.PARAM = 'F.REDO.CCRG.BALANCE.TYPE.PARAM'
  F.REDO.CCRG.BALANCE.TYPE.PARAM  = ''
  CALL OPF(FN.REDO.CCRG.BALANCE.TYPE.PARAM,F.REDO.CCRG.BALANCE.TYPE.PARAM)

* General Parameters
  R.RCP = ''
  CALL CACHE.READ('F.REDO.CCRG.PARAMETERS','SYSTEM',R.RCP,YERR)
  IF R.RCP EQ '' THEN
    Y.ERROR    = K.REC.NOT.FOUND
    Y.ERROR<2> = 'SYSTEM' : VM : 'F.REDO.CCRG.PARAMETERS'
    CALL REDO.CCRG.B.TRACE.ERROR('REDO.CCRG.B.EXT.LOAD', Y.ERROR, @FALSE, "", @FALSE)
  END

* Contract Balances
  FN.REDO.CCRG.CONTRACT.BAL = 'F.REDO.CCRG.CONTRACT.BAL'
  F.REDO.CCRG.CONTRACT.BAL = ''
  CALL OPF(FN.REDO.CCRG.CONTRACT.BAL,F.REDO.CCRG.CONTRACT.BAL)

* User requests execution
  FN.REDO.CCRG.CUSTOMER = 'F.REDO.CCRG.CUSTOMER'
  F.REDO.CCRG.CUSTOMER = ''
  CALL OPF(FN.REDO.CCRG.CUSTOMER,F.REDO.CCRG.CUSTOMER)

* Application Files
  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

* Get local fields
  APPL = 'CUSTOMER'
  FLD = 'L.CU.CIDENT':VM:'L.CU.RCN'
  POS = ''
  CALL MULTI.GET.LOC.REF(APPL,FLD,POS)
  CIDENT.POS = POS<1,1>
  RNC.POS = POS <1,2>
*
*-----------------------------------------------------------------------------
*

* Limit Application
  FN.LIMIT = 'F.LIMIT'
  F.LIMIT = ''
  CALL OPF(FN.LIMIT,F.LIMIT)

*Money Market Application
*      FN.MM.MONEY.MARKET = 'F.MM.MONEY.MARKET'
*      F.MM.MONEY.MARKET = ''
*      CALL OPF(FN.MM.MONEY.MARKET,F.MM.MONEY.MARKET)

*Forex Application
  FN.FOREX = 'F.FOREX'
  F.FOREX = ''
  CALL OPF(FN.FOREX,F.FOREX)

*Arrangement Application
  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT = ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

*Account Application
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

*Arrangemente Customer Application
  FN.AA.ARR.CUSTOMER = 'F.AA.ARR.CUSTOMER'
  F.AA.ARR.CUSTOMER = ''
  CALL OPF(FN.AA.ARR.CUSTOMER,F.AA.ARR.CUSTOMER)

*Contract Balances Application
  FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
  F.EB.CONTRACT.BALANCES = ''
  CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

*Account Details Application
  FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
  F.AA.ACCOUNT.DETAILS = ''
  CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

*Security Position
*      FN.SECURITY.POSITION = 'F.SECURITY.POSITION'
*      F.SECURITY.POSITION = ''
*      CALL OPF(FN.SECURITY.POSITION,F.SECURITY.POSITION)

*Entitlement
*      FN.ENTITLEMENT = 'F.ENTITLEMENT'
*      F.ENTITLEMENT = ''
*      CALL OPF(FN.ENTITLEMENT,F.ENTITLEMENT)

*SC.Parameter
*      FN.SC.PARAMETER = 'F.SC.PARAMETER'
*      F.SC.PARAMETER = ''
*      CALL OPF(FN.SC.PARAMETER,F.SC.PARAMETER)

*SC.Settlement
*      FN.SC.SETTLEMENT = 'F.SC.SETTLEMENT'
*      F.SC.SETTLEMENT = ''
*      CALL OPF(FN.SC.SETTLEMENT,F.SC.SETTLEMENT)

*Diary
*      FN.DIARY = 'F.DIARY'
*      F.DIARY = ''
*      CALL OPF(FN.DIARY,F.DIARY)

*Security Transfer
*      FN.SECURITY.TRANSFER = 'F.SECURITY.TRANSFER'
*      F.SECURITY.TRANSFER = ''
*      CALL OPF(FN.SECURITY.TRANSFER,F.SECURITY.TRANSFER)

*Position Transfer
*      FN.POSITION.TRANSFER = 'F.POSITION.TRANSFER'
*      F.POSITION.TRANSFER  = ''
*      CALL OPF(FN.POSITION.TRANSFER,F.POSITION.TRANSFER)

*Currency
  FN.CURRENCY = 'F.CURRENCY'
  F.CURRENCY  = ''
  CALL OPF(FN.CURRENCY,F.CURRENCY)
*
  RETURN
*-----------------------------------------------------------------------------
END
