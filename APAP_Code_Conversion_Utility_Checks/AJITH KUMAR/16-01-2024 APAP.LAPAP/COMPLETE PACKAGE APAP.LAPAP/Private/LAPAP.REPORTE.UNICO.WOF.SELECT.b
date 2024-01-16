* @ValidationCode : MjoxNzM4NDAwMDE6Q3AxMjUyOjE3MDUwNDM2NjkzODE6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Jan 2024 12:44:29
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
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.REPORTE.UNICO.WOF.SELECT
*----------------------------------------------------------------------------------------------------
* Description           : Rutina de selecion de registros para la generación, del reporte unico posterior
*                         para prestamo castigados WOFF
* Developed On          : 19-11-2019
* Developed By          : APAP
* Development Reference : GDC-704
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     No Changes
* 14-07-2023    Narmadha V             R2 Manual conversion    BP is removed in insert file

*----------------------------------------------------------------------------------------------------
    $INSERT  I_COMMON ;* R2 Manual conversion - START
    $INSERT  I_EQUATE
  *  $INSERT  I_BATCH.FILES
  *  $INSERT  I_TSA.COMMON
    $INSERT  I_F.ST.LAPAP.INFILEPRESTAMO
    $INSERT  I_F.AA.ARRANGEMENT
    $INSERT  I_LAPAP.REPORTE.UNICO.WOF.COMMON ;* R2 Manual conversion - END
   $USING EB.Service

*    CALL EB.CLEAR.FILE(FN.ST.LAPAP.INFILEPRESTAMO, FV.ST.LAPAP.INFILEPRESTAMO)
EB.Service.ClearFile(FN.ST.LAPAP.INFILEPRESTAMO, FV.ST.LAPAP.INFILEPRESTAMO);* R22 UTILITY AUTO CONVERSION

    SEL.CMD = " SELECT " : FN.AA.ARRANGEMENT :" WITH PRODUCT.GROUP EQ PRODUCTOS.WOF AND ARR.STATUS EQ CURRENT EXPIRED"
    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.RECS,SEL.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN
END
