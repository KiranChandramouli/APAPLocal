* @ValidationCode : MjotMTY5Mjk2ODI0NTpDcDEyNTI6MTcwNTM5Njc3NTU4ODp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Jan 2024 14:49:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.GET.CARD.STATUS.DET
    
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*DATE			               AUTHOR					Modification                            DESCRIPTION
*16-01-2024	                 	VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES          SQA-12394 - By Santiago
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CARD.STATUS
    
    FN.CARD.STATUS = 'F.CARD.STATUS'
    F.CARD.STATUS  = ''
    CALL OPF(FN.CARD.STATUS,F.CARD.STATUS)
    
    CALL F.READ(FN.CARD.STATUS,COMI,R.CARD.STATUS,F.CARD.STATUS,ERR.CS)
    COMI = R.CARD.STATUS<CARD.STS.CRD.STS.DES,1>
RETURN
END
