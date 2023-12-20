* @ValidationCode : MjotMjA0NDAwNjg3NTpDcDEyNTI6MTY5ODc1MDY3Mzg5NzpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion           No Change
*
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TFS.CHK.OVERRIDE

    $INSERT I_COMMON
    $INSERT I_EQUATE

    IF INDEX(COMI,'*',1) THEN
        ETEXT = 'EB-TFS.CHAR.NOT.ALLOWED'
        ETEXT<2,1> = '*'
        CALL STORE.END.ERROR
    END

RETURN
