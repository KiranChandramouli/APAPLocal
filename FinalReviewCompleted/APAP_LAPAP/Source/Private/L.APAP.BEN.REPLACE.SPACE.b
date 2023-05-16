* @ValidationCode : MjoxMDc2MjM2NDExOkNwMTI1MjoxNjgyMzMxMzE5NzEwOklUU1M6LTE6LTE6LTEwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -10
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.BEN.REPLACE.SPACE
*--------------------------------------------------------------------------------------------------
* Description           : Esta rutina reemplaza el caracter '~' por espacio
* Developed On          : ---
* Developed By          : Anthony Martinez
* Development Reference : ---
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
* Defect Reference       Modified By                    Date of Change        Change Details
* --------               Anthony Martinez               26/11/2018            Creation
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       INSERT FILE
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY ;*R22 Auto conversion - END

    GOSUB INITIAL
    GOSUB PROCESS

INITIAL:

    Y.NICKNAME = R.NEW(ARC.BEN.NICKNAME)
    Y.ARC.BEN.LOCAL.REF = R.NEW(ARC.BEN.LOCAL.REF)

RETURN

PROCESS:

    R.NEW(ARC.BEN.NICKNAME) = EREPLACE(Y.NICKNAME, "~", " ")
    R.NEW(ARC.BEN.LOCAL.REF) = EREPLACE(Y.ARC.BEN.LOCAL.REF, "~", " ")

RETURN

END
