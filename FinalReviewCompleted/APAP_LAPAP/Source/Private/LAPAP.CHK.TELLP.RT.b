* @ValidationCode : MjotNTUyNjg2NDIwOkNwMTI1MjoxNjkxNzUxMzQ4NzU0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Aug 2023 16:25:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.CHK.TELLP.RT
*----------------------------------------------------------------------------------------------------
*MODIFICATION HISTORY
* Date                  Who                    Reference                        Description
* ----                  ----                     ----                              ----
* 09-08-2023           Samaran T         R22 Manual Code Conversion     BP is removed from insert file.
*-------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 MANUAL CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.REDO.TELLER.PROCESS  ;*R22 MANUAL CODE CONVERSION.END


    GOSUB LOAD.LOCREF
    GOSUB MAKE.NO.INPUT

RETURN
LOAD.LOCREF:
    APPL.NAME.ARR = "REDO.TELLER.PROCESS"
    FLD.NAME.ARR = "L.TTP.PASO.RAPI"
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)

    Y.L.TTP.PASO.RAPI.POS = FLD.POS.ARR<1,1>

RETURN
MAKE.NO.INPUT:
    T.LOCREF<Y.L.TTP.PASO.RAPI.POS,7> = 'NOINPUT'

RETURN

END
