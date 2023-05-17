*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.LEGAL.ID
******************************************************************************************************************
*Company   Name    : Asociaciopular de Ahorros y Pramos Bank
*Developed By      : NARESH.CHAVADAPU(nareshc@temenos.com)
*Date              : 28-10-2009
*Program   Name    : REDO.V.VAL.LEGAL.ID
*Reference Number  : ODR-2009-10-0807
*-----------------------------------------------------------------------------------------------------------------
*Description       : This routine serves as a field level validation for the field l.cu.actanac***
*Linked With       : NA
*In  Parameter     : NA
*Out Parameter     : NA
*------insert files-----------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER

  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN
*-----------
OPEN.FILES:
*-----------

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  RETURN
*---------
PROCESS:
*----------------------------------------------------------------------------------
* The local field value is checked for its length and error is thrown based on it
*-----------------------------------------------------------------------------------

  Y.TEMP.VAR=COMI
  Y.CHECK.NUM = NUM(Y.TEMP.VAR)
  Y.COUNT.VAR=LEN(Y.TEMP.VAR)

  IF Y.TEMP.VAR NE '' THEN
    IF Y.COUNT.VAR NE 11 AND Y.CHECK.NUM NE 1 THEN
      AF = EB.CUS.LEGAL.ID
      ETEXT='EB-REDO.INVALID.DOC.FORMAT'
      CALL STORE.END.ERROR
    END
  END
  RETURN

*----------------------------------------------------------------------------
END
