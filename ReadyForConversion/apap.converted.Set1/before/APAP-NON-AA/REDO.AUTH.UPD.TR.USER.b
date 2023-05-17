*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AUTH.UPD.TR.USER
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at check Record Routine for TELLER VERSIONS
*------------------------------------------------------------------------------------------
*
* COMPANY NAME : APAP
* DEVELOPED BY : VICTOR NAVA
* PROGRAM NAME : REDO.V.CHK.FX.OVR
*
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*       DATE             WHO                REFERENCE         DESCRIPTION
*
* -----------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_System
$INSERT I_REDO.FX.OVR.COMMON
*
$INSERT I_F.FOREX
$INSERT I_F.MM.MONEY.MARKET
$INSERT I_F.SEC.TRADE


  LOC.REF.APPL="FOREX":FM:"MM.MONEY.MARKET":FM:"SEC.TRADE"
  LOC.REF.FIELDS="L.LIMIT.OVR":VM:"L.CR.USER.APAP":VM:"L.TR.USER.APAP":FM:"L.LIMIT.OVR":VM:"L.CR.USER.APAP":VM:"L.TR.USER.APAP":FM:"L.LIMIT.OVR":VM:"L.CR.USER.APAP":VM:"L.TR.USER.APAP"
  LOC.REF.POS=" "
  CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
  Y.FX.LIMIT.OVR.POS  = LOC.REF.POS<1,1>
  Y.FX.CR.USER.POS =  LOC.REF.POS<1,2>
  Y.FX.TR.USER.POS =  LOC.REF.POS<1,3>

  Y.MM.LIMIT.OVR.POS  = LOC.REF.POS<2,1>
  Y.MM.CR.USER.POS =  LOC.REF.POS<2,2>
  Y.MM.TR.USER.POS =  LOC.REF.POS<2,3>

  Y.SC.LIMIT.OVR.POS  = LOC.REF.POS<3,1>
  Y.SC.CR.USER.POS =  LOC.REF.POS<3,2>
  Y.SC.TR.USER.POS =  LOC.REF.POS<3,3>

  Y.APPLICATION = APPLICATION

  BEGIN CASE
  CASE Y.APPLICATION EQ "FOREX"
    GOSUB FX.DEFAULT.PARA
  CASE Y.APPLICATION EQ "MM.MONEY.MARKET"
    GOSUB MM.DEFAULT.PARA
  CASE Y.APPLICATION EQ "SEC.TRADE"
    GOSUB SC.DEFAULT.PARA
  END CASE

  RETURN
*****************
FX.DEFAULT.PARA:
*****************
  R.NEW(FX.LOCAL.REF)<1,Y.FX.TR.USER.POS>    = OPERATOR
  RETURN
*****************
MM.DEFAULT.PARA:
*****************
  R.NEW(MM.LOCAL.REF)<1,Y.MM.TR.USER.POS>    = OPERATOR
  RETURN
*****************
SC.DEFAULT.PARA:
*****************
  R.NEW(SC.SBS.LOCAL.REF)<1,Y.SC.TR.USER.POS> = OPERATOR
  RETURN
END
