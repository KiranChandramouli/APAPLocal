*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.FETCH.TELLER.ID(Y.TELLER.ID)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.FETCH.TELLER.ID
*---------------------------------------------------------------------------------

*DESCRIPTION       :This routine is to get the User ID and get the Teller ID for the USer
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.USER

  GOSUB PROCESS
  RETURN

PROCESS:

*Opening Teller ID File

  FN.TELLER.ID = 'F.TELLER.ID'
  F.TELLER.ID = ''
  CALL OPF(FN.TELLER.ID,F.TELLER.ID)

*Select on user Record to get
  SEL.CMD = "SELECT ":FN.TELLER.ID:" WITH USER EQ ":OPERATOR
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.ERR)
  Y.TELLER.ID = SEL.LIST

  RETURN
END
