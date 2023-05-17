*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.CREATE.RENEWAL.LOAD
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This load routine initialises and opens necessary files
*  and gets the position of the local reference fields
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who             Reference            Description
* 12-AUG-2010     S.R.SWAMINATHAN   ODR-2010-03-0400      Initial Creation
* 27 MAY 2011     KAVITHA           PACS00063156           PACS00063156 FIX
*---------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.CREATE.RENEWAL.COMMON
$INSERT I_F.REDO.CARD.RENEWAL
$INSERT I_F.LATAM.CARD.ORDER
$INSERT I_BATCH.FILES
$INSERT I_F.DATES
$INSERT I_GTS.COMMON
$INSERT I_F.COMPANY


  GOSUB INIT
  GOSUB OPEN.FILE

  RETURN

*----
INIT:
*----
*-------------------------------------------------
* This section initialises the necessary variables
*-------------------------------------------------
*PACS00063156-S
  FN.REDO.CARD.RENEWAL = 'F.REDO.CARD.RENEWAL'
  F.REDO.CARD.RENEWAL = ''


  FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
  F.LATAM.CARD.ORDER = ''

  FN.HOLIDAY = 'F.HOLIDAY'
  F.HOLIDAY = ''

  Y.LAST.WORKING.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
  RETURN

*---------
OPEN.FILE:
*---------
*---------------------------------------
* This section opens the necessary files
*---------------------------------------

  CALL OPF(FN.REDO.CARD.RENEWAL,F.REDO.CARD.RENEWAL)
  CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)
  CALL OPF(FN.HOLIDAY,F.HOLIDAY)

  COUNTRY.CODE = R.COMPANY(EB.COM.LOCAL.COUNTRY)
  YEAR = R.DATES(EB.DAT.LAST.WORKING.DAY)[1,4]
  HOLIDAY.ID =  COUNTRY.CODE :"00": YEAR
  CALL CACHE.READ(FN.HOLIDAY,HOLIDAY.ID,R.HOLIDAY,HOL.ERR)


  RETURN
*PACS00063156-E

END
