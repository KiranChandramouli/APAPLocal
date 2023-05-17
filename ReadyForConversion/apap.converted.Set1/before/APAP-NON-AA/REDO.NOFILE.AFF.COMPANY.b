*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOFILE.AFF.COMPANY(Y.FINAL.OUT)
*---------------------------------------------------------------------
*Description: This routine is for nofile enquiry to display the aff comp based on selected campaign type.
*---------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.CAMPAIGN.TYPES

  GOSUB PROCESS

  RETURN
*-------------------------------------
PROCESS:
*-------------------------------------

  Y.ID.CAMP.TYPE = ''
  Y.FINAL.OUT = ''

  FN.REDO.CAMPAIGN.TYPES = 'F.REDO.CAMPAIGN.TYPES'
  F.REDO.CAMPAIGN.TYPES = ''
  CALL OPF(FN.REDO.CAMPAIGN.TYPES,F.REDO.CAMPAIGN.TYPES)

  FN.REDO.AFFILIATED.COMPANY = 'F.REDO.AFFILIATED.COMPANY'
  F.REDO.AFFILIATED.COMPANY = ''
  CALL OPF(FN.REDO.AFFILIATED.COMPANY,F.REDO.AFFILIATED.COMPANY)


  LOCATE '@ID' IN D.FIELDS<1> SETTING POS1 THEN
    Y.ID.CAMP.TYPE = D.RANGE.AND.VALUE<POS1>
  END

  IF Y.ID.CAMP.TYPE THEN
    CALL F.READ(FN.REDO.CAMPAIGN.TYPES,Y.ID.CAMP.TYPE,R.REDO.CAMPAIGN.TYPES,F.REDO.CAMPAIGN.TYPES,CAMP.ERR)
    Y.FINAL.OUT = R.REDO.CAMPAIGN.TYPES<CG.TYP.ASSOC.AFF.COMP>

  END

  IF Y.FINAL.OUT ELSE
    SEL.CMD = 'SELECT ':FN.REDO.AFFILIATED.COMPANY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    Y.FINAL.OUT = SEL.LIST
    CHANGE FM TO VM IN Y.FINAL.OUT
  END

  RETURN
END
