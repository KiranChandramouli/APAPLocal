*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CNV.TXN.DATE
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CNV.TXN.DATE
*------------------------------------------------------------------------------
*Description  : This is a conversion routine used to convert the date to T24 date format
*
*In Parameter : O.DATA
*Out Parameter: O.DATA
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                        Reference                    Description
*   ------          ------                      -------------                -------------
* 22-09-2010         Renugadevi B              ODR-2010-03-0135       Initial Creation
*--------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
  GOSUB PROCESS
  RETURN

********
PROCESS:
********
  Y.VALUE    = O.DATA
  Y.VALUE1   = FIELD(Y.VALUE,'-',1)
  Y.VALUE2   = FIELD(Y.VALUE,'-',2)
  IF Y.VALUE1 THEN
    Y.DATE1 = ICONV(Y.VALUE1,'DJ')
    Y.DATE2 = OCONV(Y.DATE1,'D4E/')
    O.DATA  = Y.DATE2:" - ":Y.VALUE2
  END ELSE
    O.DATA  = ''
  END
  RETURN
END
