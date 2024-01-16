* @ValidationCode : MjotMTA3NjkyMjk1MjpDcDEyNTI6MTcwMTEwOTQ3OTQ2NjpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Nov 2023 23:54:39
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
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.ABS.VAL
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------------------------------------------------------------------
* Modification History :
*DATE			               AUTHOR					Modification                            DESCRIPTION
*27-11-2023	                      VIGNESHWARI             ADDED COMMENT FOR INTERFACE CHANGES     SQA-11637 | MONITOR � By Santiago
*------------------------------------------------------------------------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    COMI = ABS(COMI)
    
RETURN
END
