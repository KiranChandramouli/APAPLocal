* @ValidationCode : MjotMzY3NjI0ODcyOlVURi04OjE3MDI5OTA2MzIxNzk6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:27:12
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
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
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* 18-12-2023      Narmadha V        Manual R22 Conversion      Changed ardcoded value to ID variable.
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
    Y.ID = "SYSTEM"
    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,Y.ID,R.REDO.APAP.CLEAR.PARAM,"") ;*Manual R22 Conversion - Changed Hardcoded Value to ID variable.


*Get the Value of CAT.OUTWARD.RETURN
    VAR.CAT.OUT.RETURN = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CAT.OWD.RETURN>
    R.NEW(FT.CREDIT.ACCT.NO) = VAR.CAT.OUT.RETURN

RETURN
END
