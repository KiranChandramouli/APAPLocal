$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.ENQ.RTN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.INP.CHQ.ISS
* ODR NO      : ODR-2009-12-0275
*----------------------------------------------------------------------
*DESCRIPTION: Conversion routine for the Enquiry REDO.H.CANT.CK.PF


*IN PARAMETER:NONE
*OUT PARAMETER:NONE
*LINKED WITH: REDO.H.SOLICITUD.CK
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*19.02.2010  H GANESH     ODR-2009-12-0275  INITIAL CREATION
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

*-----------------------------------------------------------------------


    O.DATA = FIELD(O.DATA,"\",1)

RETURN
END
