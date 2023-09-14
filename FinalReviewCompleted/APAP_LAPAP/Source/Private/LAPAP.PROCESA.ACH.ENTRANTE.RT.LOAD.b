* @ValidationCode : Mjo0MzE1NTY5NDA6VVRGLTg6MTY4OTc0OTY1NjY0NzpJVFNTOi0xOi0xOjIwMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:16
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.PROCESA.ACH.ENTRANTE.RT.LOAD

*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file,INCLUDE to INSERT
* 14-07-2023    Narmadha V             R22 Manual Conversion     No Changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto Conversion - START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.REDO.ACH.PROCESS.DET
    $INSERT I_F.REDO.ACH.PARAM
    $INSERT I_LAPAP.PROCESA.ACH.ENTRANTE.RT ;*R22 Auto Conversion -END

* Llamamos la rutina que carga el archivo en las tablas de ACH
*CALL LAPAP.ACH.PROCESA.ARCHIVO.RT

    FN.REDO.ACH.PROCESS.DET = 'F.REDO.ACH.PROCESS.DET'; F.REDO.ACH.PROCESS.DET = ''
    CALL OPF(FN.REDO.ACH.PROCESS.DET,F.REDO.ACH.PROCESS.DET)

    FN.REDO.ACH.PARAM = 'F.REDO.ACH.PARAM'; F.REDO.ACH.PARAM = ''
    CALL OPF(FN.REDO.ACH.PARAM,F.REDO.ACH.PARAM)

    CALL CACHE.READ(FN.REDO.ACH.PARAM,"SYSTEM",R.REDO.ACH.PARAM,Y.ERR.ACH.PAR)

    Y.PARAM.TXN.PURPOSE = R.REDO.ACH.PARAM<REDO.ACH.PARAM.TXN.PURPOSE>
    Y.PARAM.TXN.CODE = R.REDO.ACH.PARAM<REDO.ACH.PARAM.TXN.CODE>
    Y.PARAM.TXN.VERSION = R.REDO.ACH.PARAM<REDO.ACH.PARAM.TXN.VERSION>


END
