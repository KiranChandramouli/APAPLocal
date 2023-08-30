* @ValidationCode : Mjo0Njk3OTUyNjM6Q3AxMjUyOjE2ODEwOTc3MzM5OTQ6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 09:05:33
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
SUBROUTINE REDO.SUPRESS.LIMIT.OVERRIDE
*-----------------------------------------------------
*Description: This routine is to suppress the core limit override
*             and it will be attached at the AA.ARRANGEMENT.ACTIVITY level..
*-----------------------------------------------------
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
    $INSERT I_GTS.COMMON
    $INSERT I_F.OVERRIDE
    $INSERT I_F.AA.TERM.AMOUNT


    GOSUB PROCESS
RETURN
*-----------------------------------------------------
PROCESS:
*-----------------------------------------------------

    IF OFS.VAL.ONLY NE 1 THEN
        GOSUB LOCATE.AND.REMOVE
    END
RETURN
*-----------------------------------------------------
LOCATE.AND.REMOVE:
*-----------------------------------------------------

    Y.OVERRIDE.ID = 'EXCESS.ID'
    LOCATE.FLAG = 1
    LOOP
    WHILE LOCATE.FLAG

        FINDSTR Y.OVERRIDE.ID IN R.NEW(AA.AMT.OVERRIDE) SETTING POS.FM,POS.VM THEN
            DEL R.NEW(AA.AMT.OVERRIDE)<POS.FM,POS.VM>
        END ELSE
            LOCATE.FLAG = 0
        END

    REPEAT

RETURN
END
