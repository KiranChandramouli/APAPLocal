*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TAKE.TRANS.REF

*--------------------------------------------------------------------------------
*Company   Name    : Asociacion Popular de Ahorros y Prestamos
*Developed By      : Shiva Prasad
*Program   Name    : REDO.TAKE.TRANS.REF
*IN DATA           : O.DATA
*OUT DATA          : O.DATA
*---------------------------------------------------------------------------------

*DESCRIPTION       : This Routine has been attached to the Enquiry for returning
*                    the Trans Reference value
* ----------------------------------------------------------------------------------
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
*---------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.STMT.ENTRY

  FN.STMT.ENTRY = 'F.STMT.ENTRY'
  F.STMT.ENTRY = ''
  CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

  CALL F.READ(FN.STMT.ENTRY,O.DATA,R.STMT.REC,F.STMT.ENTRY,STMT.ERR)
  IF NOT(STMT.ERR) THEN
    TRANS.REF = R.STMT.REC<AC.STE.TRANS.REFERENCE>
    O.DATA = FIELD(TRANS.REF,'\',1)

  END
  RETURN
END
