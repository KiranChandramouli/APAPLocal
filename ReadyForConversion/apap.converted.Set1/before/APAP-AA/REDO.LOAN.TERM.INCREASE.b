*-----------------------------------------------------------------------------
* <Rating>-61</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LOAN.TERM.INCREASE
*------------------------------------------------------------
*Description: This is a post routine for LENDING-CHANGE.TERM-TERM.AMOUNT to change the last
* review date as NULL in interest property if applicable.

* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
* 17-Aug-2011     H Ganesh              PACS00102749 - B.16      Initial Draft.
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_AA.LOCAL.COMMON
$INSERT I_F.AA.INTEREST
$INSERT I_F.AA.TERM.AMOUNT

  IF c_aalocActivityStatus EQ 'AUTH' THEN
    GOSUB LOCAL.REF
    GOSUB PROCESS
  END
  RETURN
*-----------------------------------------------------------------------------
LOCAL.REF:
*-----------------------------------------------------------------------------

  LOC.REF.APPLICATION="AA.PRD.DES.INTEREST"
  LOC.REF.FIELDS='L.AA.NXT.REV.DT':VM:'L.AA.LST.REV.DT':VM:'L.AA.RT.RV.FREQ':VM:'L.AA.REV.FORM':VM:'L.AA.REV.RT.TY'
  LOC.REF.POS=''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  POS.L.AA.NXT.REV.DT = LOC.REF.POS<1,1>
  POS.L.AA.LST.REV.DT = LOC.REF.POS<1,2>
  POS.L.AA.RT.RV.FREQ = LOC.REF.POS<1,3>
  POS.L.AA.REV.FORM   = LOC.REF.POS<1,4>
  POS.L.AA.REV.RT.TY  = LOC.REF.POS<1,5>

  RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
  ARR.ID = c_aalocArrId
  GOSUB GET.INTEREST.PROP
  Y.NEXT.REV.DATE    = R.CONDITION<AA.INT.LOCAL.REF,POS.L.AA.NXT.REV.DT>
  Y.LAST.REV.DATE    = R.CONDITION<AA.INT.LOCAL.REF,POS.L.AA.LST.REV.DT>
  Y.RATE.REV.FREQ    = R.CONDITION<AA.INT.LOCAL.REF,POS.L.AA.RT.RV.FREQ>
  Y.RATE.REVIEW.TYPE = R.CONDITION<AA.INT.LOCAL.REF,POS.L.AA.REV.RT.TY>
  Y.REVIEW.FORM      = R.CONDITION<AA.INT.LOCAL.REF,POS.L.AA.REV.FORM>

  IF Y.LAST.REV.DATE EQ '' THEN
    RETURN
  END ELSE
    IF Y.RATE.REVIEW.TYPE EQ 'Periodic' AND Y.REVIEW.FORM EQ 'AUTOMATIC' THEN
      GOSUB PROCESS.NEXT
    END
  END

  RETURN
*-----------------------------------------------------------------------------
GET.INTEREST.PROP:
*-----------------------------------------------------------------------------

  PROP.NAME='PRINCIPAL'       ;* Interest Property to obtain
  CALL REDO.GET.INTEREST.PROPERTY(ARR.ID,PROP.NAME,OUT.PROP,ERR)
  EFF.DATE = ''
  PROP.CLASS='INTEREST'
  PROPERTY = OUT.PROP
  R.CONDITION = ''
  ERR.MSG = ''
  CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)

  RETURN

*-----------------------------------------------------------------------------
PROCESS.NEXT:
*-----------------------------------------------------------------------------

  COMI = Y.RATE.REV.FREQ
  CALL CFQ
  Y.CALC.LAST.REV.DATE = COMI[1,8]
  IF Y.CALC.LAST.REV.DATE LT R.NEW(AA.AMT.MATURITY.DATE) THEN
    GOSUB POST.OFS
  END
  RETURN
*-----------------------------------------------------------------------------
POST.OFS:
*-----------------------------------------------------------------------------
  R.CONDITION = ''
  R.CONDITION<AA.INT.LOCAL.REF,POS.L.AA.LST.REV.DT> = 'NULL'
  IF Y.NEXT.REV.DATE LE TODAY THEN
    R.CONDITION<AA.INT.LOCAL.REF,POS.L.AA.NXT.REV.DT> = COMI[1,8]
    R.CONDITION<AA.INT.LOCAL.REF,POS.L.AA.RT.RV.FREQ> = COMI
  END

  Y.ACT.PROP=''
  Y.ACT.PROP<1> = PROPERTY
  Y.ACT.PROP<2> = "LENDING-CHANGE-":PROPERTY
  OFS.STRING.FINAL = ''
  CALL REDO.AA.BUILD.OFS(ARR.ID,R.CONDITION,Y.ACT.PROP,OFS.STRING.FINAL)
  OFS.SRC = 'AA.INT.UPDATE'
  OPTIONS = ''
  CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)

  RETURN
END
