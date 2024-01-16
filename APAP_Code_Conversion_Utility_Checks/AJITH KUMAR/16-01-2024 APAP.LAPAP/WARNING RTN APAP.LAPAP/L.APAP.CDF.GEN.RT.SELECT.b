* @ValidationCode : MjotNjY3NjQyNjAwOkNwMTI1MjoxNjkzMjk2MDIzNjc5OjMzM3N1Oi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 29 Aug 2023 13:30:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
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
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.CDF.GEN.RT.SELECT
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*29/08/2023      Suresh                     R22 Manual Conversion          BP FILE REMOVED
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Manual Conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CARD.RENEWAL
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.REDO.LY.POINTS
    $INSERT I_L.APAP.CDF.GEN.RT.COMMON ;*R22 Manual Conversion - File name changed from I. to I_
   $USING EB.Service
*   $INSERT I_F.ST.COUNT.CDF.GEN.RT ;*R22 Manual Conversion - END - line commented

*--GOSUB INI
*--GOSUB GET.ACCOUNTS
    GOSUB PROCESS.PARA

**************
PROCESS.PARA:
**************

    IF Y.CAN.RUN EQ "SI" THEN
*--Borra Los Registros Para la tabla del Contador
*        CALL EB.CLEAR.FILE(FN.COUNT, FV.COUNT)
EB.Service.ClearFile(FN.COUNT, FV.COUNT);* R22 UTILITY AUTO CONVERSION

        SEL.ACC.CMD = "SELECT " : FN.ACC : " WITH CATEGORY EQ 6021"
        CALL EB.READLIST(SEL.ACC.CMD,SEL.ACC.LIST,"",NO.OF.RECS.ACC,SEL.ACC.ERROR)

*Envia la data de una Rutina a Otra, Cargando el Arreglo de Datos a Memoria
*        CALL BATCH.BUILD.LIST('',SEL.ACC.LIST)
EB.Service.BatchBuildList('',SEL.ACC.LIST);* R22 UTILITY AUTO CONVERSION
    END ELSE
        CALL OCOMO("PROCESO EJECUTADO.")
    END

RETURN

END
