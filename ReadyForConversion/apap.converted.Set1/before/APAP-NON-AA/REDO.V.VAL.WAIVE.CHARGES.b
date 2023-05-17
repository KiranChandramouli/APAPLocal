*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.WAIVE.CHARGES
*----------------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.V.VAL.WAIVE.CHARGES
* ODR NO      : ODR-2009-12-0275
*---------------------------------------------------------------------------------------------------
* DESCRIPTION: If the field WAIVE.CHARGES is YES, an Override message has to be displayed
* IN PARAMETER:NONE
* OUT PARAMETER:NONE
* LINKED WITH: Attach this routine to REDO.H.SOLICITUD.CK,INPUT.PF and REDO.H.SOLICITUD.CK,INPUT.PJ
*------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO           REFERENCE         DESCRIPTION
*26.02.2010 S SUDHARSANAN    ODR-2009-12-0275  INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.SOLICITUD.CK
  GOSUB PROCESS
  RETURN
*********************************************************
********
PROCESS:
*********


  CURR.NO=''
  Y.WAIVE.CHARGES=R.NEW(REDO.H.SOL.WAIVE.CHARGES)
  IF Y.WAIVE.CHARGES EQ 'YES' THEN
    CURR.NO=DCOUNT(R.NEW(REDO.H.SOL.OVERRIDE),VM) + 1
    TEXT='REDO.WAIVE.CHARGES'
    CALL STORE.OVERRIDE(CURR.NO)
  END
  RETURN
******************************************************
END
