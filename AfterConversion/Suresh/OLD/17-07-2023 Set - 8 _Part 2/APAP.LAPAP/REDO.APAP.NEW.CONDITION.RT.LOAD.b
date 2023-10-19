* @ValidationCode : MjotMTI2MDg3OTQ4MjpDcDEyNTI6MTY4OTIzNzM3ODk0NzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jul 2023 14:06:18
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
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion           BP removed in INSERT file
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.APAP.NEW.CONDITION.RT.LOAD
*==============================================================================
*==============================================================================

    $INSERT I_COMMON ;*R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_TSA.COMMON
    $INSERT I_BATCH.FILES

    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.AA.OVERDUE
    $INSERT I_REDO.APAP.NEW.CONDITION.RT.COMO ;*R22 Auto Conversion - End

    Y.ACTIVIDAD = "LENDING-UPDATE-APAP.OVERDUE"
    Y.PROPERTY = "APAP.OVERDUE"
    Y.ARCHIVO.CARGA = "LOAD.CONDITION.txt"
    Y.FILE.LOAD.NAME = "AA.LIST.UPD"
    Y.CAMPO.COND = "L.LOAN.COND"
    Y.CAMPO.COMENT = "L.LOAN.COMMENT1"
    Y.FILE.FINAL = "AA.LIST.UPD"

    GOSUB OPEN.FILES
RETURN

*==========*
OPEN.FILES:
*==========*
    FN.EB.LOOKUP = "F.EB.LOOKUP" ; FV.EB.LOOKUP = ""
    CALL OPF(FN.EB.LOOKUP,FV.EB.LOOKUP)

    FN.CHK.DIR = "DMFILES" ; F.CHK.DIR = ""
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    FN.CONCATE.WRITE = "F.LAPAP.CONCATE.CONDIC"
    FV.CONCATE.WRITE = ""
    CALL OPF (FN.CONCATE.WRITE,FV.CONCATE.WRITE)


RETURN

END
