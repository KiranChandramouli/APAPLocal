*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RAD.MON.REVERSASN

*-----------------------------------------------------------------------------
* Primary Purpose: Returns S if the txn belongs a reverse txn, else return N
*                  Used in RAD.CONDUIT.LINEAR as API routine.
* Input Parameters: T24_FUNCTION
* Output Parameters: S (Reverse) or N (No reverse)
*-----------------------------------------------------------------------------
* Modification History:
*
* 18/09/10 - Cesar Yepez
*            New Development
*
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_TSS.COMMON

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN
*-----------------------------------------------------------------------------------
PROCESS:
  BEGIN CASE
  CASE Y.PARAM EQ 'R'
    Y.RETURN = 'S'
  CASE OTHERWISE
    Y.RETURN = 'N'
  END CASE

  COMI = Y.RETURN

  RETURN
*-----------------------------------------------------------------------------------

*-----------------------------------------------------------------------------------

*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:
  PROCESS.GOAHEAD = 1
  IP.ADDRESS = TSS$CLIENTIP
  Y.INTERF.ID = 'MON001'
  Y.RETURN = ''
  Y.REVERSE.S = 'S'
  Y.REVERSE.N = 'N'
  ERR.MSG = ''
  ERR.TYPE = ''

  Y.PARAM = COMI


  RETURN
*-----------------------------------------------------------------------------------

OPEN.FILES:


  RETURN

*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:

  RETURN

*-----------------------------------------------------------------------------------

END


















