*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.UPLOAD.TYPE

************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.GET.UPLOAD.TYPE
*----------------------------------------------------------

* Description   : This subroutine will get the UPLOAD TYPE
* Linked with   : none
* In Parameter  : None
* Out Parameter : None
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_System
$INSERT I_F.EB.FILE.UPLOAD
$INSERT I_F.REDO.CUSTOMER.PARAM
  GOSUB INIT
  GOSUB PROCESS
  RETURN
*-----
INIT:
*-----
  FN.REDO.CUSTOMER.PARAM='F.REDO.CUSTOMER.PARAM'
  Y.VAR.EXT.CUSTOMER=System.getVariable("EXT.SMS.CUSTOMERS")
  
  RETURN
*-------
PROCESS:
*-------
  CALL CACHE.READ(FN.REDO.CUSTOMER.PARAM,Y.VAR.EXT.CUSTOMER,R.REDO.CUSTOMER.PARAM,ERR)
  R.NEW(EB.UF.UPLOAD.TYPE)=R.REDO.CUSTOMER.PARAM<ACP.AC.ENTRY.PARAM>
  RETURN
END
