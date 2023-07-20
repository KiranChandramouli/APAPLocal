* @ValidationCode : MjotMTgyMjIwNDg5OTpDcDEyNTI6MTY4OTc2NDc0MTE1NzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Jul 2023 16:35:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

PROGRAM LAPAP.UPDATE.FIELD.BCR
*-----------------------------------------------------------------------------
    $INSERT I_COMMON  ;*R22 Auto Conversion
    $INSERT I_EQUATE  ;*R22 Auto Conversion
    $INSERT I_F.REDO.BCR.REPORT.EXEC ;*R22 Auto Conversion
*-----------------------------------------------------------------------------
*-- Modification History:
*-----------------
*-- Date        Name                Reference       Version
* ------        ----                ---------       -------
*-- 11/07/2018  Anthony Martinez    CN008777        update field REP.TIME.RANGE in table REDO.BCR.REPORT.EXEC
*13/07/2023      Conversion tool            R22 Auto Conversion          INCLUDE TO INSERT, BP removed in INSERT file
*13/07/2023      Suresh                     R22 Manual Conversion        Variable initialised
*-----------------------------------------------------------------------------
    FN.REDO.BCR.REPORT.EXEC = 'F.REDO.BCR.REPORT.EXEC'
    F.REDO.BCR.REPORT.EXEC  = ''
    Y.BRC.ID = 'BCR001'
    REDO.BCR.REP.EXE.REP.TIME.RANGE=""                      ;*R22 Manual Conversion
    R.DATA<REDO.BCR.REP.EXE.REP.TIME.RANGE> = '20180716'

    CALL OPF(FN.REDO.BCR.REPORT.EXEC, F.REDO.BCR.REPORT.EXEC)
    CALL F.WRITE(FN.REDO.BCR.REPORT.EXEC, Y.BRC.ID, R.DATA)
    CALL JOURNAL.UPDATE('')

RETURN
