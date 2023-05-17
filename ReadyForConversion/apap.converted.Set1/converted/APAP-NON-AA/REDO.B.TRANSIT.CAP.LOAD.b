SUBROUTINE REDO.B.TRANSIT.CAP.LOAD

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : KAVITHA
* Program Name  : REDO.B.TRANSIT.CAP.LOAD
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
* 2-04-2012         ODR-2010-09-0251                  Initial Creation
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_REDO.B.TRANSIT.CAP.COMMON
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

    FN.REDO.TRANUTIL.INTAMT = 'F.REDO.TRANUTIL.INTAMT'
    F.REDO.TRANUTIL.INTAMT = ''
    CALL OPF(FN.REDO.TRANUTIL.INTAMT,F.REDO.TRANUTIL.INTAMT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


RETURN
*-----------------------------------------------------------------------------------------------------------
READ.FILE:
**********

    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,"SYSTEM",R.REDO.APAP.CLEAR.PARAM,"")

    TRANCAP.ACCT = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.TRANCAP.ACCT>

    TRANCAP.CR.CODE = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.TRANCAP.CR.CODE>
    TRANCAP.DR.CODE = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.TRANCAP.DR.CODE>

RETURN

*----------------------------------------------------------------------------------------------------------------
END
