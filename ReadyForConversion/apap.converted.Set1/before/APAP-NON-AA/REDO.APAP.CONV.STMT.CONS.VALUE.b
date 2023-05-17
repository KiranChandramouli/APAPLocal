*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.CONV.STMT.CONS.VALUE
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.STMT.CONS.VALUE
*------------------------------------------------------------------------------
*Description  : This is a conversion routine used to fetch the value of LAST.TRANS.DATE from ACCOUNT
*Linked With  :
*In Parameter : O.DATA
*Out Parameter: O.DATA
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  Date            Who                        Reference                    Description
* ------          ------                      -------------                -------------
* 12-11-2010      Sakthi Sellappillai         ODR-2010-08-0173 N.73       Initial Creation
*--------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ACCOUNT
  GOSUB INITIALISE
  GOSUB PROCESS
  RETURN
*------------------------------------------------------------------------------------
INITIALISE:
*------------------------------------------------------------------------------------
  Y.TEMP.VALUE = ''
  RETURN
*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------
  Y.TEMP.VALUE = O.DATA
  O.DATA = "FD7=" : Y.TEMP.VALUE : "^^"
  RETURN
*-------------------------------------------------------------------------------------
END
