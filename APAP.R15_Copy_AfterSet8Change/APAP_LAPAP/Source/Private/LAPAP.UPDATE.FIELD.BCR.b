* @ValidationCode : MjotNzY1OTUyMDI4OkNwMTI1MjoxNjg5ODU2ODIyNTM0OklUU1MxOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Jul 2023 18:10:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
