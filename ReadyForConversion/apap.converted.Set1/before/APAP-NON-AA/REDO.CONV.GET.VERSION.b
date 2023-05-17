*-------------------------------------------------------------------------
* <Rating>-10</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.GET.VERSION
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 16-SEP-2011         RIYAS      ODR-2011-07-0162     Initial Creation
*-------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.EB.LOOKUP

  GOSUB CHECK.NOTES

  RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~
  CASE.TYPE = O.DATA

  VER.NAME1 = "REDO.FRONT.CLAIMS,NEW"
  VER.NAME2 = "REDO.FRONT.REQUESTS,NEW"
  VER.NAME3 = "REDO.FRONT.COMPLAINTS,NEW"

  BEGIN CASE

  CASE CASE.TYPE EQ 'RECLAMACION'
    VER.NAME = VER.NAME1

  CASE CASE.TYPE EQ 'SOLICITUD'
    VER.NAME = VER.NAME2

  CASE CASE.TYPE EQ 'QUEJAS'
    VER.NAME = VER.NAME3

  CASE OTHERWISE
    VER.NAME = ''

  END CASE

  O.DATA = VER.NAME

  RETURN
*-------------------------------------------------------------------------
END
