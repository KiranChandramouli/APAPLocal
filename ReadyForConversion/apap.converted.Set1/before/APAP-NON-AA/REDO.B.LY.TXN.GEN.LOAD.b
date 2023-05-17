*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.LY.TXN.GEN.LOAD
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine performs initialisation and gets the details from the parameter table REDO.LY.MODALITY
*  and stores it in the common variable
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date           who           Reference            Description
* 03-MAY-2010   S.Marimuthu  ODR-2009-12-0276      Initial Creation
*---------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER.ACCOUNT
$INSERT I_F.REDO.LY.MODALITY
$INSERT I_F.REDO.LY.PROGRAM
$INSERT I_F.REDO.LY.POINTS
$INSERT I_F.REDO.LY.POINTS.TOT
$INSERT I_F.DATES
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.AA.BILL.DETAILS
$INSERT I_REDO.B.LY.TXN.GEN.COMMON
$INSERT I_F.FUNDS.TRANSFER
*-----------------------------------------------------------------------------
  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROGRAM.END
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
  FLAG.CNT = 1
  FLAG.VAR = 'N'

  G.DATE = ''
  I.DATE = DATE()
  CALL DIETER.DATE(G.DATE,I.DATE,'')

  CUR.MONTH = TODAY[5,2]
  CUR.YEAR  = TODAY[1,4]
  RETURN
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
  F.REDO.LY.PROGRAM = ''
  CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

  FN.REDO.LY.MODALITY = 'F.REDO.LY.MODALITY'
  F.REDO.LY.MODALITY = ''
  CALL OPF(FN.REDO.LY.MODALITY,F.REDO.LY.MODALITY)

  FN.REDO.LY.POINTS = 'F.REDO.LY.POINTS'
  F.REDO.LY.POINTS = ''
  CALL OPF(FN.REDO.LY.POINTS,F.REDO.LY.POINTS)

  FN.REDO.LY.POINTS.TOT = 'F.REDO.LY.POINTS.TOT'
  F.REDO.LY.POINTS.TOT = ''
  CALL OPF(FN.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT)

  FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
  F.CUSTOMER.ACCOUNT = ''
  CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

  FN.ACCT.ENT.TODAY = 'F.ACCT.ENT.TODAY'
  F.ACCT.ENT.TODAY = ''
  CALL OPF(FN.ACCT.ENT.TODAY,F.ACCT.ENT.TODAY)

  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT = ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

  FN.AA.BILL.DETAILS ='F.AA.BILL.DETAILS'
  F.AA.BILL.DETAILS = ''
  CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

  FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
  F.FUNDS.TRANSFER = ''
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

  RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------
END
