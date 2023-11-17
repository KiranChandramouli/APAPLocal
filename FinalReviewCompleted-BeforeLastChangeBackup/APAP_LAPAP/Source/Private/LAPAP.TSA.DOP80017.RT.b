* @ValidationCode : MjotMTAzNDMwNTQyMTpDcDEyNTI6MTY4NDIyMjgxNjE0OTpJVFNTOi0xOi0xOi03OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.TSA.DOP80017.RT
*--------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to from ENQUIRY.SERVICE
*Linked With version  : TSA.SERVICE,DOP80017
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference                           Description
*   ------         ------               -------------                        -------------
*  23/09/2020    Juan Garcia               MDP-1200                        Initial Creation
*21-04-2023      Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*21-04-2023      Samaran T               R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON    ;*R22 AUTO CODE CONVERSION.END

    GOSUB PROCESS

RETURN

PROCESS:
********

    COMI = 'BNK/LAPAP.STMT.ENTRY.DOPACC'

RETURN

*--------------------------------------------------------------------------------------------------------
