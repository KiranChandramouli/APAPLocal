*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ENC.SAP.KEY
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.ENC.SAP.KEY
*--------------------------------------------------------------------------------------------------------
*Description  : Encrypt the key for SAPRPT
*In Parameter :
*Out Parameter:
*
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 27/08/2014    PRABHU N              Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT JBC.h
$INSERT I_F.REDO.INTERFACE.PARAM


  Y.KEY1=R.NEW(REDO.INT.PARAM.ENCRIP.KEY)

  yEncripKey=ID.NEW
  yLine = ENCRYPT(Y.KEY1,yEncripKey,JBASE_CRYPT_3DES_BASE64)

  R.NEW(REDO.INT.PARAM.ENCRIP.KEY) =yLine
  R.NEW(REDO.INT.PARAM.CON.ENC.KEY)=yLine

  RETURN
END
