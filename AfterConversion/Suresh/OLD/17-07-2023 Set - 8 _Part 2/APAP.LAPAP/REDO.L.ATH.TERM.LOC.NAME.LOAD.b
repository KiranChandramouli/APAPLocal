* @ValidationCode : MjotMTgwMDM2NDE0MjpDcDEyNTI6MTY4OTMyMTI3MTY2MjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Jul 2023 13:24:31
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
*13/07/2023      Conversion tool            R22 Auto Conversion            INCLUDE TO INSERT, BP removed in INSERT file
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.L.ATH.TERM.LOC.NAME.LOAD

    $INSERT I_COMMON ;*R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.ATH.SETTLMENT
    $INSERT I_REDO.L.ATH.TERM.LOC.NAME.COMMON ;*R22 Auto Conversion - End

    FN.REDO.ATH.SETTLMENT='F.REDO.ATH.SETTLMENT'
    F.REDO.ATH.SETTLMENT =''
    CALL OPF(FN.REDO.ATH.SETTLMENT,F.REDO.ATH.SETTLMENT)

    YSTART.DATE = ''; YEND.DATE = ''
    YSTART.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YEND.DATE = TODAY
 
RETURN
END
