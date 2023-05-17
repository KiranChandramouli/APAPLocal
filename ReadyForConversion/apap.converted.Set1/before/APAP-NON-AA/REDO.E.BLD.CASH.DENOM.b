*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BLD.CASH.DENOM(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Pradeep M
* Program Name : REDO.E.BLD.CASH.DENOM
*-----------------------------------------------------------------------------
* Description :Bulit routine to assign value to set variable.
* Linked with :
* In Parameter :
* Out Parameter :
*
**DATE           ODR                   DEVELOPER               VERSION
* 10-11-2011    ODR2011080055          Pradeep M
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.TELLER
$INSERT I_F.TELLER.ID

  GOSUB OPEN.PROCESS
  GOSUB PROCESS

  RETURN

OPEN.PROCESS:
*------------

  FN.TELLER='F.TELLER'
  F.TELLER=''

  CALL OPF(FN.TELLER,F.TELLER)

  FN.TELLER.ID='F.TELLER.ID'
  F.TELLER.ID=''

  CALL OPF(FN.TELLER.ID,F.TELLER.ID)

  RETURN

PROCESS:
*------

  Y.USER.ID=OPERATOR

  SEL.LIST=''
  NO.OF.REC=''
  ERR.TT=''

  SEL.CMD="SELECT ":FN.TELLER.ID: " WITH USER EQ ":Y.USER.ID
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR.TT)

  Y.TILL.ID=FIELD(SEL.LIST,FM,1)

  CALL System.setVariable("CURRENT.TELL.ID",Y.TILL.ID)

  RETURN

END
