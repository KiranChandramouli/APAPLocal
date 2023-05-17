*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.EX.AUDIT.TRAIL.LOG.ID
*-----------------------------------------------------------------------------
* Program Description
* Check Id validation routine for the template REDO.EX.AUDIT.TRAIL.LOG.ID
*-----------------------------------------------------------------------------
* Modification History :
* --------------
* 11/03/06 - EN_10002851 - CRM Phase 1
*            Creation
*            Ref:SAR-2005-12-06-0005
*
* 22/06/06 - CI_10042130
*            Fix to allow version names with more than 3 char's after the comma.
*            Ref:TTS0604321
*--------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
*--------------------------------------------------------------------

  CALL IN2PV(ID.N,"PV":FM:"HULWD")      ;* should be a valid application

  IF ETEXT NE "" AND ID.NEW NE 'SYSTEM' THEN      ;* if its not a valid application then it should be 'SYSTEM'
    E = ETEXT       ;* if either of these, then error
    ETEXT = ''
  END

  RETURN
*------------------------------------------------------------------
END
