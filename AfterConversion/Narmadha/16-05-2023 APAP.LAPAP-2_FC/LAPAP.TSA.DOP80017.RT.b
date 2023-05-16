* @ValidationCode : MjotMTAzNDMwNTQyMTpDcDEyNTI6MTY4MjA3MDI3MjQ4MzpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:14:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
