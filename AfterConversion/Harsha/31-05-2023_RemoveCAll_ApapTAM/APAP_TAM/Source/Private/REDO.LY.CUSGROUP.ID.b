* @ValidationCode : MjotNjEyNjg0NTk6Q3AxMjUyOjE2ODEyOTUyMTc1NTI6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 15:56:57
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
SUBROUTINE REDO.LY.CUSGROUP.ID
*-----------------------------------------------------------------------------
*** FIELD definitions FOR TEMPLATE
*!
* @author youremail@temenos.com
* @stereotype id
* @package infra.eb
* @uses
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 12.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 12.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.CUSGROUP
*-----------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------

    FN.REDO.LY.CUSGROUP = 'F.REDO.LY.CUSGROUP'
    F.REDO.LY.CUSGROUP = ''
    CALL OPF(FN.REDO.LY.CUSGROUP,F.REDO.LY.CUSGROUP)

    R.REDO.LY.CUSGROUP = ''; CUSG.ERR = ''
    CALL F.READ(FN.REDO.LY.CUSGROUP,ID.NEW,R.REDO.LY.CUSGROUP,F.REDO.LY.CUSGROUP,CUSG.ERR)
    IF R.REDO.LY.CUSGROUP AND PGM.VERSION EQ ',INPUT' THEN
        E = 'EB-REDO.LY.V.CUSGRPNAME'
        RETURN
    END

END
