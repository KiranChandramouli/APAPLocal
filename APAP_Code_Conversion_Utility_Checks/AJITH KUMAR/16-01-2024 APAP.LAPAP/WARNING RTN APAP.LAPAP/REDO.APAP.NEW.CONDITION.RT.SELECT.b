* @ValidationCode : MjotMTkzNjc4NjcyMTpDcDEyNTI6MTcwNTA0NDI2NjA0MDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jan 2024 12:54:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
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
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED
*13-07-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.APAP.NEW.CONDITION.RT.SELECT
*==============================================================================
* Esta rutina esta diceñada parara generar un archivo de cargar con nuavas
* nuevas condiciones para algunos prestamos para luego ser cargados por una DMT.
* DMT ===> APAP.UPDATE.CONDITION
*
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Requerimiento   : ET-5281
* Development by  : Juan Pablo Garcia
* Date            : Dic. 29, 2020
*==============================================================================

    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
  *  $INSERT I_TSA.COMMON
  *  $INSERT I_BATCH.FILES
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.AA.OVERDUE
    $INSERT I_REDO.APAP.NEW.CONDITION.RT.COMO ;*R22 AUTO CONVERSION END
   $USING EB.Service

    Y.ARCHIVO.CARGA = "LOAD.CONDITION.txt"
*Limpiando tabla temporal
*    CALL EB.CLEAR.FILE(FN.CONCATE.WRITE,FV.CONCATE.WRITE)
EB.Service.ClearFile(FN.CONCATE.WRITE,FV.CONCATE.WRITE);* R22 UTILITY AUTO CONVERSION

    R.CHK.DIR = "" ; CHK.DIR.ERROR = "";
    CALL F.READ(FN.CHK.DIR,Y.ARCHIVO.CARGA,R.CHK.DIR,F.CHK.DIR,CHK.DIR.ERROR)

    SEL.LIST = R.CHK.DIR;
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN


END
