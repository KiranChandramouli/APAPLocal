*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CNV.GET.TERM
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CONV.TERM.VAL
*------------------------------------------------------------------------------
*Description  : This is a conversion routine used to fetch the value of TERM from AA.ARR.COMMITMENT
*Linked With  :
*In Parameter : O.DATA
*Out Parameter: O.DATA
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                        Reference                    Description
*   ------          ------                      -------------                -------------
* 22-09-2010        Sakthi Sellappillai         ODR-2010-08-0031 B.187       Initial Creation
*--------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
  GOSUB INITIALISE
  GOSUB PROCESS
  RETURN
*---------------------------
INITIALISE:
*---------------------------

  Y.END.DATE=''
  Y.START.DATE=''
  RETURN
*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------

  Y.END.DATE=FIELD(O.DATA,':',1)
  Y.START.DATE=FIELD(O.DATA,':',2)
  Y.NO.OF.DAYS = 'C'
  CALL CDD('',Y.START.DATE,Y.END.DATE ,Y.NO.OF.DAYS)
  O.DATA=Y.NO.OF.DAYS
  RETURN
*-------------------------------------------------------------------------------------
END
