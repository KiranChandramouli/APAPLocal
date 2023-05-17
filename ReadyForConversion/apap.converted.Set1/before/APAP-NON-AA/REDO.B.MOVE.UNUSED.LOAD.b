*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.MOVE.UNUSED.LOAD
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    :
*--------------------------------------------------------------------------------------------------------
*Description       :               This load routine initialises and opens necessary files
*                   and gets the position of the local reference fields
*In Parameter      :
*Out Parameter     :
*Files  Used       : As             I/O          Mode
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  02/08/2010       REKHA S            ODR-2010-03-0400 B.166      Initial Creation
*
*********************************************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.MOVE.UNUSED.COMMON

  GOSUB INIT
  RETURN

*****
INIT:
*****

  FN.REDO.CARD.NO.LOCK = 'F.REDO.CARD.NO.LOCK'
  F.REDO.CARD.NO.LOCK =''
  CALL OPF(FN.REDO.CARD.NO.LOCK,F.REDO.CARD.NO.LOCK)

  FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
  F.REDO.CARD.NUMBERS = ''
  CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

  FN.REDO.CARD.NO.LOCK = 'F.REDO.CARD.NO.LOCK'
  F.REDO.CARD.NO.LOCK = ''
  CALL OPF(FN.REDO.CARD.NO.LOCK,F.REDO.CARD.NO.LOCK)

  FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
  F.REDO.CARD.NUMBERS = ''
  CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)
  RETURN
END
