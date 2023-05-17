*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.E.CNV.INT.TYPE.DESC
*----------------------------------------------------------------------------
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : Krishna Murthy T.S
*  ODR Number        : ODR-2010-08-0424
*  Program   Name    : REDO.APAP.E.CNV.INT.TYPE.DESC
*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : Y.FINAL.ARRAY
*-----------------------------------------------------------------------------
* DESCRIPTION       :This is a conversion routine enquiry which will fetch the
*                    description for the INTEREST.TYPE value entered
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO                  REFERENCE            DESCRIPTION
*  23-Mar-2011     Krishna Murthy T.S   PACS00037719         Initial Creation
*-------------------------------------------------------------------------------

$INSERT I_EQUATE
$INSERT I_COMMON
$INSERT I_ENQUIRY.COMMON

  Y.DATA = O.DATA
  BEGIN CASE
  CASE Y.DATA EQ 1
    O.DATA = "FIXED"
  CASE Y.DATA EQ 3
    O.DATA = "FLOATING"
  CASE Y.DATA EQ 9
    O.DATA = "NONE"
  END CASE
  RETURN
END
