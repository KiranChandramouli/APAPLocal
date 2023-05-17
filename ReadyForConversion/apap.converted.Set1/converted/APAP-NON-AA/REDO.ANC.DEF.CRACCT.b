SUBROUTINE REDO.ANC.DEF.CRACCT
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.ANC.DEF.CRACCT
*-------------------------------------------------------------------------
* Description: This routine is a Auto New Content routine
*
*----------------------------------------------------------
* Linked with:  FUNDS.TRANSFER, CH.RTN
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-09-10          ODR-2010-09-0251              Initial Creation
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
    $INSERT I_F.FUNDS.TRANSFER



    GOSUB OPEN.FILE
    GOSUB PROCESS
RETURN



OPEN.FILE:
*Opening Files

    FN.ACCOUNT = 'F.REDO.APAP.CLEAR.PARAM'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.CLEAR.PARAM =''
    CALL OPF(FN.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)


RETURN

PROCESS:
*Reading REDO.APAP.CLEAR.PARAM
    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,'SYSTEM',R.REDO.APAP.CLEAR.PARAM,"")


*Get the Value of CAT.OUTWARD.RETURN
    VAR.CAT.OUT.RETURN = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CAT.OWD.RETURN>
    R.NEW(FT.CREDIT.ACCT.NO) = VAR.CAT.OUT.RETURN

RETURN
END
