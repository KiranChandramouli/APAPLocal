*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.CAPITALISE.INT.LOAD

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Arulprakasam P
* Program Name  : REDO.B.CLEAR.OUT.LOAD
*-------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*
*-----------------------------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------------
*   DATE                ODR                             DESCRIPTION
* 23-11-2010      ODR-2010-09-0251                  Initial Creation
*--------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_REDO.B.CAPITALISE.COMMON
$INSERT I_F.REDO.APAP.CLEAR.PARAM


  GOSUB INIT
  GOSUB READ.FILE

  RETURN

*-----------------------------------------------------------------------------------------------------------
*****
INIT:
*****

  FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
  F.REDO.APAP.CLEAR.PARAM = ''
  CALL OPF(FN.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)

  FN.INT.REVERSE = 'F.REDO.INTEREST.REVERSE'
  F.INT.REVERSE = ''
  CALL OPF(FN.INT.REVERSE,F.INT.REVERSE)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.INT.REVERSE.HIS = 'F.REDO.INT.REVERSE.HIS'
  F.INT.REVERSE.HIS = ''
  CALL OPF(FN.INT.REVERSE.HIS,F.INT.REVERSE.HIS)


  RETURN
*-----------------------------------------------------------------------------------------------------------
READ.FILE:
**********

  CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,"SYSTEM",R.REDO.APAP.CLEAR.PARAM,"")

  CAPITALISE.ACCT  = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CAPITALISE.ACCT>

  CAPITAL.CR.CODE = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CAPITAL.CR.CODE>
  CAPITAL.DR.CODE = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CAPITAL.DR.CODE>

  RETURN

*----------------------------------------------------------------------------------------------------------------
END
