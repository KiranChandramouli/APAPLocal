*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.INW.PREPROCESS.LOAD

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.B.INW.PREPROCESS.LOAD
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
* 21-09-10          ODR-2010-09-0148                  Initial Creation
*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.ALTERNATE.ACCOUNT
$INSERT I_F.REDO.APAP.CLEARING.INWARD
$INSERT I_F.REDO.MAPPING.TABLE
$INSERT I_F.REDO.CLEARING.PROCESS
$INSERT I_REDO.B.INW.PREPROCESS.COMMON


  GOSUB INIT
  GOSUB OPEN.FILE
  RETURN

INIT:

  FN.REDO.CLEARING.PROCESS.ID = 'INW.PROCESS'

  FN.REDO.CLEARING.PROCESS = 'F.REDO.CLEARING.PROCESS'
  F.REDO.CLEARING.PROCESS  = ''
  CALL OPF(FN.REDO.CLEARING.PROCESS,F.REDO.CLEARING.PROCESS)

  CALL F.READ(FN.REDO.CLEARING.PROCESS,FN.REDO.CLEARING.PROCESS.ID,R.REDO.CLEARING.PROCESS,F.REDO.CLEARING.PROCESS,PROC.CLEAR.ERR)
  VAR.FILE.PATH = R.REDO.CLEARING.PROCESS<PRE.PROCESS.IN.PROCESS.PATH>
  VAR.FILE.NAME = R.REDO.CLEARING.PROCESS<PRE.PROCESS.IN.PROCESS.NAME>

  RETURN

OPEN.FILE:
*Opening Files

  FN.REDO.CLEARING.PROCESS = 'F.REDO.CLEARING.PROCESS'
  F.REDO.CLEARING.PROCESS  = ''
  CALL OPF(FN.REDO.CLEARING.PROCESS,F.REDO.CLEARING.PROCESS)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.ALTER = 'F.ALTERNATE.ACCOUNT'
  F.ALTER  = ''
  CALL OPF(FN.ALTER,F.ALTER)

  FN.APERTA = R.REDO.CLEARING.PROCESS<PRE.PROCESS.IN.PROCESS.PATH>
  F.APERTA  = ''
  CALL OPF(FN.APERTA,F.APERTA)

  FN.REDO.MAPPING.TABLE = 'F.REDO.MAPPING.TABLE'
  F.REDO.MAPPING.TABLE = ''
  CALL OPF(FN.REDO.MAPPING.TABLE,F.REDO.MAPPING.TABLE)

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.REDO.APAP.CLEARING.INWARD = 'F.REDO.APAP.CLEARING.INWARD'
  F.REDO.APAP.CLEARING.INWARD = ''
  CALL OPF(FN.REDO.APAP.CLEARING.INWARD,F.REDO.APAP.CLEARING.INWARD)

  FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
  F.REDO.APAP.CLEAR.PARAM = ''
  CALL OPF(FN.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)
  RETURN

END
