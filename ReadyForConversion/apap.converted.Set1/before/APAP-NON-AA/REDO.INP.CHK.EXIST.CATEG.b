*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INP.CHK.EXIST.CATEG
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SHANKAR RAJU
*Program   Name    :REDO.INP.CHK.EXIST.CATEG
*Reference Number  :HD1048505
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to check if the category has been assigned to any TELLER

*LINKED WITH       :
* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER.ID
$INSERT I_F.TOLERANCE.CATEG.RANGE

  GOSUB INIT
  GOSUB PROCESS

  RETURN
*----------------------------------------------------------------------------------
INIT:
*~~~~

  FN.TELLER.ID = 'F.TELLER.ID'
  F.TELLER.ID = ''
  CALL OPF(FN.TELLER.ID,F.TELLER.ID)

  RETURN
*----------------------------------------------------------------------------------
PROCESS:
*~~~~~~~

  IF V$FUNCTION EQ 'R' THEN

    SEL.CMD = "SELECT ":FN.TELLER.ID:" WITH L.TT.TOL.CAT.RG EQ ":COMI
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)

    IF SEL.LIST THEN
      E = 'EB-CATEG.ALRDY.ASSIGN'
    END

  END
  RETURN
*----------------------------------------------------------------------------------
END
