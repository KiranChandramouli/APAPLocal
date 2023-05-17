*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AA.MIG.PAY.START.DTE.ID
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AA.MIG.PAY.START.DTE.ID
*-----------------------------------------------------------------------------
*Description       : This routine is a ID routine for template REDO.AA.MIG.PAY.START.DTE
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date            Who                  Reference                Description
*     ------         ------               -------------             -------------
*    27/05/2015    Ashokkumar.V.P         PACS00460183               Initial Release
*    25/06/2015    Ashokkumar.V.P         PACS00466046               Added to check the Account details
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.ACCOUNT
*** </region>
*-----------------------------------------------------------------------------

  GOSUB INIT
  GOSUB PROCESS
  RETURN

INIT:
*****
  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'; F.AA.ARRANGEMENT = ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
  FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  RETURN

PROCESS:
********
  ERR.AA.ARRANGEMENT = ''; R.AA.ARRANGEMENT = ''
  CALL F.READ(FN.AA.ARRANGEMENT,ID.NEW,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ERR.AA.ARRANGEMENT)
  IF NOT(R.AA.ARRANGEMENT) THEN
    ERR.ACCOUNT = ''; R.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,ID.NEW,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    IF NOT(R.ACCOUNT) THEN
      E = 'AA-INVALID.AA.LOAN.ID'
      RETURN
    END
  END
  RETURN

END
