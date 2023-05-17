*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TT.PROCESS.VALIDATE
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.PART.TT.PROCESS table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.TT.PROCESS.VALIDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*29.06.2010      JEEVA T         ODR-2010-08-0017    INITIAL CREATION
* -----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.TT.PROCESS
$INSERT I_GTS.COMMON
$INSERT I_F.AA.ARRANGEMENT

  GOSUB INIT
  GOSUB PROCESS
  RETURN

*---
INIT:
*---
  FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT= ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
  ACC.CURR =''
  VAR.CURRENCY = ''
  R.AA.ARRANGE =''
  RETURN
*-------
PROCESS:
*-------
*Checking valid curreny for arrangement account
  VAR.AA.ID=R.NEW(TT.PRO.ARRANGEMENT.ID)
  CALL F.READ(FN.AA.ARRANGEMENT,VAR.AA.ID,R.AA.ARRANGE,F.AA.ARRANGEMENT,AA.ARR.ERR)
  ACC.CURR=R.AA.ARRANGE<AA.ARR.CURRENCY>
  VAR.CURRENCY=R.NEW(TT.PRO.CURRENCY)
  IF ACC.CURR NE VAR.CURRENCY THEN
    AF=TT.PRO.CURRENCY
    ETEXT='EB-MIS.MATCH.CURR'
    CALL STORE.END.ERROR
  END
  RETURN
*------------------------------------------------------------------------------------
END
