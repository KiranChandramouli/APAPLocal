*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE LATAM.CARD.CLASS.CODE.ID
*-----------------------------------------------------------------------------
*<doc>
* ID Validation is done here
* here
* @stereotype Application
* @package TODO define the product group and product, e.g. infra.eb
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 19/10/07 - EN_10003543
*            New Template changes
* ----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_METHODS.AND.PROPERTIES
$INSERT I_F.COMPANY

  GOSUB INITALISE
  GOSUB CHECK.ID

  RETURN
*------------------------------------------------------------------------------
INITALISE:

  FN.COMPANY = "F.COMPANY"
  F.COMPANY = ""
  CALL OPF(FN.COMPANY,F.COMPANY)
  RETURN

*-----------------------------------------------------------------------------
CHECK.ID:

  SELECT.COMP = "SELECT ":FN.COMPANY
  CALL EB.READLIST(SELECT.COMP,SEL.LIST.COMP,'',NO.OF.COMP,SEL.COMP)

  LOCATE ID.NEW IN SEL.LIST.COMP SETTING POS ELSE
    E = 'EB-NOT.VALID.ID'
    CALL ERR
  END
  RETURN
*-----------------------------------------------------------------------------
END
