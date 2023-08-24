* @ValidationCode : Mjo3MDQ0NDc0MzQ6Q3AxMjUyOjE2ODEwNTY0ODYxMzI6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.SOLICITUD.REPRINT

*---------------------------------------------
*Description: This routine is to change some value in the template to reprint the
* deal slip.
*---------------------------------------------
* Input  Arg   := N/A
* Output Arg   := N/A
* Linked With  := VERSION>REDO.H.SOLICITUD.CK,REPRINT
*---------------------------------------------

*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.SOLICITUD.CK

    GOSUB PROCESS

RETURN
*---------------------------------------
PROCESS:
*---------------------------------------

    R.NEW(REDO.H.SOL.RESERVED.1) = R.NEW(REDO.H.SOL.RESERVED.1) + 1

RETURN
END
