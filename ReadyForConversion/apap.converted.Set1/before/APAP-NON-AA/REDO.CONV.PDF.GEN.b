*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.PDF.GEN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: PRADEEP PANDIAN
* PROGRAM NAME: REDO.CONV.PDF.GEN
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is CONVERSION routine for the ENQUIRY
* to produce PDF for LETTERS



*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*12.05.2010  H GANESH     ODR-2009-10-0838   INITIAL CREATION
*16.06.2011  RIYAS          PACS00072833     MODIFY
*----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON


  Y.ARRAY = O.DATA

  Y.ARRAY = CHANGE(Y.ARRAY, ":", "##")
  Y.ARRAY = CHANGE(Y.ARRAY, "@", "#@#")

  O.DATA = Y.ARRAY
  RETURN
END
