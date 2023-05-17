*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.DEP.DATE
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT
$INSERT I_ENQUIRY.COMMON

*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  AZ.ID = O.DATA

  CALL F.READ(FN.AZ.ACCOUNT,AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)

  Y.VALUE.DATE = R.AZ.ACCOUNT<AZ.VALUE.DATE>

  O.DATA = AZ.ID:"-":Y.VALUE.DATE

  RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
