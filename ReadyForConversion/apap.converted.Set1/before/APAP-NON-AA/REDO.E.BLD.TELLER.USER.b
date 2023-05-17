*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BLD.TELLER.USER(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Pradeep M
* Program Name : REDO.E.BLD.TELLER.USER
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
$INSERT I_F.CUSTOMER
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER

  GOSUB OPEN.PROCESS
  GOSUB PROCESS

  RETURN

OPEN.PROCESS:
*-----------

  FN.TELLER='F.TELLER'
  F.TELLER=''
  CALL OPF(FN.TELLER,F.TELLER)

  FN.TELLER$NAU='F.TELLER$NAU'
  F.TELLER$NAU=''
  CALL OPF(FN.TELLER$NAU,F.TELLER$NAU)

  FN.FUNDS.TRANSFER='F.FUNDS.TRANSFER'
  F.FUNDS.TRANSFER=''
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

  FN.FUNDS.TRANSFER$NAU='F.FUNDS.TRANSFER$NAU'
  F.FUNDS.TRANSFER$NAU=''
  CALL OPF(FN.FUNDS.TRANSFER$NAU,F.FUNDS.TRANSFER$NAU)

  RETURN

PROCESS:
*-------


  Y.USER.ID=OPERATOR

  SEL.LIST=''
  NO.OF.REC=''
  ERR.SLT=''


  IF APPLICATION EQ 'TELLER' THEN

    SEL.CMD="SELECT ":FN.TELLER$NAU:" WITH L.INP.USER.ID EQ ":Y.USER.ID
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR.SLT)
  END ELSE

    SEL.CMD="SELECT ":FN.FUNDS.TRANSFER$NAU:" WITH L.INP.USER.ID EQ ":Y.USER.ID
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR.SLT)

  END

  ENQ.DATA<2>=''
  ENQ.DATA<3>=''
  ENQ.DATA<4>=''

  CHANGE FM TO SM IN SEL.LIST

  ENQ.DATA<2,1>='@ID'
  ENQ.DATA<3,1>='EQ'
  ENQ.DATA<4,1>=SEL.LIST


  RETURN

END
