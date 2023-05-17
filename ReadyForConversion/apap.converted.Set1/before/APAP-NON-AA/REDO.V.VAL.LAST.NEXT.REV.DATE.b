*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.LAST.NEXT.REV.DATE
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.V.VAL.LAST.NEXT.REV.DATE
*-----------------------------------------------------------------------------
* DESCRIPTION:
*------------------------------------------------------------------------------------
*       This is a validation routine used to make the Local field L.AA.NXT.REV.DT
* and L.AA.LST.REV.DT in AA.PRD.DES.INTEREST as noinput field when L.AA.REV.RT.TY
* is periodic
*---------------------------------------------------------------------------------------
*Modification History:
*-----------------------------------------------------------------------------------------

*  DATE             WHO         REFERENCE          DESCRIPTION
* 6-06-2010      SUJITHA.S   ODR-2009-10-0326 N.3  INITIAL CREATION
*
*----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.INTEREST

  GOSUB INIT
  GOSUB PROCESS

  RETURN

*-------------------------------------------------------------------------------
INIT:
*-------------------------------------------------------------------------------

  LOC.REF.APPLICATION='AA.PRD.DES.INTEREST'
  LOC.REF.FIELDS='L.AA.REV.RT.TY':VM:'L.AA.LST.REV.DT':VM:'L.AA.NXT.REV.DT'
  LOC.REF.POS=''

  RETURN

*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------

  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

  Y.TYPE.POS=LOC.REF.POS<1,1>
  Y.NEXT.POS=LOC.REF.POS<1,2>
  Y.LAST.POS=LOC.REF.POS<1,3>

  Y.REV.TY=R.NEW(AA.INT.LOCAL.REF)<1,Y.TYPE.POS>
  Y.NEXT.REV=R.NEW(AA.INT.LOCAL.REF)<1,Y.NEXT.POS>
  Y.LAST.REV=R.NEW(AA.INT.LOCAL.REF)<1,Y.LAST.POS>

  IF Y.REV.TY NE "PERIODICO" THEN
    T.LOCREF<Y.NEXT.POS,7> ='NOINPUT'
    T.LOCREF<Y.LAST.POS,7> ='NOINPUT'
  END
  RETURN
END
