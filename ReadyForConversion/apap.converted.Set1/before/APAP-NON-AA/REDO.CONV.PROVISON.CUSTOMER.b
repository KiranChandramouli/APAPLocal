*-------------------------------------------------------------------------------------*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.PROVISON.CUSTOMER
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CONV.PROVISON.CUSTOMER
*------------------------------------------------------------------------------
*Linked With  :
*In Parameter : O.DATA
*Out Parameter: O.DATA
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                        Reference                    Description
*   ------          ------                      -------------                -------------
* 24-06-2011       RIYAS                       PACS00061656 B23B       Initial Creation
*--------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.H.PROVISION.PARAMETER

  GOSUB INITIALISE
  GOSUB PROCESS
  RETURN
*---------------------------
INITIALISE:
*---------------------------
  Y.INT.PER=O.DATA
  Y.TERM.VALUE = ''

  Y.FINAL =FIELD(Y.INT.PER, "-", 1)



  RETURN
*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------
  Y.FIN.PER=Y.INT.PER[1,2]
  O.DATA=Y.FINAL

  RETURN
*-------------------------------------------------------------------------------------
END
