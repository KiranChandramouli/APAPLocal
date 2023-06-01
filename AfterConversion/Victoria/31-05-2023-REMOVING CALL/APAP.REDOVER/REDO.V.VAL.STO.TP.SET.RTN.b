* @ValidationCode : MjotNjk3MDY3ODU5OkNwMTI1MjoxNjgyNDEyMzY1MzcwOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.STO.TP.SET.RTN
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.INP.STO.SET.RTN
*------------------------------------------------------------------------------------------------------------------
*Description       :This routine is to set sunnel routine and mask the 6 digits in the credit card
*Linked With       :
*In  Parameter     :
*Out Parameter     :
*ODR  Number       : 2010-08-0031
*Modification history
*Date                Who               Reference                  Description
*20-04-2023      conversion tool     R22 Auto code conversion     No changes
*20-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDING.ORDER
    $INSERT I_System

    R.NEW(STO.FT.ROUTINE)='@REDO.V.STO.UPD.TP'
RETURN
END
