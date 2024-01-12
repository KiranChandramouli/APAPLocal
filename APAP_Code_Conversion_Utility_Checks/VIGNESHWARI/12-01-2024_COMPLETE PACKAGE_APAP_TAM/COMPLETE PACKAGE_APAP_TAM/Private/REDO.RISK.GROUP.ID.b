* @ValidationCode : MjotNDQ4NjM5NzY2OkNwMTI1MjoxNjg0ODQyMTMwMDQ4OklUU1M6LTE6LTE6LTE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             < TO LT
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
SUBROUTINE REDO.RISK.GROUP.ID
*-----------------------------------------------------------------------------

*COMPANY NAME   :APAP
*DEVELOPED BY   :TEMENOS APPLICATION MANAGEMENT
*PROGRAM NAME   :REDO.RISK.GROUP.ID
*DESCRIPTION    :TEMPLATE FOR THE ID OF REDO.RISK.GROUP
*LINKED WITH    :REDO.RISK.GROUP
*IN PARAMETER   :NULL
*OUT PARAMETER  :NULL
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------
    IF LEN(ID.NEW) LT 10 THEN ;*AUTO R22 CODE CONVERSION
        ID.NEW = STR("0",(10-LEN(ID.NEW))):ID.NEW
    END
END
