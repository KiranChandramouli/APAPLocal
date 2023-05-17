* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
* <Rating>-8</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CCRG.B.POP.LOAD
*-----------------------------------------------------------------------------
*
* Load routine to setup the common area for the multi-threaded Close of Business
* job REDO.CCRG.POP
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
$INSERT I_REDO.CCRG.B.POP.COMMON
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*OPEN.FILES
*-----------------------------------------------------------------------------

* Queue Populate
  FN.REDO.CCRG.POP.QUEUE = 'F.REDO.CCRG.POP.QUEUE'
  F.REDO.CCRG.POP.QUEUE  = ''
  CALL OPF(FN.REDO.CCRG.POP.QUEUE,F.REDO.CCRG.POP.QUEUE)

* List Risk Limit by the Customer
  FN.REDO.CCRG.RL.CUSTOMER = 'F.REDO.CCRG.RL.CUSTOMER'
  F.REDO.CCRG.RL.CUSTOMER  = ''
  CALL OPF(FN.REDO.CCRG.RL.CUSTOMER,F.REDO.CCRG.RL.CUSTOMER)

*List of the Related Customer by Risk Limit
  FN.REDO.CCRG.RL.REL.CUS = 'F.REDO.CCRG.RL.REL.CUS'
  F.REDO.CCRG.RL.REL.CUS  = ''
  CALL OPF(FN.REDO.CCRG.RL.REL.CUS,F.REDO.CCRG.RL.REL.CUS)

*Balances by the Customer and Related Customers
  FN.REDO.CCRG.CONTRACT.BAL = 'F.REDO.CCRG.CONTRACT.BAL'
  F.REDO.CCRG.CONTRACT.BAL  = ''
  CALL OPF(FN.REDO.CCRG.CONTRACT.BAL,F.REDO.CCRG.CONTRACT.BAL)

*Enquiry: Distribution by Risk Limit
  FN.REDO.CCRG.RL.BAL.MAIN = 'F.REDO.CCRG.RL.BAL.MAIN'
  F.REDO.CCRG.RL.BAL.MAIN  = ''
  CALL OPF(FN.REDO.CCRG.RL.BAL.MAIN,F.REDO.CCRG.RL.BAL.MAIN)

*Enquiry: Detail by Catergory Product
  FN.REDO.CCRG.RL.BAL.DET = 'F.REDO.CCRG.RL.BAL.DET'
  F.REDO.CCRG.RL.BAL.DET  = ''
  CALL OPF(FN.REDO.CCRG.RL.BAL.DET,F.REDO.CCRG.RL.BAL.DET)

*Enquiry: Detail by Related Customer
  FN.REDO.CCRG.RL.BAL.CUS.DET = 'F.REDO.CCRG.RL.BAL.CUS.DET'
  F.REDO.CCRG.RL.BAL.CUS.DET  = ''
  CALL OPF(FN.REDO.CCRG.RL.BAL.CUS.DET,F.REDO.CCRG.RL.BAL.CUS.DET)

*Enquiry: Monitor of process
  FN.REDO.CCRG.RL.EFFECTIVE = 'F.REDO.CCRG.RL.EFFECTIVE'
  F.REDO.CCRG.RL.EFFECTIVE = ''
  CALL OPF(FN.REDO.CCRG.RL.EFFECTIVE,F.REDO.CCRG.RL.EFFECTIVE)


  RETURN

END
