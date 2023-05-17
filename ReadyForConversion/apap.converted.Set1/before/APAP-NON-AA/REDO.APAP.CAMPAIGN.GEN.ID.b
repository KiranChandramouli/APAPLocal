*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.CAMPAIGN.GEN.ID
*-------------------------------------------------------------
* Company   Name    :Asociacion Popular de Ahorros y Prestamos
* Developed By      :PRADEEP.P
* ODR Number        :ODR-2010-08-0228
* Program   Name    :REDO.APAP.CAMPAIGN.GEN.ID
*---------------------------------------------------------------------------------
* DESCRIPTION       :This routine is the .ID routine for the local template
*                    REDO.APAP.CAMPAIGN.GEN
*
* ----------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO             REFERENCE         DESCRIPTION
*  24-08-2010      Pradeep.P    ODR-2010-08-0228    INITIAL CREATION
*----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.APAP.CAMPAIGN.GEN

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN

INIT:
*---
  FN.REDO.APAP.CAMPAIGN.GEN = 'F.REDO.APAP.CAMPAIGN.GEN'
  F.REDO.APAP.CAMPAIGN.GEN = ''
  RETURN
*
OPENFILES:
*---------
  CALL OPF(FN.REDO.APAP.CAMPAIGN.GEN,F.REDO.APAP.CAMPAIGN.GEN)
  RETURN
*
PROCESS:
*-------
*
  Y.DATE = COMI
  Y.TODAY = TODAY
  IF Y.DATE EQ Y.TODAY THEN
    RETURN
  END ELSE
    E = "EB-REC.BEF.TOD"
    CALL STORE.END.ERROR
  END
  RETURN
END
