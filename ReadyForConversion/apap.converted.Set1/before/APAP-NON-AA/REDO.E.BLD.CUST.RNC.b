*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BLD.CUST.RNC(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Pradeep M
* Program Name : REDO.E.BLD.CUST.RNC
*-----------------------------------------------------------------------------
* Description :Enquiry routine to retreive image of padrones
* Linked with :
* In Parameter :
* Out Parameter :
*
**DATE           ODR                   DEVELOPER               VERSION
* 08-11-2011    ODR2011080055           PRADEEP                  Initial Creation
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.CUSTOMER


  GOSUB OPEN.PROCESS

  GOSUB PROCESS

  RETURN

OPEN.PROCESS:
*------------



  FN.CUSTOMER='F.CUSTOMER'
  F.CUSTOMER=''

  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.REDO.CUS.IDENTIFICATION='F.REDO.CUS.IDENTIFICATION'
  F.REDO.CUS.IDENTIFICATION=''

  CALL OPF(FN.REDO.CUS.IDENTIFICATION,F.REDO.CUS.IDENTIFICATION)

  LOCATE '@ID' IN ENQ.DATA<2, 1> SETTING KEY.VALUE.POS THEN
    KEY.VALUE = ENQ.DATA<4, KEY.VALUE.POS>
  END

  LOCATE 'NAME.1' IN ENQ.DATA<2, 1> SETTING NAME.POS THEN
    NAME.VALUE = ENQ.DATA<4, NAME.POS>
  END

  RETURN

PROCESS:
*-------

  Y.INP.VAL = NAME.VALUE

  GOSUB CHECK.IDENTIFICATION

  RETURN

CHECK.IDENTIFICATION:
*--------------------
  Y.CUS.IDNT='CIDENT':FM:'RNC':FM:'PASSPORT'
  T.TOTAL.IDENT = DCOUNT(Y.CUS.IDNT,FM)
  Y.INT =1
  LOOP
  WHILE Y.INT LE T.TOTAL.IDENT
    R.CUS.IDENTIFICATION=''
    ERR.REDO=''
    IDENTI.POS=''
    Y.IDNT.ID = Y.CUS.IDNT<Y.INT>
    CALL F.READ(FN.REDO.CUS.IDENTIFICATION,Y.IDNT.ID,R.CUS.IDENTIFICATION,F.REDO.CUS.IDENTIFICATION,ERR.REDO)
    FINDSTR Y.INP.VAL IN R.CUS.IDENTIFICATION SETTING IDENTI.POS THEN
      Y.CHK.ID.POS=R.CUS.IDENTIFICATION<IDENTI.POS>
      Y.CONCAT.CUS=FIELD(Y.CHK.ID.POS,'*',1)
      ERR.CUS=''
      R.CUSTOMER=''
      ENQ.DATA<2>=''
      ENQ.DATA<3>=''
      ENQ.DATA<4>=''
      SEL.LIST = ''
      SEL.CMD = ''
      Y.SEL.ERR = ''
      CALL F.READ(FN.CUSTOMER,Y.CONCAT.CUS,R.CUSTOMER,F.CUSTOMER,ERR.CUS)
      Y.CUS.NAME=R.CUSTOMER<EB.CUS.NAME.1>
      Y.CUS.NAME = "'":Y.CUS.NAME:"'"
      IF Y.CUS.NAME THEN
        ENQ.DATA<2,1> = 'NAME.1'
        ENQ.DATA<3,1> = 'EQ'
        ENQ.DATA<4,1> =  Y.CUS.NAME
      END
    END
    Y.INT + = 1
  REPEAT
  RETURN

END
