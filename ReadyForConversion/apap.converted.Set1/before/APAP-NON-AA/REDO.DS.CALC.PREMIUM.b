*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.CALC.PREMIUM(IN.OUT.PARA)
*------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This deal slip routine should be attached to the DEAL.SLIP.FORMAT, REDO.BUY.SELL.DSLIP
*------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.DS.CALC.PREMIUM
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 16-Aug-2010      Naveenkumar N     ODR-2010-07-0082            Initial creation
*----------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.SEC.TRADE

  GOSUB PROCESS
  RETURN
********
PROCESS:
********
! Process to find y.result
*
  Y.ID = IN.OUT.PARA
  Y.VAR1 = R.NEW(SC.SBS.CUST.NO.NOM)
  Y.VAR2 = R.NEW(SC.SBS.CU.GROSS.AM.TRD)

  CHANGE VM TO '*' IN Y.VAR1
  Y.COUNT.VAR1 = DCOUNT(Y.VAR1,'*')

  CHANGE VM TO '*' IN Y.VAR2
  Y.COUNT.VAR2 = DCOUNT(Y.VAR2,'*')
*
  INIT = 1
  LOOP
  WHILE INIT LE Y.COUNT.VAR1
    Y.FIRST.VAR1 = FIELD(Y.VAR1,'*',INIT)
    Y.FIRST.VAR2 = FIELD(Y.VAR2,'*',INIT)

    Y.RESULT<-1> = (Y.FIRST.VAR1 - Y.FIRST.VAR2)
    INIT ++
  REPEAT
  CHANGE FM TO ',' IN Y.RESULT
  IN.OUT.PARA = Y.RESULT
  RETURN
END
