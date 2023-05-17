*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RAD.MON.STATUSOP

*-----------------------------------------------------------------------------
* Primary Purpose: Returns status of operation based on RECORD.STATUS
*                  Used in RAD.CONDUIT.LINEAR as API routine.
* Input Parameters: RECORD.STATUS
* Output Parameters: A (Authorised) or U (Unauthorised) or O (Override) or R (Reversed) or X (Unknow)
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
    CASE Y.PARAM EQ 'ACTIVE'
        Y.RETURN = 'A'
    CASE Y.PARAM EQ ''
        Y.RETURN = 'A'
    CASE OTHERWISE
        Y.RETURN = 'I'
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




















