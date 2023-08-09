* @ValidationCode : MjotNzY1OTUyMDI4OkNwMTI1MjoxNjkwMTk0ODI4NTg1OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 16:03:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
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
    R.DATA<REDO.BCR.REP.EXE.REP.TIME.RANGE> = '20180716'

    CALL OPF(FN.REDO.BCR.REPORT.EXEC, F.REDO.BCR.REPORT.EXEC)
    CALL F.WRITE(FN.REDO.BCR.REPORT.EXEC, Y.BRC.ID, R.DATA)
    CALL JOURNAL.UPDATE('')

RETURN
