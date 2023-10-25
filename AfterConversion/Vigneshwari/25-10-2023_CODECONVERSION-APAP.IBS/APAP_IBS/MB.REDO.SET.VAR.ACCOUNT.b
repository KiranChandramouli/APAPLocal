* @ValidationCode : Mjo5MjgxMjkzODg6Q3AxMjUyOjE2OTgyMzgxNDMzMjc6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Oct 2023 18:19:03
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
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
    PROGRAM MB.REDO.SET.VAR.ACCOUNT
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                  Nochanges
*-----------------------------------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Description :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.BENEFICIARY

*-----------------------------------------------------------------------------

    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
* Main Process
PROCESS:
*-------

    CALL System.setVariable('CURRENT.ACCT.NO','1011519941')
*    ETEXT=  System.getVariable('EXT.SMS.CUSTOMERS') :  " test"
*    CALL STORE.END.ERROR

    RETURN

*-----------------------------------------------------------------------------

END
