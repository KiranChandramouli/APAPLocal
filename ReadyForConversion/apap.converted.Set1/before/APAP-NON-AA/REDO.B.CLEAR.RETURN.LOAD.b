*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.CLEAR.RETURN.LOAD
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.B.CLEAR.RETURN.LOAD
*-------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*
*----------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-09-10          ODR-2010-09-0251                  Initial Creation
*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.REDO.MAPPING.TABLE
$INSERT I_F.REDO.CLEARING.PROCESS
$INSERT I_REDO.B.CLEAR.RETURN.COMMON
$INSERT I_F.REDO.OUTWARD.RETURN


  GOSUB INIT
  GOSUB OPEN.FILE
  RETURN

INIT:

  FN.REDO.CLEARING.PROCESS.ID = 'B132.PROCESS'

  FN.REDO.CLEARING.PROCESS = 'F.REDO.CLEARING.PROCESS'
  F.REDO.CLEARING.PROCESS  = ''
  CALL OPF(FN.REDO.CLEARING.PROCESS,F.REDO.CLEARING.PROCESS)

  CALL F.READ(FN.REDO.CLEARING.PROCESS,FN.REDO.CLEARING.PROCESS.ID,R.REDO.CLEARING.PROCESS,F.REDO.CLEARING.PROCESS,PROC.CLEAR.ERR)
  VAR.FILE.PATH = R.REDO.CLEARING.PROCESS<PRE.PROCESS.OUT.RETURN.PATH>
  VAR.FILE.NAME = R.REDO.CLEARING.PROCESS<PRE.PROCESS.OUT.RETURN.NAME>

  RETURN

OPEN.FILE:
*Opening Files

  FN.REDO.CLEARING.PROCESS = 'F.REDO.CLEARING.PROCESS'
  F.REDO.CLEARING.PROCESS  = ''
  CALL OPF(FN.REDO.CLEARING.PROCESS,F.REDO.CLEARING.PROCESS)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.REDO.MAPPING.TABLE = 'F.REDO.MAPPING.TABLE'
  F.REDO.MAPPING.TABLE = ''
  CALL OPF(FN.REDO.MAPPING.TABLE,F.REDO.MAPPING.TABLE)

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.APERTA = VAR.FILE.PATH
  F.APERTA = ''
  CALL OPF(FN.APERTA,F.APERTA)

  FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
  F.REDO.APAP.CLEAR.PARAM = ''
  CALL OPF(FN.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)

  FN.REDO.OUTWARD.RETURN = 'F.REDO.OUTWARD.RETURN'
  F.REDO.OUTWARD.RETURN = ''
  CALL OPF(FN.REDO.OUTWARD.RETURN,F.REDO.OUTWARD.RETURN)

  FN.TFS = 'F.T24.FUND.SERVICES'
  F.TFS = ''
  CALL OPF(FN.TFS,F.TFS)

  FN.REDO.H.ROUTING.HEADER = 'F.REDO.H.ROUTING.HEADER'
  F.REDO.H.ROUTING.HEADER = ''
  CALL OPF(FN.REDO.H.ROUTING.HEADER,F.REDO.H.ROUTING.HEADER)

  CALL CACHE.READ(FN.REDO.H.ROUTING.HEADER,'SYSTEM',R.REDO.H.ROUTING.HEADER,RTN.ERR)

  RETURN

END
