*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.CONV.ATLACC.STLMT.REJ
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.CONV.ATLACC.STLMT.REJ
*Date              : 15.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*15/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*23/03/2011      Balagurunathan              ODR-2010-03-0400       change for issue PACS00033279
*------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CARD.ISSUE
$INSERT I_F.ACCOUNT
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.CARD.BIN


  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN

*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------
  FN.CARD.ISSUE='F.CARD.ISSUE'
  F.CARD.ISSUE=''
  CALL OPF(FN.CARD.ISSUE,F.CARD.ISSUE)

  FN.REDO.CARD.BIN='F.REDO.CARD.BIN'
  F.REDO.CARD.BIN=''
  CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

  Y.CARD.NUMBER=O.DATA

  Y.BIN.ID=Y.CARD.NUMBER[1,6]

  CALL F.READ(FN.REDO.CARD.BIN,Y.BIN.ID,R.REDO.CARD.BIN,F.REDO.CARD.BIN,Y.BIN.ERR)


  Y.CARD.TYPE=R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>

*    changing code to accomadate multivalue of CARD.TYPE in REDO.CARD.BIN for issue PACS00033279

  LOOP

    REMOVE Y.CRD.TYP FROM Y.CARD.TYPE SETTING POS.CRD

  WHILE Y.CRD.TYP:POS.CRD

    Y.CARD.ID=Y.CRD.TYP:'.':Y.CARD.NUMBER

    CALL F.READ(FN.CARD.ISSUE,Y.CARD.ID,R.CARD.ISSUE,F.CARD.ISSUE,Y.CARD.ERR)

    IF R.CARD.ISSUE THEN

      Y.ACCT.NO=R.CARD.ISSUE<CARD.IS.ACCOUNT>
      Y.CARD.TYPE=Y.CRD.TYP
      BREAK
    END
  REPEAT
* changing code end to accomadate multivalue of CARD.TYPE in REDO.CARD.BIN for issue PACS00033279

  CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)

  O.DATA=R.ACCOUNT<AC.ALT.ACCT.ID>

  RETURN
END
