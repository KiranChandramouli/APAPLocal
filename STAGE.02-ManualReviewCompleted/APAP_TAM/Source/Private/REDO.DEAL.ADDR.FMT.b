* @ValidationCode : MjoxMDE3NDczODY6Q3AxMjUyOjE2ODA3NzM2NjgyMzY6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:04:28
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
SUBROUTINE REDO.DEAL.ADDR.FMT(Y.ADDRESS)
*---------------------------------------------
*Description: This routine is to format the address in deal slip
*---------------------------------------------
* Input  Arg   := COMI
* Output Arg   := COMI
* Linked With  := DEAL.SLIP.FORMAT>REDO.CHEQUE.ISS
*---------------------------------------------
*Modification Details:
*=====================
* Date             Who                   Reference      Description
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, ++ TO += 1
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE


    GOSUB PROCESS
RETURN
*---------------------------------------------
PROCESS:
*---------------------------------------------

    Y.NO.OF.LINES.ADDR = DCOUNT(Y.ADDRESS,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.NO.OF.LINES.ADDR
        Y.ADDRESS<Y.VAR1> = "     ":Y.ADDRESS<Y.VAR1>
        Y.VAR1 += 1                ;** R22 Auto conversion - ++ TO += 1
    REPEAT

RETURN
END
