* @ValidationCode : MjoyMDUyMTE3MzEzOlVURi04OjE2OTAxNjc1NTE1MjY6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:11
* @ValidationInfo : Encoding          : UTF-8
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
    $INSERT  I_BATCH.FILES
    $INSERT  I_TSA.COMMON
    $INSERT  I_F.ST.LAPAP.INFILEPRESTAMO
    $INSERT  I_F.AA.ARRANGEMENT
    $INSERT  I_LAPAP.REPORTE.UNICO.WOF.COMMON ;* R2 Manual conversion - END

    CALL EB.CLEAR.FILE(FN.ST.LAPAP.INFILEPRESTAMO, FV.ST.LAPAP.INFILEPRESTAMO)

    SEL.CMD = " SELECT " : FN.AA.ARRANGEMENT :" WITH PRODUCT.GROUP EQ PRODUCTOS.WOF AND ARR.STATUS EQ CURRENT EXPIRED"
    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.RECS,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
