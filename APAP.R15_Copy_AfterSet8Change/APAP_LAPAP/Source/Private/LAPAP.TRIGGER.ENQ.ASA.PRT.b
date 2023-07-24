* @ValidationCode : MjoxMTMwMTI2ODk1OlVURi04OjE2ODk3NDk2NTc1MzQ6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:17
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.TRIGGER.ENQ.ASA.PRT
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 17-07-2023    Narmadha V             R22 Manual Conversion   No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion -START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ST.L.APAP.ASAMBLEA.VOTANTE ;*R22 Auto Conversion -END

*Y.ENQ.OP = ""

*Y.ENQ.OP<1,1> = "LAPAP.ENQ.ASA.IMPR"

*Y.ENQ.OP<2,1> = "@ID"

*Y.ENQ.OP<3,1> = "EQ"

*Y.ENQ.OP<4,1> = ID.NEW    ;*CEDULA


*CALL ENQUIRY.DISPLAY (Y.ENQ.OP)

    TAREA ="ENQ LAPAP.ENQ.ASA.IMPR @ID EQ " : ID.NEW

    CALL EB.SET.NEW.TASK(TAREA)


END
