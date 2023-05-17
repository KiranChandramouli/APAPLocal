*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.ANC.DEFAULT.TELLER
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.ANC.DEFAULT.TELLER
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION: This routine is auto new content routine attached to TELLER.ID
* field in below versions
* TELLER,CHQ.OTHERS
* TELLER,CHQ.NO.TAX
* TELLER,CHQ.TAX
* TELLER,MGR.CHQ.TAX
* TELLER,MGR.CHQ.NOTAX
* TELLER,MGR.CHQ.TAX
* TELLER,MGR.CHQ.NOTAX


*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*19.02.2010  H GANESH     ODR-2009-12-0285  INITIAL CREATION
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_TT.COMMON
$INSERT I_F.TELLER.ID

  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
  FN.TELLER.ID='F.TELLER.ID'
  F.TELLER.ID=''
  CALL OPF(FN.TELLER.ID,F.TELLER.ID)
  RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
  SEL.CMD="SELECT ":FN.TELLER.ID:" WITH USER EQ '":OPERATOR:"' AND STATUS EQ OPEN"
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
  R.NEW(TT.TE.TELLER.ID.1)=SEL.LIST<1,1>
  R.NEW(TT.TE.TELLER.ID.2)=SEL.LIST<1,1>
  RETURN
END
