*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.LIQ.ACCT(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : JEEVA T
* Program Name : REDO.E.PRD.SELECT
*----------------------------------------------------------

* Description   :
* Linked with   :
* In Parameter  : None
* Out Parameter : None
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*10.10.2010   JEEVA T      ODR-2010-08-0031   INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ACCOUNT
$INSERT I_F.REDO.CLOSE.ACCT
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_System

  GOSUB OPEN.FILE
  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------
OPEN.FILE:
  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.REDO.CLOSE.ACCT ='F.REDO.CLOSE.ACCT'
  F.REDO.CLOSE.ACCT = ''
  CALL OPF(FN.REDO.CLOSE.ACCT,F.REDO.CLOSE.ACCT)


  RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
  Y.LIQ.ACCOUNT = ''
  ID.POS = ''
  NOF = ''
  LOCATE "@ID" IN ENQ.DATA<2,1> SETTING ID.POS THEN
    IF SEL.CMD.LIST THEN
      SEL.CMD.LIST<-1> = ENQ.DATA<4,ID.POS>
    END ELSE
      SEL.CMD.LIST = ENQ.DATA<4,ID.POS>
    END
    NOF += 1
  END
  LOCATE "ACCOUNT.NUMBER" IN ENQ.DATA<2,1> SETTING I.POS THEN
    IF SEL.CMD.LIST THEN
      SEL.CMD.LIST<-1> = ENQ.DATA<4,I.POS>
    END ELSE
      SEL.CMD.LIST = ENQ.DATA<4,I.POS>
    END
    NOF += 1
  END

  IF NOT(NOF) THEN
    SEL.CMD ="SELECT  ":FN.REDO.CLOSE.ACCT
    CALL EB.READLIST(SEL.CMD,SEL.CMD.LIST,'',NOF,Y.ERR)
  END

  Y.CNT = 1
  LOOP
  WHILE Y.CNT LE NOF
    Y.ACCOUNT = SEL.CMD.LIST<Y.CNT>
    CALL F.READ(FN.REDO.CLOSE.ACCT,Y.ACCOUNT,R.REDO.CLOSE.ACCT,F.REDO.CLOSE.ACCT,Y.ERR)
    IF R.REDO.CLOSE.ACCT THEN
      Y.LIQ.ACCOUNT<-1> = R.REDO.CLOSE.ACCT<REDO.ACCT.LIQ.ACCOUNT>
    END
    Y.CNT = Y.CNT + 1
  REPEAT
* IF Y.LIQ.ACCOUNT AND R.REDO.CLOSE.ACCT THEN
  CHANGE FM TO ' ' IN Y.LIQ.ACCOUNT
  ENQ.DATA<2,-1> ='@ID'
  ENQ.DATA<3,-1> ='EQ'
  ENQ.DATA<4,-1> = Y.LIQ.ACCOUNT
*END
  RETURN
*-----------------------------------------------------------------------------
END
