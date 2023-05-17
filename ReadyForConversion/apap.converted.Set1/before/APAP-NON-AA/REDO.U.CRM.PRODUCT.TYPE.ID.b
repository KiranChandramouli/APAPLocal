*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.U.CRM.PRODUCT.TYPE.ID
*------------------------------------------------------------------------------
*------------------------------------------------------------------------------
* DESCRIPTION : This routine is used to check the ID value for the table
* REDO.U.CRM.PRODUCT.TYPE.ID
*------------------------------------------------------------------------------
*------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : PRADEEP S
* PROGRAM NAME : REDO.U.CRM.PRODUCT.TYPE.ID
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE           DESCRIPTION
* 13-MAY-2011      Pradeep S          PACS00060849        Initial Creation
* ----------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.U.CRM.PRODUCT.TYPE
  GOSUB INIT
  GOSUB PROCESS
  RETURN
*****
INIT:
******
  FN.EB.LOOKUP = 'F.EB.LOOKUP'
  F.EB.LOOKUP  = ''
  CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)
  RETURN

********
PROCESS:
********
  Y.ID = ID.NEW
  Y.LOOKUP.ID = "RE.PRODUCT.TYPE*":Y.ID
  R.LOOKUP = ''

  CALL F.READ(FN.EB.LOOKUP,Y.LOOKUP.ID,R.LOOKUP,F.EB.LOOKUP,ERR.LOOKUP)
  IF ERR.LOOKUP THEN
    E = "Enter Valid Product Type"
  END
  RETURN
END
