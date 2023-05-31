* @ValidationCode : MjoxMTE4ODY4MTg3OkNwMTI1MjoxNjg1NTMwMTc0NzQyOmhhaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 16:19:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.CUS.NAME(Y.INP.DEAL)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - Include to Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - CALL ROUTINE FORMAT MODIFIED
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $USING APAP.REDORETAIL

*--PARA ABRIR EL ACHIVO FBNK.CUSTOMER
*CALL REDO.CUST.IDENTITY.REF(Y.INP.DEAL, Y.ALT.ID, Y.CUS.NAME)
    APAP.REDORETAIL.redoCustIdentityRef(Y.INP.DEAL, Y.ALT.ID, Y.CUS.NAME)   ;*R22 MANUAL CODE CONVERSION
    

    Y.NAME.1         = Y.CUS.NAME[1,35]
    Y.NAME.2         = Y.CUS.NAME[36,LEN(Y.CUS.NAME)]

    Y.INP.DEAL = Y.NAME.1 : " " : Y.NAME.2

RETURN

END
