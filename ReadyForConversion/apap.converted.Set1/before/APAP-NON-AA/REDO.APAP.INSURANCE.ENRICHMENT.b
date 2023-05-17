*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.INSURANCE.ENRICHMENT
*
*
* This routine is used to populate the enrichment for the Modification versions used for Insurance
*------------------------------------------------------------------------------------------------------------
* Modification History
*
*
*
*---------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_GTS.COMMON
$INSERT I_F.USER
$INSERT I_F.APAP.H.INSURANCE.DETAILS

*-------------------------------------------------------------------------------------------------------------
MAIN.LOGIC:

  GOSUB INITIALISE

  GOSUB POPULATE.DESC

  RETURN
*-------------------------------------------------------------------------------------------------------------

INITIALISE:

  INS.POLICY.TYPE = R.NEW(1)

  CLASS.POLICY.TYPE = R.NEW(2)

  INS.POLICY = 'INS.POLICY.STATUS'

  CLASS.POLICY = 'CLASS.POLICY'

  CALL EB.LOOKUP.LIST(INS.POLICY)

  CALL EB.LOOKUP.LIST(CLASS.POLICY)

  INS.POLICY.LIST = INS.POLICY<2>
  INS.POLICY.DESC = INS.POLICY<11>

  CLASS.POLICY.LIST = CLASS.POLICY<2>
  CLASS.POLICY.DESC = CLASS.POLICY<11>

  CHANGE '_' TO FM IN INS.POLICY.LIST
  CHANGE '_' TO FM IN INS.POLICY.DESC

  CHANGE '_' TO FM IN CLASS.POLICY.LIST
  CHANGE '_' TO FM IN CLASS.POLICY.DESC

  RETURN
*-------------------------------------------------------------------------------------------------------------------

POPULATE.DESC:

  LOCATE INS.POLICY.TYPE IN INS.POLICY.LIST SETTING POS THEN

    IF R.USER<EB.USE.LANGUAGE> EQ 2 AND INS.POLICY.DESC<POS,2> NE '' THEN
      R.NEW(INS.DET.INS.POL.DESC) = INS.POLICY.DESC<POS,2>  ;* This is for spanish user
    END ELSE
      R.NEW(INS.DET.INS.POL.DESC) = INS.POLICY.DESC<POS,1>
    END

  END

  LOCATE CLASS.POLICY.TYPE IN CLASS.POLICY.LIST SETTING CLASS.POS THEN

    IF R.USER<EB.USE.LANGUAGE> EQ 2 AND CLASS.POLICY.DESC<CLASS.POS,2> NE '' THEN
      R.NEW(INS.DET.CLASS.POL.DESC) = CLASS.POLICY.DESC<CLASS.POS,2>  ;* This is for spanish user
    END ELSE
      R.NEW(INS.DET.CLASS.POL.DESC) = CLASS.POLICY.DESC<CLASS.POS,1>
    END

  END

  RETURN
*------------------------------------------------------------------------------------------------------------------------

END
