*-------------------------------------------------------
* <Rating>-1</Rating>
*-------------------------------------------------------
  SUBROUTINE REDO.VISA.USAGE.CODE

************************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Balagurunathan
* PROGRAM NAME: REDO.OUT.ACRQ.REF.NUM
* ODR NO      : ODR-2010-08-0469
*----------------------------------------------------------------------
*DESCRIPTION: This routine is will be attached to REDO.VISA.STLMT.MAPPING
*To update USAGE.CODE
*IN PARAMETER : N/A
*OUT PARAMETER: N/A
*CALLED BY :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE                   DESCRIPTION
*09.07.2012  Balagurunathan  PACS00204001 & PACS00203771 Initial Draft
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_BATCH.FILES
$INSERT I_F.REDO.VISA.OUT.MAP
*$INCLUDE TAM.BP I_F.REDO.VISA.OUTGOING
$INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON

  IF TRIM(Y.FIELD.VALUE) EQ '' THEN
    Y.FIELD.VALUE=1
  END

  RETURN
