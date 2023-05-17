*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CNV.FETCH.PRI.NAME
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : KAVITHA
* PROGRAM NAME : REDO.E.CNV.FETCH.PRI.NAME
*----------------------------------------------------------


* DESCRIPTION : This is conversion routine to fetch primary card holder name
*
*
*
*------------------------------------------------------------

*    LINKED WITH :
*    IN PARAMETER: NONE
*    OUT PARAMETER: NONE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*14.06.2011      KAVITHA               ODR-2010-03-0400      PACS00072694 INITIAL CREATION
*----------------------------------------------------------------------


*-------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.H.SOLICITUD.CK

  FETCH.MV.NAMES = O.DATA
  O.DATA = FIELD(FETCH.MV.NAMES,VM,2,1)

  RETURN
END
