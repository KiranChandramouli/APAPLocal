*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.B.UPD.OUTS.PRINC.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.APAP.B.UPD.OUTS.PRINC.SELECT

*--------------------------------------------------------

*DESCRIBTION: REDO.APAP.B.UPD.OUTS.PRINC.SELECT is the select routine to make a
* select on the REDO.APAP.LOAN.CHEQUE.DETAILS file

*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.APAP.B.UPD.OUTS.PRINC

* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*06.08.2010   H GANESH                ODR-2009-10-0346   INITIAL CREATION

*--------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.APAP.B.UPD.OUTS.PRINC.COMMON



  GOSUB PROCESS
  RETURN

*-----------------------------------------------------------
PROCESS:
*-----------------------------------------------------------
  SEL.CMD = "SELECT ":FN.REDO.APAP.MORTGAGES.DETAIL
  LIST.PARAMETER ="F.SEL.INT.LIST"
  LIST.PARAMETER<1> = ''
  LIST.PARAMETER<3> = SEL.CMD
  CALL BATCH.BUILD.LIST(LIST.PARAMETER,'')
  RETURN
END
