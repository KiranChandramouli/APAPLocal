*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.CHEQUE.PROCESS
*--------------------------------------------------------------------------
* DESCRIPTION: This routine is used to populate the descriptions
*------------------------------------------------------------------------------------------------------------
* Modification History
* DATE         NAME          Reference        REASON
* 28-07-2012   SUDHARSANAN   PACS00208938     Initial creation
*---------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_GTS.COMMON
$INSERT I_F.USER

  GOSUB PROCESS
  RETURN
**********
PROCESS:
*********

  Y.LOOKUP.ID   = "L.PAYMT.TYPE"
  Y.LOOOKUP.VAL = O.DATA
  Y.DESC.VAL    = ''

  CALL REDO.EB.LOOKUP.LIST(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2)

  IF Y.DESC.VAL THEN
    O.DATA = Y.DESC.VAL
  END

  RETURN
*-------------------------------------------------------------------------------------------------------------------
END
