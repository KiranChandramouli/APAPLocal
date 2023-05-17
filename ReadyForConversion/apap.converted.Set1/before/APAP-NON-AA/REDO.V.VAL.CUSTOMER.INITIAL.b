*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.CUSTOMER.INITIAL
*------------------------------------------------------------------------------------------------------------------
* Developer    : SAKTHI S
* Date         : 02.08.2010
* Description  : REDO.V.VAL.CUSTOMER.INITIAL
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : --N/A--
* Out : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : --N/A--
* Called By : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
*
*------------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.CUSTOMER
$INSERT I_System

  GOSUB INIT
  GOSUB PROCESS
  GOSUB GOEND
  RETURN
*-------------------
INIT:
*-------------------

  LOC.REF.APPL="AA.PRD.DES.CUSTOMER"
  LOC.REF.FIELDS="POL.EXP.DATE":VM:"POLICY.ORG.DATE":VM:"POL.START.DATE"
  FIELD.POS=""

  CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,FIELD.POS)

  POL.EXP.DATE.POS = FIELD.POS<1,1>
  POLICY.ORG.DATE.POS = FIELD.POS<1,2>
  POL.START.DATE.POS =  FIELD.POS<1,3>



  Y.POL.EXP.DATE.POS = ""
  Y.POL.EXP.DATE = ""
  RETURN

*------------------
PROCESS:
*------------------

  R.NEW(AA.CUS.LOCAL.REF)<1,POLICY.ORG.DATE.POS> = TODAY

  POL.ORG.DATE = R.NEW(AA.CUS.LOCAL.REF)<1,POLICY.ORG.DATE.POS>

*    R.NEW(AA.CUS.LOCAL.REF)<1,POL.START.DATE.POS> = POL.ORG.DATE

  Y.POL.EXP.DATE = R.NEW(AA.CUS.LOCAL.REF)<1,POL.EXP.DATE.POS>

  IF NOT(Y.POL.EXP.DATE) THEN
    AF = AA.CUS.LOCAL.REF
    AV = FIELD.POS
    ETEXT = 'EB-POL.EXP.DATE.MISSING'
    CALL STORE.END.ERROR
  END
  IF Y.POL.EXP.DATE LE TODAY THEN
    AF = AA.CUS.LOCAL.REF
    AV = FIELD.POS
    ETEXT = 'EB-POL.EXP.DATE.BACK.DATE'
    CALL STORE.END.ERROR
  END
  RETURN

*--------------------
GOEND:
*--------------------
END
