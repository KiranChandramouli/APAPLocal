*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.PART.PROCESS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is an INPUT routine attached to below versions,
*REDO.PART.TT.PROCESS,CREATE REDO.PART.TFS.PROCESS,CREATE

* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 28-06-2010        Sudharsanan S  ODR-2010-08-0017    Initial Creation
* 10-11-2010        JEEVA T        ODR-2010-08-0017    Baselined after few logic changes
*------------------------------------------------------------------------------------------
$INSERT I_EQUATE
$INSERT I_COMMON
$INSERT I_F.TELLER
$INSERT I_F.REDO.TT.PROCESS
$INSERT I_F.REDO.TT.REJECT
$INSERT I_F.REDO.MULTI.TXN.PROCESS
$INSERT I_F.REDO.MULTI.TXN.REJECT
*    $INCLUDE USPLATFORM.BP I_F.T24.FUND.SERVICES

  GOSUB INIT
  GOSUB CHECK.AMT
  RETURN

******
INIT:
******
*Initialize all the variables


  FN.REDO.TT.PROCESS  ='F.REDO.TT.PROCESS'
  F.REDO.TT.PROCESS   =''
  CALL OPF(FN.REDO.TT.PROCESS,F.REDO.TT.PROCESS)

  FN.REDO.TT.REJECT ='F.REDO.TT.REJECT'
  F.REDO.TT.REJECT  =''
  CALL OPF(FN.REDO.TT.REJECT,F.REDO.TT.REJECT)

  FN.REDO.MULTI.TXN.PROCESS ='F.REDO.MULTI.TXN.PROCESS'
  F.REDO.MULTI.TXN.PROCESS  = ''
  CALL OPF(FN.REDO.MULTI.TXN.PROCESS,F.REDO.MULTI.TXN.PROCESS)

  FN.REDO.MULTI.TXN.REJECT  = 'F.REDO.MULTI.TXN.REJECT'
  F.REDO.MULTI.TXN.REJECT   = ''
  CALL OPF(FN.REDO.MULTI.TXN.REJECT,F.REDO.MULTI.TXN.REJECT)

  RETURN

***********
CHECK.AMT:
***********
* Checking the amount value with total amount overdue value

  IF APPLICATION EQ 'REDO.TT.PROCESS' THEN
    VAR.AMT = R.NEW(TT.PRO.AMOUNT)
    VAR.TOT.AMT.OVRDUE = R.NEW(TT.PRO.TOT.AMT.OVRDUE)
    GOSUB PROCESS1
  END

  IF APPLICATION EQ 'REDO.MULTI.TXN.PROCESS' THEN
    VAR.AMT = R.NEW(MUL.TXN.PRO.AMOUNT)
    VAR.TOT.AMT.OVRDUE = R.NEW(MUL.TXN.PRO.TOT.AMT.OVRDUE)
    GOSUB PROCESS2
  END

  RETURN

***********
PROCESS1:
***********

  IF VAR.AMT GT VAR.TOT.AMT.OVRDUE THEN
    AF = TT.PRO.AMOUNT
    ETEXT = 'EB-REDO.AMOUNT.MAX'
    CALL STORE.END.ERROR
  END
  RETURN

***********
PROCESS2:
***********
  VAR.AMT.LIST = DCOUNT(VAR.AMT,VM)
  FOR VAR.AMT.CNT = 1 TO VAR.AMT.LIST
    VAR.AMOUNT = VAR.AMT<VAR.AMT.CNT>
    VAR.AMT1 +=VAR.AMOUNT
  NEXT VAR.AMT.CNT
  IF VAR.AMT1 GT VAR.TOT.AMT.OVRDUE THEN
    AF = MUL.TXN.PRO.AMOUNT
    ETEXT = 'EB-REDO.AMOUNT.MAX'
    CALL STORE.END.ERROR
  END
  RETURN

******************************************************************************************************
END
