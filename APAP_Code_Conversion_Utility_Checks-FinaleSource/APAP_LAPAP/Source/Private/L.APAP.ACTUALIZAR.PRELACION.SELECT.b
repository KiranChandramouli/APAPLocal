* @ValidationCode : MjoxNTkxMTU5ODI1OkNwMTI1MjoxNzAyOTg4MzQ0NzI0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:04
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
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.ACTUALIZAR.PRELACION.SELECT
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION

*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   T24.BP,BP is Removed , INSERT FILE MODIFIED
*18-12-2023    Santosh C           MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT  I_EQUATE
*   $INSERT  I_BATCH.FILES ;*R22 MANUAL CONVERSION
*   $INSERT  I_TSA.COMMON ;*R22 MANUAL CONVERSION
    $INSERT  I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.AA.PAYMENT.SCHEDULE
    $INSERT   I_F.ST.L.APAP.PRELACION.COVI19.DET
    $INSERT  I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT  I_L.APAP.ACTUALIZAR.PRELACION.COMMON ;*R22 MANUAL CONVERSION
    $USING EB.Service ;*R22 Manual Code Conversion_Utility Check


    GOSUB PROCESS
RETURN

PROCESS:
    SEL.CMD = ''; NO.OF.RECS = ''; ERROR.DETAILS = '' ; SEL.LIST = '';
    CALL F.READ(FN.DIRECTORIO,Y.INFILE,R.DIRECTORIO,FV.DIRECTORIO,ERROR.DIRECTORIO)
    SEL.LIST = R.DIRECTORIO
*   CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST) ;*R22 Manual Code Conversion_Utility Check
RETURN
END
